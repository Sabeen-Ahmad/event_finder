import 'package:dio/dio.dart';
import '../models/event_model.dart';

class EventService {
  final Dio _dio;

  static const String _mockUrl =
      'https://my-json-server.typicode.com/Sabeen-Ahmad/event_finder_api/events';

  EventService(this._dio);

  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await _dio.get(_mockUrl);
      final List<dynamic> data = response.data;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load events: ${e.message}');
    }
  }
}