import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

class FileService {
  Future<void> addPackageToPubspec(String projectPath) async {
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

    final content = await File(mainDartPath).readAsString();
    if (!content.contains('GoogleMap(')) {
      throw Exception('Failed to add demo map widget');
    }
  }

  Future<String?> readFile(String path) async {
    final file = File(path);
    if (!file.existsSync()) return null;
    return await file.readAsString();
  }

  Future<void> writeFile(String path, String content) async {
    await File(path).writeAsString(content);
  }

  Future<bool> directoryExists(String path) async {
    return Directory(path).existsSync();
  }
}
