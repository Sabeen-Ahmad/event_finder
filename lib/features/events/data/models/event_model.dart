import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
  final int id;
  final String title;
  final String category;
  final String date;
  final String time;
  final String location;
  final String imageUrl;
  final String distance;
  final String description;

  const EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.distance,
    required this.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: json['id'] as int,
    title: json['title'] as String,
    category: json['category'] as String,
    date: json['date'] as String,
    time: json['time'] as String,
    location: json['location'] as String,
    imageUrl: json['image_url'] as String,
    distance: json['distance'] as String,
    description: json['description'] as String,
  );

  @override
  List<Object?> get props =>
      [id, title, category, date, time, location, imageUrl, distance, description];
}