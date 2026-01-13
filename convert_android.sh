#!/usr/bin/env bash
set -e

ROOT="android"
PACKAGE="com.globeracer.design"
JAVA_DIR="$ROOT/src/main/java/com/globeracer/design"
THEME_DIR="$JAVA_DIR/theme"
BRAND_DIR="$THEME_DIR/brand"
TOKENS="$(cd "$(dirname "$0")" && pwd)/tokens.json"

mkdir -p "$BRAND_DIR"
mkdir -p "$ROOT/src/main"

cat > "$ROOT/build.gradle.kts" << EOF
plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.compose")
}

android {
    namespace = "$PACKAGE"
    compileSdk = 35

    defaultConfig {
        minSdk = 24
    }

    buildFeatures {
        compose = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.14"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation(platform("androidx.compose:compose-bom:2025.12.01"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")
    debugImplementation("androidx.compose.ui:ui-tooling")
}
EOF

sanitize_color() {
  local hex="${1#\#}"
  local result

  case "${#hex}" in
    3)
      result="FF${hex:0:1}${hex:0:1}${hex:1:1}${hex:1:1}${hex:2:1}${hex:2:1}"
      ;;
    6)
      result="FF$hex"
      ;;
    8)
      result="${hex:6:2}${hex:0:2}${hex:2:2}${hex:4:2}"
      ;;
    *)
      result="FFFFFFFF"
      ;;
  esac

  local rgb="${result:2:6}"
  if [[ "${rgb^^}" == "FFFFFF" ]]; then
    result="FFFFFFFF"
  fi

  echo "$result"
}

array_contains() {
  local seeking=$1
  shift
  local element
  for element in "$@"; do
    if [[ "$element" == "$seeking" ]]; then
      return 0
    fi
  done
  return 1
}

echo "package $PACKAGE.theme

import androidx.compose.ui.graphics.Color
" > "$THEME_DIR/Colors.kt"

COLOR_NAMES=()

