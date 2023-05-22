import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectemos/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../commons/strings.dart';
import '../../../../../commons/strings_latinoamerica.dart';
import '../../../../../commons/styles.dart';
import '../../../../../repository/proyectemos_repository.dart';
import '../../../../../services/toast_services.dart';
import '../../../../../utils/email_sender.dart';
import '../../../../../utils/get_user.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/drawer_menu.dart';

class PUnoLatinoamericaTareaUnoPage extends StatefulWidget {
  const PUnoLatinoamericaTareaUnoPage({Key? key}) : super(key: key);

  @override
  State<PUnoLatinoamericaTareaUnoPage> createState() =>
      _PUnoLatinoamericaTareaUnoPageState();
}

class _PUnoLatinoamericaTareaUnoPageState
    extends State<PUnoLatinoamericaTareaUnoPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final StorageService storageService = StorageService();

  final formKey = GlobalKey<FormState>();
  final _answerUnoController = TextEditingController();
  final _answerDosController = TextEditingController();

  late YoutubePlayerController controller;
  late TextEditingController idController;
  late TextEditingController seekToController;

  late PlayerState playerState;
  late YoutubeMetaData videoMetaData;
  final double volume = 100;
  final bool muted = false;
  final bool isPlayerReady = false;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: 'R21d66HYGPw',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    )..addListener(listener);
    idController = TextEditingController();
    seekToController = TextEditingController();
    videoMetaData = const YoutubeMetaData();
    playerState = PlayerState.buffering;
  }

  void listener() {
    if (isPlayerReady && mounted && !controller.value.isFullScreen) {
      setState(() {
        playerState = controller.value.playerState;
        videoMetaData = controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    idController.dispose();
    seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = getCurrentUser(context);

    return Scaffold(
      backgroundColor: ThemeColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: ThemeColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(250, 251, 250, 1),
        ),
        title: Text(
          Strings.titleLatinoamericaUno,
          style: ThemeText.paragraph16WhiteBold,
        ),
      ),
      endDrawer: const DrawerMenuWidget(),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringsLationamerica.titleQOnePageOneLatin,
                      style: ThemeText.paragraph16GrayNormal,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      StringsLationamerica.qOneLatinPageOne,
                      style: ThemeText.paragraph14Gray,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      hint: 'Respuesta',
                      controller: _answerUnoController,
                      keyboardType: TextInputType.text,
                      validatorVazio: 'Ingrese tuja respuesta correctamente',
                      validatorMenorqueNumero:
                          'Su respuesta debe tener al menos 10 caracteres',
                      validatorNumeroDeCaracteres: 10,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      StringsLationamerica.qTwoLatinPageOne,
                      style: ThemeText.paragraph14Gray,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      hint: 'Respuesta',
                      controller: _answerDosController,
                      keyboardType: TextInputType.text,
                      validatorVazio: 'Ingrese tuja respuesta correctamente',
                      validatorMenorqueNumero:
                          'Su respuesta debe tener al menos 10 caracteres',
                      validatorNumeroDeCaracteres: 10,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      StringsLationamerica.titleQtwoPageOneLatin,
                      style: ThemeText.paragraph16GrayNormal,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    YoutubePlayer(
                      thumbnail: const Text(
                        'https://img.youtube.com/vi/R21d66HYGPw/hqdefault.jpg',
                      ),
                      controller: controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: ThemeColors.yellow,
                      progressColors: const ProgressBarColors(
                        playedColor: ThemeColors.yellow,
                        handleColor: ThemeColors.yellow,
                      ),
                      onReady: () {
                        controller.addListener(listener);
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final json = {
                              'resposta_1': _answerUnoController.text,
                              'resposta_2': _answerDosController.text,
                            };

                            final respostas = [
                              _answerUnoController.text,
                              _answerDosController.text,
                            ];
                            deactivate();
                            sendEmail(currentUser, respostas);
                            sendAnswersToFirebase(json);
                            saveLatinoamericaCompleted();
                            showToast(Strings.tareaConcluida);
                            Navigator.pushNamed(
                              context,
                              '/pUno_latinoamerica_menu',
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: loading
                              ? [
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ]
                              : [
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      'Contínua',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios),
                                ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendAnswersToFirebase(Map<String, String> json) async {
    const doc = 'uno/latinoamerica/atividade_1/';
    try {
      await context.read<ProyectemosRepository>().saveAnswers(doc, json);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> saveLatinoamericaCompleted() async {
    const latinoamericaTareaUnoCompleted = true;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(
      'latinoamericaTareaUnoCompleted',
      latinoamericaTareaUnoCompleted,
    );
  }

  Future<List> getEmailTeacherFromFirebase() async {
    final emails = [];
    const doc = 'professora';
    final repository = context.read<ProyectemosRepository>();

    try {
      final data = await repository.getTeacherEmail(doc);
      emails.addAll(data);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return emails;
  }

  Future<void> sendEmail(currentUser, respostas) async {
    final email = await getEmailTeacherFromFirebase();

    final studentInfo = context.read<ProyectemosRepository>().getUserInfo();
    final studentInformation = studentInfo.split('/');

    final allStudentInfo = [
      studentInformation[3],
      studentInformation[0],
      studentInformation[1],
      studentInformation[2]
    ];

    const subject = 'Atividade - Latinoamerica\n Tarea Uno';
    final text = '''
Proyectemos\n
${allStudentInfo[0]} - ${allStudentInfo[1]} - ${allStudentInfo[2]} - ${allStudentInfo[3]}\n\n 
Atividade Latinoamerica 1ª tarefa concluída!
\n\n
Pergunta: ${StringsLationamerica.qOneLatinPageOne}\n
Resposta: ${respostas[0]}
\n
Pergunta: ${StringsLationamerica.qTwoLatinPageOne}\n
Resposta: ${respostas[1]}
''';
    final emailSender = EmailSender();

    await emailSender.sendEmailToTeacher(
      currentUser,
      [],
      [email.first.values.first],
      subject,
      text,
    );
  }
}
