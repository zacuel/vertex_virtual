import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utility/snackybar.dart';
import 'auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {
    final authRepository = ref.read(authRepositoryProvider);
    return AuthController(authRepository: authRepository, ref: ref);
  },
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        super(false);

  goInAnonomously(BuildContext context) async {
    state = true;
    final result = await _authRepository.signUpAnon();
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  signUp(BuildContext context, String email, String password) async {
    state = true;
    final result = await _authRepository.signUp(email, password);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  logIn(BuildContext context, String email, String password) async {
    state = true;
    final result = await _authRepository.logIn(email, password);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  linkAccount(BuildContext context, String email, String password) async {
    state = true;
    final result = await _authRepository.linkAnonAcount(email, password);
    state = false;
    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'success');
      Navigator.of(context).pop();
    });
  }
}
