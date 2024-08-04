import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertex_virtual/features/auth/auth_repository.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  int _screenIndex = 0;

  Widget get _screen0 => Center(
        child: Column(children: [
          ElevatedButton(
              onPressed: () {
                ref.read(authRepositoryProvider).signUpAnon();
              },
              child: const Text("Continue with no account")),
          ElevatedButton(onPressed: () {}, child: const Text("Sign in with email")),
          ElevatedButton(onPressed: () {}, child: const Text("create account with email")),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          switch (_screenIndex) {
            case 0:
              return _screen0;
            default:
              return Placeholder();
          }
        },
      ),
    );
  }
}
