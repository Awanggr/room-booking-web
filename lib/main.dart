import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/booking_repository.dart';
import 'logic/blocs/calendar/calendar_bloc.dart';
import 'presentation/screens/week_calendar_screen.dart';

void main() {
  final repository = BookingRepository();
  runApp(RoomBookingApp(repository: repository));
}

class RoomBookingApp extends StatelessWidget {
  final BookingRepository repository;
  const RoomBookingApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CalendarBloc(repository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Room Booking Web',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const WeekCalendarScreen(),
      ),
    );
  }
}
