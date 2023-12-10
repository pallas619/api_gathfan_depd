part of 'services.dart';

class MasterDataService {
  static Future<List<Province>> getProvince() async {
    var response = await http.get(Uri.https(Const.baseUrl, "/starter/province"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'key': Const.apiKey,
        });

    var job = json.decode(response.body);
    List<Province> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => Province.fromJson(e))
          .toList();
    }
    return result;
  }

  static Future<List<City>> getCity(var provId) async {
    var response = await http.get(Uri.https(Const.baseUrl, "/starter/city"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'key': Const.apiKey,
        });

    var job = json.decode(response.body);
    List<City> result = [];
    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => City.fromJson(e))
          .toList();
    }

    List<City> selectedCities = [];
    for (var c in result) {
      if (c.provinceId == provId) {
        selectedCities.add(c);
      }
    }

    return selectedCities;
  }

  static Future<List<Costs>> getCost(
      var courier, var weight, var originId, var destinationId) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.rajaongkir.com/starter/cost"),
        body: {
          "key": Const.apiKey,
          "origin": originId,
          "destination": destinationId,
          "weight": weight.toString(),
          "courier": courier,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return (data['rajaongkir']['results'][0]['costs'] as List)
            .map((e) => Costs.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load costs');
      }
    } catch (e) {
      throw Exception('Failed to load costs: $e');
    }
  }
}
