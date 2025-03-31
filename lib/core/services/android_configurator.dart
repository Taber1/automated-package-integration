import 'package:xml/xml.dart';
import 'package:path/path.dart' as path;
import '../services/file_service.dart';

class AndroidConfigurator {
  final FileService _fileService;

  AndroidConfigurator({FileService? fileService})
      : _fileService = fileService ?? FileService();

  Future<void> configure(String projectPath, String apiKey) async {
    final manifestPath = path.join(
      projectPath,
      'android',
      'app',
      'src',
      'main',
      'AndroidManifest.xml',
    );

    final manifestContent = await _fileService.readFile(manifestPath);
    if (manifestContent == null) return;

    final document = XmlDocument.parse(manifestContent);
    final applicationNode = document.findAllElements('application').first;

    var existingMetaData = applicationNode.findElements('meta-data').where(
          (element) =>
              element.getAttribute('android:name') ==
              'com.google.android.geo.API_KEY',
        );

    if (existingMetaData.isNotEmpty) {
      existingMetaData.first.setAttribute('android:value', apiKey);
    } else {
      applicationNode.children.add(XmlElement(
        XmlName('meta-data'),
        [
          XmlAttribute(
              XmlName('android:name'), 'com.google.android.geo.API_KEY'),
          XmlAttribute(XmlName('android:value'), apiKey),
        ],
      ));
    }

    await _fileService.writeFile(
      manifestPath,
      document.toXmlString(pretty: true),
    );
  }
}
