import 'package:flutter/material.dart';

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

  _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus && _imageUrlCtrl.text.isNotEmpty) {
      setState(() {});
    }
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
        title: Text('Edit product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              autofocus: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
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
                      ? Text('Enter a URL')
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
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
