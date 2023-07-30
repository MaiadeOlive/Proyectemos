import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:proyectemos/repository/repository_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/proyectemos_repository.dart';
import '../services/auth_services.dart';
import '../utils/email_sender.dart';

class RepositoryImpl<T> extends Repository<T, dynamic, dynamic> {
  List<String> student = [];
  List<String> studentInformations = [];
  late SharedPreferences sharedPreferences;
  String studentSchoolInfo = '';
  String studentClassRoomInfo = '';

  final _repository = ProyectemosRepository();
  final emailSender = EmailSender();
  AuthService authService = AuthService();

  @override
  Map<T, T> createJson(List answersList) {
    final jsonList = [];
    for (var i = 0; i < answersList.length; i++) {
      jsonList.add({'resposta_$i': answersList[i]});
    }
    return {for (var e in jsonList) e.keys.first: e.values.first};
  }

  // @override
  // Future<void> saveTaskCompleted(taskName) async {
  //   final preferences = await SharedPreferences.getInstance();
  //   await preferences.setBool(
  //     taskName,
  //     true,
  //   );
  // }

  @override
  Future<void> saveTaskCompleted(T taskName) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(
      taskName.toString(),
      true,
    );
  }

  // @override
  // Future<void> sendAnswersToFirebase(Map<T, T> json, T doc) async {
  //   try {
  //     await _repository.saveAnswers(doc, json);
  //   } on FirebaseException catch (e) {
  //     e.toString();
  //   }
  // }

  @override
  Future<void> sendAnswersToFirebase(Map<T, T> json, T doc) async {
    final convertedJson = _convertMapToStringDynamic(json);
    try {
      await _repository.saveAnswers(doc.toString(), convertedJson);
    } on FirebaseException catch (e) {
      e.toString();
    }
  }

  Map<String, dynamic> _convertMapToStringDynamic(Map<T, T> inputMap) {
    final convertedMap = <String, dynamic>{};
    inputMap.forEach((key, value) {
      convertedMap[key.toString()] = value;
    });
    return convertedMap;
  }

  // @override
  // Future<void> sendEmail(
  //   GoogleSignInAccount? currentUser,
  //   List answersList,
  //   subject,
  //   message,
  //   attachment,
  // ) async {
  //   final email = await getEmailTeacherFromFirebase();

  //   await emailSender.sendEmailToTeacher(
  //     currentUser,
  //     attachment,
  //     [email.first.values.first],
  //     subject,
  //     message,
  //   );
  // }

  @override
  Future<void> sendEmail(
    GoogleSignInAccount? currentUser,
    List<T> answersList,
    dynamic subject,
    dynamic message,
    List<Attachment> attachment,
  ) async {
    final email = await _repository.getTeacherEmail();

    if (email != null) {
      await emailSender.sendEmailToTeacher(
        currentUser,
        attachment,
        [email[0]],
        subject,
        message,
      );
    }
  }

  // @override
  // Future getEmailTeacherFromFirebase() async {
  //   final emails = [];
  //   const doc = 'professora';

  //   try {
  //     final data = await _repository.getTeacherEmail(doc);
  //     emails.addAll(data);
  //   } on FirebaseException catch (e) {
  //     e.toString();
  //   }
  //   return emails;
  // }

  // @override
  // Future<List<String>> getEmailTeacherFromFirebase() async {
  //   final emails = [];

  //   try {
  //     final data = await _repository.getTeacherEmail();
  //     emails.addAll(await data);

  //   } on FirebaseException catch (e) {
  //     e.toString();
  //   }
  //   return emails;
  // }

  @override
  Future<List<String>> getStudentInfo() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final studentInfo = await _repository.getUserInfo();
    final studentInformation = studentInfo.split('/');

    return studentInformations
      ..add(studentInformation[0])
      ..add(studentInformation[1])
      ..add(studentInformation[2]);
  }

  @override
  Future<List<String>> getSchoolsInfo() async {
    final schoolsRef = FirebaseFirestore.instance.collection('escolas');
    List<String> schools = [];

    try {
      await schoolsRef.get().then((QuerySnapshot querySnapshot) {
        for (final doc in querySnapshot.docs) {
          final schoolName = doc.data();
          if (schoolName == null) return;
          schools.add((schoolName as Map)['schoolName']);
        }
      });
    } catch (error) {
      error.toString();
    }

    return schools;
  }

  @override
  Future<String> getSchoolId(String schoolNameParams) async {
    final schoolsRef = FirebaseFirestore.instance.collection('escolas');
    String schoolId = '';

    try {
      await schoolsRef.get().then((QuerySnapshot querySnapshot) {
        for (final doc in querySnapshot.docs) {
          final schoolName = doc.data();
          if (schoolName == null) return;
          if ((schoolName as Map)['schoolName'] == schoolNameParams) {
            schoolId = doc.id.toString();
          }
        }
      });
    } catch (error) {
      error.toString();
    }
    return schoolId;
  }

  @override
  Future<List<String>> getClassRoomInfo(String schoolName) async {
    final schoolId = await getSchoolId(schoolName);
    final classRoomRef = FirebaseFirestore.instance
        .collection('escolas/')
        .doc('$schoolId/')
        .collection('turmas');
    List<String> classRoom = [];

    try {
      await classRoomRef.get().then((QuerySnapshot querySnapshot) {
        for (final doc in querySnapshot.docs) {
          final className = doc.data();
          if (className == null) return;
          classRoom.add((className as Map)['classRoom']);
        }
      });
    } catch (error) {
      error.toString();
    }

    return classRoom;
  }

  // @override
  // Future<List<String>>? getSchoolsInfo() async {
  //   final schoolsRef = FirebaseFirestore.instance.collection('escolas');

  //   final schools = [];

  //   try {
  //     await schoolsRef.get().then((QuerySnapshot querySnapshot) {
  //       for (final doc in querySnapshot.docs) {
  //         schools.add(doc.data().toString());
  //       }
  //     });
  //   } catch (error) {
  //     error.toString();
  //   }
  //   return schools;
  // }

  @override
  Future<List> getClassesInfo() {
    // TODO: implement getClassesInfo
    throw UnimplementedError();
  }

  @override
  Future<List> getTeachersInfo() {
    // TODO: implement getTeachersInfo
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getEmailTeacherFromFirebase() {
    // TODO: implement getEmailTeacherFromFirebase
    throw UnimplementedError();
  }

  // @override
  // Future<List<String>>? getTeachersInfo() async {
  //   final teachersRef = FirebaseFirestore.instance.collection(
  //     'professores',
  //   );

  //   var teachers;

  //   await teachersRef.get().then((QuerySnapshot querySnapshot) {
  //     teachers = querySnapshot.docs;
  //   }).catchError((error) {
  //     print("Erro ao obter os documentos: $error");
  //   });

  //   return teachers;
  // }

  // @override
  // Future<List<String>>? getClassesInfo() async {
  //   final turmasRef = FirebaseFirestore.instance.collection(
  //     'turmas',
  //   );

  //   var turmas;

  //   await turmasRef.get().then((QuerySnapshot querySnapshot) {
  //     turmas = querySnapshot.docs;
  //   }).catchError((error) {
  //     print("Erro ao obter os documentos: $error");
  //   });

  //   return turmas;
  // }
}