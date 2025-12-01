import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

class NewsFilterWidget extends StatelessWidget {
  final String selectedTag;
  final List<String> tags;
  final Function(String) onTagChanged;

  final DateTimeRange? selectedDateRange;
  final Function(DateTimeRange?) onDateRangeChanged;

  const NewsFilterWidget({
    super.key,
    required this.selectedTag,
    required this.tags,
    required this.onTagChanged,
    required this.selectedDateRange,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateText =
        selectedDateRange == null
            ? "Todas las fechas"
            : "${DateFormat("d/M/y").format(selectedDateRange!.start)} - ${DateFormat("d/M/y").format(selectedDateRange!.end)}";

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Filtro de tipo
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedTag,
              onChanged: (value) {
                if (value != null) {
                  onTagChanged(value);
                }
              },
              items:
                  tags
                      .map(
                        (tag) => DropdownMenuItem(
                          value: tag,
                          child: Text(tag[0].toUpperCase() + tag.substring(1)),
                        ),
                      )
                      .toList(),
            ),
          ),

          const SizedBox(width: 12),

          // Botón de calendario mejorado
          OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today, size: 16),
            label: Text(dateText, style: const TextStyle(fontSize: 13)),
            onPressed: () => _showImprovedDatePickerDialog(context),
          ),
        ],
      ),
    );
  }

  void _showImprovedDatePickerDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(
            opacity: animation,
            child: Center(
              child: _DatePickerModal(
                selectedDateRange: selectedDateRange,
                onDateRangeChanged: onDateRangeChanged,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DatePickerModal extends StatefulWidget {
  final DateTimeRange? selectedDateRange;
  final Function(DateTimeRange?) onDateRangeChanged;

  const _DatePickerModal({
    required this.selectedDateRange,
    required this.onDateRangeChanged,
  });

  @override
  State<_DatePickerModal> createState() => _DatePickerModalState();
}

class _DatePickerModalState extends State<_DatePickerModal> {
  PickerDateRange? _selectedRange;
  late DateRangePickerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DateRangePickerController();

    if (widget.selectedDateRange != null) {
      _selectedRange = PickerDateRange(
        widget.selectedDateRange!.start,
        widget.selectedDateRange!.end,
      );
    } else {
      final now = DateTime.now();
      final start = now.subtract(const Duration(days: 14));
      _selectedRange = PickerDateRange(start, now);
    }

    _controller.selectedRange = _selectedRange;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Container(
        width: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).dialogBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con título y botón de cerrar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Seleccionar fechas",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),

            // Información del rango seleccionado
            if (_selectedRange != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getSelectedDateText(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // DatePicker
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SfDateRangePicker(
                controller: _controller,
                selectionMode: DateRangePickerSelectionMode.range,
                maxDate: DateTime.now(),
                startRangeSelectionColor: Theme.of(context).primaryColor,
                endRangeSelectionColor: Theme.of(context).primaryColor,
                rangeSelectionColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                selectionTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                rangeTextStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor: Colors.transparent,
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  todayTextStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  setState(() {
                    _selectedRange = args.value;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // Botones de acción
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 10, 16),
              child: Row(
                children: [
                  // Botón limpiar
                  if (_selectedRange != null)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedRange = null;
                          _controller.selectedRange = null;
                        });
                      },
                      icon: const Icon(Icons.clear, size: 15),
                      label: const Text("Limpiar"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                      ),
                    ),

                  const Spacer(),

                  // Botón cancelar
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                    child: const Text("Cancelar"),
                  ),

                  const SizedBox(width: 8),

                  // Botón aplicar
                  ElevatedButton(
                    onPressed:
                        _selectedRange != null &&
                                _selectedRange!.startDate != null &&
                                _selectedRange!.endDate != null
                            ? () {
                              widget.onDateRangeChanged(
                                DateTimeRange(
                                  start: _selectedRange!.startDate!,
                                  end: _selectedRange!.endDate!,
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Aplicar"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSelectedDateText() {
    if (_selectedRange == null ||
        _selectedRange!.startDate == null ||
        _selectedRange!.endDate == null) {
      return "Selecciona un rango de fechas";
    }

    final start = DateFormat(
      "d MMM y",
      "es",
    ).format(_selectedRange!.startDate!);
    final end = DateFormat("d MMM y", "es").format(_selectedRange!.endDate!);

    return "$start - $end";
  }
}
