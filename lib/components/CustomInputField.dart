import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool showError;
  final String errorMessage;
  final String errorIconPath;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.showError,
    required this.errorMessage,
    required this.errorIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.grey),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: showError ? Colors.red : Colors.black),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: showError ? Colors.red : Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: showError ? Colors.red : Colors.black, width: 2),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.person,
                color: Colors.deepOrange,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (showError)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE5E6), // rose clair
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  errorIconPath,
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
