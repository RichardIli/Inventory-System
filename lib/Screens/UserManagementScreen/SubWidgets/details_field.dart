import 'package:flutter/material.dart';
import 'package:inventory_system/Theme/theme.dart';

class DetailsField extends StatefulWidget {
  const DetailsField({
    super.key,
    required this.customWidth,
    required this.fieldLabel,
    required this.controller,
  });

  final double customWidth;
  final String fieldLabel;
  final TextEditingController controller;

  @override
  State<DetailsField> createState() => _DetailsFieldState();
}

class _DetailsFieldState extends State<DetailsField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.fieldLabel,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(
          width: widget.customWidth,
          child: TextFormField(
            controller: widget.controller,
            decoration: customInputDecoration.copyWith(
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.redAccent,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This Field is Required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
