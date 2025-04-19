import 'package:flutter/material.dart';

class ProfilePhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const ProfilePhoneField({
    Key? key,
    required this.controller,
    required this.labelText,
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
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/us_flag.png',
                  width: 24,
                  height: 16,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: 24,
                        height: 16,
                        color: Colors.blue,
                        child: const Center(
                          child: Text(
                            'US',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 24),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
