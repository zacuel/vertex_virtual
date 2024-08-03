import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vertex_virtual/model/person.dart';
import 'package:vertex_virtual/utility/type_defs.dart';

import '../utility/firebase_tools/firebase_providers.dart';

final authStateChangeProvider = StreamProvider<User?>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return authRepo.authStateChange;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  final auth = ref.read(authProvider);
  return AuthRepository(firestore: firestore, auth: auth);
});

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  AuthRepository({required FirebaseFirestore firestore, required FirebaseAuth auth})
      : _auth = auth,
        _firestore = firestore;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  CollectionReference get _people => _firestore.collection('people');

  FutureEitherFailureOr<void> signUpAnon() async {
    try {
      final anonCredential = await _auth.signInAnonymously();
      final newPerson = Person(uid: anonCredential.user!.uid, favoriteArticleIds: [], isAuthenticated: false);
      await _people.doc(newPerson.uid).set(newPerson.toMap());
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
