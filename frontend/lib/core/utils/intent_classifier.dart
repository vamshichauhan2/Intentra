class IntentClassifier {
  static const focusApps = [
    'com.google.android.apps.docs',
    'com.google.android.apps.meet',
    'com.microsoft.office.word',
  ];

  static const distractionApps = [
    'com.whatsapp',
    'com.instagram.android',
    'com.google.android.youtube',
    'com.facebook.katana',
  ];

  static String classify(String packageName) {
    if (focusApps.contains(packageName)) {
      return 'FOCUS';
    }
    if (distractionApps.contains(packageName)) {
      return 'DISTRACTION';
    }
    return 'NEUTRAL';
  }
}
