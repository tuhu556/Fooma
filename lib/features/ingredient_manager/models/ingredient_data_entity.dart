import 'dart:convert';

import 'dart:async';
import 'package:foodhub/config/endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:tiengviet/tiengviet.dart';

class IngredientResponse {
  List<IngredientDataModel> data;
  int totalItem;
  IngredientResponse(this.data, this.totalItem);
  factory IngredientResponse.fromJson(Map<String, dynamic> json) {
    final listData = (json["items"] as List)
        .map((e) => IngredientDataModel.fromJson(e))
        .toList();
    final totalItem = json["totalItem"];
    return IngredientResponse(listData, totalItem);
  }
}

class IngredientDataModel {
  final String id;
  final String categoryId;
  final String ingredientName;
  final String imageUrl;
  final String categoryName;
  final int freeze;
  final int cool;
  final int normal;
  IngredientDataModel(this.id, this.categoryId, this.ingredientName,
      this.imageUrl, this.categoryName, this.freeze, this.cool, this.normal);
  factory IngredientDataModel.fromJson(Map<String, dynamic> json) {
    return IngredientDataModel(
      json["id"],
      json["categoryId"],
      json["ingredientName"],
      json['imageUrl'],
      json["categoryName"],
      json["freeze"] ?? 0,
      json["cool"] ?? 0,
      json["normal"] ?? 0,
    );
  }
}

class IngredientService {
  static Future<List<IngredientDataModel>> getIngredientSuggestions(
      String query) async {
    var url = Uri.https(
        Endpoint.shared.url,
        Path.shared.pathIngredientSuggestionData,
        {'search': query, 'size': '100'});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List ingredients = json.decode(response.body);

      return ingredients
          .map((json) => IngredientDataModel.fromJson(json))
          .where((ingredient) {
        final ingredientLower = ingredient.ingredientName.toLowerCase();
        final queryLower = query.toLowerCase();
        return TiengViet.parse(ingredientLower)
            .contains(TiengViet.parse(queryLower));
      }).toList();
    } else {
      throw Exception();
    }
  }
}
