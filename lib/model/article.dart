//TODO attach userId to article in case of Nazis

class Article {
  final String articleId;
  final String title;
  final String? url;
  final String? content;
  final List<String> upvoteIds;
  Article({
    required this.articleId,
    required this.title,
    this.url,
    this.content,
    required this.upvoteIds,
  });


  Map<String, dynamic> toMap() {
    return {
      'articleId': articleId,
      'title': title,
      'url': url,
      'content': content,
      'upvoteIds': upvoteIds,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      articleId: map['articleId'] ?? '',
      title: map['title'] ?? '',
      url: map['url'],
      content: map['content'],
      upvoteIds: List<String>.from(map['upvoteIds']),
    );
  }



}
