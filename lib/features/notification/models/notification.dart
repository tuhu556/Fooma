class NotificationResponse {
  List<Noti> listNoti;
  int totalPage;
  NotificationResponse(this.listNoti, this.totalPage);

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final listNoti =
        (json["items"] as List).map((e) => Noti.fromJson(e)).toList();
    final totalPage = json["totalPage"];
    return NotificationResponse(listNoti, totalPage);
  }
}

class Noti {
  final String id;
  final String postId;
  final String postTitle;
  final String postThumbnail;
  final String recipeId;
  final String recipeTitle;
  final String recipeThumbnail;
  final String planId;
  final String planTitle;
  final String planThumbnail;
  final String ingredientId;
  final String ingredientName;
  final String ingredientThumbnail;
  final String title;
  final String content;
  final String category;
  final String createDate;
  bool isSeen;
  final int status;

  Noti(
    this.id,
    this.postId,
    this.postTitle,
    this.postThumbnail,
    this.recipeId,
    this.recipeTitle,
    this.recipeThumbnail,
    this.planId,
    this.planTitle,
    this.planThumbnail,
    this.ingredientId,
    this.ingredientName,
    this.ingredientThumbnail,
    this.title,
    this.content,
    this.category,
    this.createDate,
    this.isSeen,
    this.status,
  );
  factory Noti.fromJson(Map<String, dynamic> json) {
    return Noti(
      json["id"] ?? "",
      json["postId"] ?? "",
      json["postTitle"] ?? "",
      json['postThumbnail'] ?? "",
      json["recipeId"] ?? "",
      json["recipeTitle"] ?? "",
      json["recipeThumbnail"] ?? "",
      json["planId"] ?? "",
      json["planTitle"] ?? "",
      json['planThumbnail'] ?? "",
      json["ingredientId"] ?? "",
      json["ingredientName"] ?? "",
      json["ingredientThumbnail"] ?? "",
      json["title"] ?? "",
      json["content"] ?? "",
      json['category'] ?? "",
      json["createDate"] ?? "",
      json["isSeen"] ?? "",
      json["status"] ?? "",
    );
  }
}
