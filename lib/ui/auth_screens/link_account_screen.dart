import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertex_virtual/features/auth/auth_controller.dart';

class LinkAccountScreen extends ConsumerStatefulWidget {
  const LinkAccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends ConsumerState<LinkAccountScreen> {
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

  _submit() {
    if (_passCheckController.text == _passwordController.text) {
      ref.read(authControllerProvider.notifier).linkAccount(context, _emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
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
            const Text('check Password'),
            TextField(
              obscureText: true,
              controller: _passCheckController,
            ),
            ElevatedButton(onPressed: _submit, child: const Text("proceed")),
          ],
        ),
      ),
    );
  }
}
