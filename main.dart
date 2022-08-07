import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// class for api objects
class Drink {
  final String name;
  final String desc;
  const Drink ({
    required this.name,
    required this.desc
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      name: json['name'] as String,
      desc: json['desc'] as String,
    );
  }
}

Future<Drink> fetchDrink() async {
  // can't fetch entire list only one entry from json list
  // local api url used
  final response = await http.get(Uri.parse('put Local API Here'));

  if (response.statusCode == 200) {
    return Drink.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed request');
  }
}

void main() => runApp(const drinkHome());

class drinkHome extends StatefulWidget {
  const drinkHome({super.key});
  
  State<drinkHome> createState() => _drinkHomeState();
}

class _drinkHomeState extends State<drinkHome> {
  late Future<Drink> futureDrink;

  @override
  void initState() {
    super.initState();
    futureDrink = fetchDrink();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          Container(
            color: Colors.purple[500],
            child: FutureBuilder<Drink> (
              future: futureDrink,
              builder: (context, snapshot) {
                // code to display data from local api
                if (snapshot.hasData) {
                  return Text(snapshot.data!.name + ', ' + snapshot.data!.desc, textDirection: TextDirection.ltr, style: const TextStyle(fontFamily: 'Bangers', fontSize: 50),);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}', textDirection: TextDirection.ltr);
                }
                return const CircularProgressIndicator();
              }
            ),
          ),
        ],
      ),
    );
  }
}