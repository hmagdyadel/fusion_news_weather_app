import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import '../../domain/entities/weather_entities.dart';

class TemperatureChart extends StatelessWidget {
  final List<ForecastEntity> forecasts;

  const TemperatureChart({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TemperatureChartPainter(
        forecasts: forecasts,
        primaryColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.onSurface,
      ),
      child: Container(),
    );
  }
}

class _TemperatureChartPainter extends CustomPainter {
  final List<ForecastEntity> forecasts;
  final Color primaryColor;
  final Color textColor;

  _TemperatureChartPainter({
    required this.forecasts,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (forecasts.isEmpty) return;

    final paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    // Find min and max temperatures
    final temps = forecasts.map((f) => f.temperature).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final tempRange = maxTemp - minTemp;

    // Calculate points
    final points = <Offset>[];
    final padding = 40.0;
    final chartWidth = size.width - padding * 2;
    final chartHeight = size.height - padding * 2;

    for (int i = 0; i < forecasts.length; i++) {
      final x = padding + (i / (forecasts.length - 1)) * chartWidth;
      final normalizedTemp = (forecasts[i].temperature - minTemp) / (tempRange == 0 ? 1 : tempRange);
      final y = size.height - padding - (normalizedTemp * chartHeight);
      points.add(Offset(x, y));
    }

    // Draw filled area
    final path = Path();
    path.moveTo(points.first.dx, size.height - padding);
    for (final point in points) {
      path.lineTo(point.dx, point.dy);
    }
    path.lineTo(points.last.dx, size.height - padding);
    path.close();
    canvas.drawPath(path, fillPaint);

    // Draw line
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, paint);

    // Draw points and labels
    final pointPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
    );

    for (int i = 0; i < points.length; i++) {
      // Draw point
      canvas.drawCircle(points[i], 4, pointPaint);

      // Draw temperature label
      if (i % 3 == 0) {
        textPainter.text = TextSpan(
          text: '${forecasts[i].temperature.toStringAsFixed(0)}°',
          style: TextStyle(color: textColor, fontSize: 12),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(points[i].dx - textPainter.width / 2, points[i].dy - 20),
        );

        // Draw time label
        final time = DateFormat.Hm().format(forecasts[i].dateTime);
        textPainter.text = TextSpan(
          text: time,
          style: TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 10),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(points[i].dx - textPainter.width / 2, size.height - padding + 10),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
