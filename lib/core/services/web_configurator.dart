import 'package:path/path.dart' as path;
import '../services/file_service.dart';
import '../services/process_service.dart';

class WebConfigurator {
  final FileService _fileService;
  final ProcessService _processService;

  WebConfigurator({
    FileService? fileService,
    ProcessService? processService,
  })  : _fileService = fileService ?? FileService(),
        _processService = processService ?? ProcessService();

  Future<void> configure(String projectPath, String apiKey) async {
    await _enableWebSupport(projectPath);
    await _addApiKeyToWeb(projectPath, apiKey);
  }

  Future<void> _enableWebSupport(String projectPath) async {
    if (!await _fileService.directoryExists(path.join(projectPath, 'web'))) {
      await _processService.runFlutterCreateWeb(projectPath);
    }
  }

  Future<void> _addApiKeyToWeb(String projectPath, String apiKey) async {
    final indexFilePath = path.join(projectPath, 'web', 'index.html');
    final content = await _fileService.readFile(indexFilePath);
    if (content == null) return;

    if (!content.contains('maps.googleapis.com')) {
      final apiKeyScript = '''
  <script src="https://maps.googleapis.com/maps/api/js?key=$apiKey"></script>
  ''';
      final newContent =
          content.replaceFirst('</head>', '$apiKeyScript</head>');
      await _fileService.writeFile(indexFilePath, newContent);
    }
  }
}
