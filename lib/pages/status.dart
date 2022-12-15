import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/constants.dart';
import '../controller/doc_id.dart';
import '../controller/page_controller.dart';
import '../models/employee.dart';
import '../services/fire_service.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column hide Row;
import 'dart:convert';
import 'dart:html' as html;

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
        actions: [
          InkWell(
            onTap: () {
              hello();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 50),
              child: Container(
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: const [
                      Text("Download Week Summery",
                          style: TextStyle(color: Colors.white)),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add_circle_outline_rounded,
                          color: Colors.white)
                    ],
                  )),
            ),
          ),
        ],
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

Future<void> hello() async {
  // Create a new Excel document.
  final Workbook workbook = Workbook();
//Accessing worksheet via index.
  final Worksheet sheet = workbook.worksheets[0];

// Set Data

  Style globalStyle = workbook.styles.add('style');
  globalStyle.fontSize = 12;

  sheet.getRangeByName('A1').columnWidth = 20;
  sheet.getRangeByName('B1').columnWidth = 20;
  sheet.getRangeByName('C1').columnWidth = 24;
  sheet.getRangeByName('D1:J1').columnWidth = 28;
  sheet.getRangeByName('D2:J2').columnWidth = 28;

  sheet.getRangeByName('A1:A2').cellStyle.backColor = '#f79646';

  sheet.getRangeByName('B1:C1').cellStyle.backColor = '#8faadc';
  sheet.getRangeByName('B1:B2').merge();
  sheet.getRangeByName('C1:C2').merge();

  sheet.getRangeByName('A1').cellStyle.hAlign = HAlignType.center;
  sheet.getRangeByName('A1').setText('Designated');
  sheet.getRangeByName('A2').cellStyle.hAlign = HAlignType.center;
  sheet.getRangeByName('A2').setText('Areas');

  sheet.getRangeByName('B1').cellStyle.hAlign = HAlignType.center;
  sheet.getRangeByName('B1').setText('Name');

  sheet.getRangeByName('C1').cellStyle.hAlign = HAlignType.center;
  sheet.getRangeByName('C1').setText('ERP Numbers / Emp ID');
  sheet.getRangeByName('D1').setText('DD/MM');
  sheet.getRangeByName('E1').setText('DD/MM');
  sheet.getRangeByName('F1').setText('DD/MM');
  sheet.getRangeByName('G1').setText('DD/MM');
  sheet.getRangeByName('H1').setText('DD/MM');
  sheet.getRangeByName('I1').setText('DD/MM');
  sheet.getRangeByName('J1').setText('DD/MM');

  sheet.getRangeByName('D2:J2').cellStyle.hAlign = HAlignType.center;
  sheet.getRangeByName('D2:J2').cellStyle.backColor = '#92d050';
  sheet.getRangeByName('D2').setText('Sat');
  sheet.getRangeByName('E2').setText('Sun');
  sheet.getRangeByName('F2').setText('Mon');
  sheet.getRangeByName('G2').setText('Tue');
  sheet.getRangeByName('H2').setText('Wed');
  sheet.getRangeByName('I2').setText('Thu');
  sheet.getRangeByName('J2').setText('Fri');

// Save the document.
  final List<int> bytes = workbook.saveAsStream();

//Dispose the workbook.
  workbook.dispose();
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = 'WeekSummery.xlsx';
  html.document.body!.children.add(anchor);

// download
  anchor.click();

// cleanup
  html.document.body!.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
