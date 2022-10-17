import 'package:flutter/material.dart';

import '../components/constants.dart';
import '../models/employee.dart';
import '../services/fire_service.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  TextEditingController employeeName = TextEditingController();
  TextEditingController employeeId = TextEditingController();
  TextEditingController employeeMobile = TextEditingController();
  @override
  void dispose() {
    employeeName.dispose();

    employeeMobile.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: Container(),
        title: const Text(
          "Employees",
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
                            'Add Employee',
                            style: TextStyle(color: primaryColor),
                          ),
                          content: SizedBox(
                            width: 300,
                            height: 250,
                            child: ListView(
                              controller: ScrollController(),
                              children: [
                                TextField(
                                  controller: employeeId,
                                  decoration: InputDecoration(
                                      label: const Text("Employee Id"),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: employeeName,
                                  decoration: InputDecoration(
                                      label: const Text("Employee Name"),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: employeeMobile,
                                  decoration: InputDecoration(
                                      label: const Text("Mobile No"),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: () {
                                      FireService.addEmployee(
                                        employeeName: employeeName.text.trim(),
                                        employeeId: employeeId.text.trim(),
                                        mobileNo: employeeMobile.text.trim(),
                                      );
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
      body: StreamBuilder<List<Employee>>(
          stream: FireService.getEmployees(),
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
                    final employees = snapshot.data!;

                    return ListView.builder(
                      controller: ScrollController(),
                      itemCount: employees.length,
                      itemBuilder: (BuildContext context, int index) {
                        final employee = employees[index];
                        return employeeCard(
                            employeeId: employee.employeeId!,
                            name: employee.employeeName!,
                            mobile: employee.employeeMobile!);
                      },
                    );
                  }
                }
            }
          }),
    );
  }

  Widget employeeCard(
      {required String employeeId,
      required String name,
      required String mobile}) {
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
                  "Employee ID : $employeeId",
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
                Text(
                  name,
                  style: const TextStyle(
                      color: secondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 30,
                ),
                const Icon(Icons.phone),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  mobile,
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
