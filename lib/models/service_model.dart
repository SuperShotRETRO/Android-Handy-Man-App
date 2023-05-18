class ServiceModel {
  int id;
  String name;
  String price;
  String rating;
  int reviewCount;
  String category;
  String image;
  String lat;
  String long;
  String distance;
  String duration;

  ServiceModel({
    required this.id ,
    this.name = '',
    this.price = '',
    this.rating = '',
    this.reviewCount = 0,
    this.category = '',
    this.image = '',
    this.lat = '',
    this.long = '',
    this.distance = '',
    this.duration = ''
});

}
