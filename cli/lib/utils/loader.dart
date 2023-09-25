import 'dart:async';
import 'dart:io';

Future<T> showLoader<T>(Future<T> future) async {
  final frames = ['-', '\\', '|', '/'];
  var currentFrame = 0;

  final timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
    stdout.write('\r${frames[currentFrame]}');
    currentFrame = (currentFrame + 1) % frames.length;
  });

  // Simulate a long-running task
  final result = await future;
  timer.cancel();
  stdout.writeln('\r ');
  return result;
}
