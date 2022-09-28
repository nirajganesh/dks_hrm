import 'dart:io';

import 'package:image_picker/image_picker.dart';
class Image_pick
{
  static Future pick() async
  {
    File? file;
    final my_file=(await ImagePicker().pickImage(source: ImageSource.gallery));
    file=File(my_file!.path);
    return file;
  }
}