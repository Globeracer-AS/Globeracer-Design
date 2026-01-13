package com.globeracer.design.theme

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
data class Dimens(
    val fontSizeBodyBase: TextUnit = 16.sp,
    val fontSizeBodySmall: TextUnit = 14.sp,
    val fontSizeBodyLarge: TextUnit = 20.sp,
    val fontSizeHeadingXLarge: TextUnit = 24.sp,
    val fontSizeHeading2xLarge: TextUnit = 32.sp,
    val fontSizeHeading3xLarge: TextUnit = 40.sp,
    val fontSizeHeading4xLarge: TextUnit = 48.sp,
    val fontSizeHeading5xLarge: TextUnit = 64.sp,
    val fontSizeBodyXSmall: TextUnit = 12.sp,
    val fontSizeHeadingLarge: TextUnit = 20.sp,
    val lineHeightBodyXSm: TextUnit = 10.sp,
    val lineHeightBodyMd: TextUnit = 18.sp,
    val lineHeightBodySm: TextUnit = 14.sp,
    val lineHeightHeadingLg: TextUnit = 24.sp,
    val lineHeightHeadingXLg: TextUnit = 28.sp,
    val lineHeightHeading2xLg: TextUnit = 36.sp,
    val lineHeightHeading3xLg: TextUnit = 48.sp,
    val lineHeightHeading4xLg: TextUnit = 56.sp,
    val lineHeightHeading5xLg: TextUnit = 76.sp,
    val paragraphSpacingBodyXSm: Dp = 2.dp,
    val paragraphSpacingBodyMd: Dp = 6.dp,
    val paragraphSpacingBodyLg: Dp = 8.dp,
    val paragraphSpacingHeadingLg: Dp = 16.dp,
    val paragraphSpacingHeadingXLg: Dp = 24.dp,
    val paragraphSpacingHeading2xLg: Dp = 32.dp,
    val paragraphSpacingHeading3xLg: Dp = 36.dp,
    val paragraphSpacingHeading4xLg: Dp = 40.dp,
    val paragraphSpacingBodySm: Dp = 4.dp,
    val paragraphSpacingHeading5xLg: Dp = 48.dp,
    val spacing2xSm: Dp = 2.dp,
    val spacingXSm: Dp = 4.dp,
    val spacingSm: Dp = 8.dp,
    val spacingBase: Dp = 16.dp,
    val spacingLg: Dp = 24.dp,
    val spacingXLg: Dp = 32.dp,
    val spacing2xLg: Dp = 48.dp,
    val spacing3xLg: Dp = 64.dp,
    val iconSizeMd: Dp = 24.dp,
    val iconSizeSm: Dp = 16.dp,
    val spacingNone: Dp = 0.dp,
    val dropshadowBlurDefault: Dp = 8.dp,
    val dropshadowOpacity: Dp = 30.dp,
    val dropshadowPositionSm: Dp = 2.dp,
    val dropshadowPositionNone: Dp = 0.dp,
    val borderWidthDefault: Dp = 2.dp,
    val borderWidthNone: Dp = 0.dp,
    val iconSizeLg: Dp = 32.dp,
    val dropshadowPositionMd: Dp = 4.dp,
    val iconSizeXSm: Dp = 12.dp,
    val dropshadowBlurSm: Dp = 4.dp,
    val borderRadiusNone: Dp = 0.dp,
    val borderRadiusXSm: Dp = 2.dp,
    val borderRadiusSm: Dp = 4.dp,
    val borderRadiusMd: Dp = 12.dp,
    val borderRadiusLg: Dp = 16.dp,
    val borderRadiusXLg: Dp = 24.dp,
    val borderRadius2xLg: Dp = 32.dp,
    val borderRadius3xLg: Dp = 64.dp,
    val dropshadowBlurLg: Dp = 24.dp,
    val dropshadowPositionLg: Dp = 8.dp,
)

val LocalDimens = staticCompositionLocalOf { Dimens() }

val MaterialTheme.dimens: Dimens
    @Composable
    @ReadOnlyComposable
    get() = LocalDimens.current
