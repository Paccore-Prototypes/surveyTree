import 'package:flutter_test/flutter_test.dart';
import 'package:infosurvey/infosurvey.dart';
import 'package:infosurvey/infosurvey_platform_interface.dart';
import 'package:infosurvey/infosurvey_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockInfosurveyPlatform
    with MockPlatformInterfaceMixin
    implements InfosurveyPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final InfosurveyPlatform initialPlatform = InfosurveyPlatform.instance;

  test('$MethodChannelInfosurvey is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelInfosurvey>());
  });

  test('getPlatformVersion', () async {
    Infosurvey infosurveyPlugin = Infosurvey();
    MockInfosurveyPlatform fakePlatform = MockInfosurveyPlatform();
    InfosurveyPlatform.instance = fakePlatform;

    expect(await infosurveyPlugin.getPlatformVersion(), '42');
  });
}
