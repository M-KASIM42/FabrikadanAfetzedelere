
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductPage extends StatefulWidget {
  final String url;
  const ProductPage({super.key, required this.url});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white,child: Image.network(widget.url),);
  }
}