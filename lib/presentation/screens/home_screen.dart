import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../logic/blocs/booking/booking_bloc.dart';
import '../../logic/blocs/booking/booking_event.dart';
import '../../logic/blocs/booking/booking_state.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/booking_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Minggu Ini')),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.bookings.isEmpty) {
            return const Center(child: Text("Tidak ada booking minggu ini"));
          }

          DateTime today = DateTime.now();
          DateTime start = DateUtilsHelper.startOfWeek(today);

          // Generate list Senin-Minggu
          List<DateTime> daysOfWeek = List.generate(7, (index) {
            return start.add(Duration(days: index));
          });

          return ListView.builder(
            itemCount: daysOfWeek.length,
            itemBuilder: (context, index) {
              DateTime day = daysOfWeek[index];
              String dayLabel = DateUtilsHelper.formatDay(day);

              // Ambil booking sesuai hari ini
              List<BookingModel> dayBookings = state.bookings.where((b) {
                DateTime bookingDate = DateTime.parse(b.tanggal);
                return bookingDate.year == day.year &&
                       bookingDate.month == day.month &&
                       bookingDate.day == day.day;
              }).toList();

              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(dayLabel),
                  children: dayBookings.isEmpty
                      ? [const ListTile(title: Text("Tidak ada booking"))]
                      : dayBookings.map((booking) {
                          return ListTile(
                            title: Text("booking.a"),
                            subtitle: Text(
                                "{booking.buildingName} - {booking.floor}\n"
                                "Kapasitas: {booking.capacity}\n"
                                "Pemesan: {booking.bookedBy}"),
                            isThreeLine: true,
                          );
                        }).toList(),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<BookingBloc>().add(LoadBookings());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
