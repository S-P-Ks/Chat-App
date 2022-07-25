import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageP extends StatefulWidget {
  ImageP({Key? key, required this.imagePicked}) : super(key: key);

  final void Function(File ImageP) imagePicked;

  @override
  State<ImageP> createState() => _ImagePState();
}

class _ImagePState extends State<ImageP> {
  File? image;

  Future<dynamic> getImage() async {
    final imagePicker = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 150,
      imageQuality: 50,
    );
    final img = File(imagePicker!.path);
    setState(() {
      image = img;
    });

    widget.imagePicked(img);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black54,
            backgroundImage: image != null ? FileImage(image!) : null,
          ),
          TextButton.icon(
              onPressed: () => getImage(),
              icon: const Icon(Icons.image),
              label: const Text("Add Image"))
        ],
      ),
    );
  }
}
