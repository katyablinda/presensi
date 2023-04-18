class CekRespon {
  CekRespon({
    required this.status,
    required this.message,
    this.data,
  });

  int status;
  String message;
  dynamic data;

  factory CekRespon.fromJson(Map<String, dynamic> json) => CekRespon(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}
