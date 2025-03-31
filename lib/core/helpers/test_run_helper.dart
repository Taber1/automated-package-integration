import 'dart:io';
import 'package:process_run/process_run.dart';

Future<void> setupVirtualDisplay() async {
  if (Platform.isLinux) {
    final shell = Shell();
    await shell.run('''
      sudo apt-get install -y xvfb
      Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
      export DISPLAY=:99
    ''');
  }
}
