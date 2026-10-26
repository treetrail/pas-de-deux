const _keep = Object();

/// What the app remembers between games (US-01, US-03 to US-05, US-19).
class Settings {
  const Settings({
    this.appLanguage,
    this.secondLanguage,
    this.stages = const [1, 2, 3],
    this.questionCount,
    this.ownName = '',
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    appLanguage: json['appLanguage'] as String?,
    secondLanguage: json['secondLanguage'] as String?,
    stages: (json['stages'] as List).cast<int>(),
    questionCount: json['questionCount'] as int?,
    ownName: json['ownName'] as String,
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

  Settings copyWith({
    Object? appLanguage = _keep,
    Object? secondLanguage = _keep,
    List<int>? stages,
    Object? questionCount = _keep,
    String? ownName,
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
  );

  Map<String, Object?> toJson() => {
    'appLanguage': appLanguage,
    'secondLanguage': secondLanguage,
    'stages': stages,
    'questionCount': questionCount,
    'ownName': ownName,
  };
}
