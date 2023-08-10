class ProductModel {
  final id;
  int cantidad;
  String catalogo;
  String modelo;
  String title;
  String color;
  String talla;
  String category;
  String description;
  String valoration;
  int price;

  ProductModel({
    this.id,
    required this.cantidad,
    required this.catalogo,
    required this.modelo,
    required this.title,
    required this.color,
    required this.talla,
    required this.category,
    required this.description,
    required this.valoration,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      cantidad: json['cantidad'],
      catalogo: json['catalogo'],
      modelo: json['modelo'],
      title: json['nombre'],
      color: json['color'],
      talla: json['talla'],
      category: json['categoria'],
      description: json['descripcion'],
      valoration: json['valoracion'],
      price: json['precio'],
    );
  }

  List<Map<String, dynamic>> toJson(ProductModel productModel) {
    return [
      {
        'id': productModel.id,
        'cantidad': productModel.cantidad,
        'catalogo': productModel.catalogo,
        'modelo': productModel.modelo,
        'nombre': productModel.title,
        'color': productModel.color,
        'talla': productModel.talla,
        'categoria': productModel.category,
        'descripcion': productModel.description,
        'valoracion': productModel.valoration,
        'precio': productModel.price,
      }
    ];
  }

  getProducts() {
    return [
      {
        'id': id,
        'cantidad': cantidad,
        'catalogo': catalogo,
        'modelo': modelo,
        'title': title,
        'color': color,
        'talla': talla,
        'category': category,
        'description': description,
        'valoration': valoration,
        'price': price,
      }
    ];
  }
}
