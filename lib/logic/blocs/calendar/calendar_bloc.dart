import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/booking_repository.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final BookingRepository repository;

  CalendarBloc(this.repository) : super(const CalendarState()) {
    on<LoadCalendarData>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final rooms = await repository.getRooms();
        final bookings = await repository.getBookings();
        emit(state.copyWith(rooms: rooms, bookings: bookings, isLoading: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }
}
