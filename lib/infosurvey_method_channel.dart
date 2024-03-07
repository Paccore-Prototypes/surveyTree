import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'infosurvey_platform_interface.dart';

/// An implementation of [InfosurveyPlatform] that uses method channels.
class MethodChannelInfosurvey extends InfosurveyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('infosurvey');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
