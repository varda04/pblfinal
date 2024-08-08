// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pblfinal/loginPage.dart';
import 'package:pblfinal/menuPage.dart';

mixin readyConnection {
  static bool isReady = false;
  static String? currentOrderNumber;
}

class Order {
  late String name;
  late int quantity;
  late int cost;

  Order(String n, int q, int c) {
    name = n;
    quantity = q;
    cost = c;
  }

  Map<String, dynamic> toJSON() => {
        'Item Name: ': name,
        'Quantity: ': quantity,
        'Cost: ': cost,
      };
}

class CartPage extends StatefulWidget with CartConnection, nameConnection, readyConnection {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with WidgetsBindingObserver {
  int totalCost = 0;
  List<Order> orders = [];
  String orderStatus = 'Place Order';
  

  @override
  void initState() {
    super.initState();
    calculatetotalCost();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        calculatetotalCost();
      });
    }
  }

  Map<String, dynamic> orderToJson() {
    return {
      'Student Name': nameConnection.userName,
      'Items': jsonEncode(orders.map((order) => order.toJSON()).toList()),
      'Total Cost': totalCost,
      'isReady': false,
    };
  }

  void placeOrder() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference orderCounterRef = db.collection('meta').doc('orderCounter');

      DateTime now = DateTime.now();
      String currentDate = now.toLocal().toString().split(' ')[0];

      DocumentSnapshot orderCounterDoc = await orderCounterRef.get();
      if (!orderCounterDoc.exists) {
        await orderCounterRef.set({
          'currentOrderNumber': 1,
          'lastResetDate': currentDate,
        });
      }

      int currentOrderNo = orderCounterDoc['currentOrderNumber'];
      String lastResetDate = orderCounterDoc['lastResetDate'];

      if (currentDate != lastResetDate) {
        await orderCounterRef.update({
          'currentOrderNumber': 1,
          'lastResetDate': currentDate,
        });
      }
      setState(() {
        readyConnection.currentOrderNumber = currentOrderNo.toString();
      });
      
      await db.collection("Orders").doc(readyConnection.currentOrderNumber).set(orderToJson());

      await orderCounterRef.update({
        'currentOrderNumber': FieldValue.increment(1),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );

      setState(() {});  
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $error')),
      );
    }
    setState(() {});  
  }

  void calculatetotalCost() {
    totalCost = 0;
    orders.clear();

    CartConnection.orders.forEach((key, value) {
      int itemCostOne = CartConnection.items[key] ?? 0;
      int itemCost = itemCostOne * value;
      totalCost += itemCost;
      orders.add(Order(key, value, itemCost));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        automaticallyImplyLeading: false,
      ),
      body: readyConnection.currentOrderNumber == null
          ? buildCartContent()
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('Orders').doc(readyConnection.currentOrderNumber).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("No order data available"));
                }

                var orderData = snapshot.data!.data() as Map<String, dynamic>;
                bool isReady = orderData['isReady'] ?? false;

                if (isReady) {
                  return ReadyOrderView(orderData: orderData);
                } else {
                  return PendingOrderView(orderData: orderData);
                }
              },
            ),
    );
  }

  Widget buildCartContent() {
    return CartConnection.orders.isNotEmpty
        ? Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('Total Cost: $totalCost',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: CartConnection.orders.length,
                  itemBuilder: (context, index) {
                    String itemName = CartConnection.orders.keys.elementAt(index);
                    int quantity = CartConnection.orders.values.elementAt(index);
                    int itemCostOne = CartConnection.items[itemName] ?? 0;
                    int itemCost = itemCostOne * quantity;

                    return ListTile(
                      title: Text(itemName),
                      subtitle: Row(
                        children: [
                          Text('Quantity: $quantity'),
                          const SizedBox(width: 10),
                          Text('Cost: $itemCost'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    placeOrder();
                  });
                },
                child: Text(
                  orderStatus,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          )
        : const Center(
            child: Text("Sorry, cart is currently empty"),
          );
  }
}

class ReadyOrderView extends StatelessWidget {
  final Map<String, dynamic> orderData;

  ReadyOrderView({required this.orderData});
  

  @override
  Widget build(BuildContext context) {
    int mon = orderData['Total Cost'] ?? 0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 100),
          
          SizedBox(height: 20),
          Text('Your order is ready for pickup!', style: TextStyle(fontSize: 24)),
          Text('Please pay ₹$mon at the counter', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

class PendingOrderView extends StatelessWidget {
  final Map<String, dynamic> orderData;

  PendingOrderView({required this.orderData});
  

  @override
  Widget build(BuildContext context) {
    String itemsJson = orderData['Items'] ?? '[]';
    List<dynamic> itemsList = jsonDecode(itemsJson);

    // Format the list of items into a string
    String itemsText = itemsList.map((item) {
      var itemName = item['Item Name: '];
      var quantity = item['Quantity: '];
      return '$itemName ($quantity)';
    }).join('\n');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer, color: Colors.yellow, size: 100),
          SizedBox(height: 20),
          Text('Your order is being prepared!', style: TextStyle(fontSize: 24)),
          Text('Items include: $itemsText', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
