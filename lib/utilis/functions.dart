import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showMySnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

 navigateScreen(BuildContext context, Widget screen){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> screen));
}
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source, imageQuality: 50);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}
