import 'package:cloud_firestore/cloud_firestore.dart';

class DateStatus {
  DateStatus({
    required this.docId,
    required this.sTime,
    required this.eTime,
    required this.status,
    required this.department,
  });
  String docId;
  Timestamp sTime;
  Timestamp eTime;
  int status;
  String department;

  static DateStatus fromJson(Map<String, dynamic> json) => DateStatus(
      docId: json["doc-id"],
      sTime: json["sdate"],
      eTime: json["edate"],
      status: json["status"],
      department: json["department"]);

  Map<String, dynamic> toJson() => {
        "doc-id":docId,
        "sdate": sTime,
        "edate": eTime,
        "status": status,
        "department": department
      };
}
