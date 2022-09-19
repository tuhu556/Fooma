class MyPostResponse {
  List<MyPost> myPost;
  int totalPage;
  MyPostResponse(this.myPost, this.totalPage);

  factory MyPostResponse.fromJson(Map<String, dynamic> json) {
    final listMyPost =
        (json["items"] as List).map((e) => MyPost.fromJson(e)).toList();
    final totalPage = json["totalPage"];
    return MyPostResponse(listMyPost, totalPage);
  }
}

class MyPost {
  final String id;
  final String userID;
  final String name;
  final String userImageUrl;
  final String title;
  final String content;
  final String publishedDate;
  final String role;
  final String reason;
  bool isReacted;
  bool isSaved;
  final int status;
  int totalComment;
  int totalReact;
  final List<ImageList> postImages;

  MyPost(
    this.id,
    this.userID,
    this.name,
    this.userImageUrl,
    this.title,
    this.content,
    this.publishedDate,
    this.role,
    this.reason,
    this.isReacted,
    this.isSaved,
    this.status,
    this.totalComment,
    this.totalReact,
    this.postImages,
  );
  factory MyPost.fromJson(Map<String, dynamic> json) {
    return MyPost(
        json["id"],
        json["userId"],
        json["name"],
        json['userImageUrl'],
        json["title"],
        json["content"],
        json["publishedDate"],
        json["role"],
        json["reason"] ?? "Không có",
        json["isReacted"],
        json["isSaved"],
        json["status"],
        json["totalComment"],
        json["totalReact"],
        (List<dynamic>.from(json["postImages"]))
            .map((e) => ImageList.fromJson(e))
            .toList());
  }
}

class ImageList {
  final String id;
  final String imageUrl;
  final bool isThumbnail;
  final int status;

  ImageList(this.id, this.imageUrl, this.isThumbnail, this.status);
  factory ImageList.fromJson(Map<String, dynamic> json) {
    return ImageList(
      json["id"] ?? "",
      json["imageUrl"] ?? "",
      json["isThumbnail"] ?? true,
      json["status"] ?? 1,
    );
  }
}
