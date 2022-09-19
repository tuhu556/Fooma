class CommentResponse {
  List<Comment> comment;
  int totalPage;
  CommentResponse(this.comment, this.totalPage);

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    final listComment =
        (json["items"] as List).map((e) => Comment.fromJson(e)).toList();
    final totalPage = json["totalPage"];
    return CommentResponse(listComment, totalPage);
  }
}

class Comment {
  final String id;
  final String userID;
  final String name;
  final String userImageUrl;
  String content;
  final String createDate;

  Comment(
    this.id,
    this.userID,
    this.name,
    this.userImageUrl,
    this.content,
    this.createDate,
  );
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      json["id"],
      json["userId"],
      json["name"],
      json['userImageUrl'],
      json["content"],
      json["createDate"],
    );
  }
}
