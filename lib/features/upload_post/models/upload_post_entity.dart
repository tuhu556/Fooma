class PostImages {
  final int orderNumber;
  final String imageUrl;
  final bool isThumbnail;

  PostImages(
    this.orderNumber,
    this.imageUrl,
    this.isThumbnail,
  );
  factory PostImages.fromJson(Map<String, dynamic> json) {
    return PostImages(
      json["orderNumber"] ?? "",
      json["imageUrl"] ?? "",
      json["isThumbnail"] ?? true,
    );
  }
}
