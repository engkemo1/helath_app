import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors/app_colors.dart';

class LabeledSwitch extends StatefulWidget {
  final String label;
  final TextStyle? labelStyle;
  final bool initialValue;
  final double? scale;
  final ValueChanged<bool> onChanged;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color activeThumbColor;
  final Color inactiveThumbColor;

  LabeledSwitch({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.activeThumbColor,
    required this.inactiveThumbColor,  this.labelStyle, this.scale,
  });

  @override
  _LabeledSwitchState createState() => _LabeledSwitchState();
}

class _LabeledSwitchState extends State<LabeledSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.label,
          style:widget.labelStyle?? Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.lightBlackColor,
          ),
        ),
        Transform.scale(
          scale:widget.scale?? 0.9, // Adjust the scale to change the size of the switch
          child: Switch(
            activeTrackColor: widget.activeTrackColor,
            inactiveTrackColor: widget.inactiveTrackColor,
            inactiveThumbColor: widget.inactiveThumbColor,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            activeColor: widget.activeThumbColor,
            value: _value,
            onChanged: (bool newValue) {
              setState(() {
                _value = newValue;
              });
              widget.onChanged(newValue);
            },
          ),
        ),
      ],
    );
  }
}
