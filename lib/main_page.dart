import 'package:employee_management/pages/departments.dart';
import 'package:employee_management/pages/employees.dart';
import 'package:employee_management/pages/status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/constants.dart';
import 'controller/page_controller.dart';
import 'pages/calendar_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  var pages = [
    const Status(),
    const Employees(),
    const Departments(),
    const CalendarPage()
  ];
  final pageNo = PageModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Row(
      children: [
        Expanded(
          child: Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Image.asset(
                      "assets/images/logo.png",
                      
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.home_filled,
                      color: Provider.of<PageModel>(context).getPageNo == 0
                          ? Colors.white
                          : secondaryColor,
                    ),
                    tileColor: Provider.of<PageModel>(context).getPageNo == 0
                        ? primaryColor
                        : Colors.white,
                    onTap: () {
                      Provider.of<PageModel>(context, listen: false)
                          .currentPage(0);
                    },
                    horizontalTitleGap: 0,
                    title: Text(
                      "Status",
                      style: TextStyle(
                        color: Provider.of<PageModel>(context).getPageNo == 0
                            ? Colors.white
                            : secondaryColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.list_alt_rounded,
                      color: Provider.of<PageModel>(context).getPageNo == 1
                          ? Colors.white
                          : secondaryColor,
                    ),
                    tileColor: Provider.of<PageModel>(context).getPageNo == 1
                        ? primaryColor
                        : Colors.white,
                    onTap: () {
                      Provider.of<PageModel>(context, listen: false)
                          .currentPage(1);
                    },
                    horizontalTitleGap: 0,
                    title: Text(
                      "Employees",
                      style: TextStyle(
                        color: Provider.of<PageModel>(context).getPageNo == 1
                            ? Colors.white
                            : secondaryColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.people,
                      color: Provider.of<PageModel>(context).getPageNo == 2
                          ? Colors.white
                          : secondaryColor,
                    ),
                    tileColor: Provider.of<PageModel>(context).getPageNo == 2
                        ? primaryColor
                        : Colors.white,
                    onTap: () {
                      Provider.of<PageModel>(context, listen: false)
                          .currentPage(2);
                    },
                    horizontalTitleGap: 0,
                    title: Text(
                      "Departments",
                      style: TextStyle(
                        color: Provider.of<PageModel>(context).getPageNo == 2
                            ? Colors.white
                            : secondaryColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: secondaryColor,
                    ),
                    tileColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    horizontalTitleGap: 0,
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
            flex: 5, child: pages[Provider.of<PageModel>(context).getPageNo])
      ],
    )));
  }
}
