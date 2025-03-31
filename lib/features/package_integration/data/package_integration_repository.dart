import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:heyflutter_assignment/core/helpers/ui_helpers.dart';
import 'package:process_run/process_run.dart';
import 'package:yaml/yaml.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as path;

class PackageIntegrationRepository {
  Future<String?> pickProjectDirectory() async {
    final directory = await FilePicker.platform.getDirectoryPath();
    if (directory != null) {
      final pubspec = File(path.join(directory, 'pubspec.yaml'));
      if (pubspec.existsSync()) {
        return directory;
      } else {
        showToast(msg: "Selected folder is not a Flutter project directory.");
      }
    }
    return null;
  }

  Future<void> addPackage(String projectPath) async {
    final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
    final contents = await pubspecFile.readAsString();
    final yamlMap = loadYaml(contents) as YamlMap;

    if (!yamlMap['dependencies'].toString().contains('google_maps_flutter')) {
      final newContents = contents.replaceFirst(
        'dependencies:',
        'dependencies:\n  google_maps_flutter: ^2.2.0',
      );
      await pubspecFile.writeAsString(newContents);
    }

    // Run flutter pub get
    final shell = Shell(workingDirectory: projectPath);
    await shell.run('flutter pub get');
  }

  Future<void> configureAndroid(String projectPath, String apiKey) async {
    final manifestPath = path.join(
      projectPath,
      'android',
      'app',
      'src',
      'main',
      'AndroidManifest.xml',
    );

    final manifestFile = File(manifestPath);
    if (!manifestFile.existsSync()) return;

    final document = XmlDocument.parse(await manifestFile.readAsString());
    final applicationNode = document.findAllElements('application').first;

    // Add or update API key
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

    await manifestFile.writeAsString(document.toXmlString(pretty: true));
  }

  Future<void> configureIOS(String projectPath, String apiKey) async {
    final plistPath = path.join(
      projectPath,
      'ios',
      'Runner',
      'Info.plist',
    );

    final plistFile = File(plistPath);
    if (!plistFile.existsSync()) return;

    var plistContent = await plistFile.readAsString();

    if (!plistContent.contains('GMSApiKey')) {
      final keyInsertionPoint = plistContent.indexOf('<dict>') + 6;
      plistContent = plistContent.substring(0, keyInsertionPoint) +
          '''
  <key>GMSApiKey</key>
  <string>$apiKey</string>
''' +
          plistContent.substring(keyInsertionPoint);
    } else {
      final startIndex =
          plistContent.indexOf('<string>', plistContent.indexOf('GMSApiKey')) +
              8;
      final endIndex = plistContent.indexOf('</string>', startIndex);
      plistContent = plistContent.substring(0, startIndex) +
          apiKey +
          plistContent.substring(endIndex);
    }

    await plistFile.writeAsString(plistContent);
  }

  Future<void> addExampleCode(String projectPath) async {
    const demoCode = '''
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MapsDemo());

class MapsDemo extends StatefulWidget {
  const MapsDemo({super.key});

  @override
  State<MapsDemo> createState() => _MapsDemoState();
}

class _MapsDemoState extends State<MapsDemo> {
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Maps Demo'),
          centerTitle: true,
        ),
        body: const GoogleMap(
          initialCameraPosition: _initialPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }
}
''';

    final mainDartPath = path.join(projectPath, 'lib', 'main.dart');
    await File(mainDartPath).writeAsString(demoCode);

    // Verify code injection
    final content = await File(mainDartPath).readAsString();
    if (!content.contains('GoogleMap(')) {
      throw Exception('Failed to add demo map widget');
    }
  }

  Future<bool> testRunFlutterApp(String projectPath) async {
    final shell = Shell(workingDirectory: projectPath);

    try {
      // Run in debug mode with timeout
      final result = await shell
          .run(
            'flutter run --debug -d ${await _getFirstDeviceId()} --no-pub --no-track-widget-creation',
          )
          .timeout(const Duration(seconds: 30));

      // Check for successful launch
      final output = result.outText.toLowerCase();
      return output.contains('running') &&
          !output.contains('error') &&
          !output.contains('exception');
    } catch (e) {
      return false;
    }
  }

  Future<String> _getFirstDeviceId() async {
    final shell = Shell();
    final result = await shell.run('flutter devices');
    final lines = result.outText.split('\n');

    // Extract first available device ID
    for (final line in lines.skip(1)) {
      if (line.trim().isNotEmpty) {
        return line.split('•').first.trim();
      }
    }
    throw Exception('No devices found');
  }
}
