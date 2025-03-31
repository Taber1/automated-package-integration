import 'package:path/path.dart' as path;
import '../services/file_service.dart';

class IOSConfigurator {
  final FileService _fileService;

  IOSConfigurator({FileService? fileService})
      : _fileService = fileService ?? FileService();

  Future<void> configure(String projectPath, String apiKey) async {
    final plistPath = path.join(projectPath, 'ios', 'Runner', 'Info.plist');
    final plistContent = await _fileService.readFile(plistPath);
    if (plistContent == null) return;

    String updatedContent;
    if (!plistContent.contains('GMSApiKey')) {
      final keyInsertionPoint = plistContent.indexOf('<dict>') + 6;
      updatedContent =
          '''${plistContent.substring(0, keyInsertionPoint)}  <key>GMSApiKey</key>
  <string>$apiKey</string>
${plistContent.substring(keyInsertionPoint)}''';
    } else {
      final startIndex =
          plistContent.indexOf('<string>', plistContent.indexOf('GMSApiKey')) +
              8;
      final endIndex = plistContent.indexOf('</string>', startIndex);
      updatedContent = plistContent.substring(0, startIndex) +
          apiKey +
          plistContent.substring(endIndex);
    }

    await _fileService.writeFile(plistPath, updatedContent);
  }
}
