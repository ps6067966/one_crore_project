import 'package:flutter/material.dart';

extension PhoneNumber on String {
  bool isPhoneNumber() {
    return RegExp(r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$')
        .hasMatch(this);
  }
}

extension AbuseMessage on String {
  bool isAbuseMessage() {
    return RegExp(
            'sex|madharchod|madhar|chod|Madhar|Chod|behenchod|bhosdike|madhar chod|Sex|Madharchod|hole|HOLE|Hole|MADHARCHOD|SEX|BEHENCHOD|Behenchod|Behen chod|BEHEN CHOD|behen chod|BHOSDIKE|ass|Ass|ASS|cock|Cock|COCK|MOTHERFUCKER|Mother Fucker|MotherFucker|motherfucker|SisterFucking|sisterfucking|FUCK|fuck|fucking|Asshole|ASSHOLE|asshole|fuckyou|fuck you|Fuck you|FUCK YOU |id|ID|FACEBOOK|facebook|INSTA|insta|instagran|INSTAGRAM')
        .hasMatch(this);
  }
}

extension SocialSite on String {
  bool isSocialSite() {
    return RegExp('@.com|@|.com|.COM|www|WWW|Www').hasMatch(this);
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}
