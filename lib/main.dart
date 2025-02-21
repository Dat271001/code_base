import 'package:flutter/material.dart';
import 'package:test_project/components/w_text_form_field.dart';
import 'generated/assets.gen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  String? _emailError;
  String? _passwordError;
  String? _phoneError;

  void _validateAndLogin() {
    setState(() {
      _emailError = _emailController.text.contains('@') ? null : "Invalid email format";
      _passwordError = _passwordController.text.length >= 6 ? null : "Password must be at least 6 characters";
      _phoneError = _phoneController.text.length >= 10 ? null : "Invalid phone number";
    });

    if (_emailError == null && _passwordError == null && _phoneError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            WTextFormField.fromType(
              type: WTextFormFieldType.email,
              controller: _emailController,
              hint: "Enter your email",
              prefixIcon: Assets.svg.icUserSmall,
              focusNode: _emailFocus,
              error: _emailError,
              onChanged: (value) => setState(() => _emailError = null),
            ),
            const SizedBox(height: 16),
            WTextFormField.fromType(
              type: WTextFormFieldType.password,
              controller: _passwordController,
              hint: "Enter your password",
              prefixIcon: null,
              focusNode: _passwordFocus,
              error: _passwordError,
              onChanged: (value) => setState(() => _passwordError = null),
            ),
            const SizedBox(height: 16),
            WTextFormField.fromType(
              type: WTextFormFieldType.phoneNumber,
              controller: _phoneController,
              hint: "Enter your phone number",
              prefixIcon: null,
              focusNode: _phoneFocus,
              error: _phoneError,
              onChanged: (value) => setState(() => _phoneError = null),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _validateAndLogin,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }
}
