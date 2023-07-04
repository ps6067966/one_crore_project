import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  static void launch(String url) async {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}
