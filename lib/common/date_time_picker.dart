import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_shift/common/input_dropdown.dart';
import 'package:habit_shift/services/format.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key key,
    this.labelText,
    this.selectedTime,
    this.onSelectedTime,
    this.onSaved,
  }) : super(key: key);

  final String labelText;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onSelectedTime;
  final FormFieldSetter<TimeOfDay> onSaved;

  Future<void> _selectTime(BuildContext context, FormFieldState state) async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (pickedTime != null) {
      onSelectedTime(pickedTime);
      state.didChange(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.headline6;
    return FormField<TimeOfDay>(
        onSaved: onSaved,
        initialValue: selectedTime,
        builder: (FormFieldState state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: InputDropdown(
                  valueText: selectedTime.format(context),
                  valueStyle: valueStyle,
                  onPressed: () => _selectTime(context, state),
                ),
              ),
            ],
          );
        });
  }
}
