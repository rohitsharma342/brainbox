import 'package:flutter/material.dart';
import '../config/theme.dart';

class FilterDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hint;
  final void Function(T?) onChanged;
  final String Function(T) itemBuilder;

  const FilterDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value != null
              ? AppTheme.primaryColor.withOpacity(0.5)
              : Colors.grey.shade800,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T?>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: value != null
                ? AppTheme.primaryColor
                : AppTheme.textSecondary,
          ),
          dropdownColor: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          items: [
            DropdownMenuItem<T?>(
              value: null,
              child: Text(
                'All',
                style: TextStyle(
                  color: value == null
                      ? AppTheme.primaryColor
                      : AppTheme.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
            ...items.map((item) {
              final isSelected = item == value;
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemBuilder(item),
                  style: TextStyle(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}