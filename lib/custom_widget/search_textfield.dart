import 'package:flutter/material.dart';

class CustomSearchTextField extends StatefulWidget {
  final VoidCallback? onSearch; // 검색 성공 시 실행
  final TextEditingController? controller;
  final String? hintText;

  const CustomSearchTextField({
    super.key,
    this.onSearch,
    this.controller,
    this.hintText,
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
        controller: widget.controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '빈값이에요!';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: widget.hintText ?? '닉네임을 입력해주세요',
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
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
