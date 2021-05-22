import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem({
    Key key,
    this.id,
    this.title,
    this.imageUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        leading: IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {},
        ),
        trailing: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.black45,
      ),
    );
  }
}
