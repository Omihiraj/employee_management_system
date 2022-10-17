import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:employee_management/models/employee.dart';

import '../models/datestatus.dart';
import '../models/departments.dart';

class FireService {
  static Stream<List<Employee>> getEmployees() => FirebaseFirestore.instance
      .collection('employees')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Employee.fromJson(doc.data())).toList());
  static Stream<List<Department>> getDepartments() => FirebaseFirestore.instance
      .collection('departments')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Department.fromJson(doc.data())).toList());

  static Stream<List<DateStatus>> getDateStatus() => FirebaseFirestore.instance
      .collection('employees')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => DateStatus.fromJson(doc.data())).toList());
  static Future addStatus(
      {required Timestamp sDate,
      required Timestamp eDate,
      required String department,
      required int statusId,
      required String docId}) async {
    final String dateStateId = FirebaseFirestore.instance
        .collection("employees")
        .doc(docId)
        .collection("date-state")
        .doc()
        .id;
    final dateStateDoc = FirebaseFirestore.instance
        .collection("employees")
        .doc(docId)
        .collection("date-state")
        .doc(dateStateId);
    final dateStateDoc2 =
        FirebaseFirestore.instance.collection("employees").doc(docId);
    final dateStateItem = DateStatus(
        sTime: sDate,
        eTime: eDate,
        department: department,
        status: statusId,
        docId: dateStateId);

    final json = dateStateItem.toJson();
    await dateStateDoc.set(json).catchError((error) {
      print("Some Error Occured");
    });

    await dateStateDoc2.update({
      'stime': sDate,
      'etime': eDate,
      'department': department,
      'status': statusId
    }).catchError((error) {
      print("Some Error Occured");
    });
  }

  static Future updateStatus(
      {required Timestamp sDate,
      required Timestamp eDate,
      required String department,
      required int statusId,
      required String docId,
      required String subDocId}) async {
    final dateStateDoc = FirebaseFirestore.instance
        .collection("employees")
        .doc(docId)
        .collection("date-state")
        .doc(subDocId);
    final dateStateItem = DateStatus(
        sTime: sDate,
        eTime: eDate,
        department: department,
        status: statusId,
        docId: subDocId);

    final json = dateStateItem.toJson();
    await dateStateDoc.update(json).catchError((error) {
      print("Some Error Occured");
    });
  }

  static Future deleteStatus({
    required String docId,
    required String subDocId,
  }) async {
    final dateStateDoc = FirebaseFirestore.instance
        .collection("employees")
        .doc(docId)
        .collection("date-state")
        .doc(subDocId);

    await dateStateDoc.delete().catchError((error) {
      print("Some Error Occured");
    });
  }

  static Future addEmployee({
    required String employeeName,
    required String employeeId,
    required String mobileNo,
  }) async {
    final String empDocId =
        FirebaseFirestore.instance.collection("employees").doc().id;
    final empDoc =
        FirebaseFirestore.instance.collection("employees").doc(empDocId);
    final empDocItem = Employee(
      docId: empDocId,
      employeeId: employeeId,
      employeeName: employeeName,
      employeeMobile: mobileNo,
      status: 4,
    );

    final json = empDocItem.toJson();
    await empDoc.set(json).catchError((error) {
      print("Some Error Occured");
    });
  }

  static Future addDepartment({
    required String departmentName,
    required int maxEmployees,
    required int currenntEmployees,
  }) async {
    final String depDocId =
        FirebaseFirestore.instance.collection("departments").doc().id;
    final depDoc =
        FirebaseFirestore.instance.collection("departments").doc(depDocId);
    final depDocIdItem = Department(
      docId: depDocId,
      departmentName: departmentName,
      maxEmployees: maxEmployees,
      currenntEmployees: currenntEmployees,
    );

    final json = depDocIdItem.toJson();
    await depDoc.set(json).catchError((error) {
      print("Some Error Occured");
    });
  }
}
