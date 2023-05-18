import 'package:flutter/material.dart';

class LoginInputField extends StatelessWidget {
  const LoginInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    required this.enabled,
    this.multiLineGrowing = false,
    this.focusNode,
    this.minLines,
    this.maxLines,
    this.borderRadius,
    this.callback,
    this.autofocus = false,
    this.autoCaps = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final bool enabled;
  final bool multiLineGrowing;
  final FocusNode? focusNode;
  final int? minLines;
  final bool autofocus;
  final int? maxLines;
  final bool autoCaps;
  final void Function(String)? callback;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: TextField(
          textCapitalization: autoCaps? TextCapitalization.words: TextCapitalization.none,
          onSubmitted: callback,
          autofocus: autofocus,
          cursorColor: Colors.black,
          style: const TextStyle(color: Colors.black),
          focusNode: focusNode,
          minLines: minLines ?? 1,
          maxLines: multiLineGrowing ? maxLines ?? 4 : minLines ?? 1,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: labelText,
            enabled: enabled,
            contentPadding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 8.0,
              bottom: 8.0,
            ),
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
            ),
            labelStyle: TextStyle(
              color: Colors.grey.shade500,
            ),
            filled: false,
            fillColor: Theme.of(context).colorScheme.primaryContainer,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(borderRadius ?? 10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          )),
    );
  }
}
