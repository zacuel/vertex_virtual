

class Person {
  final String uid;
  final List<String> favoriteArticleIds;
  Person({
    required this.uid,
    required this.favoriteArticleIds,
  });


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'favoriteArticleIds': favoriteArticleIds,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      uid: map['uid'] ?? '',
      favoriteArticleIds: List<String>.from(map['favoriteArticleIds']),
    );
  }


}
