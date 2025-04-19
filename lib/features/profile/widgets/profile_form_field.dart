import 'package:flutter/material.dart';

class ProfileFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool background;
  final TextInputType? inputType;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const ProfileFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.background = false,
    this.inputType,
    this.suffix,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.grey[850] : const Color(0xFFF5F5F8);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType ?? TextInputType.text,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: background,
          fillColor: background ? backgroundColor : Colors.transparent,
          border:
              background
                  ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  )
                  : const UnderlineInputBorder(),
          suffixIcon: suffix,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
