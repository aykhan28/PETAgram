import 'package:flutter/material.dart';
import 'dart:math';

class PawBackgroundPainter extends CustomPainter {
  final int pawCount;
  final Color pawColor;
  final double minDistance; // Pati izleri arasındaki minimum mesafe

  PawBackgroundPainter({this.pawCount = 12, this.pawColor = Colors.brown, this.minDistance = 60.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = pawColor.withOpacity(0.15);
    final random = Random();
    List<Offset> pawPositions = [];

    int attempts = 0;
    while (pawPositions.length < pawCount && attempts < pawCount * 5) {
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height;
      final Offset newPawPosition = Offset(x, y);

      if (!_isOverlapping(newPawPosition, pawPositions)) {
        pawPositions.add(newPawPosition);
        _drawPaw(canvas, newPawPosition, paint);
      }

      attempts++;
    }
  }

  bool _isOverlapping(Offset newPaw, List<Offset> existingPaws) {
    for (var paw in existingPaws) {
      if ((newPaw - paw).distance < minDistance) {
        return true; // Yeni pati, mevcut bir patiyle çakışıyor!
      }
    }
    return false;
  }

  void _drawPaw(Canvas canvas, Offset center, Paint paint) {
    const double mainPadWidth = 40.0;
    const double mainPadHeight = 30.0;
    const double toeSize = 16.0;
    const double outerToeSpacing = 22.0;
    const double innerToeSpacing = 7.0;
    const double spacingY = 20.0;

    // Ana yastık (Büyük alt ped)
    canvas.drawOval(
      Rect.fromCenter(center: center, width: mainPadWidth, height: mainPadHeight),
      paint,
    );

    // Üstteki dört parmak izi
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - outerToeSpacing, center.dy - spacingY),
        width: toeSize * 0.9,
        height: toeSize * 1.2,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + outerToeSpacing, center.dy - spacingY),
        width: toeSize * 0.9,
        height: toeSize * 1.2,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - innerToeSpacing, center.dy - spacingY * 1.3),
        width: toeSize * 0.8,
        height: toeSize * 1.1,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + innerToeSpacing, center.dy - spacingY * 1.3),
        width: toeSize * 0.8,
        height: toeSize * 1.1,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}