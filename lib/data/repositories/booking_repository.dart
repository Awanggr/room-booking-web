import 'package:dio/dio.dart';
import '../models/room_model.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<List<RoomModel>> getRooms() async {
    final response = await _dio.get('/ruangan');
    return (response.data as List)
        .map((json) => RoomModel.fromJson(json))
        .toList();
  }

  Future<List<BookingModel>> getBookings() async {
    final response = await _dio.get('/bookings');
    return (response.data as List)
        .map((json) => BookingModel.fromJson(json))
        .toList();
  }
}
