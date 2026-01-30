import 'package:shopease/models/cart_item.dart';
import 'package:shopease/models/product.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items
          .map(
            (item) => {
              'productId': item.product.id,
              'productName': item.product.name,
              'productImage': item.product.imageUrl,
              'price': item.product.price,
              'quantity': item.quantity,
              'categoryId': item
                  .product
                  .categoryId, // Saving basic category info just in case
              'description': item.product.description,
            },
          )
          .toList(),
      'total': total,
      'date': date.toIso8601String(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List).map((i) {
        return CartItem(
          product: Product(
            id: i['productId'],
            name: i['productName'],
            imageUrl: i['productImage'],
            price: (i['price'] as num).toDouble(),
            description: i['description'] ?? '',
            categoryId: i['categoryId'] ?? '',
            isFeatured: false, // Default
          ),
          quantity: i['quantity'],
        );
      }).toList(),
      total: (json['total'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}
