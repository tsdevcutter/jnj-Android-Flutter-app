import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:jnjversion01windows/handlers/database_helper.dart';
import 'package:jnjversion01windows/models/event.dart';
import 'package:jnjversion01windows/models/user.dart';
import 'package:jnjversion01windows/screens/profile_screen.dart';
import 'package:jnjversion01windows/screens/race_screen.dart';
import 'package:jnjversion01windows/utilities/univariable.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utilities/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  List<dynamic> _eventsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _fetchEvents();
  }

  Future<void> _loadUser() async {
    final user = await DatabaseHelper.instance.getUser();// Implement getUser() in DatabaseHelper

    setState(() {
      _user = user;
    });
  }

  Future<void> _fetchEvents() async {
    try {
      final response = await http.get(Uri.parse(BASE_API_URL + "events/list/full"));
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        setState(() {
          // Mapping the raw json to your Event model list
          _eventsList = body.map((dynamic item) => Event.fromJson(item)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error fetching events: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
            Stack(children: [
                Container(
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2.0),
                                      blurRadius: 6.0),
                                ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image(
                      image: AssetImage("assets/images/1.jpg"),
                      fit: BoxFit.cover,),
                  ),
                )
              ],
            ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Univariable.primaryColor))
                : ListView.builder(
              padding: EdgeInsets.only(top: 20),
              itemCount: _eventsList.length,
              itemBuilder: (context, index) {
                Event event = _eventsList[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Univariable.lightPimaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        event.featureUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.event, color: Univariable.primaryColor),
                      ),
                    ),
                    title: Text(
                      event.title,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text("${event.eventDate} • ${event.startTime}"),
                        Text(event.startAddress, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Univariable.primaryColor),
                    onTap: () {
                      // Navigate to Event Details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RaceScreen(event: event),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        },
        backgroundColor: Univariable.primaryColor, // Choose a color that fits your theme
        child: const Icon(Icons.person),
      ),
    );
  }
}
