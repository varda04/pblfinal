// import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pblfinal/loginPage.dart';
import 'package:pblfinal/menuPage.dart';

class Order{
  late String name;
  late int quantity;
  late int cost;

  Order(String n, int q, int c){
    name=n;
    quantity=q;
    cost=c;

  }

  Map<String, dynamic> toJSON()=>{
    'Item Name: ': name,
    'Quantity: ': quantity,
    'Cost: ': cost
  };
}

class CartPage extends StatefulWidget with CartConnection,nameConnection{
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}



class _CartPageState extends State<CartPage> with WidgetsBindingObserver {
  int totalCost = 0;
  List<Order> orders= [];
  String orderstatus= 'Place Order';
  @override
  void initState() {
    super.initState();
    // Add this widget as an observer of the app lifecycle
    calculatetotalCost();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    // Remove this widget as an observer of the app lifecycle
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Check if the app came into the foreground
    if (state == AppLifecycleState.resumed) {
      // Call setState to update the UI when the page becomes visible
      setState(() {
        calculatetotalCost();
        // Update any state variables or call any methods here
      });
    }
  }

  Map<String, dynamic> orderToJson() {
    return {
      'Student Name': widget.userName,
      'Items': jsonEncode(orders.map((order) => order.toJSON()).toList()),
      'Total Cost': totalCost,
      'isReady': 0,
    };
  }

void placeOrder() async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference orderCounterRef = db.collection('meta').doc('orderCounter');
    
    // Get the current date
    DateTime now = DateTime.now();
    String currentDate = now.toLocal().toString().split(' ')[0]; // Format: YYYY-MM-DD

    // Retrieve the current order number and last reset date from Firestore
    DocumentSnapshot orderCounterDoc = await orderCounterRef.get();
    if (!orderCounterDoc.exists) {
      // Create document if it does not exist
      await orderCounterRef.set({
        'currentOrderNumber': 1,
        'lastResetDate': currentDate,
      });
    }

    int currentOrderNumber = orderCounterDoc['currentOrderNumber'];
    String lastResetDate = orderCounterDoc['lastResetDate'];

    // Check if we need to reset the order number
    if (currentDate != lastResetDate) {
      // Reset the order number and update the last reset date
      await orderCounterRef.update({
        'currentOrderNumber': 1,
        'lastResetDate': currentDate,
      });
    }

    // Place the order with the current order number
    await db.collection("Orders").doc(currentOrderNumber.toString()).set(orderToJson());

    // Increment the order number for the next order
    await orderCounterRef.update({
      'currentOrderNumber': FieldValue.increment(1),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully!')),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to place order: $error')),
    );
  }
}



  
  void calculatetotalCost() {
    totalCost = 0;
    orders.clear(); // Clear previous orders

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
      body: CartConnection.orders.isNotEmpty
          ? Column(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('Total Cost: $totalCost',
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: CartConnection.orders.length,
                    itemBuilder: (context, index) {
                      String itemName =
                          CartConnection.orders.keys.elementAt(index);
                      int quantity =
                          CartConnection.orders.values.elementAt(index);
                      int itemCostOne = CartConnection.items[itemName] ?? 0;
                      int itemCost = itemCostOne * quantity;
                      // totalCost+=itemCost;

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
                      placeOrder();
                    },
                    child: Text(
                      orderstatus,
                      style: TextStyle(fontSize: 10),
                    ))
              ],
            )
          : const Center(
              child: Text("Sorry, cart is currently empty"),
            ),
    );
  }

}
