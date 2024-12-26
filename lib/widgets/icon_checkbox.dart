import 'package:flutter/material.dart';

class IconCheckbox extends StatefulWidget {
  final IconData iconChecked;
  final IconData iconUnchecked;
  final ValueChanged<bool>? onChanged;
  final bool initialValue;
  final Color? checkedColor;
  final Color? uncheckedColor;

  const IconCheckbox({
    super.key,
    required this.iconChecked,
    required this.iconUnchecked,
    this.onChanged,
    this.initialValue = false,
    this.checkedColor,
    this.uncheckedColor,
  });

  @override
  State<IconCheckbox> createState() => _IconCheckboxState();
}

class _IconCheckboxState extends State<IconCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  void _toggleCheckbox() {
    setState(() {
      _isChecked = !_isChecked;
    });
    widget.onChanged?.call(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCheckbox,
      child: Icon(
        _isChecked ? widget.iconChecked : widget.iconUnchecked,
        color: _isChecked ? widget.checkedColor ?? Colors.blue : widget.uncheckedColor ?? Colors.grey,
        size: 24.0,
      ),
    );
  }
}
