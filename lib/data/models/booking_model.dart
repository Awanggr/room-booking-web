class BookingModel {
  final int id;
  final int ruanganId;
  final String nama;
  final String kegiatan;
  final int jumlahPeserta;
  final String tanggal;
  final String waktuMulai;
  final String waktuSelesai;

  BookingModel({
    required this.id,
    required this.ruanganId,
    required this.nama,
    required this.kegiatan,
    required this.jumlahPeserta,
    required this.tanggal,
    required this.waktuMulai,
    required this.waktuSelesai,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as int,
      ruanganId: json['ruanganId'] as int,
      nama: json['nama'] as String,
      kegiatan: json['kegiatan'] as String,
      jumlahPeserta: json['jumlah_peserta'] as int,
      tanggal: json['tanggal'] as String,
      waktuMulai: json['waktu_mulai'] as String,
      waktuSelesai: json['waktu_selesai'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ruanganId': ruanganId,
      'nama': nama,
      'kegiatan': kegiatan,
      'jumlah_peserta': jumlahPeserta,
      'tanggal': tanggal,
      'waktu_mulai': waktuMulai,
      'waktu_selesai': waktuSelesai,
    };
  }
}