while IFS= read -r line; do
  if [[ $line =~ \"([a-zA-Z0-9]+)\"[[:space:]]*:[[:space:]]*\{ ]]; then
    NAME="${BASH_REMATCH[1]}"
  fi

  if [[ $line =~ \"light\"[[:space:]]*:[[:space:]]*\"(#?[0-9a-fA-F]+)\" ]]; then
    LIGHT_RAW="${BASH_REMATCH[1]}"
  fi

  if [[ $line =~ \"dark\"[[:space:]]*:[[:space:]]*\"(#?[0-9a-fA-F]+)\" ]]; then
    DARK_RAW="${BASH_REMATCH[1]}"

    LIGHT=$(sanitize_color "$LIGHT_RAW")
    DARK=$(sanitize_color "$DARK_RAW")

    if ! array_contains "$NAME" "${COLOR_NAMES[@]}"; then
      COLOR_NAMES+=("$NAME")
      echo "val ${NAME}Light = Color(0x$LIGHT)" >> "$THEME_DIR/Colors.kt"
      echo "val ${NAME}Dark = Color(0x$DARK)" >> "$THEME_DIR/Colors.kt"
    fi

    NAME=""
    LIGHT_RAW=""
    DARK_RAW=""
  fi
done < "$TOKENS"

TEXT_COLORS=()
SURFACE_COLORS=()
BORDER_COLORS=()
ICON_COLORS=()

for NAME in "${COLOR_NAMES[@]}"; do
  case "$NAME" in
    text*) TEXT_COLORS+=("$NAME") ;;
    surface*) SURFACE_COLORS+=("$NAME") ;;
    border*) BORDER_COLORS+=("$NAME") ;;
    icon*) ICON_COLORS+=("$NAME") ;;
  esac
done

generate_color_class() {
  local CLASS_NAME=$1
  shift
  local COLOR_LIST=("$@")
  local FILE="$BRAND_DIR/$CLASS_NAME.kt"
  local PROPERTY_NAME="$(tr '[:upper:]' '[:lower:]' <<< ${CLASS_NAME:0:1})${CLASS_NAME:1}"

  echo "package $PACKAGE.theme.brand

import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.graphics.Color
import androidx.compose.material3.MaterialTheme
import com.globeracer.design.theme.*

@Immutable
data class $CLASS_NAME(" > "$FILE"

  for NAME in "${COLOR_LIST[@]}"; do
    echo "    val $NAME: Color," >> "$FILE"
  done

  echo ")" >> "$FILE"

  echo "
val Local$CLASS_NAME = staticCompositionLocalOf { $CLASS_NAME(" >> "$FILE"
  for NAME in "${COLOR_LIST[@]}"; do
    echo "    $NAME = ${NAME}Light," >> "$FILE"
  done
  echo ")}" >> "$FILE"

  echo "
val MaterialTheme.$PROPERTY_NAME: $CLASS_NAME
    @Composable
    @ReadOnlyComposable
    get() = Local$CLASS_NAME.current" >> "$FILE"
}

generate_color_class "TextColors" "${TEXT_COLORS[@]}"
generate_color_class "SurfaceColors" "${SURFACE_COLORS[@]}"
generate_color_class "BorderColors" "${BORDER_COLORS[@]}"
generate_color_class "IconColors" "${ICON_COLORS[@]}"

echo "package $PACKAGE.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Immutable
data class Dimens(" > "$THEME_DIR/Dimens.kt"

while IFS= read -r line; do
  if [[ $line =~ \"([a-zA-Z0-9]+)\"[[:space:]]*:[[:space:]]*\{ ]]; then
    RAW_NAME="${BASH_REMATCH[1]}"
  fi

  if [[ $line =~ \"mobile\"[[:space:]]*:[[:space:]]*([0-9]+(\.[0-9]+)?) ]]; then
    VALUE="${BASH_REMATCH[1]}"

    if [[ "$RAW_NAME" == fontSize* ]]; then
      echo "    val $RAW_NAME: TextUnit = ${VALUE}.sp," >> "$THEME_DIR/Dimens.kt"
    else
      echo "    val $RAW_NAME: Dp = ${VALUE}.dp," >> "$THEME_DIR/Dimens.kt"
    fi

    RAW_NAME=""
  fi
done < "$TOKENS"

cat >> "$THEME_DIR/Dimens.kt" << EOF
)

val LocalDimens = staticCompositionLocalOf { Dimens() }

val MaterialTheme.dimens: Dimens
    @Composable
    @ReadOnlyComposable
    get() = LocalDimens.current
EOF

cat > "$JAVA_DIR/GloberacerTheme.kt" << EOF
package $PACKAGE

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import com.globeracer.design.theme.brand.*
import com.globeracer.design.theme.*

EOF

generate_theme_instance() {
  local CLASS_NAME=$1
  local VAR_NAME=$2
  local SUFFIX=$3
  shift 3
  local COLOR_LIST=("$@")

  echo "val $VAR_NAME = $CLASS_NAME(" >> "$JAVA_DIR/GloberacerTheme.kt"
  for NAME in "${COLOR_LIST[@]}"; do
    echo "    $NAME = ${NAME}${SUFFIX}," >> "$JAVA_DIR/GloberacerTheme.kt"
  done
  echo ")" >> "$JAVA_DIR/GloberacerTheme.kt"
}

generate_theme_instance "TextColors" "TextColorsLight" "Light" "${TEXT_COLORS[@]}"
generate_theme_instance "TextColors" "TextColorsDark" "Dark" "${TEXT_COLORS[@]}"
generate_theme_instance "SurfaceColors" "SurfaceColorsLight" "Light" "${SURFACE_COLORS[@]}"
generate_theme_instance "SurfaceColors" "SurfaceColorsDark" "Dark" "${SURFACE_COLORS[@]}"
generate_theme_instance "BorderColors" "BorderColorsLight" "Light" "${BORDER_COLORS[@]}"
generate_theme_instance "BorderColors" "BorderColorsDark" "Dark" "${BORDER_COLORS[@]}"
generate_theme_instance "IconColors" "IconColorsLight" "Light" "${ICON_COLORS[@]}"
generate_theme_instance "IconColors" "IconColorsDark" "Dark" "${ICON_COLORS[@]}"

cat >> "$JAVA_DIR/GloberacerTheme.kt" << EOF

@Composable
fun GloberacerTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val textColors = if (darkTheme) TextColorsDark else TextColorsLight
    val surfaceColors = if (darkTheme) SurfaceColorsDark else SurfaceColorsLight
    val borderColors = if (darkTheme) BorderColorsDark else BorderColorsLight
    val iconColors = if (darkTheme) IconColorsDark else IconColorsLight

    CompositionLocalProvider(
        LocalTextColors provides textColors,
        LocalSurfaceColors provides surfaceColors,
        LocalBorderColors provides borderColors,
        LocalIconColors provides iconColors,
        LocalDimens provides Dimens(),
    ) {
        MaterialTheme(
            typography = MaterialTheme.typography,
            content = content,
        )
    }
}
EOF

FONT_SRC_DIR="$(dirname "$0")/fonts"
FONT_DIR="$ROOT/src/main/res/font"
mkdir -p "$FONT_DIR"

for FONT_PATH in "$FONT_SRC_DIR"/*; do
    if [[ -f "$FONT_PATH" ]]; then
        FONT_NAME="$(basename "$FONT_PATH" .ttf | tr '[:upper:]' '[:lower:]' | tr '-' '_' )"
        cp "$FONT_PATH" "$FONT_DIR/$FONT_NAME.ttf"
    fi
done

FONT_FILE="$THEME_DIR/Fonts.kt"
echo "package $PACKAGE.theme

import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import $PACKAGE.R
" > "$FONT_FILE"

declare -A FONT_FAMILIES

for FONT_PATH in "$FONT_SRC_DIR"/*; do
    if [[ -f "$FONT_PATH" ]]; then
        FILE_NAME="$(basename "$FONT_PATH" .ttf)"
        SNAKE_NAME="$(echo "$FILE_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_' )"
        FAMILY_NAME="$(echo "$FILE_NAME" | cut -d'-' -f1 | cut -d'_' -f1)"
        FAMILY_NAME_CAP="$(tr '[:lower:]' '[:upper:]' <<< ${FAMILY_NAME:0:1})${FAMILY_NAME:1}"
        FONT_FAMILIES["$FAMILY_NAME_CAP"]+="$SNAKE_NAME "
    fi
done

for FAMILY in "${!FONT_FAMILIES[@]}"; do
    echo "val $FAMILY = FontFamily(" >> "$FONT_FILE"
    for FONT in ${FONT_FAMILIES[$FAMILY]}; do
        WEIGHT="FontWeight.Normal"
        [[ "$FONT" =~ bold ]] && WEIGHT="FontWeight.Bold"
        [[ "$FONT" =~ medium ]] && WEIGHT="FontWeight.Medium"
        echo "    Font(resId = R.font.$FONT, weight = $WEIGHT)," >> "$FONT_FILE"
    done
    echo ")" >> "$FONT_FILE"
done