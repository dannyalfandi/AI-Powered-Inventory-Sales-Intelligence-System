import 'package:flutter/material.dart';

import 'app_accent.dart';
import 'app_motion.dart';
import 'app_spacing.dart';
import 'app_status_colors.dart';
import 'app_typography.dart';

/// Builds the app's light and dark themes from one accent seed.
///
/// Everything visual is decided here: screens read `Theme.of(context)` and
/// never hardcode a colour, a radius or a text size. The component themes
/// below exist so that a plain `Card`, `TextField` or `Chip` already looks
/// right — a screen should not have to decorate a container to get the house
/// style, and if it does, that is the signal to add a component theme instead.
abstract final class AppTheme {
  static ThemeData light([AppAccent accent = AppAccent.fallback]) => _build(Brightness.light, accent);

  static ThemeData dark([AppAccent accent = AppAccent.fallback]) => _build(Brightness.dark, accent);

  static ThemeData _build(Brightness brightness, AppAccent accent) {
    final isLight = brightness == Brightness.light;
    final scheme = ColorScheme.fromSeed(seedColor: accent.seed, brightness: brightness);
    final status = isLight ? AppStatusColors.light : AppStatusColors.dark;
    final base = ThemeData(colorScheme: scheme, brightness: brightness);
    final text = AppTypography.apply(base.textTheme);

    return base.copyWith(
      textTheme: text,
      extensions: [status],
      scaffoldBackgroundColor: scheme.surface,

      // Route transitions are defined once here so every platform and every
      // route animates the same way (see AppPageTransitions).
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _FadeThroughTransitionBuilder(),
          TargetPlatform.iOS: _FadeThroughTransitionBuilder(),
          TargetPlatform.linux: _FadeThroughTransitionBuilder(),
          TargetPlatform.macOS: _FadeThroughTransitionBuilder(),
          TargetPlatform.windows: _FadeThroughTransitionBuilder(),
        },
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: scheme.surfaceTint,
        centerTitle: false,
        scrolledUnderElevation: 2,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
      ),

      cardTheme: CardThemeData(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color: scheme.surfaceContainerLow,
        // A hairline instead of a shadow: on a list of cards, five soft
        // shadows turn into grey mush, while an outline stays crisp in both
        // modes and at any brightness setting.
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: isLight ? 0.7 : 0.5)),
        ),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(borderRadius: AppRadius.mdAll),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        labelStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        helperStyle: text.bodySmall,
        errorStyle: text.bodySmall?.copyWith(color: scheme.error),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 44),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: text.labelLarge,
        ),
      ),

      chipTheme: ChipThemeData(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
        side: BorderSide(color: scheme.outlineVariant),
        labelStyle: text.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      ),

      dialogTheme: DialogThemeData(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
        titleTextStyle: text.titleMedium?.copyWith(color: scheme.onSurface),
        contentTextStyle: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        showDragHandle: true,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
        contentTextStyle: text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        insetPadding: AppSpacing.allMd,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? text.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface)
              : text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ),

      listTileTheme: ListTileThemeData(
        titleTextStyle: text.bodyLarge?.copyWith(color: scheme.onSurface),
        subtitleTextStyle: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
      ),

      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1, thickness: 1),

      // RefreshIndicator already defaults its arrow to colorScheme.primary,
      // so pull-to-refresh follows the chosen accent for free; only the disc
      // behind it is lifted off the page (see AppRefreshIndicator).
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        circularTrackColor: Colors.transparent,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        extendedTextStyle: text.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(textStyle: text.labelMedium),
      ),
    );
  }
}

/// Page transition: a short fade with a small upward drift.
///
/// The stock Android transition slides a whole screen in from the right, which
/// on a five-tab app makes every push feel like a journey. This travels 16px —
/// enough to say "a new layer arrived", not enough to make the user wait for
/// it — and reverses on pop. Under "reduce motion" it degrades to a plain cut.
class _FadeThroughTransitionBuilder extends PageTransitionsBuilder {
  const _FadeThroughTransitionBuilder();

  @override
  Duration get transitionDuration => AppMotion.page;

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (AppMotion.reduced(context)) return child;
    final curved = CurvedAnimation(parent: animation, curve: AppMotion.enter);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.02), end: Offset.zero).animate(curved),
        child: child,
      ),
    );
  }
}
