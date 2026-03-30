import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/theme.dart';

class ProductivityChart extends StatefulWidget {
  final int completed;
  final int inProgress;
  final int pending;

  const ProductivityChart({
    super.key,
    required this.completed,
    required this.inProgress,
    required this.pending,
  });

  @override
  State<ProductivityChart> createState() => _ProductivityChartState();
}

class _ProductivityChartState extends State<ProductivityChart>
    with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.completed + widget.inProgress + widget.pending;

    if (total == 0) {
      return _buildEmptyChart();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          children: [
            Expanded(
              flex: 3,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  sections: _buildSections(total),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem(
                    'Completed',
                    widget.completed,
                    total,
                    AppTheme.successColor,
                  ),
                  const SizedBox(height: 12),
                  _buildLegendItem(
                    'In Progress',
                    widget.inProgress,
                    total,
                    AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildLegendItem(
                    'Pending',
                    widget.pending,
                    total,
                    AppTheme.warningColor,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyChart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart_outline,
            size: 48,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'No data to display',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(int total) {
    return [
      _buildSection(
        0,
        widget.completed.toDouble(),
        total,
        AppTheme.successColor,
        'Done',
      ),
      _buildSection(
        1,
        widget.inProgress.toDouble(),
        total,
        AppTheme.primaryColor,
        'Active',
      ),
      _buildSection(
        2,
        widget.pending.toDouble(),
        total,
        AppTheme.warningColor,
        'Todo',
      ),
    ];
  }

  PieChartSectionData _buildSection(
    int index,
    double value,
    int total,
    Color color,
    String title,
  ) {
    final isTouched = index == touchedIndex;
    final double fontSize = isTouched ? 14 : 12;
    final double radius = isTouched ? 55 : 45;
    final percentage = (value / total * 100).toStringAsFixed(0);

    return PieChartSectionData(
      color: color,
      value: value * _animation.value,
      title: isTouched ? '$percentage%' : '',
      radius: radius * _animation.value,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      badgeWidget: isTouched
          ? null
          : null,
    );
  }

  Widget _buildLegendItem(String label, int value, int total, Color color) {
    final percentage = total > 0 ? (value / total * 100).toStringAsFixed(0) : '0';

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '$value ($percentage%)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}