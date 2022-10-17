import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/constants.dart';
import '../controller/doc_id.dart';
import '../controller/page_controller.dart';
import '../models/employee.dart';
import '../services/fire_service.dart';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  List<String> list = <String>[
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  String dropdownValue = "Sunday";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: Container(),
        title: const Text(
          "Status",
          style: TextStyle(
              color: secondaryColor,
              fontSize: headlineText,
              fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: bgColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 50.0,
                  width: 300,
                  child: const TextField(
                    decoration: InputDecoration(
                        hintText: "Enter Employee Id",
                        suffixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                        return statusCard(
                            docId: employee.docId!,
                            employeeId: employee.employeeId!,
                            name: employee.employeeName!,
                            status: employee.status!,
                            department: employee.department,
                            sTime: DateTime.parse(
                                employee.sTime!.toDate().toString()),
                            eTime: DateTime.parse(
                                employee.eTime!.toDate().toString()));
                      },
                    );
                  }
                }
            }
          }),
    );
  }

  Widget statusCard(
      {required String docId,
      required String employeeId,
      required String name,
      String? department,
      required int status,
      DateTime? sTime,
      DateTime? eTime}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Provider.of<PageModel>(context, listen: false).currentPage(3);
          Provider.of<DocId>(context, listen: false).selectDoc(docId);
        },
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
                  statusText(status)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
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
              Row(
                children: [
                  status == 0
                      ? const Icon(
                          Icons.blur_linear_outlined,
                          color: primaryColor,
                        )
                      : Container(),
                  status == 0
                      ? const SizedBox(
                          width: 5,
                        )
                      : const SizedBox(
                          width: 0,
                        ),
                  status == 0
                      ? Text(
                          "Department : $department",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      : Container(),
                  status == 0
                      ? const SizedBox(
                          width: 25,
                        )
                      : const SizedBox(
                          width: 0,
                        ),
                  const Icon(
                    Icons.access_time_rounded,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "$sTime   to   $eTime",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //Shift = 0 Green, Week Off = 1 Amber, Leav = 2 redAccent, Monthly Leav = 3 Red
  Widget statusText(int status) {
    if (status == 0) {
      return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(15)),
          child: const Text(
            "Shift",
            style: TextStyle(color: Colors.white),
          ));
    } else if (status == 1) {
      return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(15)),
          child: const Text("Week Off", style: TextStyle(color: Colors.white)));
    } else if (status == 2) {
      return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.redAccent, borderRadius: BorderRadius.circular(15)),
          child: const Text("Leav", style: TextStyle(color: Colors.white)));
    } else if (status == 3) {
      return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.redAccent[700],
              borderRadius: BorderRadius.circular(15)),
          child: const Text("Monthly Leav",
              style: TextStyle(color: Colors.white)));
    } else if (status == 4) {
      return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(15)),
          child:
              const Text("Not Assign", style: TextStyle(color: Colors.white)));
    }
    return Container();
  }
}
