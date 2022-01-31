class PlaceSerach{

  final String description;
  final String placeId;

  PlaceSerach({required this.description, required this.placeId});


  factory PlaceSerach.fromJson(Map<String, dynamic> json){
    return PlaceSerach(
      description: json['description'],
      placeId: json['place_id']
    );
  }
}