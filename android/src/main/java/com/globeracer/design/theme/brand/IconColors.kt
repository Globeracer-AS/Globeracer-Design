package com.globeracer.design.theme.brand

import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.graphics.Color
import androidx.compose.material3.MaterialTheme
import com.globeracer.design.theme.*

@Immutable
data class IconColors(
    val iconPrimary: Color,
    val iconPrimaryInverted: Color,
    val iconOnActionPrimary: Color,
    val iconOnActionSecondary: Color,
    val iconOnActionLink: Color,
    val iconOnActionOutline: Color,
    val iconOnDisabled: Color,
    val iconOnActionError: Color,
    val iconOnActionWarning: Color,
    val iconOnActionSuccess: Color,
    val iconOnActionLinkHover: Color,
    val iconOnActionOutlineNeutral: Color,
    val iconSecondary: Color,
    val iconAccent: Color,
    val iconOnActionTransparentError: Color,
    val iconOnActionTransparentErrorHover: Color,
    val iconInfo: Color,
    val iconOnActionTransparent: Color,
    val iconOnActionTransparentInverted: Color,
    val iconWarning: Color,
    val iconError: Color,
    val iconPrimaryLight: Color,
    val iconOnActionTransparentErrorActive: Color,
    val iconOnActionTransparentHover: Color,
    val iconOnActionTransparentActive: Color,
    val iconOnActionTransparentInvertedHover: Color,
    val iconOnActionTransparentInvertedActive: Color,
    val iconOnActionLinkActive: Color,
    val iconLike: Color,
)

val LocalIconColors = staticCompositionLocalOf { IconColors(
    iconPrimary = iconPrimaryLight,
    iconPrimaryInverted = iconPrimaryInvertedLight,
    iconOnActionPrimary = iconOnActionPrimaryLight,
    iconOnActionSecondary = iconOnActionSecondaryLight,
    iconOnActionLink = iconOnActionLinkLight,
    iconOnActionOutline = iconOnActionOutlineLight,
    iconOnDisabled = iconOnDisabledLight,
    iconOnActionError = iconOnActionErrorLight,
    iconOnActionWarning = iconOnActionWarningLight,
    iconOnActionSuccess = iconOnActionSuccessLight,
    iconOnActionLinkHover = iconOnActionLinkHoverLight,
    iconOnActionOutlineNeutral = iconOnActionOutlineNeutralLight,
    iconSecondary = iconSecondaryLight,
    iconAccent = iconAccentLight,
    iconOnActionTransparentError = iconOnActionTransparentErrorLight,
    iconOnActionTransparentErrorHover = iconOnActionTransparentErrorHoverLight,
    iconInfo = iconInfoLight,
    iconOnActionTransparent = iconOnActionTransparentLight,
    iconOnActionTransparentInverted = iconOnActionTransparentInvertedLight,
    iconWarning = iconWarningLight,
    iconError = iconErrorLight,
    iconPrimaryLight = iconPrimaryLightLight,
    iconOnActionTransparentErrorActive = iconOnActionTransparentErrorActiveLight,
    iconOnActionTransparentHover = iconOnActionTransparentHoverLight,
    iconOnActionTransparentActive = iconOnActionTransparentActiveLight,
    iconOnActionTransparentInvertedHover = iconOnActionTransparentInvertedHoverLight,
    iconOnActionTransparentInvertedActive = iconOnActionTransparentInvertedActiveLight,
    iconOnActionLinkActive = iconOnActionLinkActiveLight,
    iconLike = iconLikeLight,
)}

val MaterialTheme.iconColors: IconColors
    @Composable
    @ReadOnlyComposable
    get() = LocalIconColors.current
