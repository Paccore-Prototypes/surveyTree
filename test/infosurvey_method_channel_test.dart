import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infosurvey/infosurvey_method_channel.dart';

void main() {
  MethodChannelInfosurvey platform = MethodChannelInfosurvey();
  const MethodChannel channel = MethodChannel('infosurvey');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
