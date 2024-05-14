import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Daily Schedule',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(100),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(100),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Time',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Subject',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Room',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('09:00 - 10:00'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Mathematics'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('101'),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('10:15 - 11:15'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Physics'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('102'),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('11:30 - 12:30'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Chemistry'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('103'),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
