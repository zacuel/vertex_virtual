import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertex_virtual/features/auth/auth_controller.dart';

import 'package:vertex_virtual/utility/error_loader.dart';
import 'package:vertex_virtual/utility/snackybar.dart';

enum AuthMode {
  intro,
  logIn,
  signUp,
}

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  AuthMode _authMode = AuthMode.intro;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passCheckController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passCheckController.dispose();
  }

  Widget get _screen0 => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).goInAnonomously(context);
              },
              child: const Text("Continue with no account")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _authMode = AuthMode.logIn;
                });
              },
              child: const Text("Sign in with email")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _authMode = AuthMode.signUp;
                });
              },
              child: const Text("create account with email")),
        ]),
      );

  Widget get _logInWidget => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("email"),
            TextField(
              controller: _emailController,
            ),
            const Text("password"),
            TextField(
              controller: _passwordController,
              obscureText: true,
            ),
            ElevatedButton(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).logIn(context, _emailController.text, _passwordController.text);
                },
                child: const Text("Log in")),
            TextButton(
                onPressed: () {
                  setState(() {
                    _authMode = AuthMode.signUp;
                  });
                },
                child: const Text("sign up instead"))
          ],
        ),
      );

  Widget get _signUpWidget => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("email"),
            TextField(
              controller: _emailController,
            ),
            const Text("password"),
            TextField(
              controller: _passwordController,
              obscureText: true,
            ),
            const Text("re-enter password"),
            ElevatedButton(onPressed: _signUp, child: const Text("Sign Up")),
            TextButton(
                onPressed: () {
                  setState(() {
                    _authMode = AuthMode.logIn;
                  });
                },
                child: const Text("log in instead"))
          ],
        ),
      );

  void _signUp() {
    if (_passwordController != _passCheckController) {
      showSnackBar(context, "passwords do not match");
    } else {
      ref.read(authControllerProvider.notifier).signUp(context, _emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          final isLoading = ref.watch(authControllerProvider);
          if (isLoading) {
            return const Loader();
          }
          switch (_authMode) {
            case AuthMode.intro:
              return _screen0;
            case AuthMode.logIn:
              return _logInWidget;
            case AuthMode.signUp:
              return _signUpWidget;
          }
        },
      ),
    );
  }
}
