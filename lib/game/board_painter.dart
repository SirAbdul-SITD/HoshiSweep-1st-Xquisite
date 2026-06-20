// lib/game/board_painter.dart
import 'package:flutter/material.dart';
import 'game_state.dart';
import '../utils/constants.dart';

class BoardPainter extends CustomPainter {
  final GameState st;
  BoardPainter(this.st);

  @override
  void paint(Canvas canvas, Size size) {
    final n = st.n;
    final cell = size.width / n;

    for (int i = 0; i < n * n; i++) {
      final r = i ~/ n, c = i % n;
      final rect = Rect.fromLTWH(c * cell + 1, r * cell + 1, cell - 2, cell - 2);
      final rr = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      final m = st.marks[i];
      if (m == 1) {
        final bad = st.shadedTouching(i);
        canvas.drawRRect(rr, Paint()..color = kShade);
        canvas.drawRRect(
            rr,
            Paint()
              ..color = bad ? kErr : kShadeEdge
              ..style = PaintingStyle.stroke
              ..strokeWidth = bad ? 2.5 : 1);
      } else {
        canvas.drawRRect(rr, Paint()..color = kCell);
        canvas.drawRRect(
            rr,
            Paint()
              ..color = kCellEdge
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1);
        final dup = st.duplicateError(i);
        final tp = TextPainter(
          text: TextSpan(
              text: '${st.level.numbers[i]}',
              style: TextStyle(
                  color: dup ? kErr : kNum,
                  fontSize: cell * 0.42,
                  fontWeight: FontWeight.w900)),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, rect.center - Offset(tp.width / 2, tp.height / 2));
        if (m == 2) {
          canvas.drawCircle(
              rect.center,
              cell * 0.40,
              Paint()
                ..color = kMark
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2);
        }
      }
    }
  }

  @override
  bool shouldRepaint(BoardPainter old) => true;
}
