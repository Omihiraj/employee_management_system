import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:employee_management/models/employee.dart';
import 'package:flutter/material.dart';

import '../components/constants.dart';
import '../models/datestatus.dart';
import '../models/departments.dart';

class FireService {
  static List<DateTime> sDateArr = [];
  static List<DateTime> eDateArr = [];
  static var startDate = DateTime.now();
  static var endDate = DateTime.now();
  static String minDepartment = "";
  static List<String> maxDepartment = [];
  static List<int> statusIdArr = [0, 1];
  static List<Map> allDepData = [];

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
  static Future<bool> addStatus(
      {required Timestamp sDate,
      required Timestamp eDate,
      required String department,
      required int statusId,
      required String docId,
      required context}) async {
    getQtyEmps();
    bool canAdd = true;
    maxDepartment.forEach((element) {
      if (element == department) {
        canAdd = false;
      }
    });
    if (canAdd == false) {
      print("You Can't Update to this department.Please Assign Any one");
    } else {
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
      await dateStateDoc
          .set(json)
          .then((val) => {
                allDepData.forEach((value) {
                  if (value['dep'] == department && statusId == 0) {
                    int currentEps = value['current-emps'] + 1;
                    updateDep(departmentId: value['id'], qtyEmp: currentEps);
                  }
                })
              })
          .catchError((error) {
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
    return canAdd;
  }

  static updateDep({required String departmentId, required int qtyEmp}) async {
    CollectionReference deps =
        FirebaseFirestore.instance.collection('departments');

    await deps
        .doc(departmentId)
        .update({'current-emps': qtyEmp})
        .then((value) => print("Current Employee Qty Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  static Future<bool> updateStatus(
      {required Timestamp sDate,
      required Timestamp eDate,
      required String oldDep,
      required int oldStatus,
      required String department,
      required int statusId,
      required String docId,
      required String subDocId,
      required context}) async {
    getQtyEmps();
    bool canAdd = true;
    maxDepartment.forEach((element) {
      if (element == department) {
        canAdd = false;
      }
      print(element);
    });
    if (canAdd == false) {
      print("You Can't Update to this department.Please Assign Any Dep");
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                "Can't Update",
                style: TextStyle(color: primaryColor),
              ),
            );
          });
    } else {
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
      await dateStateDoc
          .update(json)
          .then((val) => {
                allDepData.forEach((value) {
                  if (value['dep'] == department && statusId == 0) {
                    int currentEps = value['current-emps'] + 1;
                    updateDep(departmentId: value['id'], qtyEmp: currentEps);
                  }

                  if (value['dep'] == oldDep && oldStatus == 0) {
                    int currentEps = value['current-emps'] - 1;
                    updateDep(departmentId: value['id'], qtyEmp: currentEps);
                  }
                })
              })
          .catchError((error) {
        print(error);
      });
    }
    return canAdd;
  }

  static Future deleteStatus(
      {required String docId,
      required String subDocId,
      required String oldDep,
      required int oldStatus}) async {
    getQtyEmps();
    final dateStateDoc = FirebaseFirestore.instance
        .collection("employees")
        .doc(docId)
        .collection("date-state")
        .doc(subDocId);

    await dateStateDoc
        .delete()
        .then((val) => {
              allDepData.forEach((value) {
                if (value['dep'] == oldDep && oldStatus == 0) {
                  int currentEps = value['current-emps'] - 1;
                  updateDep(departmentId: value['id'], qtyEmp: currentEps);
                }
              })
            })
        .catchError((error) {
      print("Some Error Occured");
    });
  }

  static Future addEmployee(
      {required String employeeName,
      required String employeeId,
      required String mobileNo,
      required context}) async {
    getQtyEmps();
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
    await empDoc.set(json).then((value) {
      addStatus(
          sDate: Timestamp.fromDate(DateTime.now()),
          eDate: Timestamp.fromDate(DateTime.now()),
          department: minDepartment,
          statusId: 0,
          docId: empDocId,
          context: context);
    }).catchError((error) {
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

  static getQtyEmps() {
    var depQty = FirebaseFirestore.instance
        .collection('departments')
        .get()
        .then((QuerySnapshot querySnapshot) {
      Map depQty = {};

      int min = 0;

      querySnapshot.docs.forEach((doc) {
        int difference = doc["max-emps"] - doc["current-emps"];
        if (min < difference) {
          min = difference;
          depQty = {'dep': doc["dep-name"], 'difference': difference};
        }
        if (difference == 0) {
          //max = difference;
          maxDepartment.add(doc["dep-name"]);
        }
        allDepData.add({
          'id': doc["doc-id"],
          'dep': doc["dep-name"],
          'current-emps': doc["current-emps"]
        });
      });
      return depQty;
    });
    depQty.then((value) {
      minDepartment = value['dep'];
    });
  }

  static dateCalculate(DateTime nowDate) {
    var arr = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    final now = nowDate;
    int firstYear = 0;
    int lastYear = 0;
    int firstMonth = 0;
    int lastMonth = 0;

    if (now.year % 400 == 0) {
      arr[1] = 29;
    } else if (now.year % 4 == 0) {
      arr[1] = 29;
    }

    print(now.weekday);
    int firstDay = 0;
    int lastDay = 0;
    if (now.weekday == 6) {
      firstDay = now.day;
      lastDay = now.day + 6;
    } else if (now.weekday == 7) {
      firstDay = now.day - 1;
      lastDay = now.day + 5;
    } else {
      firstDay = now.day - (now.weekday - 1) - 2;
      lastDay = now.day + (7 - now.weekday) - 2;
    }

    print("First Day :");
    if (firstDay < 1) {
      if (now.month != 1) {
        firstDay = arr[now.month - 2] + firstDay;
        firstMonth = now.month - 1;
        firstYear = now.year;
      } else if (now.month == 1) {
        firstDay = 31 + firstDay;
        firstMonth = 12;
        firstYear = now.year - 1;
      }
      print("$firstYear-$firstMonth-$firstDay");
      startDate = DateTime.utc(firstYear, firstMonth, firstDay);
    } else {
      firstYear = now.year;
      firstMonth = now.month;
      print("$firstYear-$firstMonth-$firstDay");
      startDate = DateTime.utc(firstYear, firstMonth, firstDay);
    }

    print("Last Day :");
    if (arr[now.month - 1] < lastDay) {
      lastDay = lastDay - arr[now.month - 1];
      lastMonth = now.month + 1;
      lastYear = now.year;
      if (now.month == 12) {
        lastMonth = 1;
        lastYear = now.year + 1;
      }
      print("$lastYear-$lastMonth-$lastDay");
      endDate = DateTime.utc(lastYear, lastMonth, lastDay);
    } else {
      lastYear = now.year;
      lastMonth = now.month;
      print("$lastYear-$lastMonth-$lastDay");
      endDate = DateTime.utc(lastYear, lastMonth, lastDay);
    }
    int tempDay = lastDay - 1;
    if (lastDay == 1) {
      tempDay = arr[now.month - 2];
    }
    sDateArr.add(DateTime.utc(firstYear, firstMonth, firstDay));
    sDateArr.add(DateTime.utc(firstYear, firstMonth, lastDay));
    eDateArr.add(DateTime.utc(firstYear, firstMonth, tempDay));
    eDateArr.add(DateTime.utc(firstYear, firstMonth, lastDay));
  }

  static Future<bool> addAutoStatus(String docId, context) async {
    bool canAdd = true;
    getQtyEmps();

    dateCalculate(DateTime.now());
    await FirebaseFirestore.instance
        .collection('employees')
        .doc(docId)
        .collection('date-state')
        .where('sdate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('sdate', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get()
        .then((QuerySnapshot querySnapshot) {
      int docQty = 0;
      querySnapshot.docs.forEach((doc) {
        // String test = doc["doc-id"];
        docQty++;
      });
      if (docQty > 0) {
        canAdd = false;
        print("You Can not add status");
      } else {
        print(minDepartment);
        for (int i = 0; i < 2; i++) {
          addStatus(
              docId: docId,
              department: minDepartment,
              sDate: Timestamp.fromDate(sDateArr[i]),
              eDate: Timestamp.fromDate(eDateArr[i]),
              statusId: statusIdArr[i],
              context: context);
        }
      }
    });
    return canAdd;
  }
}
