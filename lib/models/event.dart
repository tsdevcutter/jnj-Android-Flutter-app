import 'dart:convert';

class Event {
  final String id; // From MongoDB _id
  final String title;
  final String featureUrl;
  final String startLat;
  final String startLon;
  final String startAddress;
  final String endLat;
  final String endLon;
  final String endAddress;
  final String eventDate;
  final String startTime;
  final bool on;
  final DateTime? createdAt;

  Event({
    required this.id,
    required this.title,
    required this.featureUrl,
    required this.startLat,
    required this.startLon,
    required this.startAddress,
    required this.endLat,
    required this.endLon,
    required this.endAddress,
    required this.eventDate,
    required this.startTime,
    required this.on,
    this.createdAt,
  });

  // Convert JSON Map to Event Object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      featureUrl: json['featureUrl'] ?? '',
      startLat: json['startLat'] ?? '',
      startLon: json['startLon'] ?? '',
      startAddress: json['startAddress'] ?? '',
      endLat: json['endLat'] ?? '',
      endLon: json['endLon'] ?? '',
      endAddress: json['endAddress'] ?? '',
      eventDate: json['eventDate'] ?? '',
      startTime: json['startTime'] ?? '',
      on: json['on'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  // Convert Event Object to JSON Map (for POST/PATCH requests)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'featureUrl': featureUrl,
      'startLat': startLat,
      'startLon': startLon,
      'startAddress': startAddress,
      'endLat': endLat,
      'endLon': endLon,
      'endAddress': endAddress,
      'eventDate': eventDate,
      'startTime': startTime,
      'on': on,
    };
  }
}