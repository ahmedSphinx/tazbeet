import 'package:flutter/material.dart';
import '../../../models/mood.dart';
import 'dart:math' as math;

/// Interactive chart showing mood trends over time
class MoodTrendsChart extends StatefulWidget {
  final List<Mood> moods;
  final String timeframe;

  const MoodTrendsChart({super.key, required this.moods, required this.timeframe});

  @override
  State<MoodTrendsChart> createState() => _MoodTrendsChartState();
}

class _MoodTrendsChartState extends State<MoodTrendsChart> with TickerProviderStateMixin {
  late AnimationController _chartController;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();

    _chartController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _chartAnimation = CurvedAnimation(parent: _chartController, curve: Curves.easeOutCubic);

    _chartController.forward();
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [theme.colorScheme.secondaryContainer.withValues(alpha: 0.2), theme.colorScheme.tertiaryContainer.withValues(alpha: 0.1), theme.colorScheme.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 30, offset: const Offset(0, 15))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(theme),

          const SizedBox(height: 24),

          // Chart
          AnimatedBuilder(
            animation: _chartAnimation,
            builder: (context, child) {
              return SizedBox(
                height: 200,
                child: CustomPaint(
                  painter: MoodTrendsPainter(moods: widget.moods, timeframe: widget.timeframe, animation: _chartAnimation, theme: theme),
                  size: Size.infinite,
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Legend and stats
          _buildLegendAndStats(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        // Chart icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [theme.colorScheme.secondary, theme.colorScheme.tertiary]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: theme.colorScheme.secondary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: const Icon(Icons.trending_up, color: Colors.white, size: 20),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📈 Mood Trends',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 4),
              Text(_getTimeframeDescription(), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
          ),
        ),

        // Trend indicator
        _buildTrendIndicator(theme),
      ],
    );
  }

  Widget _buildTrendIndicator(ThemeData theme) {
    final trend = _calculateTrend();
    final isPositive = trend > 0;
    final isNeutral = trend.abs() < 0.1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isNeutral
            ? theme.colorScheme.outline.withValues(alpha: 0.1)
            : isPositive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNeutral
              ? theme.colorScheme.outline.withValues(alpha: 0.3)
              : isPositive
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isNeutral
                ? Icons.trending_flat
                : isPositive
                ? Icons.trending_up
                : Icons.trending_down,
            size: 16,
            color: isNeutral
                ? theme.colorScheme.outline
                : isPositive
                ? Colors.green
                : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            isNeutral
                ? 'Stable'
                : isPositive
                ? 'Improving'
                : 'Declining',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isNeutral
                  ? theme.colorScheme.outline
                  : isPositive
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendAndStats(ThemeData theme) {
    final stats = _calculateStats();

    return Row(
      children: [
        // Legend
        Expanded(child: Wrap(spacing: 16, runSpacing: 8, children: [_buildLegendItem(theme, 'Mood', theme.colorScheme.primary), _buildLegendItem(theme, 'Energy', Colors.orange), _buildLegendItem(theme, 'Focus', Colors.blue), _buildLegendItem(theme, 'Stress', Colors.red)])),

        // Quick stats
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Avg: ${stats['avgMood']?.toStringAsFixed(1) ?? 'N/A'}',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
              ),
              Text('Range: ${stats['range']?.toStringAsFixed(1) ?? 'N/A'}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(1.5)),
        ),
        const SizedBox(width: 6),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
      ],
    );
  }

  String _getTimeframeDescription() {
    switch (widget.timeframe) {
      case 'week':
        return 'Last 7 days';
      case 'month':
        return 'Last 30 days';
      case '3months':
        return 'Last 3 months';
      case 'year':
        return 'Last 12 months';
      default:
        return 'Custom range';
    }
  }

  double _calculateTrend() {
    if (widget.moods.length < 2) return 0.0;

    final sortedMoods = List<Mood>.from(widget.moods)..sort((a, b) => a.date.compareTo(b.date));

    final firstHalf = sortedMoods.take(sortedMoods.length ~/ 2);
    final secondHalf = sortedMoods.skip(sortedMoods.length ~/ 2);

    final firstAvg = firstHalf.isEmpty ? 0.0 : firstHalf.map((m) => m.level.index).reduce((a, b) => a + b) / firstHalf.length;

    final secondAvg = secondHalf.isEmpty ? 0.0 : secondHalf.map((m) => m.level.index).reduce((a, b) => a + b) / secondHalf.length;

    return secondAvg - firstAvg;
  }

  Map<String, double> _calculateStats() {
    if (widget.moods.isEmpty) return {};

    final moodValues = widget.moods.map((m) => m.level.index.toDouble()).toList();
    final avgMood = moodValues.reduce((a, b) => a + b) / moodValues.length;
    final minMood = moodValues.reduce(math.min);
    final maxMood = moodValues.reduce(math.max);

    return {'avgMood': avgMood, 'range': maxMood - minMood};
  }
}

class MoodTrendsPainter extends CustomPainter {
  final List<Mood> moods;
  final String timeframe;
  final Animation<double> animation;
  final ThemeData theme;

