
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DirectionsRepository {

  String key = 'AIzaSyAKB6P5XDKpjN3bJ-2dgdK0aufHrpAIKvk';

  Future<Map<String,dynamic>> getDirections(
      String origin, String destination) async {

    final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    return json;
  }
}