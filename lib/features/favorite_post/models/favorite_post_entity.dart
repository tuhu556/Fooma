class MyFavoritePostResponse {
  List<FavoritePost> favoritePost;
  int totalItem;
  MyFavoritePostResponse(this.favoritePost, this.totalItem);

  factory MyFavoritePostResponse.fromJson(Map<String, dynamic> json) {
    final listFavoritePost =
        (json["items"] as List).map((e) => FavoritePost.fromJson(e)).toList();
    final totalItem = json["totalItem"];
    return MyFavoritePostResponse(listFavoritePost, totalItem);
  }
}

class FavoritePost {
  final String id;
  final String userId;
  final String postId;
  final String createDate;
  final int status;
  final PostResponse postResponse;
  FavoritePost(this.id, this.userId, this.postId, this.createDate, this.status,
      this.postResponse);
  factory FavoritePost.fromJson(Map<String, dynamic> json) {
    return FavoritePost(
      json["id"],
      json["userId"],
      json["postId"],
      json['createDate'],
      json["status"],
      PostResponse.fromJson(
        json["postResponse"],
      ),
    );
  }
}

class PostResponse {
  final String id;
  final String userId;
  final String name;
  final String userImageUrl;
  final String title;
  final String content;
  final String publishedDate;
  final String hashtag;
  final int status;
  final String role;
  int totalComment;
  int totalReact;
  final List<ImageList> postImages;
  PostResponse(
      this.id,
      this.userId,
      this.name,
      this.userImageUrl,
      this.title,
      this.content,
      this.publishedDate,
      this.hashtag,
      this.status,
      this.role,
      this.totalComment,
      this.totalReact,
      this.postImages);
  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
        json["id"],
        json["userId"],
        json["name"],
        json["userImageUrl"],
        json["title"],
        json["content"],
        json["publishedDate"],
        json["hashtag"],
        json["status"],
        json["role"],
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
