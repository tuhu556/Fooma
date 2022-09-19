class LocationResponse {
  final int totalItem;
  final List<LocationModel> item;
  LocationResponse(this.totalItem, this.item);
  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    final totalItem = json["totalItem"];
    final items =
        (json["items"] as List).map((e) => LocationModel.fromJson(e)).toList();

    return LocationResponse(totalItem, items);
  }
}

class LocationModel {
  final String id;
  final String locationName;
  LocationModel(this.id, this.locationName);
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      json["id"],
      json["locationName"],
    );
  }
}
