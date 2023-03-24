import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.name,
    required this.imageUrl,
    required this.quantity,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [
    CartItem(name: 'Product 1', imageUrl: 'url', quantity: 2),
    CartItem(name: 'Product 2', imageUrl: 'url', quantity: 1),
  ];

  void incrementQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      } else {
        cartItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.network(cartItems[index].imageUrl),
            title: Text(cartItems[index].name),
            subtitle: Row(
              children: [
                IconButton(
                  onPressed: () => decrementQuantity(index),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(cartItems[index].quantity.toString()),
                IconButton(
                  onPressed: () => incrementQuantity(index),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () => setState(() {
                cartItems.removeAt(index);
              }),
              icon: const Icon(Icons.delete),
            ),
          );
        },
      ),
    );
  }
}
