class ProductModel {
  String id;
  int cantidad;
  String catalogo;
  String modelo;
  String title;
  String color;
  String talla;
  String category;
  String description;
  String valoration;
  String price;

  ProductModel(
    this.id,
    this.cantidad,
    this.catalogo,
    this.modelo,
    this.title,
    this.color,
    this.talla,
    this.category,
    this.description,
    this.valoration,
    this.price,
  );

  static fromMap(Map<String, dynamic> item) {}
}
