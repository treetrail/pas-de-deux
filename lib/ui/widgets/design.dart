import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../domain/game.dart';

/// Two circles in the colors of the two people, overlapping in plum, with
/// "36" where they meet. Decoration only.
class Logo extends StatelessWidget {
  const Logo({super.key, this.width = 210});

  final double width;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      size: Size(width, width * 150 / 210),
      painter: _LogoPainter(
        people: Palette.dawn.people,
        overlap: Palette.dawn.primary,
        digits: TextStyle(
          fontFamily: AppTheme.serif,
          fontSize: width * 34 / 210,
          color: Palette.dawn.ground,
        ),
      ),
    ),
  );
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({
    required this.people,
    required this.overlap,
    required this.digits,
  });

  final List<Color> people;
  final Color overlap;
  final TextStyle digits;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 210;
    final radius = 62 * unit;
    final left = Offset(75 * unit, size.height / 2);
    final right = Offset(135 * unit, size.height / 2);
    final shared = Path.combine(
      PathOperation.intersect,
      Path()..addOval(Rect.fromCircle(center: left, radius: radius)),
      Path()..addOval(Rect.fromCircle(center: right, radius: radius)),
    );
    canvas.drawPath(shared, Paint()..color = overlap);
    for (final (center, color) in [(left, people[0]), (right, people[1])]) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 * unit
          ..color = color,
      );
    }
    final text = TextPainter(
      text: TextSpan(text: '36', style: digits),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(
      canvas,
      Offset(size.width / 2, size.height / 2) -
          Offset(text.width / 2, text.height / 2),
    );
  }

  @override
  bool shouldRepaint(_LogoPainter old) =>
      old.people != people || old.overlap != overlap || old.digits != digits;
}

/// A small infinity sign, one loop in each person's color. Decoration only,
/// it does nothing.
class InfinitySign extends StatelessWidget {
  const InfinitySign({super.key, this.size = 26});

  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      size: Size.square(size),
      painter: _InfinityPainter(Palette.of(context).people),
    ),
  );
}

class _InfinityPainter extends CustomPainter {
  _InfinityPainter(this.people);

  final List<Color> people;

  @override
  void paint(Canvas canvas, Size size) {
    // Drawn on a 24 × 24 grid, like the icons beside it.
    canvas.scale(size.width / 24);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final left = Path()
      ..moveTo(12, 12)
      ..cubicTo(10, 8.5, 3.5, 8, 3.5, 12)
      ..cubicTo(3.5, 16, 10, 15.5, 12, 12);
    final right = Path()
      ..moveTo(12, 12)
      ..cubicTo(14, 15.5, 20.5, 16, 20.5, 12)
      ..cubicTo(20.5, 8, 14, 8.5, 12, 12);
    canvas.drawPath(left, stroke..color = people[0]);
    canvas.drawPath(right, stroke..color = people[1]);
  }

  @override
  bool shouldRepaint(_InfinityPainter old) => old.people != people;
}

/// The initial of a person in their color: filled for who acts, a ring for
/// who waits.
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({
    super.key,
    required this.name,
    required this.person,
    this.filled = true,
    this.size = 36,
  });

  final String name;
  final int person;
  final bool filled;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);
    final color = palette.people[person];
    final initial = name.isEmpty ? '' : name.characters.first.toUpperCase();
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? color : null,
          border: filled ? null : Border.all(color: color, width: 2),
        ),
        child: Text(
          initial,
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            fontSize: size * 0.42,
            fontWeight: FontWeight.w600,
            color: filled ? palette.onPeople[person] : palette.ink,
          ),
        ),
      ),
    );
  }
}

/// A small dot in a person's color.
class PersonDot extends StatelessWidget {
  const PersonDot({super.key, required this.person, this.size = 12});

  final int person;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Palette.of(context).people[person],
    ),
  );
}

/// One segment per stage of the game, filled as far as the game has got.
class StageProgress extends StatelessWidget {
  const StageProgress({super.key, required this.game});

  final GameState game;

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);
    final stages = <int, ({int total, int done})>{};
    for (var i = 0; i < game.turns.length; i++) {
      final stage = game.turns[i].stage;
      final counts = stages[stage] ?? (total: 0, done: 0);
      stages[stage] = (
        total: counts.total + 1,
        done: counts.done + (i < game.turnIndex || game.finished ? 1 : 0),
      );
    }
    return ExcludeSemantics(
      child: Row(
        children: [
          for (final (i, counts) in stages.values.indexed) ...[
            if (i > 0) const SizedBox(width: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: counts.done / counts.total,
                  minHeight: 4,
                  color: palette.ink,
                  backgroundColor: palette.track,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
