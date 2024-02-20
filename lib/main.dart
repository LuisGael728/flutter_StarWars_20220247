import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galaxia de las Estrellas',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(
        title: 'Galaxia de las Estrellas - Aventuras Cósmicas',
        age: 45,
        imageUrl: 'https://starwars-visualguide.com/assets/img/characters/4.jpg',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    required this.title,
    required this.age,
    required this.imageUrl,
  }) : super(key: key);

  final String title;
  final int age;
  final String imageUrl;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _futureCharacter;

  @override
  void initState() {
    super.initState();
    _futureCharacter = _fetchCharacter();
  }

  Future<Map<String, dynamic>> _fetchCharacter() async {
    final response = await http.get(
      Uri.parse('https://swapi.dev/api/people/4/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Fallo al cargar el personaje');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(widget.imageUrl),
            FutureBuilder<Map<String, dynamic>>(
              future: _futureCharacter,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Nombre: ${snapshot.data!['name']}'),
                      Text('Edad: ${widget.age}'),
                      Text('Altura: ${snapshot.data!['height']}'),
                      Text('Masa: ${snapshot.data!['mass']}'),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
