import 'package:flutter/material.dart';
import 'package:form_validation/src/models/product_model.dart';
import 'package:form_validation/src/providers/products_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productsProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _createList(),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.pushNamed(context, 'producto'));
  }

  Widget _createList() {
    return FutureBuilder(
      future: productsProvider.getProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) =>
                _createItem(products[index], context),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(ProductModel product, BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (direction) {
          productsProvider.deleteProduct(product.id);
        },
        child: Column(
          children: [
            (product.imageUrl == null)
                ? Image(image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                    image: NetworkImage(product.imageUrl),
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${product.title} - ${product.value}'),
              subtitle: Text(product.id),
              onTap: () =>
                  Navigator.pushNamed(context, 'producto', arguments: product)
                      .then((value) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {});
                });
              }),
            )
          ],
        ));
  }
}
