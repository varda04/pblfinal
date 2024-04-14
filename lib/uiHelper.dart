import 'package:flutter/material.dart';

class UiHelper {
  static CustomTextField(TextEditingController controller, String text,
      IconData iconData, bool toHide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextField(
        controller: controller,
        obscureText: toHide,
        decoration: InputDecoration(
          hintText: text,
          suffixIcon: Icon(iconData),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        ),
      ),
    );
  }

  static CustomButton(VoidCallback voidCallback, String text) {
    return SizedBox(
      height: 50,
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          voidCallback();
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }

  static CustomAlertBox(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(text),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }

  static MenuItemButtonpers(BuildContext context, String itemName, int cost) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        children: [
          Column(
            children: [Text(itemName), Text(cost.toString())],
          ),
          //add +button here??
          //or on menupage so addtocart functionality can directly be called
        ],
      ),
    );
  }

  static AddButton(VoidCallback voidCallback) {
    return SizedBox(
      height: 48,
      width: 48,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero, // Remove padding to center the icon
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24), // Round button shape
            ),
          ),
          onPressed: () {
            voidCallback();
          },
          child: const Center(
            child: Icon(Icons.add),
          )),
    );
  }

  static DelButton(VoidCallback voidCallback) {
    return SizedBox(
      height: 48,
      width: 48,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero, // Remove padding to center the icon
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24), // Round button shape
            ),
          ),
          onPressed: () {
            voidCallback();
          },
          child: const Center(
            child: Icon(Icons.delete),
          )),
    );
  }

  static CartItems(BuildContext context, String itemName, int quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        children: [
          Column(
            children: [Text(itemName), Text(quantity.toString())],
          ),
        ],
      ),
    );
  }
}
