import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  Employee({
    this.docId,
    this.employeeId,
    this.employeeName,
    this.department,
    this.employeeMobile,
    this.sTime,
    this.eTime,
    this.status,
  });
  String? docId;
  String? employeeId;
  String? employeeName;
  String? employeeMobile;
  String? department;
  Timestamp? sTime;
  Timestamp? eTime;
  int? status;

  static Employee fromJson(Map<String, dynamic> json) => Employee(
        docId: json["doc-id"],
        employeeId: json["id"],
        employeeName: json["name"],
        employeeMobile: json["mobile"],
        department: json["department"],
        sTime: json["stime"],
        eTime: json["etime"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "doc-id": docId,
        "id": employeeId,
        "name": employeeName,
        "mobile": employeeMobile,
        "department": department,
        "stime": sTime,
        "eTime": eTime,
        "status": status,
      };
}
