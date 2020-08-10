import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

final RegExp _urlRegex = RegExp(r'^https?:\/\/[\w.\/?=&_%#-]*');

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit/product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlCtrl = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product.empty();
  var _isInitialized = false;
  var _isLoading = false;

  _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus &&
        _urlRegex.hasMatch(_imageUrlCtrl.text)) {
      setState(() {});
    }
  }

  _saveForm() async {
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id == null) {
      await context.read<Products>().addProduct(Product.from(_editedProduct));
    } else {
      context.read<Products>().updateProduct(_editedProduct);
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (!_isInitialized) {
      var product = ModalRoute.of(context).settings.arguments as Product;

      if (product != null) {
        _editedProduct = product;
        _imageUrlCtrl.text = product.imageUrl;
      }
    }
    _isInitialized = true;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editedProduct.id != null
            ? const Text('Edit product')
            : const Text('Create product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                autovalidate: true,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      initialValue: _editedProduct.title,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Please provide a title.';
                        if (value.length < 4) return 'Title is too short.';
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _editedProduct = _editedProduct.copyWith(
                            title: value,
                          );
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      initialValue: _editedProduct.price?.toString(),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Please provide a price.';

                        final number =
                            int.tryParse(value) ?? double.tryParse(value);

                        if (number == null) return 'Price should be a number.';
                        if (number <= 0)
                          return 'Price should be greater than zero.';
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _editedProduct = _editedProduct.copyWith(
                            price: double.parse(value),
                          );
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      initialValue: _editedProduct.description,
                      validator: (value) {
                        if (value.isEmpty || value.trim().isEmpty)
                          return 'Please provide a description.';
                        if (value.length < 10)
                          return 'Description should be at least 10 characters long.';
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _editedProduct = _editedProduct.copyWith(
                            description: value,
                          );
                        });
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlCtrl.text.isEmpty
                              ? Center(child: Text('Enter a URL'))
                              : FittedBox(
                                  child: Image.network(_imageUrlCtrl.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlCtrl,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please provide a image URL';
                              if (!_urlRegex.hasMatch(value))
                                return 'Please enter a valid URL.';
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _editedProduct = _editedProduct.copyWith(
                                  imageUrl: value,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
