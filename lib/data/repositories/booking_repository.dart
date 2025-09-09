import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/room_model.dart';
import '../models/booking_model.dart';

import 'package:dio/dio.dart';

class BookingRepository {
  final Dio _dio = Dio();

  // URL raw GitHub langsung ke file db.json
  final String _url =
      'https://raw.githubusercontent.com/Awanggr/room-booking-web/main/mock_api/db.json';

  Future<List<RoomModel>> getRooms() async {
    final response = await _dio.get(_url);
    final data = response.data;
    // pastikan response.data berupa Map
    if (data is String) {
      // Jika dio mengembalikan string, decode dulu
      final jsonData = jsonDecode(data);
      return (jsonData['ruangan'] as List)
          .map((json) => RoomModel.fromJson(json))
          .toList();
    } else if (data is Map) {
      return (data['ruangan'] as List)
          .map((json) => RoomModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Unexpected data format');
    }
  }

  Future<List<BookingModel>> getBookings() async {
    final response = await _dio.get(_url);
    final data = response.data;
    if (data is String) {
      final jsonData = jsonDecode(data);
      return (jsonData['bookings'] as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();
    } else if (data is Map) {
      return (data['bookings'] as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Unexpected data format');
    }
  }
}

