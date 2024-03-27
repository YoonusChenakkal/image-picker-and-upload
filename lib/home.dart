import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  File? _image;
  String? _imageUrl ;

  uploadImage()async {
    FirebaseStorage storage = FirebaseStorage.instance;
     Reference storageReference = storage.ref().child('images/${DateTime.now()}.png');
     UploadTask uploadTask = storageReference.putFile(_image!);
     TaskSnapshot snapshot = await uploadTask;
     String imageUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      _imageUrl =imageUrl;
    });
  }

  getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
        
          children: [
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!, height: 200),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed:  () => uploadImage(), child: Text('Upload')),
            _imageUrl !=null ? Image.network(_imageUrl!,height: 200,): SizedBox()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
