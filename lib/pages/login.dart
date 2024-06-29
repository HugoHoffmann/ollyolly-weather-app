import 'package:flutter/material.dart';
import 'package:weather_app/components/form.dart';
import 'package:weather_app/services/authentication.dart';
import 'home.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void signUserIn(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await AuthService()
            .signIn(usernameController.text, passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return _buildMobileLayout(context);
            } else {
              return _buildWebLayout(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LoginForm(
            formKey: _formKey,
            usernameController: usernameController,
            passwordController: passwordController,
            onTap: () => signUserIn(context),
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: LoginForm(
          formKey: _formKey,
          usernameController: usernameController,
          passwordController: passwordController,
          onTap: () => signUserIn(context),
          iconSize: 90,
          fontSize: 18,
          titleFontSize: 28,
          padding: 32,
        ),
      ),
    );
  }
}
