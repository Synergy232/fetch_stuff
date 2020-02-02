import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response =
      await http.get('https://www.balldontlie.io/api/v1/teams/7');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final int id;
  final String abbviation;
  final String city;
  final String conference;
  final String division;
  final String full_name;
  final String name;
  final int total_pages;
  final int current_page;
  final int next_page;
  final int per_page;
  final int total_count;

  Post({this.id, this.abbviation, this.city, this.conference, this.division, this.full_name, this.name, this.total_pages, this.current_page, this.next_page, this.per_page, this.total_count});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      abbviation: json['abbviation'],
      city: json['city'],
      conference: json['conference'],
      division:  json['division'],
      full_name: json['full_name'],
      name: json['name'],
      total_pages: json['total_pages'],
      current_page: json['current_page'],
      next_page: json['next_page'],
      per_page: json['per_page'],
      total_count: json['total_count']
    );
  }
}


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
Future<Post> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Stuff'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.full_name);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

