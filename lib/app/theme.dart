import 'package:flutter/material.dart';

/// The colors of one ground. The game gets darker with every stage, like an
/// evening: light rose, plum, night. The four-minute look is black. Each
/// person keeps one color throughout the game: rose for the owner of the
/// phone, gold for the other person.
@immutable
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.ground,
    required this.ink,
    required this.muted,
    required this.primary,
    required this.onPrimary,
    required this.outline,
    required this.line,
    required this.card,
    required this.track,
    required this.people,
    required this.onPeople,
  });

  final Color ground;
  final Color ink;

  /// Secondary text, at least 4.5:1 on [ground].
  final Color muted;
  final Color primary;
  final Color onPrimary;
  final Color outline;
  final Color line;
  final Color card;

  /// The empty part of the progress bar and of the look's ring.
  final Color track;

  /// One color per person, in the order of the game's names.
  final List<Color> people;

  /// Text on a filled [people] color.
  final List<Color> onPeople;

  static const dawn = Palette(
    ground: Color(0xFFF7EDE8),
    ink: Color(0xFF2A1620),
    muted: Color(0xFF6E5560),
    primary: Color(0xFF8C3B5E),
    onPrimary: Color(0xFFFFF7F9),
    outline: Color(0xFFCDB3BD),
    line: Color(0xFFE8D6CF),
    card: Color(0xFFFFFBF9),
    track: Color(0xFFE2C6BD),
    people: [Color(0xFFC24D78), Color(0xFFC98A2B)],
    onPeople: [Color(0xFFFFF7F9), Color(0xFF2A1620)],
  );

  /// Stage 1 in dark mode.
  static const dusk = Palette(
    ground: Color(0xFF2B1822),
    ink: Color(0xFFF3E6EA),
    muted: Color(0xFFC9B3BD),
    primary: Color(0xFFE9A6C0),
    onPrimary: Color(0xFF2B1822),
    outline: Color(0xFF7A6070),
    line: Color(0xFF47303C),
    card: Color(0xFF37222D),
    track: Color(0xFF47303C),
    people: [Color(0xFFF08DB0), Color(0xFFE2A54A)],
    onPeople: [Color(0xFF2A1620), Color(0xFF2A1620)],
  );

  static const plum = Palette(
    ground: Color(0xFF8C3B5E),
    ink: Color(0xFFFFF4F7),
    muted: Color(0xFFF6DCE6),
    primary: Color(0xFFFFF4F7),
    onPrimary: Color(0xFF6E2747),
    outline: Color(0xFFD9A5BB),
    line: Color(0xFFA9607F),
    card: Color(0xFF9A4A6C),
    track: Color(0xFFA9607F),
    people: [Color(0xFFF08DB0), Color(0xFFE2A54A)],
    onPeople: [Color(0xFF2A1620), Color(0xFF2A1620)],
  );

  static const night = Palette(
    ground: Color(0xFF1C0F17),
    ink: Color(0xFFF3E6EA),
    muted: Color(0xFFC7B1BB),
    primary: Color(0xFFF3E6EA),
    onPrimary: Color(0xFF1C0F17),
    outline: Color(0xFF6B5160),
    line: Color(0xFF3E2A35),
    card: Color(0xFF2A1A23),
    track: Color(0xFF3E2A35),
    people: [Color(0xFFF08DB0), Color(0xFFE2A54A)],
    onPeople: [Color(0xFF2A1620), Color(0xFF2A1620)],
  );

  static const look = Palette(
    ground: Color(0xFF000000),
    ink: Color(0xFFF3E6EA),
    muted: Color(0xFFA8949D),
    primary: Color(0xFF8C3B5E),
    onPrimary: Color(0xFFFFF7F9),
    outline: Color(0xFF6B5160),
    line: Color(0xFF24161D),
    card: Color(0xFF1C0F17),
    track: Color(0xFF24161D),
    people: [Color(0xFFC24D78), Color(0xFFC98A2B)],
    onPeople: [Color(0xFFFFF7F9), Color(0xFF2A1620)],
  );

  static Palette of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<Palette>() ??
        (theme.brightness == Brightness.light ? dawn : night);
  }

  @override
  Palette copyWith() => this;

  @override
  Palette lerp(Palette? other, double t) =>
      other == null || t < 0.5 ? this : other;
}

