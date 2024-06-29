import 'package:flutter/material.dart';
import 'textfield.dart';
import 'button.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final double titleFontSize;
  final double padding;

  const LoginForm({
    Key? key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.onTap,
    this.iconSize = 90,
    this.fontSize = 16,
    this.titleFontSize = 24,
    this.padding = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.lock,
            size: iconSize,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome!',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Please login to your account',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: fontSize,
            ),
          ),
          const SizedBox(height: 30),
          MyTextField(
            controller: usernameController,
            hintText: 'Username',
            obscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          MyTextField(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          MyButton(
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
