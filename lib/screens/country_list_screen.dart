import 'package:example/models/country_model.dart';
import 'package:example/services/country_service.dart';
import 'package:flutter/material.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late CountryService _countryService;
  List<Country> countries = [];
  List<Country> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _countryService = CountryService();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Country> fetchedCountries = await _countryService.fetchCountries();
      setState(() {
        countries = fetchedCountries;
        filteredCountries = countries;
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void filterCountries(String query) {
    setState(() {
      filteredCountries = countries
          .where((country) => country.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void showCountryDetails(BuildContext context, Country country) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Country: ${country.name}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Image.network(
                country.flag,
                height: 100,
                width: 150,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('Flag not available'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => filterCountries(value),
          decoration: const InputDecoration(
            hintText: 'Search Country',
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredCountries.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => showCountryDetails(context, filteredCountries[index]),
            leading: Text(filteredCountries[index].name),
            trailing: Image.network(
              filteredCountries[index].flag,
              width: 50,
              height: 30,
            ),
          );
        },
      ),
    );
  }
}
