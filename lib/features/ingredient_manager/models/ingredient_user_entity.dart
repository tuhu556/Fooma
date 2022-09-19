import 'package:foodhub/config/endpoint.dart';

class IngredientUserResponse {
  int totalItem;
  int totalFreeze;
  int totalCool;
  int totalOutSide;
  List<IngredientUserModel> items;
  IngredientUserResponse(this.totalItem, this.totalFreeze, this.totalCool,
      this.totalOutSide, this.items);
  factory IngredientUserResponse.fromJson(Map<String, dynamic> json) {
    final totalItem = json["totalItem"];
    final totalFreeze = json["totalFreeze"];
    final totalCool = json["totalCool"];
    final totalOutSide = json["totalOther"];
    final items = (json["items"] as List)
        .map((e) => IngredientUserModel.fromJson(e))
        .toList();

    return IngredientUserResponse(
        totalItem, totalFreeze, totalCool, totalOutSide, items);
  }
}

class IngredientTotalResponse {
  int totalItem;
  List<IngredientUserModel> items;
  IngredientTotalResponse(this.totalItem, this.items);
  factory IngredientTotalResponse.fromJson(Map<String, dynamic> json) {
    final totalItem = json["totalItem"];
    final items = (json["items"] as List)
        .map((e) => IngredientUserModel.fromJson(e))
        .toList();

    return IngredientTotalResponse(totalItem, items);
  }
}

class IngredientUserModel {
  final String id;
  final String ingredientDbid;
  final String categoryId;
  final String locationId;
  final String locationName;
  final String categoryName;
  final String ingredientName;
  final String createDate;
  final String expiredDate;
  final int remainDate;
  final String condition;
  double quantity;
  final String imageUrl;
  final String unit;
  bool onTap = false;
  final List<IngredientNotifications> ingredientNotifications;
  IngredientUserModel(
    this.id,
    this.ingredientDbid,
    this.categoryId,
    this.locationId,
    this.locationName,
    this.categoryName,
    this.ingredientName,
    this.createDate,
    this.expiredDate,
    this.remainDate,
    this.condition,
    this.quantity,
    this.imageUrl,
    this.unit,
    this.ingredientNotifications,
  );
  factory IngredientUserModel.fromJson(Map<String, dynamic> json) {
    return IngredientUserModel(
      json["id"] ?? "",
      json["ingredientDbid"] ?? "",
      json["categoryId"] ?? "",
      json["locationId"] ?? "",
      json["locationName"] ?? "",
      json['categoryName'] ?? "",
      json['ingredientName'] ?? "",
      json["createDate"] ?? "",
      json["expiredDate"] ?? "",
      json["remainDate"] ?? 0,
      json["condition"] ?? "",
      json['quantity'] ?? 0,
      json["imageUrl"] ?? "",
      json["unit"] ?? "",
      (List<dynamic>.from(json["ingredientNotifications"]))
          .map((e) => IngredientNotifications.fromJson(e))
          .toList(),
    );
  }
}

class IngredientNotifications {
  final String ingredientNotificationId;

  IngredientNotifications(
    this.ingredientNotificationId,
  );
  factory IngredientNotifications.fromJson(Map<String, dynamic> json) {
    return IngredientNotifications(
      json["ingredientNotificationId"] ?? "",
    );
  }
}
