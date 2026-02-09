import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../core/constants/app_index.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final bool isPassword;
  final bool isDate;
  final bool isPhone;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.isPassword = false,
    this.isDate = false,
    this.isPhone = false,
    this.keyboardType,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  final _dateMask = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final _phoneMask = MaskTextInputFormatter(
    mask: '+## (###) ###-##-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    final effectiveKeyboardType =
        widget.keyboardType ??
        (widget.isPhone
            ? TextInputType.phone
            : widget.isDate
            ? TextInputType.datetime
            : TextInputType.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText, style: AppStyles.leagueSpartan20),
        const SizedBox(height: 12),
        TextFormField(
          controller: widget.controller,
          keyboardType: effectiveKeyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          inputFormatters: _buildInputFormatters(),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.fillColor,
            hintText: widget.hintText,
            hintStyle: AppStyles.leagueSpartan20.copyWith(
              color: AppColors.hintColor,
            ),
            suffixIcon: _buildSuffixIcon(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  List<TextInputFormatter>? _buildInputFormatters() {
    if (widget.isDate) {
      return [_dateMask];
    }

    if (widget.isPhone) {
      return [_phoneMask];
    }

    return null;
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
      );
    }

    return null;
  }
}
