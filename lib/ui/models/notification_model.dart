class NotificationModel {
  final uid;
  String idUser;
  String titulo;
  String descripcion;
  String tiempoEntrega;
  String fecha;
  String hora;
  String estado;

  NotificationModel(
      {this.uid,
      required this.idUser,
      required this.titulo,
      required this.descripcion,
      required this.tiempoEntrega,
      required this.fecha,
      required this.hora,
      required this.estado});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      uid: json['uid'],
      idUser: json['idUser'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      tiempoEntrega: json['tiempoEntrega'],
      fecha: json['fecha'],
      hora: json['hora'],
      estado: json['estado'],
    );
  }
}
