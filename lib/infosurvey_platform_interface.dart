import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'infosurvey_method_channel.dart';

abstract class InfosurveyPlatform extends PlatformInterface {
  /// Constructs a InfosurveyPlatform.
  InfosurveyPlatform() : super(token: _token);

  static final Object _token = Object();

  static InfosurveyPlatform _instance = MethodChannelInfosurvey();

  /// The default instance of [InfosurveyPlatform] to use.
  ///
  /// Defaults to [MethodChannelInfosurvey].
  static InfosurveyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [InfosurveyPlatform] when
  /// they register themselves.
  static set instance(InfosurveyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
