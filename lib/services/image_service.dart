
import 'package:image_picker/image_picker.dart';

class ImageService {

  ImagePicker imagePicker = ImagePicker();

  captureImage(ImageSource? source) async {
    var pickedImage =  await imagePicker.pickImage(source: source!);
    return pickedImage;
  }
}