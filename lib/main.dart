
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

Future<Album> fetchAlbum() async {
  final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  if (response.statusCode == 200) {

    return Album.fromJson(jsonDecode(response.body));
  } else {

    throw Exception('Failed to load album');
  }
}

Future<Album> UpdatingData(String title) async{
  final response = await http.put(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
      headers: <String ,String>{
        'Content-Type':'application/json; charset=UTF-8',
  },
  body:jsonEncode(<String,String>{'title':title}));
  if(response.statusCode == 200){
    return Album.fromJson(jsonDecode(response.body));
  }
  else
    {
      throw Exception("failed to update title");
    }
}

class Album {
  final String title;


  Album({
    required this.title,

  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['title'],
    );
  }
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TextEditingController controller = TextEditingController();
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data from internet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fatching Data from Internet'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            child: FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {

                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(snapshot.data!.title),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "enter the title"
                            ),

                            controller: controller,
                          ),
                          ElevatedButton(onPressed: (){
                            setState(() {
                              futureAlbum = UpdatingData(controller.text);
                            });
                          },
                            child: Text('update the title'),
                          )


                        ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                }
                return
                  CircularProgressIndicator
                    (
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}