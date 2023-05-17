import 'package:shared_preferences/shared_preferences.dart';

class TasksCompletedService {
  static const latinoamericaCompleted = true;
  static const artistasCompleted = true;
  static const eventoCulturalCompleted = true;

  static Future<List<bool>> getUnoTaskCompletedInfo() async {
    final latinoamericaList = await getUnoLatinoamericaTaskCompletedInfo();
    final artistsList = await getUnoArtistasTaskCompletedInfo();
    final eventList = await getUnoEventoTaskCompletedInfo();
    final divulgation = await getUnoDivulgationCompletedInfo();

    var latinoamerica = false;
    var artistas = false;
    var eventoCultural = false;

    if (latinoamericaList[0] && latinoamericaList[1] && latinoamericaList[2]) {
      latinoamerica = true;
    }

    if (artistsList[0] && artistsList[1]) {
      artistas = true;
    }

    if (eventList[0] && eventList[1]) {
      eventoCultural = true;
    }

    return [latinoamerica, artistas, eventoCultural, divulgation.first];
  }

  static Future<List<bool>> getUnoLatinoamericaTaskCompletedInfo() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final tareaUnoLatinoamerica =
        sharedPreferences.getBool('latinoamericaTareaUnoCompleted') ?? false;
    final tareaDosLatinoamerica =
        sharedPreferences.getBool('latinoamericaTareaDosCompleted') ?? false;
    final tareaTresLatinoamerica =
        sharedPreferences.getBool('latinoamericaTareaTresCompleted') ?? false;

    if (tareaUnoLatinoamerica &&
        tareaDosLatinoamerica &&
        tareaTresLatinoamerica == true) {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(
        'latinoamericaCompleted',
        latinoamericaCompleted,
      );
    }

    return [
      tareaUnoLatinoamerica,
      tareaDosLatinoamerica,
      tareaTresLatinoamerica,
    ];
  }

  static Future<List<bool>> getUnoArtistasTaskCompletedInfo() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final tareaUnoArtistas =
        sharedPreferences.getBool('artistasTareaUnoCompleted') ?? false;
    final tareaDosArtistas =
        sharedPreferences.getBool('artistasTareaDosCompleted') ?? false;

    if (tareaUnoArtistas && tareaDosArtistas == true) {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(
        'artistasCompleted',
        artistasCompleted,
      );
    }

    return [tareaUnoArtistas, tareaDosArtistas];
  }

  static Future<List<bool>> getUnoEventoTaskCompletedInfo() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final tareaUnoEvento =
        sharedPreferences.getBool('eventoTareaUnoCompleted') ?? false;
    final feedbackEvento =
        sharedPreferences.getBool('eventoReceivedFeedbackCompleted') ?? false;

    if (tareaUnoEvento && feedbackEvento == true) {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(
        'eventoCulturalCompleted',
        eventoCulturalCompleted,
      );
    }

    return [tareaUnoEvento, feedbackEvento];
  }

  static Future<List<bool>> getUnoDivulgationCompletedInfo() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final divulgation =
        sharedPreferences.getBool('divulgationCompleted') ?? false;

    return [divulgation];
  }

  static Future<void> restoreAllTasks() async {
    const latinoamericaTareaUnoCompleted = false;
    const latinoamericaTareaDosCompleted = false;
    const latinoamericaTareaTresCompleted = false;
    const artistasTareaUnoCompleted = false;
    const artistasTareaDosCompleted = false;
    const eventoTareaUnoCompleted = false;
    const divulgationCompleted = false;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      'latinoamericaTareaUnoCompleted',
      latinoamericaTareaUnoCompleted,
    );
    await preferences.setBool(
      'latinoamericaTareaDosCompleted',
      latinoamericaTareaDosCompleted,
    );
    await preferences.setBool(
      'latinoamericaTareaTresCompleted',
      latinoamericaTareaTresCompleted,
    );
    await preferences.setBool(
      'artistasTareaUnoCompleted',
      artistasTareaUnoCompleted,
    );
    await preferences.setBool(
      'artistasTareaDosCompleted',
      artistasTareaDosCompleted,
    );
    await preferences.setBool(
      'eventoTareaUnoCompleted',
      eventoTareaUnoCompleted,
    );
    await preferences.setBool(
      'divulgationCompleted',
      divulgationCompleted,
    );
  }
}