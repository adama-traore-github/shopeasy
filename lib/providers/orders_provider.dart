import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopease/models/cart_item.dart';
import 'package:shopease/models/order.dart';
import 'package:uuid/uuid.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  OrdersProvider() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('orders')) return;

    final String? ordersData = prefs.getString('orders');
    if (ordersData == null) return;

    try {
      final List<dynamic> extractedData = json.decode(ordersData);
      _orders = extractedData.map((json) => Order.fromJson(json)).toList();

      // Sort by date descending (newest first)
      _orders.sort((a, b) => b.date.compareTo(a.date));

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading orders: $e');
    }
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final newOrder = Order(
      id: const Uuid().v4(),
      items: cartItems,
      total: total,
      date: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    notifyListeners();
    _saveOrders();
  }

  Future<void> removeOrder(String id) async {
    _orders.removeWhere((order) => order.id == id);
    notifyListeners();
    _saveOrders();
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _orders.map((order) => order.toJson()).toList(),
    );
    await prefs.setString('orders', encodedData);
  }
}