abstract final class AppTheme {
  static const serif = 'Fraunces';
  static const sans = 'Figtree';

  static final light = _theme(Palette.dawn);
  static final dark = _theme(Palette.night);
  static final _dusk = _theme(Palette.dusk);
  static final _plum = _theme(Palette.plum);

  /// The four-minute look is calm and dark, whatever the system mode (US-14).
  static final look = _theme(Palette.look);

  /// The deeper the stage, the darker the ground.
  static ThemeData stage(int stage, Brightness brightness) => switch (stage) {
    1 => brightness == Brightness.light ? light : _dusk,
    2 => _plum,
    _ => dark,
  };

  static ThemeData _theme(Palette p) {
    final brightness = ThemeData.estimateBrightnessForColor(p.ground);
    final light = brightness == Brightness.light;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      primaryContainer: p.card,
      onPrimaryContainer: p.ink,
      secondary: p.primary,
      onSecondary: p.onPrimary,
      secondaryContainer: p.card,
      onSecondaryContainer: p.ink,
      tertiary: p.people[1],
      onTertiary: p.onPeople[1],
      error: light ? const Color(0xFFB3261E) : const Color(0xFFF2B8B5),
      onError: light ? Colors.white : const Color(0xFF601410),
      surface: p.ground,
      onSurface: p.ink,
      onSurfaceVariant: p.muted,
      surfaceContainerLowest: p.card,
      surfaceContainerLow: p.card,
      surfaceContainer: p.card,
      surfaceContainerHigh: p.card,
      surfaceContainerHighest: p.card,
      surfaceTint: Colors.transparent,
      outline: p.outline,
      outlineVariant: p.line,
      inverseSurface: p.ink,
      onInverseSurface: p.ground,
      inversePrimary: p.primary,
    );
    final typography = Typography.material2021();
    final base = (light ? typography.black : typography.white).apply(
      fontFamily: sans,
      bodyColor: p.ink,
      displayColor: p.ink,
    );
    TextStyle serifStyle(
      TextStyle? style,
      double size,
      FontWeight weight,
      double height,
    ) => style!.copyWith(
      fontFamily: serif,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: 0,
    );
    final text = base.copyWith(
      displayLarge: serifStyle(base.displayLarge, 72, FontWeight.w300, 1),
      displayMedium: serifStyle(base.displayMedium, 54, FontWeight.w300, 1),
      displaySmall: serifStyle(base.displaySmall, 40, FontWeight.w300, 1.08),
      headlineLarge: serifStyle(base.headlineLarge, 32, FontWeight.w400, 1.22),
      headlineMedium: serifStyle(base.headlineMedium, 28, FontWeight.w400, 1.2),
      headlineSmall: serifStyle(base.headlineSmall, 27, FontWeight.w400, 1.28),
      titleLarge: serifStyle(base.titleLarge, 22, FontWeight.w400, 1.35),
      titleMedium: base.titleMedium!.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      titleSmall: base.titleSmall!.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: base.bodyLarge!.copyWith(fontSize: 17, height: 1.45),
      bodyMedium: base.bodyMedium!.copyWith(fontSize: 15, height: 1.45),
      labelLarge: base.labelLarge!.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      labelMedium: base.labelMedium!.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    );
    const pill = StadiumBorder();
    return ThemeData(
      colorScheme: scheme,
      textTheme: text,
      fontFamily: sans,
      scaffoldBackgroundColor: p.ground,
      extensions: [p],
      appBarTheme: AppBarTheme(
        backgroundColor: p.ground,
        foregroundColor: p.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: text.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: pill,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: pill,
          foregroundColor: p.ink,
          side: BorderSide(color: p.outline, width: 1.5),
          textStyle: text.labelLarge!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: p.muted,
          textStyle: text.labelLarge!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: p.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: p.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: p.primary, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: p.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: p.line),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: text.headlineMedium,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: p.primary,
        inactiveTrackColor: p.track,
        thumbColor: p.primary,
      ),
      dividerTheme: DividerThemeData(color: p.line),
    );
  }
}
