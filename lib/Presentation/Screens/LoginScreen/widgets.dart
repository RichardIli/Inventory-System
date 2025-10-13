import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isError;
  final bool isPassword;
  final bool showPassword;
  final VoidCallback? togglePasswordVisibility;
  final VoidCallback login;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isError = false,
    this.isPassword = false,
    this.showPassword = false,
    this.togglePasswordVisibility,
    required this.login,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        obscureText: isPassword && !showPassword,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isError ? Colors.red[100] : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: isError
                ? BorderSide(color: Colors.red, width: 2)
                : BorderSide.none,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: togglePasswordVisibility,
                )
              : null,
        ),
        onSubmitted: (value) {
          login();
        },
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  final double widthFactor;
  final double heightFactor;

  const AppLogo({super.key, this.widthFactor = 0.4, this.heightFactor = 0.5});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Image.asset(
      'logo.png',
      width: size.width * widthFactor,
      height: size.height * heightFactor,
      fit: BoxFit.contain,
    );
  }
}
