import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/constants.dart';
import '../models/departments.dart';
import '../services/fire_service.dart';

class Departments extends StatefulWidget {
  const Departments({Key? key}) : super(key: key);

  @override
  State<Departments> createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {
  TextEditingController departmentName = TextEditingController();
  TextEditingController maxEmployees = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: Container(),
        title: const Text(
          "Departments",
          style: TextStyle(
              color: secondaryColor,
              fontSize: headlineText,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 50),
            child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Add Department',
                            style: TextStyle(color: primaryColor),
                          ),
                          content: SizedBox(
                            width: 300,
                            height: 250,
                            child: ListView(
                              controller: ScrollController(),
                              children: [
                                TextField(
                                  controller: departmentName,
                                  decoration: InputDecoration(
                                      label: const Text("Department Name"),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: maxEmployees,
                                  decoration: InputDecoration(
                                      label: const Text("Maximum Employees"),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: () {
                                      FireService.addDepartment(
                                          departmentName:
                                              departmentName.text.trim(),
                                          maxEmployees: int.parse(
                                              maxEmployees.text.trim()),
                                          currenntEmployees: 5);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Submit"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: const [
                        Text("Add Employee",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.add_circle_outline_rounded,
                            color: Colors.white)
                      ],
                    ))),
          ),
        ],
        elevation: 0,
        backgroundColor: bgColor,
      ),
      body: StreamBuilder<List<Department>>(
          stream: FireService.getDepartments(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  if (snapshot.data == null) {
                    return const Text('No data to show');
                  } else {
                    final departments = snapshot.data!;

                    return ListView.builder(
                      controller: ScrollController(),
                      itemCount: departments.length,
                      itemBuilder: (BuildContext context, int index) {
                        final department = departments[index];
                        return employeeCard(
                            departmentName: department.departmentName!,
                            maxEmployees: department.maxEmployees!,
                            currentEmployees: department.currenntEmployees!);
                      },
                    );
                  }
                }
            }
          }),
    );
  }

  Widget employeeCard(
      {required String departmentName,
      required int maxEmployees,
      required int currentEmployees}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Department Name : $departmentName",
                  style: const TextStyle(
                      color: primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Maximum Employees : ",
                  style: TextStyle(
                      color: secondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "$maxEmployees",
                  style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 30,
                ),
                const Text(
                  "Currently Working Employees : ",
                  style: TextStyle(
                      color: secondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "$currentEmployees",
                  style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
