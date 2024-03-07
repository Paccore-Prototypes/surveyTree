
import 'infosurvey_platform_interface.dart';

class Infosurvey {
  Future<String?> getPlatformVersion() {
    return InfosurveyPlatform.instance.getPlatformVersion();
  }
}
