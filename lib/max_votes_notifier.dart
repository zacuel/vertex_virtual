import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertex_virtual/utility/firebase_tools/firebase_providers.dart';

final maxVotesNotifierProvider = StateNotifierProvider<MaxVotesNotifier, int>((ref) {
  final firestore = ref.read(firestoreProvider);
  return MaxVotesNotifier(firestore: firestore);
});

class MaxVotesNotifier extends StateNotifier<int> {
  final FirebaseFirestore _firestore;
  MaxVotesNotifier({required FirebaseFirestore firestore})
      : _firestore = firestore,
        super(6);

  CollectionReference get _collectionRef => _firestore.collection('maxVotes');

  setValue() async {
    final obj = await _collectionRef.doc('maxVotes').get();
    final objMap = obj.data() as Map<String, dynamic>;
    final webValue = objMap['maxVotes'] as int;
    state = webValue;
  }
}
