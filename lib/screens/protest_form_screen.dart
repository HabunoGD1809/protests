import 'package:flutter/material.dart';
import 'package:project_protestas/models/protest.dart';
import 'package:project_protestas/services/protest_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:intl/intl.dart';

class ProtestFormScreen extends StatefulWidget {
  final int userId;
  final Protest? protest;

  const ProtestFormScreen({super.key, required this.userId, this.protest});

  @override
  State<ProtestFormScreen> createState() => _ProtestFormScreenState();
}

class _ProtestFormScreenState extends State<ProtestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProtestService _protestService = ProtestService();

  late TextEditingController _natureNameController;
  late TextEditingController _provinceController;
  late TextEditingController _summaryController;
  late DateTime _dateTime;
  late Color _natureColor;
  late IconData _natureIcon;

  @override
  void initState() {
    super.initState();
    _natureNameController = TextEditingController(text: widget.protest?.natureName ?? '');
    _provinceController = TextEditingController(text: widget.protest?.province ?? '');
    _summaryController = TextEditingController(text: widget.protest?.summary ?? '');
    _dateTime = widget.protest?.dateTime ?? DateTime.now();
    _natureColor = widget.protest?.natureColor ?? Theme.of(context).colorScheme.primary;
    _natureIcon = widget.protest?.natureIcon ?? Icons.flag;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.protest == null ? 'Nueva Protesta' : 'Editar Protesta'),
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurfaceVariant,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _natureNameController,
                label: 'Nombre de la naturaleza',
                icon: Icons.nature,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickColor,
                      icon: Icon(Icons.color_lens, color: _natureColor),
                      label: const Text('Color'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        foregroundColor: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickIcon,
                      icon: Icon(_natureIcon),
                      label: const Text('Icono'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        foregroundColor: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _provinceController,
                label: 'Provincia',
                icon: Icons.location_city,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _summaryController,
                label: 'Resumen',
                icon: Icons.summarize,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    'Fecha y hora: ${DateFormat('dd/MM/yyyy HH:mm').format(_dateTime)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: _pickDateTime,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProtest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Guardar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
    );
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _natureColor,
            onColorChanged: (color) {
              setState(() => _natureColor = color);
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _pickIcon() async {
    IconData? icon = await showIconPicker(
      context,
      iconPackModes: [IconPack.material],
    );
    if (icon != null) {
      setState(() => _natureIcon = icon);
    }
  }

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dateTime),
      );
      if (time != null) {
        setState(() {
          _dateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveProtest() async {
    if (_formKey.currentState!.validate()) {
      final protest = Protest(
        uuid: widget.protest?.uuid ?? const Uuid().v4(),
        userId: widget.userId,
        natureName: _natureNameController.text,
        natureIcon: _natureIcon,
        natureColor: _natureColor,
        province: _provinceController.text,
        summary: _summaryController.text,
        dateTime: _dateTime,
      );

      bool success;
      if (widget.protest == null) {
        success = await _protestService.addProtest(protest);
      } else {
        success = await _protestService.updateProtest(protest);
      }

      if (success) {
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la protesta')),
        );
      }
    }
  }
}