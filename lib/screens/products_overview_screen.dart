import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
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
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    //Future.delayed(Duration.zero).then((_) {
    //  Provider.of<Products>(context).fetchProducts();
    //});

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
          ),
          Consumer<Cart>(
            builder: (context, cart, ch) {
              return Badge(child: ch, value: cart.itemCount.toString());
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavourites),
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
