import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> placeSuggestions = [];

  Future<void> getSuggestions(String input) async {
    String apiKey = 'AIzaSyArXVgSCF4LhaTp4M-ckCvz5ZzT2Xg68to';
    String baseApiUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String requestUrl = '$baseApiUrl?input=$input&key=$apiKey';

    var response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      setState(() {
        placeSuggestions = jsonDecode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Location"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search other Location",
              ),
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                getSuggestions(value);
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: placeSuggestions.length,
                itemBuilder: (context, index) {
                  final place = placeSuggestions[index];
                  return ListTile(
                    title: Text(place['description']),
                    onTap: () {
                      String selectedPlace = place['description'];
                      Navigator.pop(context, selectedPlace);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
