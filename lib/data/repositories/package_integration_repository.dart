import 'dart:async';
import '../../core/services/android_configurator.dart';
import '../../core/services/file_picker_service.dart';
import '../../core/services/file_service.dart';
import '../../core/services/ios_configurator.dart';
import '../../core/services/process_service.dart';
import '../../core/services/web_configurator.dart';

class PackageIntegrationRepository {
  final FilePickerService _filePickerService;
  final ProcessService _processService;
  final FileService _fileService;
  final AndroidConfigurator _androidConfigurator;
  final IOSConfigurator _iosConfigurator;
  final WebConfigurator _webConfigurator;

  PackageIntegrationRepository({
    FilePickerService? filePickerService,
    ProcessService? processService,
    FileService? fileService,
    AndroidConfigurator? androidConfigurator,
    IOSConfigurator? iosConfigurator,
    WebConfigurator? webConfigurator,
  })  : _filePickerService = filePickerService ?? FilePickerService(),
        _processService = processService ?? ProcessService(),
        _fileService = fileService ?? FileService(),
        _androidConfigurator = androidConfigurator ?? AndroidConfigurator(),
        _iosConfigurator = iosConfigurator ?? IOSConfigurator(),
        _webConfigurator = webConfigurator ?? WebConfigurator();

  Future<String?> pickProjectDirectory() async {
    return _filePickerService.pickProjectDirectory();
  }

  Future<void> addPackage(String projectPath) async {
    await _fileService.addPackageToPubspec(projectPath);
    await _processService.runFlutterPubGet(projectPath);
  }

  Future<void> configureAndroid(String projectPath, String apiKey) async {
    await _androidConfigurator.configure(projectPath, apiKey);
  }

  Future<void> configureIOS(String projectPath, String apiKey) async {
    await _iosConfigurator.configure(projectPath, apiKey);
  }

  Future<void> configureWeb(String projectPath, String apiKey) async {
    await _webConfigurator.configure(projectPath, apiKey);
  }

  Future<void> addExampleCode(String projectPath) async {
    await _fileService.addExampleCode(projectPath);
  }

  Future<bool> testRunOnWeb(String projectPath) async {
    return _processService.testRunOnWeb(projectPath);
  }
}
