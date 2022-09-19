class OriginResponse {
  final int page;
  final int size;
  final int totalItem;
  final int totalPage;
  final List<OriginModel> items;
  OriginResponse(
      this.page, this.size, this.totalItem, this.totalPage, this.items);
  factory OriginResponse.fromJson(Map<String, dynamic> json) {
    final page = json["page"];
    final size = json["size"];
    final totalItem = json["totalItem"];
    final totalPage = json["totalPage"];
    final items =
        (json["items"] as List).map((e) => OriginModel.fromJson(e)).toList();

    return OriginResponse(page, size, totalItem, totalPage, items);
  }
}

class OriginModel {
  final String id;
  final String originName;
  OriginModel(this.id, this.originName);
  factory OriginModel.fromJson(Map<String, dynamic> json) {
    return OriginModel(
      json["id"],
      json["originName"],
    );
  }
}
