import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/splash_screen.dart';

import './providers/auth.dart';
import './providers/orders.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';

import './screens/product_detail_screen.dart';
//import './screens/products_overview_screen.dart';
import 'providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              return Auth();
            },
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) {
              return Products('', '', []);
            },
            update: (context, auth, previousProducts) => Products(
                auth.userId,
                auth.token,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider(
            create: (context) {
              return Cart();
            },
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) {
              return Orders('', '', []);
            },
            update: (context, auth, Orders previousOrders) => Orders(
                auth.userId,
                auth.token,
                previousOrders == null ? [] : previousOrders.orders),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                    future: auth.tryAutoLogin(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) {
                return ProductDetailScreen();
              },
              CartScreen.routeName: (ctx) {
                return CartScreen();
              },
              OrdersScreen.routeName: (ctx) {
                return OrdersScreen();
              },
              UserProductScreen.routeName: (ctx) {
                return UserProductScreen();
              },
              EditProductScreen.routeName: (ctx) {
                return EditProductScreen();
              },
            },
          ),
        ));
  }
}
