package com.globeracer.design.theme.brand

import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.graphics.Color
import androidx.compose.material3.MaterialTheme
import com.globeracer.design.theme.*

@Immutable
data class TextColors(
    val textPrimary: Color,
    val textSecondary: Color,
    val textDisabled: Color,
    val textError: Color,
    val textSuccess: Color,
    val textWarning: Color,
    val textInfo: Color,
    val textOnActionPrimary: Color,
    val textOnActionOutline: Color,
    val textOnActionLink: Color,
    val textOnActionErrorHover: Color,
    val textOnActionLinkHover: Color,
    val textOnActionSuccessHover: Color,
    val textOnActionWarningHover: Color,
    val textOnActionInfoHover: Color,
    val textOnActionError: Color,
    val textOnActionWarning: Color,
    val textOnActionSuccess: Color,
    val textOnActionInfo: Color,
    val textOnActionTransparent: Color,
    val textAccent: Color,
    val textOnActionSecondary: Color,
    val textOnActionOutlineNeutral: Color,
    val textOnActionTransparentError: Color,
    val textOnActionTransparentErrorHover: Color,
    val textDisabledInverted: Color,
    val textPrimaryInverted: Color,
    val textOnActionTransparentInverted: Color,
    val textPrimaryLight: Color,
    val textOnActionTransparentErrorActive: Color,
    val textOnActionTransparentInvertedActive: Color,
    val textOnActionTransparentInvertedHover: Color,
    val textOnActionTransparentActive: Color,
    val textOnActionTransparentHover: Color,
    val textOnActionLinkActive: Color,
)

val LocalTextColors = staticCompositionLocalOf { TextColors(
    textPrimary = textPrimaryLight,
    textSecondary = textSecondaryLight,
    textDisabled = textDisabledLight,
    textError = textErrorLight,
    textSuccess = textSuccessLight,
    textWarning = textWarningLight,
    textInfo = textInfoLight,
    textOnActionPrimary = textOnActionPrimaryLight,
    textOnActionOutline = textOnActionOutlineLight,
    textOnActionLink = textOnActionLinkLight,
    textOnActionErrorHover = textOnActionErrorHoverLight,
    textOnActionLinkHover = textOnActionLinkHoverLight,
    textOnActionSuccessHover = textOnActionSuccessHoverLight,
    textOnActionWarningHover = textOnActionWarningHoverLight,
    textOnActionInfoHover = textOnActionInfoHoverLight,
    textOnActionError = textOnActionErrorLight,
    textOnActionWarning = textOnActionWarningLight,
    textOnActionSuccess = textOnActionSuccessLight,
    textOnActionInfo = textOnActionInfoLight,
    textOnActionTransparent = textOnActionTransparentLight,
    textAccent = textAccentLight,
    textOnActionSecondary = textOnActionSecondaryLight,
    textOnActionOutlineNeutral = textOnActionOutlineNeutralLight,
    textOnActionTransparentError = textOnActionTransparentErrorLight,
    textOnActionTransparentErrorHover = textOnActionTransparentErrorHoverLight,
    textDisabledInverted = textDisabledInvertedLight,
    textPrimaryInverted = textPrimaryInvertedLight,
    textOnActionTransparentInverted = textOnActionTransparentInvertedLight,
    textPrimaryLight = textPrimaryLightLight,
    textOnActionTransparentErrorActive = textOnActionTransparentErrorActiveLight,
    textOnActionTransparentInvertedActive = textOnActionTransparentInvertedActiveLight,
    textOnActionTransparentInvertedHover = textOnActionTransparentInvertedHoverLight,
    textOnActionTransparentActive = textOnActionTransparentActiveLight,
    textOnActionTransparentHover = textOnActionTransparentHoverLight,
    textOnActionLinkActive = textOnActionLinkActiveLight,
)}

val MaterialTheme.textColors: TextColors
    @Composable
    @ReadOnlyComposable
    get() = LocalTextColors.current
