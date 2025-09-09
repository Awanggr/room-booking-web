class RoomModel {
  final int id;
  final String kode;
  final String lokasi;
  final int jumlahKursi;

  RoomModel({
    required this.id,
    required this.kode,
    required this.lokasi,
    required this.jumlahKursi,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as int,
      kode: json['kode'] as String,
      lokasi: json['lokasi'] as String,
      jumlahKursi: json['jumlah_kursi'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode': kode,
      'lokasi': lokasi,
      'jumlah_kursi': jumlahKursi,
    };
  }
}