  MoodTrendsPainter({required this.moods, required this.timeframe, required this.animation, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    if (moods.isEmpty) {
      _drawEmptyState(canvas, size);
      return;
    }

    final sortedMoods = List<Mood>.from(moods)..sort((a, b) => a.date.compareTo(b.date));

    // Group moods by time period
    final groupedData = _groupMoodsByTimeframe(sortedMoods);

    if (groupedData.isEmpty) return;

    final padding = const EdgeInsets.all(20);
    final chartRect = Rect.fromLTWH(padding.left, padding.top, size.width - padding.horizontal, size.height - padding.vertical);

    // Draw grid
    _drawGrid(canvas, chartRect);

    // Draw mood line
    _drawMoodLine(canvas, chartRect, groupedData);

    // Draw metric lines
    _drawMetricLines(canvas, chartRect, groupedData);

    // Draw data points
    _drawDataPoints(canvas, chartRect, groupedData);
  }

  void _drawEmptyState(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.colorScheme.outline.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(Offset(center.dx - 50, center.dy), Offset(center.dx + 50, center.dy), paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'No data available',
        style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy + 20));
  }

  void _drawGrid(Canvas canvas, Rect chartRect) {
    final paint = Paint()
      ..color = theme.colorScheme.outline.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = chartRect.top + (chartRect.height / 4) * i;
      canvas.drawLine(Offset(chartRect.left, y), Offset(chartRect.right, y), paint);
    }

    // Vertical grid lines
    const gridLines = 6;
    for (int i = 0; i <= gridLines; i++) {
      final x = chartRect.left + (chartRect.width / gridLines) * i;
      canvas.drawLine(Offset(x, chartRect.top), Offset(x, chartRect.bottom), paint);
    }
  }

