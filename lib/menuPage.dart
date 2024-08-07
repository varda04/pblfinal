import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pblfinal/uiHelper.dart';

mixin CartConnection {
  static Map<String, int> orders = {};

  static final Map<String,int> items = {
    "roll":2,
    "rice":3,
    "lemonade":5
  };
}

class MenuPage extends StatefulWidget with CartConnection {
  MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
//1st int- index number of item in _items, 2nd int- quantity ordered

  addItemToCart(String i) {
    if (CartConnection.orders.containsKey(i)) {
      //increment value of key
      CartConnection.orders[i] = (CartConnection.orders[i] ?? 0) + 1;
    } else {
      //creating new pair where key= index number in _items
      CartConnection.orders[i] = 1;
    }
    setState(() {});
  }
void delItemFromCart(String itemName) {
    setState(() {
      if (CartConnection.orders.containsKey(itemName)) {
        if (CartConnection.orders[itemName]! > 1) {
          // Decrement the quantity
          CartConnection.orders[itemName] = (CartConnection.orders[itemName] ?? 0) - 1;
        } else {
          // Remove the item if quantity is 1
          CartConnection.orders.remove(itemName);
        }
      } else {
        Fluttertoast.showToast(
          msg: "Item does not exist in cart :)",
          timeInSecForIosWeb: 2,
          webPosition: ToastGravity.BOTTOM,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: CartConnection.items.length,
        itemBuilder: (context, index) {
          String itemName = CartConnection.items.keys.toList()[index];
          int itemCostOne = CartConnection.items[itemName]!;
          int itemCount = CartConnection.orders[itemName] ?? 0;
          int itemCost = itemCostOne * itemCount;


          if(CartConnection.orders[itemName]!=0){
            final itemCount= CartConnection.orders[itemName];
          }
          else{
            final itemCount= 0;
          }

          itemCost= itemCostOne*itemCount;
          print(itemName);
          print(itemCount);
          print(itemCost);
          return SizedBox(
            child: Row(children: [
              UiHelper.MenuItemButtonpers(context, itemName,
                  itemCostOne),
              UiHelper.AddButton(() {
                addItemToCart(itemName);
                setState(() {
                  
                });
                //updateState to be called???
              },),
              UiHelper.DelButton(() {
                delItemFromCart(itemName);
                setState(() {
                  
                });
              }),
              Text(itemName),
              Text(itemCost.toString())
            ]),
          );
        },
      ),
    );
  }
  
  
}
