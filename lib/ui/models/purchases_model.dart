class PurchasesModel {
  String uid;
  String idUser;
  String idpedido;
  int cantidad;
  String imagen;
  String nombre;
  String description;
  String color;
  String talla;
  String category;
  String valoration;
  int price;

  PurchasesModel(
    this.uid,
    this.idUser,
    this.idpedido,
    this.cantidad,
    this.imagen,
    this.nombre,
    this.description,
    this.color,
    this.talla,
    this.category,
    this.valoration,
    this.price,
  );

  static fromMap(Map<String, dynamic> item) {}
}
