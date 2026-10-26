// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Pas de deux';

  @override
  String get appSubtitle => '36 preguntas para conocerse';

  @override
  String get newGame => 'Nueva partida';

  @override
  String get resumeGame => 'Continuar partida';

  @override
  String get settings => 'Ajustes';

  @override
  String get setupTitle => 'Preparar la partida';

  @override
  String get yourName => 'Tu nombre';

  @override
  String get otherName => 'Nombre de la otra persona';

  @override
  String get personA => 'Persona A';

  @override
  String get personB => 'Persona B';

  @override
  String get stagesTitle => 'Niveles';

  @override
  String stageLabel(int number, String name, String intro) {
    return 'Nivel $number – $name: $intro';
  }

  @override
  String questionCount(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preguntas',
      one: '1 pregunta',
    );
    return '$_temp0 · unos $minutes min';
  }

  @override
  String distribution(String value) {
    return 'Reparto: $value';
  }

  @override
  String get secondLanguage => 'Segundo idioma';

  @override
  String get off => 'Desactivado';

  @override
  String get startGame => '¡Empezamos!';

  @override
  String answersFirst(String answerer, String holder) {
    return '$answerer responde primero. $holder tiene el teléfono.';
  }

  @override
  String answersNow(String answerer, String holder) {
    return 'Ahora responde $answerer. Pásale el teléfono a $holder.';
  }

  @override
  String get next => 'Continuar';

  @override
  String get skip => 'Saltar';

  @override
  String get back => 'Atrás';

  @override
  String progress(int number, int total) {
    return '$number de $total';
  }

  @override
  String progressSemantics(int number, int total) {
    return 'Pregunta $number de $total';
  }

  @override
  String ratingPrompt(String rater, String answerer) {
    return '$rater, ¿cuánto te llegó la respuesta de $answerer?';
  }

  @override
  String get ratingMoved => 'Me conmovió';

  @override
  String get ratingInteresting => 'Interesante';

  @override
  String get ratingOkay => 'Está bien';

  @override
  String get continueWithoutRating => 'Seguir sin valorar';

  @override
  String get endGame => 'Terminar partida';

  @override
  String get endGameQuestion => '¿Terminar la partida?';

  @override
  String get endGameBody =>
      'Se pasa al resumen con las preguntas jugadas hasta ahora.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirmEnd => 'Terminar';

  @override
  String stageTitle(int number, String name) {
    return 'Nivel $number: $name';
  }

  @override
  String get finishTitle => 'Los momentos más bonitos';

  @override
  String momentLine(String answerer, String rater) {
    return 'La respuesta de $answerer conmovió a $rater.';
  }

  @override
  String get noMoments => 'Qué bonito dedicarse tiempo.';

  @override
  String get toStart => 'Al inicio';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Como el dispositivo';

  @override
  String get privacyOptions => 'Opciones de privacidad';

  @override
  String get adFreeTitle => 'Sin anuncios';

  @override
  String get adFreeHint => 'Jugar sin anuncios';

  @override
  String buyAdFree(String price) {
    return 'Sin anuncios por $price';
  }

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get purchasePending => 'La compra se está procesando…';

  @override
  String get adFreeActive => 'Sin anuncios activado. ¡Gracias!';

  @override
  String get storeUnavailable =>
      'La tienda no está disponible en este momento.';

  @override
  String get purchaseFailed => 'La compra no se completó.';

  @override
  String get aboutTitle => 'Acerca de la app';

  @override
  String get aboutSource =>
      'Basada en una idea del estudio de Aron et al. (1997): «The Experimental Generation of Interpersonal Closeness: A Procedure and Some Preliminary Findings», Personality and Social Psychology Bulletin 23 (4), 363–377. Las preguntas tienen redacción propia. Los autores del estudio no tienen ninguna relación con esta app.';

  @override
  String get resetConsent => 'Restablecer consentimiento (prueba)';
}
