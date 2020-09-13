import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/products_bloc.dart';
import 'package:form_validation/src/bloc/provider.dart';

import 'package:form_validation/src/models/product_model.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductsBloc productsBloc;
  ProductModel product = new ProductModel();
  bool _saving = false;
  File _photo;

  @override
  Widget build(BuildContext context) {
    productsBloc = Provider.productsBloc(context);
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      product = prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.photo_size_select_actual,
                color: Colors.white,
              ),
              onPressed: _selectPhoto),
          IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              onPressed: _takePicture),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _showImage(),
                _createName(),
                _createPrice(),
                _createAvailable(),
                _createButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => product.title = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingresa el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => product.value = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo se aceptan números';
        }
      },
    );
  }

  Widget _createAvailable() {
    return SwitchListTile(
        value: product.available,
        title: Text('Disponible'),
        activeColor: Colors.deepPurple,
        onChanged: (value) => setState(() {
              product.available = value;
            }));
  }

  Widget _createButton(BuildContext context) {
    return RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        label: Text('Guardar'),
        icon: Icon(Icons.save),
        onPressed: (_saving) ? null : _submit);
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _saving = true;
    });
    if (_photo != null) {
      product.imageUrl = await productsBloc.uploadImage(_photo);
    }
    if (product.id == null) {
      productsBloc.createProduct(product);
    } else {
      productsBloc.updateProduct(product);
    }

    showSnackbar('Registro guardado');
    Navigator.pop(context);
  }

  void showSnackbar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _showImage() {
    if (product.imageUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(product.imageUrl),
        fit: BoxFit.contain,
      );
    } else {
      if (_photo != null) {
        return Image.file(
          _photo,
          fit: BoxFit.cover,
          height: 300.0,
        );
      } else {
        return Image.asset('assets/no-image.png');
      }
    }
  }

  _selectPhoto() async {
    _processImage(ImageSource.gallery);
  }

  _takePicture() async {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource origin) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: origin);
    setState(() {
      _photo = File(pickedFile.path);
    });
    if (_photo != null) {
      product.imageUrl = null;
    }
  }
}
