import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hiking_state.dart';
import 'nordivex_theme.dart';

class ElevationProfileView extends StatelessWidget {
  const ElevationProfileView({super.key});

  String _formatHours(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HikingState>();
    final startAlt = state.trailheadAlt;
    final peakAlt = state.targetPeakAlt;
    final distanceKm = state.trailDistanceKm;

    final gainMeters = (peakAlt - startAlt).clamp(0, 8000).round();
    final distanceMeters = distanceKm * 1000.0;
    final gradePercent = distanceMeters > 0 ? ((gainMeters / distanceMeters) * 100).toStringAsFixed(1) : '0';

    // Naismith's Rule: 5 km/h horizontal pace + 1 hour per 600m ascent
    final estimatedAscentHours = (distanceKm / 4.0) + (gainMeters / 500.0);
    final estimatedCalories = (gainMeters * 0.9) + (distanceKm * 65);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.show_chart_rounded, color: NordivexColors.glacierCyan),
            SizedBox(width: 8),
            Text('Elevation Profile & Slope'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mountain Elevation Canvas Container
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NordivexColors.slateRock,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NordivexColors.stoneBorder),
              ),
              child: CustomPaint(
                painter: _ElevationGraphPainter(
                  startAlt: startAlt,
                  peakAlt: peakAlt,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Computed Metrics Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'VERTICAL GAIN',
                    value: '+$gainMeters m',
                    subtitle: '${(gainMeters * 3.28084).round()} ft ascent',
                    color: NordivexColors.pineEmerald,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricCard(
                    title: 'AVG GRADE',
                    value: '$gradePercent%',
                    subtitle: double.parse(gradePercent) > 15 ? 'Steep Alpine' : 'Moderate Trail',
                    color: NordivexColors.glacierCyan,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricCard(
                    title: 'EST. TIME',
                    value: _formatHours(estimatedAscentHours),
                    subtitle: 'Naismith Rule',
                    color: NordivexColors.mountainGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Interactive Altitude Tuning
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: NordivexColors.slateRock,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NordivexColors.stoneBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Trailhead Altitude',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: NordivexColors.textBright),
                      ),
                      Text(
                        '${startAlt.round()} m',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: NordivexColors.glacierCyan),
                      ),
                    ],
                  ),
                  Slider(
                    value: startAlt,
                    min: 200,
                    max: 3000,
                    divisions: 56,
                    activeColor: NordivexColors.glacierCyan,
                    onChanged: (val) => state.setElevationParams(start: val),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Summit Peak Target Altitude',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: NordivexColors.textBright),
                      ),
                      Text(
                        '${peakAlt.round()} m',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: NordivexColors.pineEmerald),
                      ),
                    ],
                  ),
                  Slider(
                    value: peakAlt,
                    min: 1000,
                    max: 4800,
                    divisions: 76,
                    activeColor: NordivexColors.pineEmerald,
                    onChanged: (val) => state.setElevationParams(peak: val),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Trail Route Distance',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: NordivexColors.textBright),
                      ),
                      Text(
                        '${distanceKm.toStringAsFixed(1)} km',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: NordivexColors.mountainGold),
                      ),
                    ],
                  ),
                  Slider(
                    value: distanceKm,
                    min: 2.0,
                    max: 30.0,
                    divisions: 56,
                    activeColor: NordivexColors.mountainGold,
                    onChanged: (val) => state.setElevationParams(dist: val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Trail Bio-Energy Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NordivexColors.stoneElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: NordivexColors.stoneBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: NordivexColors.mountainGold, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Bio-Caloric Demand',
                          style: TextStyle(fontWeight: FontWeight.bold, color: NordivexColors.textBright, fontSize: 14),
                        ),
                        Text(
                          '~${estimatedCalories.round()} kcal ascent energy. Carry at least 2.5L water and 60g carbs per hour.',
                          style: const TextStyle(fontSize: 12, color: NordivexColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: NordivexColors.slateRock,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NordivexColors.stoneBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: NordivexColors.textBright,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: NordivexColors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ElevationGraphPainter extends CustomPainter {
  final double startAlt;
  final double peakAlt;

  _ElevationGraphPainter({required this.startAlt, required this.peakAlt});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          NordivexColors.pineEmerald.withValues(alpha: 0.35),
          NordivexColors.pineEmerald.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePaint = Paint()
      ..color = NordivexColors.pineEmerald
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.82);
    path.cubicTo(
      size.width * 0.35,
      size.height * 0.70,
      size.width * 0.65,
      size.height * 0.25,
      size.width,
      size.height * 0.15,
    );

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // Draw Trailhead Point
    final dotPaint = Paint()..color = NordivexColors.glacierCyan;
    canvas.drawCircle(Offset(0, size.height * 0.82), 6, dotPaint);

    // Draw Summit Point
    final summitPaint = Paint()..color = NordivexColors.mountainGold;
    canvas.drawCircle(Offset(size.width, size.height * 0.15), 7, summitPaint);

    // Labels
    final textPainterStart = TextPainter(
      text: TextSpan(
        text: 'Trailhead ${startAlt.round()}m',
        style: const TextStyle(fontSize: 10, color: NordivexColors.glacierCyan, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainterStart.paint(canvas, Offset(8, size.height * 0.82 - 18));

    final textPainterPeak = TextPainter(
      text: TextSpan(
        text: 'Summit ${peakAlt.round()}m',
        style: const TextStyle(fontSize: 10, color: NordivexColors.mountainGold, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainterPeak.paint(canvas, Offset(size.width - textPainterPeak.width - 8, size.height * 0.15 - 20));
  }

  @override
  bool shouldRepaint(covariant _ElevationGraphPainter oldDelegate) {
    return oldDelegate.startAlt != startAlt || oldDelegate.peakAlt != peakAlt;
  }
}
