import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'date_range_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CustomPopupMenu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
        body: Center(
          child: ExampleDateRangePicker(),
        ),
      ),
    );
  }
}

class ExampleDateRangePicker extends StatefulWidget {
  const ExampleDateRangePicker({Key? key}) : super(key: key);

  @override
  State<ExampleDateRangePicker> createState() => _ExampleDateRangePickerState();
}

class _ExampleDateRangePickerState extends State<ExampleDateRangePicker> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.deepOrangeAccent,
      onPressed: () async {
        final List<DateTime>? picked = await showCustomDateRangePicker(
          context: context,
          initialFirstDate: DateTime.now(),
          initialLastDate: (DateTime.now()).add(const Duration(days: 7)),
          firstDate: DateTime(2015),
          lastDate: DateTime(
            DateTime.now().year + 2,
          ),
        );
        if (picked != null) {
          if (picked.length == 2) {
            if (kDebugMode) {
              print(picked);
            }
          }
        }
      },
      child: const Text("Pick date range"),
    );
  }

  theme() {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.black,
        buttonTheme: ButtonThemeData(
            highlightColor: Colors.green,
            buttonColor: Colors.green,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                secondary: Colors.red,
                background: Colors.white,
                primary: Colors.green,
                brightness: Brightness.dark,
                onBackground: Colors.green),
            textTheme: ButtonTextTheme.accent),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.green,
        ),
      ),
      child: Builder(
        builder: (context) => ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromRGBO(212, 20, 15, 1.0)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
          ),
          child: const Padding(
            padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
            child: Text(
              "Date Picker",
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 28,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          onPressed: () async {
            final List<DateTime>? picked = await showCustomDateRangePicker(
              context: context,
              initialFirstDate: DateTime.now(),
              initialLastDate: (DateTime.now()).add(const Duration(days: 7)),
              firstDate: DateTime(2015),
              lastDate: DateTime(DateTime.now().year + 2),
            );
            if (picked != null) {
              if (picked.length == 2) {
                if (kDebugMode) {
                  print(picked);
                }
              }
            }
          },
        ),
      ),
    );
  }
}
