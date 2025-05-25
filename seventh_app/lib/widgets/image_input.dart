import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

// Cameraで写真をInputするWidget
class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    // Cameraで写真を撮影する処理 (カメラを起動)
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    // 写真を取らずにカメラを終了した場合
    if (pickedImage == null) {
      return;
    }

    // 写真を撮った場合は、.pathで保存された画像のパスにアクセスが可能
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    // コンストラクタで受け取ったsuper classの関数でsuper classに値を渡す
    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      label: Text('Take Picture'),
      icon: Icon(Icons.camera),
    );

    if (_selectedImage != null) {
      // GestureDetectorで、画像タップ時の処理を追加可能
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
