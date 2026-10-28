import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../domain/game.dart';

/// Two circles in the colors of the two people, overlapping in plum, with
/// "36" where they meet. Decoration only.
///
/// The animations play the opening: [dance] brings the circles in, turning
/// around each other, [meet] fills the overlap, [digits] shows "36". Without
/// them the logo stands still.
class Logo extends StatelessWidget {
  const Logo({
    super.key,
    this.width = 210,
    this.dance = kAlwaysCompleteAnimation,
    this.meet = kAlwaysCompleteAnimation,
    this.digits = kAlwaysCompleteAnimation,
  });

  final double width;
  final Animation<double> dance;
  final Animation<double> meet;
  final Animation<double> digits;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      size: Size(width, width * 150 / 210),
      painter: _LogoPainter(
        dance: dance,
        meet: meet,
        digits: digits,
        people: Palette.dawn.people,
        overlap: Palette.dawn.primary,
        digitStyle: TextStyle(
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
    required this.dance,
    required this.meet,
    required this.digits,
    required this.people,
    required this.overlap,
    required this.digitStyle,
  }) : super(repaint: Listenable.merge([dance, meet, digits]));

  final Animation<double> dance;
  final Animation<double> meet;
  final Animation<double> digits;
  final List<Color> people;
  final Color overlap;
  final TextStyle digitStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 210;
    final radius = 62 * unit;
    final center = size.center(Offset.zero);
    final left = Offset(75 * unit, center.dy);
    final right = Offset(135 * unit, center.dy);

    void around(double angle, double scale, void Function() draw) {
      canvas
        ..save()
        ..translate(center.dx, center.dy)
        ..rotate(angle)
        ..scale(scale)
        ..translate(-center.dx, -center.dy);
      draw();
      canvas.restore();
    }

    final meeting = meet.value;
    if (meeting > 0) {
      final shared = Path.combine(
        PathOperation.intersect,
        Path()..addOval(Rect.fromCircle(center: left, radius: radius)),
        Path()..addOval(Rect.fromCircle(center: right, radius: radius)),
      );
      around(0, meeting, () {
        canvas.drawPath(
          shared,
          Paint()..color = overlap.withValues(alpha: meeting.clamp(0, 1)),
        );
      });
    }

    // Half a turn and more, while the two come closer.
    final apart = 1 - dance.value;
    final shift = Offset(78 * unit * apart, 0);
    final alpha = (dance.value * 4).clamp(0.0, 1.0);
    around(-200 / 180 * pi * apart, 1, () {
      for (final (at, color) in [
        (left - shift, people[0]),
        (right + shift, people[1]),
      ]) {
        canvas.drawCircle(
          at,
          radius,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5 * unit
            ..color = color.withValues(alpha: alpha),
        );
      }
    });

    if (digits.value > 0) {
      final text = TextPainter(
        text: TextSpan(
          text: '36',
          style: digitStyle.copyWith(
            color: digitStyle.color!.withValues(alpha: digits.value),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(canvas, center - Offset(text.width / 2, text.height / 2));
    }
  }

  @override
  bool shouldRepaint(_LogoPainter old) =>
      old.dance != dance ||
      old.meet != meet ||
      old.digits != digits ||
      old.people != people ||
      old.overlap != overlap ||
      old.digitStyle != digitStyle;
}

/// A small infinity sign, one loop in each person's color. Decoration only,
/// it does nothing.
///
/// [left] and [right] draw the loops in the opening animation.
class InfinitySign extends StatelessWidget {
  const InfinitySign({
    super.key,
    this.size = 26,
    this.left = kAlwaysCompleteAnimation,
    this.right = kAlwaysCompleteAnimation,
  });

  final double size;
  final Animation<double> left;
  final Animation<double> right;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      size: Size.square(size),
      painter: _InfinityPainter(Palette.of(context).people, left, right),
    ),
  );
}

class _InfinityPainter extends CustomPainter {
  _InfinityPainter(this.people, this.left, this.right)
    : super(repaint: Listenable.merge([left, right]));

  final List<Color> people;
  final Animation<double> left;
  final Animation<double> right;

  @override
  void paint(Canvas canvas, Size size) {
    // Drawn on a 24 × 24 grid, like the icons beside it.
    canvas.scale(size.width / 24);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final leftLoop = Path()
      ..moveTo(12, 12)
      ..cubicTo(10, 8.5, 3.5, 8, 3.5, 12)
      ..cubicTo(3.5, 16, 10, 15.5, 12, 12);
    final rightLoop = Path()
      ..moveTo(12, 12)
      ..cubicTo(14, 15.5, 20.5, 16, 20.5, 12)
      ..cubicTo(20.5, 8, 14, 8.5, 12, 12);
    for (final (path, share, color) in [
      (leftLoop, left.value, people[0]),
      (rightLoop, right.value, people[1]),
    ]) {
      if (share <= 0) continue;
      for (final metric in path.computeMetrics()) {
        canvas.drawPath(
          metric.extractPath(0, metric.length * share),
          stroke..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_InfinityPainter old) =>
      old.people != people || old.left != left || old.right != right;
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
