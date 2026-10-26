/// The five languages of version 1, in the order the app lists them.
const supportedLanguages = ['de', 'en', 'es', 'it', 'fr'];

/// One of the 36 questions. Weights and ratings refer to [id], never to text.
class Question {
  const Question({required this.id, required this.stage, required this.text});

  final String id;
  final int stage;
  final Map<String, String> text;

  String textIn(String language) => text[language] ?? text['en']!;
}

/// Name and one sentence for a stage (US-04, US-08).
class StageInfo {
  const StageInfo({
    required this.stage,
    required this.name,
    required this.intro,
  });

  final int stage;
  final Map<String, String> name;
  final Map<String, String> intro;

  String nameIn(String language) => name[language] ?? name['en']!;

  String introIn(String language) => intro[language] ?? intro['en']!;
}

class Catalog {
  Catalog({required this.stages, required this.questions})
    : _byId = {for (final question in questions) question.id: question};

  factory Catalog.fromJson(Map<String, dynamic> json) {
    Map<String, String> texts(Object? value) =>
        (value as Map<String, dynamic>).cast<String, String>();
    return Catalog(
      stages: [
        for (final stage in json['stages'] as List)
          StageInfo(
            stage: stage['stage'] as int,
            name: texts(stage['name']),
            intro: texts(stage['intro']),
          ),
      ],
      questions: [
        for (final question in json['questions'] as List)
          Question(
            id: question['id'] as String,
            stage: question['stage'] as int,
            text: texts(question['text']),
          ),
      ],
    );
  }

  final List<StageInfo> stages;
  final List<Question> questions;
  final Map<String, Question> _byId;

  Question question(String id) => _byId[id]!;

  StageInfo stage(int stage) => stages.firstWhere((s) => s.stage == stage);

  List<String> idsOfStage(int stage) => [
    for (final question in questions)
      if (question.stage == stage) question.id,
  ];
}
