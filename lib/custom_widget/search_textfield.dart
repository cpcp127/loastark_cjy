import 'package:cjylostark/constants/app_colors.dart';
import 'package:cjylostark/constants/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomSearchTextField extends StatefulWidget {
  final VoidCallback? onSearch; // 검색 성공 시 실행
  final TextEditingController? controller;
  final String? hintText;
  final FocusNode? focusNode;

  const CustomSearchTextField({
    super.key,
    this.onSearch,
    this.controller,
    this.hintText,
    this.focusNode,
  });

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '빈값이에요!';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: widget.hintText ?? '닉네임을 입력해주세요',
          hintStyle: AppTextStyle.bodyMediumStyle.copyWith(
            color: AppColors.textSecondary,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.bgSecondary, width: 2),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.bgSecondary,
              width: 2,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search, color: AppColors.sky900),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSearch?.call();
              }
            },
          ),
        ),
      ),
    );
  }
}
