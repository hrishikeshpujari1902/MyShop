import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/orders.dart' as pro;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final pro.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: _expanded
          ? min(widget.order.products.length * 20.0 + 120, 200) + 95
          : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('Rs.${widget.order.amount}'),
              subtitle: Text(DateFormat.yMMMd().format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 30, 100)
                  : 0,
              duration: Duration(
                milliseconds: 300,
              ),
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (context, index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.order.products[index].title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.order.products[index].quantity}x Rs.${widget.order.products[index].price}',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        )
                      ]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
