class dataPresensi {
  dataPresensi({
    required this.waktuMasuk,
    required this.waktuPulang,
    required this.ket,
    required this.tanggal,
    required this.status,
  });

  String waktuMasuk;
  String waktuPulang;
  String ket;
  String tanggal;
  String status;

  factory dataPresensi.fromJson(Map<String, dynamic> json) => dataPresensi(
        waktuMasuk: json["waktuMasuk"],
        waktuPulang: json["waktuPulang"],
        ket: json["Ket"],
        tanggal: json["Tanggal"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "waktuMasuk": waktuMasuk,
        "waktuPulang": waktuPulang,
        "Ket": ket,
        "Tanggal": "${tanggal}",
        "Status": status,
      };
}
