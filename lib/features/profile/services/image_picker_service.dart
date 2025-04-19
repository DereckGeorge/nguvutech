import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  // Show an image picker bottom sheet and return the selected image path
  static Future<String?> pickImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();

      // Show a bottom sheet with options
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          );
        },
      );

      // User canceled the selection
      if (source == null) return null;

      // Pick the image
      final XFile? image = await picker.pickImage(source: source);

      // Return the image path if an image was selected
      return image?.path;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
      }
      return null;
    }
  }
}
