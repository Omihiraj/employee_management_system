import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../components/constants.dart';
import '../controller/doc_id.dart';
import '../controller/status_changer.dart';
import '../services/fire_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    List<String> depNameList = [];
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('departments')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        depNameList.add(doc['dep-name']);
      });
    });
    setState(() {
      depList = depNameList;
    });
  }

  bool showError = false;
  int statusNo = 0;
  String startDate = "yyyy/mm/dd";
  String endDate = "yyyy/mm/dd";
  String startTime = "hh:mm";
  String endTime = "hh:mm";
  List<String> list = <String>[
    'Shift',
    'Week Off',
    'Leav',
    'Monthly Leav',
  ];
  List<String> depList = <String>[];
  String oldDepValue = "";
  String oldStatusVal = "";
  String depDropdownValue = "First Floor";
  String dropdownValue = "Shift";
  DateTime sDate = DateTime.now();
  DateTime eDate = DateTime.now();
  TimeOfDay sTime = TimeOfDay.now();
  TimeOfDay eTime = TimeOfDay.now();
  DateTime sendStartDate = DateTime.now();
  DateTime sendEndDate = DateTime.now();
  String subDocumentId = "";

  List<Meeting> meetings = <Meeting>[];
  Future<void> getDataSource(String docId) async {
    List<Meeting> calMeetings = <Meeting>[];
    final calData = await FirebaseFirestore.instance
        .collection('employees')
        .doc(docId)
        .collection('date-state')
        .get();

    calData.docs.forEach((doc) {
      String status = "";
      Color color = Colors.amber;
      int statusNo = doc["status"];
      Timestamp startTime = doc["sdate"];
      Timestamp endTime = doc["edate"];
      String subDocId = doc["doc-id"];
      String department = doc["department"];

      if (statusNo == 0) {
        status = "Shift";
        color = Colors.green;
      } else if (statusNo == 1) {
        status = "Week Off";
        color = Colors.amber;
      } else if (statusNo == 2) {
        status = "Leav";
        color = Colors.redAccent;
      } else if (statusNo == 3) {
        status = "Monthly Leav";
        color = const Color.fromARGB(255, 213, 0, 0);
      }

      calMeetings.add(Meeting(
          subDocId,
          status,
          DateTime.parse(startTime.toDate().toString()),
          DateTime.parse(endTime.toDate().toString()),
          color,
          false,
          department));
    });

    setState(() {
      meetings = calMeetings;
    });
  }

  @override
  Widget build(BuildContext context) {
    String docId = Provider.of<DocId>(context).getDocNo;
    getDataSource(docId);
    //Start DateTime
    // String sYear = "${sDate.year}";
    // String sMonth = sDate.month.toString().padLeft(2, "0");
    // String sDay = sDate.day.toString().padLeft(2, "0");
    // String sHour = sTime.hour.toString().padLeft(2, "0");
    // String sMin = sTime.minute.toString().padLeft(2, "0");
    //End DateTime
    // String eYear = "${eDate.year}";
    // String eMonth = eDate.month.toString().padLeft(2, "0");
    // String eDay = eDate.day.toString().padLeft(2, "0");
    // String eHour = eTime.hour.toString().padLeft(2, "0");
    // String eMin = eTime.minute.toString().padLeft(2, "0");

    print(sDate);

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text(
          "Status Calander",
          style: TextStyle(
              color: secondaryColor,
              fontSize: headlineText,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          InkWell(
            onTap: () {
              FireService.addAutoStatus(docId, context);
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
                      Text("Add Auto Status",
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
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 50),
            child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Add Status',
                            style: TextStyle(color: primaryColor),
                          ),
                          content:
                              StatefulBuilder(builder: (context, setState) {
                            return SizedBox(
                                width: 300,
                                height: 280,
                                child: ListView(
                                  controller: ScrollController(),
                                  children: [
                                    const Text("Start Date",
                                        style: TextStyle(color: primaryColor)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            showError == true
                                                ? const Center(
                                                    child: Text(
                                                      "Can't Add Please Select a Another Department",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent,
                                                          fontSize: 20),
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height:
                                                  showError == true ? 20 : 0,
                                            ),
                                            Text(startDate),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.calendar_month),
                                              onPressed: () async {
                                                DateTime? newDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate: sDate,
                                                        firstDate:
                                                            DateTime(1900),
                                                        lastDate:
                                                            DateTime(2100));
                                                if (newDate == null) return;
                                                setState(() {
                                                  sDate = newDate;
                                                  startDate =
                                                      "${sDate.year}/${sDate.month}/${sDate.day}";
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(startTime),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.access_time_outlined),
                                              onPressed: () async {
                                                TimeOfDay? newTime =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: sTime,
                                                );
                                                if (newTime == null) return;
                                                setState(() {
                                                  sTime = newTime;
                                                  String hour = sTime.hour
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  String minute = sTime.minute
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  startTime = "$hour:$minute";
                                                });
                                              },
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  String sYear =
                                                      "${sDate.year}";
                                                  String sMonth = sDate.month
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  String sDay = sDate.day
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  String sHour = sTime.hour
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  String sMin = sTime.minute
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  setState(() {
                                                    sendStartDate = DateTime.parse(
                                                        "$sYear-$sMonth-$sDay $sHour:$sMin");
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.add_box_outlined))
                                          ],
                                        )
                                      ],
                                    ),
                                    const Text("End Date",
                                        style: TextStyle(color: primaryColor)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(endDate),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.calendar_month),
                                              onPressed: () async {
                                                DateTime? newDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate: eDate,
                                                        firstDate:
                                                            DateTime(1900),
                                                        lastDate:
                                                            DateTime(2100));
                                                if (newDate == null) return;
                                                setState(() {
                                                  eDate = newDate;
                                                  endDate =
                                                      "${eDate.year}/${eDate.month}/${eDate.day}";
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(endTime),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.access_time_outlined),
                                              onPressed: () async {
                                                TimeOfDay? newTime =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: eTime,
                                                );
                                                if (newTime == null) return;
                                                setState(() {
                                                  eTime = newTime;
                                                  String hour = eTime.hour
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  String minute = eTime.minute
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  endTime = "$hour:$minute";
                                                });
                                              },
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  String eYear =
                                                      "${eDate.year}";
                                                  String eMonth = eDate.month
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  String eDay = eDate.day
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  String eHour = eTime.hour
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  String eMin = eTime.minute
                                                      .toString()
                                                      .padLeft(2, "0");
                                                  setState(() {
                                                    sendEndDate = DateTime.parse(
                                                        "$eYear-$eMonth-$eDay $eHour:$eMin");
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.add_box_outlined))
                                          ],
                                        )
                                      ],
                                    ),
                                    const Text("Status",
                                        style: TextStyle(color: primaryColor)),
                                    DropdownButton<String>(
                                      underline: Container(),
                                      value: dropdownValue,
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          dropdownValue = value!;
                                          if (dropdownValue == "Shift") {
                                            statusNo = 0;
                                          } else if (dropdownValue ==
                                              "Week Off") {
                                            statusNo = 1;
                                          } else if (dropdownValue == "Leav") {
                                            statusNo = 2;
                                          } else if (dropdownValue ==
                                              "Monthly Leav") {
                                            statusNo = 3;
                                          }
                                        });
                                      },
                                      items: list.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    const Text("Departments",
                                        style: TextStyle(color: primaryColor)),
                                    DropdownButton<String>(
                                      underline: Container(),
                                      value: depDropdownValue,
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          depDropdownValue = value!;
                                        });
                                      },
                                      items: depList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: secondaryColor,
                                              foregroundColor: Colors.white),
                                          onPressed: () {
                                            FireService.addStatus(
                                                    context: context,
                                                    department:
                                                        depDropdownValue,
                                                    docId: docId,
                                                    sDate: Timestamp.fromDate(
                                                        sendStartDate),
                                                    eDate: Timestamp.fromDate(
                                                        sendEndDate),
                                                    statusId: statusNo)
                                                .then((value) => {
                                                      if (value == false)
                                                        {
                                                          setState(() {
                                                            showError = true;
                                                          })
                                                        }
                                                    });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Add"),
                                        ))
                                  ],
                                ));
                          }),
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
                        Text("Add Status",
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            color: bgColor,
            height: 10.0,
          ),
        ),
      ),
      body: SfCalendar(
        firstDayOfWeek: 6,
        view: CalendarView.month,
        dataSource: MeetingDataSource(meetings),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          dayFormat: 'EEE',
        ),
        showNavigationArrow: true,
        onTap: (CalendarTapDetails details) {
          dynamic appointment = details.appointments;
          DateTime date = details.date!;
          CalendarElement element = details.targetElement;

          setState(() {
            sDate = details.appointments!.first.from;
            startDate = "${sDate.year}/${sDate.month}/${sDate.day}";
            startTime = "${sDate.hour}:${sDate.minute}";
            eDate = details.appointments!.first.to;
            endDate = "${eDate.year}/${eDate.month}/${eDate.day}";
            endTime = "${eDate.hour}:${eDate.minute}";
            depDropdownValue = details.appointments!.first.department;
            dropdownValue = details.appointments!.first.eventName;
            subDocumentId = details.appointments!.first.docId;
            oldDepValue = details.appointments!.first.department;
            oldStatusVal = details.appointments!.first.eventName;
          });
          if (appointment.length == 0) {
            return;
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Edit Status',
                      style: TextStyle(color: primaryColor),
                    ),
                    content: SizedBox(
                      width: 300,
                      height: 280,
                      child: StatefulBuilder(builder: (context, setState) {
                        return ListView(
                          controller: ScrollController(),
                          children: [
                            showError == true
                                ? const Center(
                                    child: Text(
                                      "Can't Update Please Select a Another Department",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 20),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: showError == true ? 20 : 0,
                            ),
                            const Text("Start Date",
                                style: TextStyle(color: primaryColor)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(startDate),
                                    IconButton(
                                      icon: const Icon(Icons.calendar_month),
                                      onPressed: () async {
                                        DateTime? newDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: sDate,
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));
                                        if (newDate == null) return;
                                        setState(() {
                                          sDate = newDate;
                                          startDate =
                                              "${sDate.year}/${sDate.month}/${sDate.day}";
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(startTime),
                                    IconButton(
                                      icon: const Icon(
                                          Icons.access_time_outlined),
                                      onPressed: () async {
                                        TimeOfDay? newTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: sTime,
                                        );
                                        if (newTime == null) return;
                                        setState(() {
                                          sTime = newTime;
                                          String hour = sTime.hour
                                              .toString()
                                              .padLeft(2, "0");
                                          String minute = sTime.minute
                                              .toString()
                                              .padLeft(2, "0");
                                          startTime = "$hour:$minute";
                                        });
                                      },
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          String sYear = "${sDate.year}";
                                          String sMonth = sDate.month
                                              .toString()
                                              .padLeft(2, "0");
                                          String sDay = sDate.day
                                              .toString()
                                              .padLeft(2, "0");
                                          String sHour = sTime.hour
                                              .toString()
                                              .padLeft(2, "0");
                                          String sMin = sTime.minute
                                              .toString()
                                              .padLeft(2, "0");
                                          setState(() {
                                            sendStartDate = DateTime.parse(
                                                "$sYear-$sMonth-$sDay $sHour:$sMin");
                                          });
                                        },
                                        icon:
                                            const Icon(Icons.add_box_outlined))
                                  ],
                                ),
                              ],
                            ),
                            const Text("End Date",
                                style: TextStyle(color: primaryColor)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(endDate),
                                    IconButton(
                                      icon: const Icon(Icons.calendar_month),
                                      onPressed: () async {
                                        DateTime? newDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: eDate,
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));
                                        if (newDate == null) return;
                                        setState(() {
                                          eDate = newDate;
                                          endDate =
                                              "${eDate.year}/${eDate.month}/${eDate.day}";
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(endTime),
                                    IconButton(
                                      icon: const Icon(
                                          Icons.access_time_outlined),
                                      onPressed: () async {
                                        TimeOfDay? newTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: eTime,
                                        );
                                        if (newTime == null) return;
                                        setState(() {
                                          eTime = newTime;
                                          String hour = eTime.hour
                                              .toString()
                                              .padLeft(2, "0");
                                          String minute = eTime.minute
                                              .toString()
                                              .padLeft(2, "0");
                                          endTime = "$hour:$minute";
                                        });
                                      },
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          String eYear = "${eDate.year}";
                                          String eMonth = eDate.month
                                              .toString()
                                              .padLeft(2, "0");
                                          String eDay = eDate.day
                                              .toString()
                                              .padLeft(2, "0");
                                          String eHour = eTime.hour
                                              .toString()
                                              .padLeft(2, "0");
                                          String eMin = eTime.minute
                                              .toString()
                                              .padLeft(2, "0");
                                          setState(() {
                                            sendEndDate = DateTime.parse(
                                                "$eYear-$eMonth-$eDay $eHour:$eMin");
                                          });
                                        },
                                        icon:
                                            const Icon(Icons.add_box_outlined))
                                  ],
                                )
                              ],
                            ),
                            const Text("Status",
                                style: TextStyle(color: primaryColor)),
                            DropdownButton<String>(
                              underline: Container(),
                              value: dropdownValue,
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue = value!;
                                  if (dropdownValue == "Shift") {
                                    statusNo = 0;
                                  } else if (dropdownValue == "Week Off") {
                                    statusNo = 1;
                                  } else if (dropdownValue == "Leav") {
                                    statusNo = 2;
                                  } else if (dropdownValue == "Monthly Leav") {
                                    statusNo = 3;
                                  }
                                });
                              },
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            dropdownValue == "Shift"
                                ? const Text("Department",
                                    style: TextStyle(color: primaryColor))
                                : Container(),
                            dropdownValue == "Shift"
                                ? DropdownButton<String>(
                                    underline: Container(),
                                    value: depDropdownValue,
                                    onChanged: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        depDropdownValue = value!;
                                      });
                                    },
                                    items: depList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )
                                : Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white),
                                  onPressed: () {
                                    FireService.updateStatus(
                                            context: context,
                                            oldStatus:
                                                oldStatusVal == "Shift" ? 0 : 1,
                                            oldDep: oldDepValue,
                                            department: dropdownValue == "Shift"
                                                ? depDropdownValue
                                                : "",
                                            docId: docId,
                                            sDate: Timestamp.fromDate(
                                                sendStartDate),
                                            eDate:
                                                Timestamp.fromDate(sendEndDate),
                                            statusId: statusNo,
                                            subDocId: subDocumentId)
                                        .then((value) => {
                                              if (value == false)
                                                {
                                                  setState(() {
                                                    showError = true;
                                                  })
                                                }
                                            });
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Update"),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white),
                                  onPressed: () {
                                    FireService.deleteStatus(
                                        docId: docId,
                                        subDocId: subDocumentId,
                                        oldStatus:
                                            oldStatusVal == "Shift" ? 0 : 1,
                                        oldDep: oldDepValue);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Delete"),
                                )
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.docId, this.eventName, this.from, this.to, this.background,
      this.isAllDay, this.department);
  String docId;
  String eventName;
  String department;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
