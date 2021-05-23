import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/screens/orders_screen.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import 'providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Products();
        }),
        ChangeNotifierProvider(
          create: (context) {
            return Cart();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return Orders();
          },
        )
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) {
            return ProductDetailScreen();
          },
          CartScreen.routeName: (ctx) {
            return CartScreen();
          },
          OrdersScreen.routeName: (ctx) {
            return OrdersScreen();
          }
        },
      ),
    );
  }
}
