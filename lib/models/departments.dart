class Department {
  Department({
    this.docId,
    this.departmentName,
    this.maxEmployees,
    this.currenntEmployees,
  });
  String? docId;
  String? departmentName;
  int? maxEmployees;
  int? currenntEmployees;

  static Department fromJson(Map<String, dynamic> json) => Department(
        docId: json["doc-id"],
        departmentName: json["dep-name"],
        maxEmployees: json["max-emps"],
        currenntEmployees: json["current-emps"],
      );

  Map<String, dynamic> toJson() => {
        "doc-id": docId,
        "dep-name": departmentName,
        "max-emps": maxEmployees,
        "current-emps": currenntEmployees,
      };
}
