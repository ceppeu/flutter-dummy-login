import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/models/product_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final productsBloc = Provider.productsBloc(context);
    productsBloc.getProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _createList(productsBloc),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.pushNamed(context, 'producto'));
  }

  Widget _createList(ProductsBloc productsBloc) {
    return StreamBuilder(
      stream: productsBloc.productsStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) =>
                _createItem(products[index], context, productsBloc),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(
      ProductModel product, BuildContext context, ProductsBloc productsBloc) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (direction) {
          productsBloc.deleteProduct(product.id);
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
