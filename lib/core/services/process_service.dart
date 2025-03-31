import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:process_run/process_run.dart';

class ProcessService {
  Future<void> runFlutterPubGet(String projectPath) async {
    final shell = Shell(workingDirectory: projectPath);
    await shell.run('flutter pub get');
  }

  Future<void> runFlutterCreateWeb(String projectPath) async {
    final shell = Shell(workingDirectory: projectPath);
    await shell.run('flutter create --platforms web .');
  }

  Future<bool> testRunOnWeb(String projectPath) async {
    try {
      final process = await Process.start(
        Platform.isWindows ? 'flutter.bat' : 'flutter',
        ['run', '-d', 'chrome', '--web-renderer', 'canvaskit', '--release'],
        workingDirectory: projectPath,
      );

      final completer = Completer<bool>();
      bool buildSuccess = false;

      process.stdout.transform(utf8.decoder).listen((output) {
        if (output.contains('√ Built') || output.contains('Succeeded')) {
          buildSuccess = true;
          completer.complete(true);
        }
        if (output.contains('Application running')) {
          if (!completer.isCompleted) completer.complete(true);
        }
      });

      process.stderr.transform(utf8.decoder).listen((error) {
        if (error.contains('HTML Renderer is deprecated')) return;
        if (!completer.isCompleted) completer.complete(false);
      });

      process.exitCode.then((code) {
        if (!completer.isCompleted) {
          final success = buildSuccess || code == 0;
          completer.complete(success);
        }
      });

      return await completer.future;
    } catch (e) {
      return false;
    }
  }
}
