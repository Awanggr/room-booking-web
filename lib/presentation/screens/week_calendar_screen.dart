import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../logic/blocs/calendar/calendar_bloc.dart';
import '../../logic/blocs/calendar/calendar_event.dart';
import '../../logic/blocs/calendar/calendar_state.dart';

class WeekCalendarScreen extends StatefulWidget {
  const WeekCalendarScreen({Key? key}) : super(key: key);

  @override
  State<WeekCalendarScreen> createState() => _WeekCalendarScreenState();
}

class _WeekCalendarScreenState extends State<WeekCalendarScreen> {
  int weekOffset = 0;

  @override
  void initState() {
    super.initState();
    context.read<CalendarBloc>().add(LoadCalendarData());
  }

  /// Ambil tanggal 1 minggu (Senin-Minggu)
  List<DateTime> _getCurrentWeek() {
    final now = DateTime.now().add(Duration(days: weekOffset * 7));
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  /// Cek apakah tanggal ini hari ini
  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  /// Parsing jam string "HH:mm"
  DateTime parseTime(String time) {
    return DateTime.parse("2023-01-01 $time");
  }

  @override
  Widget build(BuildContext context) {
    final days = _getCurrentWeek();

    return Scaffold(
      appBar: AppBar(title: const Text("Booking Calendar"), centerTitle: true),
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text("Error: ${state.error}"));
          }

          final rooms = state.rooms;
          final bookings = state.bookings;

          if (rooms.isEmpty) {
            return const Center(child: Text("Tidak ada data ruangan"));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return _buildDesktopGridDynamic(days, rooms, bookings, context);
              } else {
                return _buildMobileView(days, rooms, bookings);
              }
            },
          );
        },
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  /// Navigasi per minggu
  Widget _buildNavigationBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => weekOffset--),
          ),
          Text(
            "Minggu ke-${weekOffset + 1}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => setState(() => weekOffset++),
          ),
        ],
      ),
    );
  }

  /// Desktop Grid
  Widget _buildDesktopGridDynamic(
    List<DateTime> days,
    List rooms,
    List bookings,
    BuildContext context, // tambahkan context untuk MediaQuery
  ) {
    const double minCellHeight = 40;

    // Hitung lebar layar
    final screenWidth = MediaQuery.of(context).size.width;

    // Total jumlah kolom = 1 kolom ruangan + jumlah hari
    final totalColumns = 1 + days.length;

    // Berikan lebar dinamis: roomCellWidth bisa lebih besar, dayCellWidth sisanya
    final roomCellWidth = screenWidth * 0.10; // 20% untuk kolom Ruangan
    final dayCellWidth = (screenWidth - roomCellWidth) / days.length;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: roomCellWidth,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey[200],
                    ),
                    child: const Center(
                      child: Text(
                        'Ruangan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  ...days.map((d) {
                    return Container(
                      width: dayCellWidth,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: d.weekday == DateTime.sunday
                            ? Colors.red[100]
                            : Colors.grey[200],
                      ),
                      child: Center(
                        child: Text(
                          DateFormat("EEE\ndd MMM").format(d),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isToday(d) ? Colors.blue : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            // Rows per room
            ...rooms.map((room) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Room Name Cell
                    Container(
                      width: roomCellWidth,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text("${room.kode} - ${room.lokasi}"),
                      ),
                    ),

                    // Booking Cells
                    ...days.map((day) {
                      final cellBookings =
                          bookings.where((b) {
                            DateTime? date;
                            try {
                              date = DateTime.parse(b.tanggal);
                            } catch (_) {
                              return false;
                            }
                            return (b.ruanganId == room.id) &&
                                date.year == day.year &&
                                date.month == day.month &&
                                date.day == day.day;
                          }).toList()..sort(
                            (a, b) => parseTime(
                              a.waktuMulai,
                            ).compareTo(parseTime(b.waktuMulai)),
                          );

                      return Container(
                        width: dayCellWidth,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: cellBookings.isEmpty
                            ? SizedBox(height: minCellHeight)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: cellBookings.map((booking) {
                                  final start = parseTime(booking.waktuMulai);
                                  final end = parseTime(booking.waktuSelesai);
                                  final isLunch =
                                      start.hour < 13 && end.hour > 12;

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: isLunch
                                          ? Colors.orange[200]
                                          : Colors.green[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "${booking.kegiatan}\n${booking.waktuMulai} - ${booking.waktuSelesai}\n(${booking.nama})",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// Mobile View
  Widget _buildMobileView(List<DateTime> days, List rooms, List bookings) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: days.map((day) {
        return ExpansionTile(
          title: Container(
            color: day.weekday == 7 ? Colors.red[100] : null,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              DateFormat("EEEE, dd MMM").format(day),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isToday(day) ? Colors.blue : Colors.black,
              ),
            ),
          ),
          children: rooms.map((room) {
            final cellBookings =
                bookings.where((b) {
                  final date = DateTime.parse(b.tanggal);
                  return b.ruanganId == room.id &&
                      date.year == day.year &&
                      date.month == day.month &&
                      date.day == day.day;
                }).toList()..sort(
                  (a, b) => parseTime(
                    a.waktuMulai,
                  ).compareTo(parseTime(b.waktuMulai)),
                );

            if (cellBookings.isEmpty) return const SizedBox();

            return Container(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: cellBookings.map((booking) {
                  final start = parseTime(booking.waktuMulai);
                  final end = parseTime(booking.waktuSelesai);
                  final isLunch = start.hour < 13 && end.hour > 12;

                  return Card(
                    color: isLunch ? Colors.orange[200] : Colors.green[200],
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        "${room.kode} - ${room.lokasi}\n"
                        "${booking.kegiatan}\n"
                        "${booking.waktuMulai} - ${booking.waktuSelesai}\n"
                        "(${booking.nama})",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
