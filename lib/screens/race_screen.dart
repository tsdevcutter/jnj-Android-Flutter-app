import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:jnjversion01windows/handlers/database_helper.dart';
import 'package:jnjversion01windows/models/event.dart';
import 'package:jnjversion01windows/models/user.dart';
import 'package:jnjversion01windows/screens/home_screen.dart';
import 'package:jnjversion01windows/screens/profile_screen.dart';
import 'package:jnjversion01windows/utilities/univariable.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../utilities/strings.dart';

class RaceScreen extends StatefulWidget {
  final Event event;
  const RaceScreen({super.key, required this.event});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {

  String _currentPosition = "Ready to Track (10m intervals)";
  StreamSubscription<Position>? _positionStream;
  bool _isTracking = false;
  User? _user;
  IO.Socket? socket;
  bool _raceFinished = false;
  String _finishMessage = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await DatabaseHelper.instance.getUser();// Implement getUser() in DatabaseHelper

    setState(() {
      _user = user;
    });
  }

  final LocationSettings _lowPowerSettings = const LocationSettings(
    accuracy: LocationAccuracy.medium, // Medium accuracy uses less battery than High
    distanceFilter: 10,               // Only updates every 10 meters
  );

  void _connectSocket() {

    socket = IO.io(
      BASE_URL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) {
      print("✅ Socket Connected");
    });

    socket!.onDisconnect((_) {
      print("❌ Socket Disconnected");
    });

    // 🏁 Listen for race finish
    socket!.on("race_finished", (data) {

      if (data["eventId"] == widget.event.id) {

        setState(() {
          _raceFinished = true;
          _finishMessage = "🏁 Race Completed!";
        });

        _stopTracking();
      }
    });

    socket!.onError((data) {
      print("⚠️ Socket Error: $data");
    });

  }

  Future<void> _toggleLocationUpdates() async {

    if (_raceFinished) return;

    if (_isTracking) {
      _stopTracking();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (_user == null) return;

    _connectSocket();

    setState(() => _isTracking = true);

    _positionStream = Geolocator.getPositionStream(
      locationSettings: _lowPowerSettings,
    ).listen((Position position) {

      setState(() {
        _currentPosition =
        "Lat: ${position.latitude.toStringAsFixed(5)}\n"
            "Long: ${position.longitude.toStringAsFixed(5)}";
      });

      if (socket?.connected == true) {

        socket!.emit("race-location-update", {
          "eventId": widget.event.id,
          "mid": _user!.mid,
          "name": _user!.name,
          "surname": _user!.surname,
          "cell": _user!.cell,
          "latitude": position.latitude,
          "longitude": position.longitude,
          "timestamp": DateTime.now().toIso8601String()
        });
      }
    });
  }

  void _stopTracking() {

    _positionStream?.cancel();

    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
      socket = null;
    }

    setState(() {
      _isTracking = false;
      _currentPosition = "Tracking Paused";
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    socket?.disconnect();
    super.dispose();
  }

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
                  image: AssetImage("assets/images/2.jpg"),
                  fit: BoxFit.cover,),
              ),
            ),

            Column(
              children: [
                SizedBox(height: 40,),
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 25.0,
                  color: Univariable.whiteColor,
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    )
                  },
                )
              ],
            )
          ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  if (_raceFinished)
                    Column(
                      children: [
                        const Text(
                          "🏁 Race Completed",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _finishMessage,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Text(
                          _isTracking ? "🛰️ Tracking Active" : "📡 JnJ Ready",
                          style: TextStyle(
                            color: _isTracking ? Colors.green : Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          _currentPosition,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        ElevatedButton(
                          onPressed: _toggleLocationUpdates,
                          child: Text(
                            _isTracking
                                ? "Stop"
                                : "Start Tracking (10m)",
                          ),
                        ),
                      ],
                    ),
                ],
              ),
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
