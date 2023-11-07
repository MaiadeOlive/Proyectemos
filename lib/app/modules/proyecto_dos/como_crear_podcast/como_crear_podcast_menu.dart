import 'package:flutter/material.dart';
import 'package:proyectemos/commons/styles.dart';
import 'package:proyectemos/services/dos_tasks_completed.dart';

import '../../../../commons/strings/strings.dart';
import '../../widgets/card_button.dart';
import '../../widgets/drawer_menu.dart';

class PDosComoCrearPodcastMenu extends StatefulWidget {
  const PDosComoCrearPodcastMenu({super.key});

  @override
  State<PDosComoCrearPodcastMenu> createState() =>
      _PDosComoCrearPodcastMenuState();
}

class _PDosComoCrearPodcastMenuState extends State<PDosComoCrearPodcastMenu> {
  bool tareaUno = false;
  bool tareaDos = false;

  @override
  void initState() {
    super.initState();
    getTaskCompleted();
  }

  Future<void> getTaskCompleted() async {
    final resultado = await DosTasksCompletedService
        .getDosComoCrearPodcastTaskCompletedInfo();

    setState(() {
      tareaUno = resultado[0];
      tareaDos = resultado[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * .9;
    final height = MediaQuery.of(context).size.width * .4;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeColors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: ThemeColors.white),
            onPressed: () => Navigator.pushNamed(context, '/proyecto_dos'),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Color.fromRGBO(250, 251, 250, 1),
          ),
          title: Text(
            Strings.titleComoCrearPodcast,
            style: ThemeText.paragraph14WhiteBold,
          ),
        ),
        endDrawer: DrawerMenuWidget(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                CardButton(
                  iconSize: 30,
                  text: tareaUno
                      ? 'Feedback Escuchar Podcast'
                      : 'Escuchar el podcast',
                  cardWidth: width,
                  cardHeight: height,
                  namedRoute: tareaUno
                      ? '/pDos_escuchar_podcast_feedback_tarea_uno'
                      : '/pDos_escuchar_podcast_tarea_uno',
                  backgroundColor:
                      tareaUno ? ThemeColors.green : ThemeColors.yellow,
                  icon: tareaUno ? Icons.check : Icons.music_note_sharp,
                  shadowColor:
                      tareaUno ? ThemeColors.green : ThemeColors.yellow,
                ),
                const SizedBox(
                  height: 20,
                ),
                CardButton(
                  iconSize: 30,
                  text: tareaDos
                      ? 'Feedback\nCrear un Podcast'
                      : 'Crear un Podcast',
                  cardWidth: width,
                  cardHeight: height,
                  namedRoute: tareaDos
                      ? '/pDos_crear_un_podcast_feedback_tarea_dos'
                      : '/pDos_crear_un_podcast_tarea_dos',
                  backgroundColor:
                      tareaDos ? ThemeColors.green : ThemeColors.yellow,
                  icon: tareaDos ? Icons.check : Icons.image,
                  shadowColor:
                      tareaDos ? ThemeColors.green : ThemeColors.yellow,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
