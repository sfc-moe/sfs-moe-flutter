import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sfs/pages/assignments.dart';
import 'package:sfs/utils/consts.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportCardWidget extends StatelessWidget {
  ReportCardWidget({@required this.assignment, @required this.background});

  final Assignment assignment;
  final Color background;
  final formatter = DateFormat.yMEd().add_jms();
  final textFormat =
      TextStyle(color: Color.fromARGB(0xff, 0xff, 0xff, 0xff), fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 5, right: 10, bottom: 5, left: 10),
        child: Card(
          color: background,
          child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                  onTap: () async {
                    await launch("${Consts.SFS_HOST}/sfs_class/student/${assignment.link}");
                  },
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: 20, right: 20, bottom: 20, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(assignment.course, style: textFormat),
                          SizedBox(height: 16),
                          Text(assignment.title, style: textFormat),
                          SizedBox(height: 16),
                          Text(formatter.format(assignment.deadline.toLocal()),
                              style: textFormat),
                        ],
                      )))),
        ));
  }
}
