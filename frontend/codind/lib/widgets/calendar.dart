/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-13 22:10:24
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-13 23:03:54
 */

/// diy a scroll bar  https://www.jianshu.com/p/c14c5bd649c2

import 'package:codind/bloc/gantt_bloc.dart';
import 'package:codind/utils/common.dart' as my;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class CalendarWidget extends StatefulWidget {
  CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerJan = ScrollController();
  ScrollController scrollControllerFeb = ScrollController();
  ScrollController scrollControllerMar = ScrollController();
  ScrollController scrollControllerApr = ScrollController();
  ScrollController scrollControllerMay = ScrollController();
  ScrollController scrollControllerJun = ScrollController();
  ScrollController scrollControllerJul = ScrollController();
  ScrollController scrollControllerAug = ScrollController();
  ScrollController scrollControllerSep = ScrollController();
  ScrollController scrollControllerOct = ScrollController();
  ScrollController scrollControllerNov = ScrollController();
  ScrollController scrollControllerDec = ScrollController();
  GlobalKey globalKey = GlobalKey();

  List<ScrollController> _scrollList = [];

  late double dx = 0;
  final my.DateUtils _dateUtils = my.DateUtils();

  // int year = 2022;
  Map<String, int> data = {};
  late GanttBloc _ganttBloc;

  @override
  void initState() {
    super.initState();
    _ganttBloc = context.read<GanttBloc>();
    _scrollList = [
      scrollControllerJan,
      scrollControllerFeb,
      scrollControllerMar,
      scrollControllerApr,
      scrollControllerMay,
      scrollControllerJun,
      scrollControllerJul,
      scrollControllerAug,
      scrollControllerSep,
      scrollControllerOct,
      scrollControllerNov,
      scrollControllerDec
    ];
    data = _dateUtils.data;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;
    for (var i in _scrollList) {
      i.jumpTo(metrics.pixels);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // List days = List.generate(365, (e) => e);

    // print(_ganttBloc.state.getDates());

    List<ScheduleDates> scheduleDates = _ganttBloc.state.getDates();

    List _days = data.values.toList();
    // print(_days);
    var _all = List.generate(31, (i) => i);
    // print(DateTime(2022, 1, 2).isSunday);
    return Scaffold(
      appBar: AppBar(
        title: Text(_dateUtils.year.toString()),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _days
                .asMap()
                .map((key, value) {
                  var _l = List.generate(value, (i) => i);
                  if (key == 0) {
                    return MapEntry(
                        key,
                        NotificationListener<ScrollNotification>(
                          onNotification: _handleScrollNotification,
                          child: SingleChildScrollView(
                            key: UniqueKey(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: _l.map((e) {
                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  height: 20,
                                  width: 20,
                                  alignment: Alignment.center,
                                  child: Text((e + 1).toString()),
                                  color:
                                      const Color.fromARGB(255, 175, 147, 145),
                                );
                              }).toList(),
                            ),
                          ),
                        ));
                  }
                  return MapEntry(
                      key,
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        key: UniqueKey(),
                        scrollDirection: Axis.horizontal,
                        controller: _scrollList[key - 1],
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _all.map((e) {
                            if (e < _days[key]) {
                              var utc = DateTime(_dateUtils.year, key, e + 1)
                                      .isSaturday ||
                                  DateTime(_dateUtils.year, key, e + 1)
                                      .isSunday;
                              var thisDay =
                                  DateTime(_dateUtils.year, key, e + 1);
                              // var hasThings = _ganttBloc.state
                              //     .getDates()
                              //     .contains(
                              //         DateTime(_dateUtils.year, key, e + 1));
                              BoxStatus status = BoxStatus.nothing;
                              for (var sd in scheduleDates) {
                                if (sd.dates.contains(thisDay)) {
                                  status = sd.status;
                                }
                              }

                              return DayBox(
                                isWeekend: utc,
                                rowId: key,
                                columnId: e,
                                boxStatus: status,
                              );
                            } else {
                              return DayBox(
                                isWeekend: false,
                                rowId: key,
                                columnId: e,
                                boxStatus: BoxStatus.cannotSelected,
                              );
                            }
                          }).toList(),
                        ),
                      ));
                })
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}

class DayBox extends StatefulWidget {
  DayBox(
      {Key? key,
      required this.rowId,
      required this.columnId,
      this.boxStatus,
      required this.isWeekend})
      : super(key: key);
  int rowId;
  int columnId;
  BoxStatus? boxStatus;
  bool isWeekend;

  @override
  State<DayBox> createState() => _DayBoxState();
}

class _DayBoxState extends State<DayBox> {
  late Color backgroundColor;
  String tootipMessage = "";
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    if (widget.boxStatus == BoxStatus.nothing) {
      backgroundColor = Colors.white;
    } else if (widget.boxStatus == BoxStatus.delayed) {
      backgroundColor = Colors.red;
    } else if (widget.boxStatus == BoxStatus.done) {
      backgroundColor = Colors.green;
    } else if (widget.boxStatus == BoxStatus.underGoing) {
      backgroundColor = const Color.fromARGB(255, 28, 103, 189);
    } else {
      backgroundColor = Colors.yellow;
    }

    tootipMessage = widget.isWeekend
        ? widget.rowId.toString() +
            "月" +
            (widget.columnId + 1).toString() +
            "日" +
            " 周末"
        : widget.rowId.toString() +
            "月" +
            (widget.columnId + 1).toString() +
            "日";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: widget.isWeekend
              ? Border.all(
                  color: const Color.fromARGB(255, 47, 98, 133),
                  width: isSelected ? 2 : 1)
              : Border.all(color: Colors.grey[500]!, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(5)),
      child: Tooltip(
        message:
            widget.boxStatus != BoxStatus.cannotSelected ? tootipMessage : "",
        child: InkWell(
          onTap: widget.boxStatus == BoxStatus.cannotSelected
              ? null
              : () {
                  // debugPrint(tootipMessage);
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
          onDoubleTap: () async {
            String res = await showCupertinoDialog(
                context: context,
                builder: (context) {
                  var s = "";
                  return CupertinoAlertDialog(
                    title: const Text("输入日程"),
                    content: Material(
                      child: TextField(
                        onChanged: ((value) => s = value),
                        maxLines: null,
                      ),
                    ),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.of(context).pop(s);
                        },
                        child: Text(
                            FlutterI18n.translate(context, "button.label.ok")),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(FlutterI18n.translate(
                            context, "button.label.quit")),
                      )
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
