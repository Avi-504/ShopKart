import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/auth.dart';
import '../providers/products.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    this.productId,
    this.id,
    this.price,
    this.quantity,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final cartProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    final authData = Provider.of<Auth>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
      ),
      // direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                'Are you Sure?',
              ),
              content: Text(
                'Do you want to remove item from cart?',
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text(
                    'No',
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text(
                    'Yes',
                  ),
                ),
              ],
            ),
          );
        } else {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                'Are you Sure?',
              ),
              content: Text(
                'Do you want to Favorite this product?',
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text(
                    'No',
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text(
                    'Yes',
                  ),
                ),
              ],
            ),
          );
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          Provider.of<Cart>(
            context,
            listen: false,
          ).removeItem(productId);
        } else {
          cartProduct.toggleFavoriteStatus(authData.token, authData.userId);
          Provider.of<Cart>(
            context,
            listen: false,
          ).removeItem(productId);
        }
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(
            10,
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(
                  4,
                ),
                child: FittedBox(
                  child: Text(
                    '₹ ${(price * quantity)}',
                  ),
                ),
              ),
            ),
            title: Text(
              title,
            ),
            subtitle: Text(
              '₹ $price',
            ),
            trailing: Text(
              'x $quantity',
            ),
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
      ),
    );
  }
}
