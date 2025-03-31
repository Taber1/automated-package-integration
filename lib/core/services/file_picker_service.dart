import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:heyflutter_assignment/core/helpers/ui_helpers.dart';
import 'package:path/path.dart' as path;

class FilePickerService {
  Future<String?> pickProjectDirectory() async {
    final directory = await FilePicker.platform.getDirectoryPath();
    if (directory != null) {
      final requiredFiles = [
        path.join(directory, 'pubspec.yaml'),
        path.join(directory, 'lib', 'main.dart'),
        path.join(
            directory, 'android', 'app', 'src', 'main', 'AndroidManifest.xml'),
        path.join(directory, 'ios', 'Runner', 'Info.plist'),
      ];

      for (final file in requiredFiles) {
        if (!File(file).existsSync()) {
          showSnackbar(
              message: "Selected folder is not a Flutter project directory.");
        } else {
          return directory;
        }
      }
    }
    return null;
  }
}
