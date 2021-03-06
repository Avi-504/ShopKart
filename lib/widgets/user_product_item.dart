import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final double price;
  final String imgUrl;
  final String id;

  UserProductItem({
    this.title,
    this.imgUrl,
    this.price,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(
          title,
        ),
        subtitle: Text('₹ $price'),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            imgUrl,
          ),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.mode_edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                color: Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Deleted',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } catch (error) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Deletion Failed',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
