import 'dart:convert';
import 'package:example/models/country_model.dart';
import 'package:http/http.dart' as http;

class CountryService {
  Future<List<Country>> fetchCountries() async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Country.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch countries');
    }
  }
}
