import 'package:equatable/equatable.dart';
import '../../../data/models/booking_model.dart';

class BookingState extends Equatable {
  final List<BookingModel> bookings;
  final bool isLoading;

  const BookingState({this.bookings = const [], this.isLoading = false});

  BookingState copyWith({List<BookingModel>? bookings, bool? isLoading}) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [bookings, isLoading];
}
