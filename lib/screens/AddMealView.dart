import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hello_world/utils/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMealView extends StatefulWidget {
  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMealView> {
  var name;
  var category_id = 1;
  var restaurant_id = 1;
  var price;
  var photo;

  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add new Meal'),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: _buildFormFields(),
          )
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 80.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                name = value;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
              onChanged: (value) {
                price = value;
              },
            ),
            OutlinedButton(onPressed: getImage, child: _buildImage()),
            SizedBox(
              height: 20.0,
            ),
            _buildSubmitButton(),
            SizedBox(
              height: 10.0,
            ),
            //_buildRegisterText(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _submit();
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      child: Text(
        'Submit',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Widget _buildRegisterText() {
  // return Text(
  //   'REGISTER',
  //   textAlign: TextAlign.center,
  //   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
  // );
  // }
  Widget _buildImage() {
    if (_image == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
        child: Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(File(_image.path));
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _submit() async {
    // setState(() {
    //   _isLoading = true;
    // });
    var data = new Map<String, String>();
    data['name'] = name;
    data['price'] = price;
    data['IdRestaurant'] = restaurant_id.toString();
    data['category_id'] = category_id.toString();
    data['image'] = _image.path;

    // var map = new Map<String, dynamic>();
    // map['email'] = email;
    // map['password'] = password;
    var response =
        await Network().postDataWithImage(data, '/meals', _image.path);

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      _showMsg('Error ${response.statusCode}');
    }

    // setState(() {
    //   _isLoading = false;
    // });
  }

  _showMsg(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    ));
  }
}