  void _drawMoodLine(Canvas canvas, Rect chartRect, List<MoodDataPoint> data) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = theme.colorScheme.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = chartRect.left + (chartRect.width / (data.length - 1)) * i;
      final y = chartRect.bottom - (data[i].avgMood / 4) * chartRect.height;
      points.add(Offset(x, y));
    }

    // Create smooth curve
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(points[i - 1].dx + (points[i].dx - points[i - 1].dx) / 3, points[i - 1].dy);
      final cp2 = Offset(points[i].dx - (points[i].dx - points[i - 1].dx) / 3, points[i].dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
    }

    // Animate the line drawing
    final pathMetric = path.computeMetrics().first;
    final animatedPath = pathMetric.extractPath(0, pathMetric.length * animation.value);

    canvas.drawPath(animatedPath, paint);

    // Draw gradient fill
    if (animation.value > 0.5) {
      final fillPath = Path.from(animatedPath);
      fillPath.lineTo(points.last.dx, chartRect.bottom);
      fillPath.lineTo(points.first.dx, chartRect.bottom);
      fillPath.close();

      final gradientPaint = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [theme.colorScheme.primary.withValues(alpha: 0.3), theme.colorScheme.primary.withValues(alpha: 0.05)]).createShader(chartRect);

      canvas.drawPath(fillPath, gradientPaint);
    }
  }

  void _drawMetricLines(Canvas canvas, Rect chartRect, List<MoodDataPoint> data) {
    if (data.length < 2) return;

    final metrics = [
      {'color': Colors.orange, 'getValue': (MoodDataPoint d) => d.avgEnergy},
      {'color': Colors.blue, 'getValue': (MoodDataPoint d) => d.avgFocus},
      {'color': Colors.red, 'getValue': (MoodDataPoint d) => d.avgStress},
    ];

    for (final metric in metrics) {
      final paint = Paint()
        ..color = (metric['color'] as Color).withValues(alpha: 0.7)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final path = Path();
      final getValue = metric['getValue'] as double Function(MoodDataPoint);

      for (int i = 0; i < data.length; i++) {
        final x = chartRect.left + (chartRect.width / (data.length - 1)) * i;
        final y = chartRect.bottom - (getValue(data[i]) / 10) * chartRect.height;

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      // Animate metric lines with delay
      final pathMetric = path.computeMetrics().first;
      final animatedPath = pathMetric.extractPath(0, pathMetric.length * math.max(0, (animation.value - 0.3) / 0.7));

      canvas.drawPath(animatedPath, paint);
    }
  }

  void _drawDataPoints(Canvas canvas, Rect chartRect, List<MoodDataPoint> data) {
    if (animation.value < 0.8 || data.isEmpty) return;

    for (int i = 0; i < data.length; i++) {
      final x = data.length > 1 ? chartRect.left + (chartRect.width / (data.length - 1)) * i : chartRect.left + chartRect.width / 2;
      final y = chartRect.bottom - (data[i].avgMood / 4) * chartRect.height;

      // Check for valid coordinates
      if (x.isNaN || y.isNaN || x.isInfinite || y.isInfinite) continue;

      // Outer circle
      final outerPaint = Paint()
        ..color = theme.colorScheme.primary.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 8, outerPaint);

      // Inner circle
      final innerPaint = Paint()
        ..color = theme.colorScheme.primary
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 4, innerPaint);
    }
  }

  List<MoodDataPoint> _groupMoodsByTimeframe(List<Mood> sortedMoods) {
    final now = DateTime.now();
    final dataPoints = <MoodDataPoint>[];

    switch (timeframe) {
      case 'week':
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final dayMoods = sortedMoods.where((m) => m.date.year == date.year && m.date.month == date.month && m.date.day == date.day).toList();

          if (dayMoods.isNotEmpty) {
            dataPoints.add(MoodDataPoint.fromMoods(dayMoods, date));
          }
        }
        break;

      case 'month':
        for (int i = 29; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final dayMoods = sortedMoods.where((m) => m.date.year == date.year && m.date.month == date.month && m.date.day == date.day).toList();

          if (dayMoods.isNotEmpty) {
            dataPoints.add(MoodDataPoint.fromMoods(dayMoods, date));
          }
        }
        break;

      default:
        // Group by week for longer timeframes
        final weeks = <DateTime, List<Mood>>{};
        for (final mood in sortedMoods) {
          final weekStart = mood.date.subtract(Duration(days: mood.date.weekday - 1));
          final weekKey = DateTime(weekStart.year, weekStart.month, weekStart.day);
          weeks.putIfAbsent(weekKey, () => []).add(mood);
        }

        for (final entry in weeks.entries) {
          dataPoints.add(MoodDataPoint.fromMoods(entry.value, entry.key));
        }
    }

    return dataPoints;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MoodDataPoint {
  final DateTime date;
  final double avgMood;
  final double avgEnergy;
  final double avgFocus;
  final double avgStress;
  final int count;

  MoodDataPoint({required this.date, required this.avgMood, required this.avgEnergy, required this.avgFocus, required this.avgStress, required this.count});

  factory MoodDataPoint.fromMoods(List<Mood> moods, DateTime date) {
    if (moods.isEmpty) {
      return MoodDataPoint(date: date, avgMood: 0, avgEnergy: 0, avgFocus: 0, avgStress: 0, count: 0);
    }

    final avgMood = moods.map((m) => m.level.index.toDouble()).reduce((a, b) => a + b) / moods.length;
    final avgEnergy = moods.map((m) => m.energyLevel).reduce((a, b) => a + b) / moods.length;
    final avgFocus = moods.map((m) => m.focusLevel).reduce((a, b) => a + b) / moods.length;
    final avgStress = moods.map((m) => m.stressLevel).reduce((a, b) => a + b) / moods.length;

    return MoodDataPoint(date: date, avgMood: avgMood.isNaN ? 0 : avgMood, avgEnergy: avgEnergy.isNaN ? 0 : avgEnergy, avgFocus: avgFocus.isNaN ? 0 : avgFocus, avgStress: avgStress.isNaN ? 0 : avgStress, count: moods.length);
  }
}
