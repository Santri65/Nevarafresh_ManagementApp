import 'package:flutter/material.dart';
import 'package:nevara_emp/models/task.dart';

const Color _darkBackground = Color(0xFF16181E);
const Color _darkCardColor = Color(0xFF21252E);
const Color _darkBorderColor = Color(0xFF323744);
const Color _primaryTextColor = Color(0xFFF1F5F9);
const Color _secondaryTextColor = Color(0xFF94A3B8);
const Color _activeGreen = Color(0xFF81C784);

/// Left column with the filters for the task list.
class TaskFilterSidebar extends StatelessWidget {
  final TaskFilter selectedFilter;
  final Function(TaskFilter) onFilterSelected;

  const TaskFilterSidebar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: _darkCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _darkBorderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.filter_list_rounded, size: 18, color: _activeGreen),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Filtrar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _FilterButton(
              label: 'Todas',
              selected: selectedFilter == TaskFilter.all,
              onTap: () => onFilterSelected(TaskFilter.all),
            ),
            const SizedBox(height: 8),
            _FilterButton(
              label: 'Faltantes',
              selected: selectedFilter == TaskFilter.missing,
              onTap: () => onFilterSelected(TaskFilter.missing),
            ),
            const SizedBox(height: 8),
            _FilterButton(
              label: 'En proceso',
              selected: selectedFilter == TaskFilter.inProgress,
              onTap: () => onFilterSelected(TaskFilter.inProgress),
            ),
            const SizedBox(height: 8),
            _FilterButton(
              label: 'Terminadas',
              selected: selectedFilter == TaskFilter.completed,
              onTap: () => onFilterSelected(TaskFilter.completed),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Function() onTap;

  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );

    return SizedBox(
      height: 40,
      child: selected
          ? ElevatedButton(
              onPressed: () => onTap(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _activeGreen,
                foregroundColor: _darkBackground,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: shape,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: () => onTap(),
              style: OutlinedButton.styleFrom(
                foregroundColor: _secondaryTextColor,
                side: const BorderSide(color: _darkBorderColor, width: 1),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: shape,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
