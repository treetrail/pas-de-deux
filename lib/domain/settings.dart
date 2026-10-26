const _keep = Object();

/// What the app remembers between games (US-01 to US-05, US-14, US-19).
class Settings {
  const Settings({
    this.appLanguage,
    this.secondLanguage,
    this.stages = const [1, 2, 3],
    this.questionCount,
    this.ownName = '',
    this.soundOn = true,
    this.introSeen = false,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    appLanguage: json['appLanguage'] as String?,
    secondLanguage: json['secondLanguage'] as String?,
    stages: (json['stages'] as List).cast<int>(),
    questionCount: json['questionCount'] as int?,
    ownName: json['ownName'] as String,
    // Missing in settings saved before these options existed.
    soundOn: json['soundOn'] as bool? ?? true,
    introSeen: json['introSeen'] as bool? ?? false,
  );

  /// Null follows the device language (US-01).
  final String? appLanguage;

  /// Null shows the questions in one language only.
  final String? secondLanguage;
  final List<int> stages;

  /// Null plays all questions of the chosen stages.
  final int? questionCount;

  /// Only the name of the person who owns the phone is kept (US-03).
  final String ownName;

  /// Sound at the end of the four-minute look. Vibration stays (US-14).
  final bool soundOn;

  /// The introduction appears on the first start only (US-02).
  final bool introSeen;

  Settings copyWith({
    Object? appLanguage = _keep,
    Object? secondLanguage = _keep,
    List<int>? stages,
    Object? questionCount = _keep,
    String? ownName,
    bool? soundOn,
    bool? introSeen,
  }) => Settings(
    appLanguage: appLanguage == _keep
        ? this.appLanguage
        : appLanguage as String?,
    secondLanguage: secondLanguage == _keep
        ? this.secondLanguage
        : secondLanguage as String?,
    stages: stages ?? this.stages,
    questionCount: questionCount == _keep
        ? this.questionCount
        : questionCount as int?,
    ownName: ownName ?? this.ownName,
    soundOn: soundOn ?? this.soundOn,
    introSeen: introSeen ?? this.introSeen,
  );

  Map<String, Object?> toJson() => {
    'appLanguage': appLanguage,
    'secondLanguage': secondLanguage,
    'stages': stages,
    'questionCount': questionCount,
    'ownName': ownName,
    'soundOn': soundOn,
    'introSeen': introSeen,
  };
}
