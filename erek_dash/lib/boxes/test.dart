import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../globals.dart';

class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File? _image;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  Future<void> _saveImage() async {
    if (_image != null) {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String path = await GlobalValues.imageFolderPath;
      final newImagePath = '$path/$fileName.jpg';

      await _image!.copy(newImagePath);
      // You can now use the newImagePath to access the copied image file.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image != null
            ? Image.file(
                _image!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
            : Text('No Image Selected'),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _pickImage,
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _saveImage,
            tooltip: 'Save Image',
            child: Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
