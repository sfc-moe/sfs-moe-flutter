// Text("Error Occured")

import 'package:dio/dio.dart';
import 'package:euc/euc.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:sfs/components/report_card.dart';
import 'package:sfs/utils/consts.dart';
import 'package:sfs/utils/sfs_auth.dart';
import 'package:sfs/utils/time_helper.dart';

class Assignment {
  Assignment(
      {this.course, this.submitted, this.deadline, this.title, this.link});
  String course;
  bool submitted;
  DateTime deadline;
  String title;
  String link;
}

class AssignmentsWidget extends StatefulWidget {
  @override
  _AssignmentsWidgetState createState() => new _AssignmentsWidgetState();
}

class _AssignmentsWidgetState extends State<StatefulWidget> {
  _AssignmentsWidgetState() {
    fetchData();
  }

  var _cardList = <Widget>[];
  bool _isLoading = true;

  void fetchData() async {
    final cardList = <Widget>[];

    final client = Dio();
    // Fetch timetables
    final timetable = await client.get(
      '${Consts.SFS_HOST}/sfs_class/student/view_timetable.cgi',
      queryParameters: {
        'id': await SfsAuth.token,
        'term': TimeHelper.term,
        'fix': await SfsAuth.fix,
        'lang': 'ja',
      },
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
        responseType: ResponseType.bytes,
      ),
    );

    final dom = parse(EucJP().decode(timetable.data));
    final links = dom.querySelectorAll("td > a").map((ele) {
      return ele.attributes['href'];
    }).toSet();

    final reportFutures = links.map((link) async {
      final report = await client.get(
        link,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.bytes,
        ),
      );
      final reportDom = parse(EucJP().decode(report.data));
      final exp = new RegExp(r"deadline: (.*?)/(.*?) (.*?):(.*?),");
      return reportDom.querySelectorAll('a[target="report"]').map((a) {
        final deadline = exp.firstMatch(a.parent.text);
        return Assignment(
          course: reportDom.querySelector('h3.one').innerHtml.split("<")[0],
          submitted: !a.parent.text.contains('未提出'),
          deadline: TimeHelper.getDeadline(
            int.parse(deadline.group(1)),
            int.parse(deadline.group(2)),
            int.parse(deadline.group(3)),
            int.parse(deadline.group(4)),
          ),
          title: a.text,
          link: a.attributes['href'],
        );
      }).toList();
    });

    final reports =
        (await Future.wait(reportFutures)).expand((i) => i).toList();

    final upcoming = reports
        .where((a) => a.submitted == false)
        .where((a) => a.deadline.isAfter(DateTime.now()))
        .toList();
    upcoming.sort((a, b) => a.deadline.compareTo(b.deadline));

    final missed = reports
        .where((a) => a.submitted == false)
        .where((a) => a.deadline.isBefore(DateTime.now()))
        .toList();
    missed.sort((a, b) => a.deadline.compareTo(b.deadline));

    final finished = reports.where((a) => a.submitted == true).toList();
    finished.sort((a, b) => -a.deadline.compareTo(b.deadline));

    cardList.add(
      Text(
        "Upcoming",
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
      ),
    );

    if (upcoming.length == 0) {
      cardList.add(SizedBox(height: 16));
      cardList.add(Center(child: Text(
        "Empty",
        style: TextStyle(fontSize: 24),
      )));
      cardList.add(SizedBox(height: 16));
    }

    cardList.addAll(upcoming.map((a) => ReportCardWidget(
          assignment: a,
          background: Color.fromARGB(0xff, 0x18, 0x62, 0xff),
        )));

    cardList.add(
      Text(
        "Missed",
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
      ),
    );

    if (missed.length == 0) {
      cardList.add(SizedBox(height: 16));
      cardList.add(Center(child: Text(
        "Empty",
        style: TextStyle(fontSize: 24),
      )));
      cardList.add(SizedBox(height: 16));
    }

    cardList.addAll(missed.map((a) => ReportCardWidget(
          assignment: a,
          background: Color.fromARGB(0xff, 0x21, 0x21, 0x21),
        )));

    cardList.add(
      Text(
        "Finished",
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
      ),
    );

    if (finished.length == 0) {
      cardList.add(SizedBox(height: 16));
      cardList.add(Center(child: Text(
        "Empty",
        style: TextStyle(fontSize: 24),
      )));
      cardList.add(SizedBox(height: 16));
    }

    cardList.addAll(finished.map((a) => ReportCardWidget(
          assignment: a,
          background: Color.fromARGB(0xff, 0x1e, 0xd2, 0x80),
        )));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _cardList = cardList;
      });
    }
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          padding: const EdgeInsets.all(8),
          children: _cardList,
        ),
        _showCircularProgress(),
      ],
    );
  }
}
