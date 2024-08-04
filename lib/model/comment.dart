import 'dart:convert';

class Comment {
  final String commentText;
  Comment({
    required this.commentText,
  });

  Comment copyWith({
    String? commentText,
  }) {
    return Comment(
      commentText: commentText ?? this.commentText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentText': commentText,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentText: map['commentText'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source));

  @override
  String toString() => 'Comment(commentText: $commentText)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Comment &&
      other.commentText == commentText;
  }

  @override
  int get hashCode => commentText.hashCode;
}
