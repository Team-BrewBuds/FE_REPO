import 'package:flutter/material.dart';

class RouletteDatePicker extends StatefulWidget {
  @override
  _RouletteDatePickerState createState() => _RouletteDatePickerState();
}

class _RouletteDatePickerState extends State<RouletteDatePicker> {
  int selectedYear = DateTime.now().year;
  final List<int> years = List.generate(101, (index) => 1970 + index); // 1970 ~ 2070

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selected Date: $selectedYear',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWheel(
                  items: years,
                  selectedItem: selectedYear,
                  onSelected: (value) {
                    setState(() {
                      selectedYear = value;
                    });
                  },
                ),

              ],
            ),
          ],
        ),
      );

  }

  Widget _buildWheel({
    required List<int> items,
    required int selectedItem,
    required ValueChanged<int> onSelected,
  }) {
    return SizedBox(
      height: 150,
      width: 100,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        perspective: 0.005,
        physics: FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildLoopingListDelegate(
          children: items
              .map((item) => Center(
            child: Text(
              item.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: item == selectedItem
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ))
              .toList(),
        ),
        onSelectedItemChanged: (index) {
          onSelected(items[index]);
        },
      ),
    );
  }


}
