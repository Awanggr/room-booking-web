import 'package:equatable/equatable.dart';

import '../../../data/models/booking_model.dart';
import '../../../data/models/room_model.dart';

class CalendarState extends Equatable {
  final bool isLoading;
  final List<RoomModel> rooms;
  final List<BookingModel> bookings;
  final String? error;

  const CalendarState({
    this.isLoading = false,
    this.rooms = const [],
    this.bookings = const [],
    this.error,
  });

  CalendarState copyWith({
    bool? isLoading,
    List<RoomModel>? rooms,
    List<BookingModel>? bookings,
    String? error,
  }) {
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      rooms: rooms ?? this.rooms,
      bookings: bookings ?? this.bookings,
      error: error ?? this.error,
    );
  }

  

  @override
  List<Object?> get props => [isLoading, rooms, bookings, error];
}
