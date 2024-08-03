

class Person {
  final String uid;
  final List<String> favoriteArticleIds;
  final bool isAuthenticated;
  Person({
    required this.uid,
    required this.favoriteArticleIds,
    required this.isAuthenticated,
  });



  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'favoriteArticleIds': favoriteArticleIds,
      'isAuthenticated': isAuthenticated,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      uid: map['uid'] ?? '',
      favoriteArticleIds: List<String>.from(map['favoriteArticleIds']),
      isAuthenticated: map['isAuthenticated'] ?? false,
    );
  }


}
