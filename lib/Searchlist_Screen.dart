import 'dart:convert';

import 'package:flutter/material.dart';

import 'API_Services.dart';
import 'Search.dar.dart';
import 'Uselmodel.dart';
import 'package:http/http.dart' as http;

class SearchlistPage extends StatefulWidget {
  const SearchlistPage({Key? key}) : super(key: key);

  @override
  State<SearchlistPage> createState() => _SearchlistPageState();
}

class _SearchlistPageState extends State<SearchlistPage> {
  late Future<List<Usermodel>> userList;

  @override
  void initState() {
    super.initState();
    userList = getuser();
  }

  Future<List<Usermodel>> getuser() async {
    try {
      final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users/"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString()) as List;
        List<Usermodel> users = data.map((user) => Usermodel.fromJson(user)).toList();
        return users;
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchUser());
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: FutureBuilder<List<Usermodel>>(
          future: userList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Usermodel> users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  Usermodel user = users[index];
                  return Card(
                    child: ListTile(
                      title: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                user.id.toString(),
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(user.email),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}