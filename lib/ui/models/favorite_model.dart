class FavoriteModel {
  String uid;
  int cantidad;
  String imagen;
  String nombre;
  String description;
  String color;
  String talla;
  String category;
  String valoration;
  double price;
  String id;

  FavoriteModel(
    this.uid,
    this.cantidad,
    this.imagen,
    this.nombre,
    this.description,
    this.color,
    this.talla,
    this.category,
    this.valoration,
    this.price,
    this.id,
  );

  static fromMap(Map<String, dynamic> item) {}
}
