// import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pblfinal/menuPage.dart';

class CartPage extends StatefulWidget with CartConnection {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with WidgetsBindingObserver {
  int totalCost = 0;
  String orderstatus= 'Place Order';
  @override
  void initState() {
    super.initState();
    // Add this widget as an observer of the app lifecycle
    calculatetotalcost();
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
        calculatetotalcost();
        // Update any state variables or call any methods here
      });
    }
  }

  void placeOrder(){
    DatabaseReference db= FirebaseDatabase.instance.ref().child('order');
    db.push().set({
      'value': '234',
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

  void calculatetotalcost() {
    totalCost = 0;
    CartConnection.orders.forEach((key, value) {
      int itemCostOne = CartConnection.items[key] ?? 0;
      int itemCost = itemCostOne * value;
      totalCost += itemCost;
    });
  }
}
