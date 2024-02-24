// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/product.dart';
import '../colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {this.imageAspectRatio = 33 / 49, required this.product, Key? key})
      : assert(imageAspectRatio > 0),
        super(key: key);

  final double imageAspectRatio;
  final Product product;

  static const kTextBoxHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 0, locale: Localizations.localeOf(context).toString());
    final ThemeData theme = Theme.of(context);

    final imageWidget = Image.asset(
      product.assetName,
      package: product.assetPackage,
      fit: BoxFit.cover,
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: kShrinePink100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                aspectRatio: imageAspectRatio,
                child: imageWidget,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    product.name,
                    style: theme.textTheme.bodyText1!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            formatter.format(product.price),
            style: theme.textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
            child: Text('Beli'),
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      widget.product.assetName,
                      package: widget.product.assetPackage,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      widget.product.name,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Harga: \$${widget.product.price}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) {
                                quantity--;
                              }
                            });
                          },
                        ),
                        Text(
                          quantity.toString(),
                          style: TextStyle(fontSize: 20.0),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    // You can add more details about the product here
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implement your action here, for example adding to cart
                      // You can access the product data via `widget.product` and quantity via `quantity` variable
                    },
                    child: Text(
                      'Add Keranjang',
                      style: TextStyle(color: Colors.white), // Mengatur warna tulisan menjadi putih
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Mengatur warna tombol menjadi hitam
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final totalHarga = widget.product.price * quantity;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Text(
                                  'Total harga ${quantity} buah ${widget.product.name}: \$${totalHarga.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 30), // Spasi antara total harga dan pesan "Terima Kasih"
                                Text(
                                  'Terima Kasih!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      'Beli Sekarang',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
