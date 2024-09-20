import 'no_web.dart' if (dart.library.html) 'web.dart' as switch_value;

/// [MultiPlatforms] class help to using the 'dart:io' and any files have running problem in web/native environments.
class MultiPlatforms {
  static bool resetSingletonObjectLock() {
    return switch_value.resetSingletonObjectLock();
  }
}
