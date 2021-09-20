import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klasha_checkout/src/shared/shared.dart';

class KlashaInputField extends StatelessWidget {
   const KlashaInputField({
    Key key,
    this.controller,
    this.hintText,
    this.inputFormatters,
    this.textInputAction,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.keyboardType,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final Function(String) validator;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType ?? TextInputType.number,
      inputFormatters: [
        ...?inputFormatters,
      ],
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
        filled: true,
        fillColor: appColors.grey,
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: appColors.lowerText,
        ),
      ),
    );
  }
}

class KlashaOutlinedInputField extends StatelessWidget {
    const KlashaOutlinedInputField({
    Key key,
    this.controller,
    this.hintText,
    this.labeltext,
    this.inputFormatters,
    this.textInputAction,
    this.focusNode,
    this.validator,
  }) : super(key: key);
  
  final TextEditingController controller;
  final String hintText;
  final String labeltext;
  final List<TextInputFormatter> inputFormatters;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final Function(String) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: appColors.text,
        fontSize: 16,
      ),
      inputFormatters: [
        ...?inputFormatters,
      ],
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: appColors.lowerText.withOpacity(.8),
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        isDense: true,
        labelText: labeltext,
        hintText: hintText,
        labelStyle: TextStyle(
          color: appColors.lowerText,
        ),
        hintStyle: TextStyle(
          color: appColors.lowerText,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: appColors.lowerText,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: appColors.lowerText,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
