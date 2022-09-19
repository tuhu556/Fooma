import 'dart:convert';

import 'dart:async';
import 'package:foodhub/config/endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:tiengviet/tiengviet.dart';

class reicpeSuggestResponse {
  final int page;
  final int size;
  final List<recipeSuggestModel> items;
  reicpeSuggestResponse(this.page, this.size, this.items);
  factory reicpeSuggestResponse.fromJson(Map<String, dynamic> json) {
    final page = json["page"];
    final size = json["size"];
    final listData = (json["items"] as List)
        .map((e) => recipeSuggestModel.fromJson(e))
        .toList();

    return reicpeSuggestResponse(page, size, listData);
  }
}

class recipeSuggestModel {
  final String id;
  final String recipeName;
  final String thumbnail;
  recipeSuggestModel(this.id, this.recipeName, this.thumbnail);
  factory recipeSuggestModel.fromJson(Map<String, dynamic> json) {
    return recipeSuggestModel(
      json["id"],
      json["recipeName"],
      json["thumbnail"],
    );
  }
}

class RecipeSuggestionService {
  static Future<List<recipeSuggestModel>> getRecipeSuggestions(
      String query) async {
    var url = Uri.https(
        Endpoint.shared.url,
        Path.shared.pathRecipeSuggestionData,
        {'search': query, 'size': '1000'});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List recipe = json.decode(response.body);
      print(response.body);

      return recipe
          .map((json) => recipeSuggestModel.fromJson(json))
          .where((recipe) {
        final recipeLower = recipe.recipeName.toLowerCase();
        final queryLower = query.toLowerCase();
        return TiengViet.parse(recipeLower)
            .contains(TiengViet.parse(queryLower));
      }).toList();
    } else {
      throw Exception();
    }
  }
}
