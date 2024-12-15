import 'package:flutter/material.dart';

class RecordFlaverWdgt extends StatefulWidget {
  const RecordFlaverWdgt({super.key});

  @override
  State<RecordFlaverWdgt> createState() => _RecordFlaverWdgtState();
}

class _RecordFlaverWdgtState extends State<RecordFlaverWdgt> {
  List<String> _selectedValues = List.generate(5, (index) => 'O 1');  // 여러 개의 기본값


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,  // 5개의 항목
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Item ${index + 1}"),
          trailing: DropdownButton<String>(
            value: _selectedValues[index],
            items: <String>['O 1', 'O 2', 'O 3', 'O 4']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedValues[index] = newValue!;  // 선택된 값을 업데이트
              });
            },
          ),
        );
      },
    );
  }
}
