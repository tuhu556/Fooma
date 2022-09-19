class UserProfileResponse {
  final String? id;
  final String? email;
  final String? name;
  final String? imageUrl;
  final String? bio;
  int? totalPost;
  int? totalRecipe;
  final String? role;

  UserProfileResponse({
    this.id,
    this.email,
    this.name,
    this.imageUrl,
    this.bio,
    this.totalPost,
    this.totalRecipe,
    this.role,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
        id: json["id"] ?? "",
        email: json["email"] ?? "",
        name: json["name"] ?? "",
        imageUrl: json["imageUrl"] ??
            "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png",
        bio: json["bio"] ?? "",
        totalPost: json["totalPost"] ?? "0",
        totalRecipe: json["totalRecipe"] ?? "0",
        role: json["role"] ?? "USER");
  }
}
