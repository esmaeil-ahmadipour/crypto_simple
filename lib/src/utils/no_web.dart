import 'dart:io' show Platform;

bool resetSingletonObjectLock() {
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    return false;
  }
  return true;
}
