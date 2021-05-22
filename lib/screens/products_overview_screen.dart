import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.Favourites) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text(
                    'Only Favourites',
                    style: TextStyle(
                        color:
                            _showOnlyFavourites ? Colors.purple : Colors.black),
                  ),
                  value: FilterOptions.Favourites,
                ),
                PopupMenuItem(
                  child: Text(
                    'Show All',
                    style: TextStyle(
                        color:
                            _showOnlyFavourites ? Colors.black : Colors.purple),
                  ),
                  value: FilterOptions.All,
                ),
              ];
            },
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavourites),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavs;
  ProductsGrid(this.showOnlyFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showOnlyFavs ? productsData.foavouriteList : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],

          //create: (BuildContext context) {
          //  return products[index];
          //},
          child: ProductItem(
              //id: products[index].id,
              //title: products[index].title,
              //imageUrl: products[index].imageUrl,
              ),
        );
      },
      itemCount: products.length,
    );
  }
}
