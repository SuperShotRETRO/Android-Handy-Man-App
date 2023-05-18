class AddressModel {
  String name;
  String addressline1;
  String addressline2;
  String city;
  String pin;
  int lat;
  int long;

  AddressModel({
    this.name = '',
    this.addressline1 = '',
    this.addressline2 = '',
    this.city = '',
    this.pin = '',
    this.lat = 0,
    this.long = 0,
  });
}