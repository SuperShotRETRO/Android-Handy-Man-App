class ServiceModel {
  int id;
  String name;
  String price;
  String rating;
  int reviewCount;
  String category;
  String image;

  ServiceModel({
    required this.id ,
    this.name = '',
    this.price = '',
    this.rating = '',
    this.reviewCount = 0,
    this.category = '',
    this.image = '',
});

}
