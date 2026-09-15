import 'package:flutter/material.dart';
import '../theme/nordivex_theme.dart';

class SummitElevationPainter extends CustomPainter {
  final List<int> elevations;

  SummitElevationPainter({required this.elevations});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Mountain peak silhouette
    final path = Path();
    path.moveTo(0, height * 0.9);
    path.lineTo(width * 0.2, height * 0.45); // First ridge
    path.lineTo(width * 0.35, height * 0.65);
    path.lineTo(width * 0.55, height * 0.2); // Main summit
    path.lineTo(width * 0.75, height * 0.55);
    path.lineTo(width * 0.9, height * 0.35); // Second summit
    path.lineTo(width, height * 0.9);
    path.close();

    final mountainPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          NordivexTheme.accent.withValues(alpha: 0.3),
          NordivexTheme.surface,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(path, mountainPaint);

    final strokePaint = Paint()
      ..color = NordivexTheme.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(path, strokePaint);

    // Snow cap on main summit
    final snowPath = Path();
    snowPath.moveTo(width * 0.55, height * 0.2);
    snowPath.lineTo(width * 0.50, height * 0.3);
    snowPath.lineTo(width * 0.60, height * 0.3);
    snowPath.close();
    final snowPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawPath(snowPath, snowPaint);

    // Summit altitude flag at (0.55, 0.2)
    final flagPaint = Paint()..color = NordivexTheme.accentLight;
    canvas.drawLine(
      Offset(width * 0.55, height * 0.2),
      Offset(width * 0.55, height * 0.12),
      Paint()..color = Colors.white..strokeWidth = 2,
    );
    final flagPath = Path()
      ..moveTo(width * 0.55, height * 0.12)
      ..lineTo(width * 0.62, height * 0.15)
      ..lineTo(width * 0.55, height * 0.18)
      ..close();
    canvas.drawPath(flagPath, flagPaint);
  }

  @override
  bool shouldRepaint(covariant SummitElevationPainter oldDelegate) {
    return oldDelegate.elevations != elevations;
  }
}
