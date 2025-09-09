import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_booking_web/core/utils/date_utils.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/repositories/booking_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc(this.bookingRepository) : super(const BookingState()) {
    on<LoadBookings>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final allBookings = await bookingRepository.getBookings();
        DateTime today = DateTime.now();
        DateTime start = DateUtilsHelper.startOfWeek(today);
        DateTime end = DateUtilsHelper.endOfWeek(today);

        final filtered = allBookings.where((booking) {
          DateTime bookingDate = DateTime.parse(booking.tanggal);
          return bookingDate.isAfter(start.subtract(const Duration(days: 1))) &&
              bookingDate.isBefore(end.add(const Duration(days: 1)));
        }).toList();

        emit(state.copyWith(bookings: filtered, isLoading: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }
}
