import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:task_management/model/notes_model.dart';

class Edit_Screen extends StatefulWidget {
  Note _todo;
  Edit_Screen(this._todo, {super.key});

  @override
  State<Edit_Screen> createState() => _Edit_ScreenState();
}

class _Edit_ScreenState extends State<Edit_Screen> {
  TextEditingController? title;
  TextEditingController? subtitle;
  TextEditingController? selectedDate;
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  int indexx = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = TextEditingController(text: widget._todo.title);
    subtitle = TextEditingController(text: widget._todo.subtitle);
    selectedDate = TextEditingController(text: widget._todo.selectedDate);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management Tool'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title_widgets(),
            SizedBox(height: 20),
            subtite_wedgite(),
            SizedBox(height: 20),
            dateSelecter(context),
            SizedBox(height: 40),
            button()
          ],
        ),
      ),
    );
  }

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: Size(170, 48),
          ),
          onPressed: () async {
            if (title.text.isNotEmpty) {
              // Check if the title text field is not empty
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Task edited"),
                duration: Duration(seconds: 3),
              ));
              await saveTodo(title.text, subtitle.text,
                  selectedDate); // Call saveTodo with text values
              // to redirect
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Title Cannot be Empty"),
                duration: Duration(seconds: 5),
              ));
            }
          },
          child: Text(
            'Edit Task',
            style: TextStyle(
              color: Colors.white, // Set the text color here
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: Size(170, 48),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white, // Set the text color here
            ),
          ),
        ),
      ],
    );
  }

  Widget title_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: title,
          focusNode: _focusNode1,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: 'title',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color(0xffc5c5c5),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              )),
        ),
      ),
    );
  }

  Padding subtite_wedgite() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          maxLines: 3,
          controller: subtitle,
          focusNode: _focusNode2,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'subtitle',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xffc5c5c5),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dateSelecter(BuildContext context) {
    Future<void> _selectDate() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2024),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null && pickedDate != selectedDate) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20), // Add horizontal padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Due Date:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 10), // Add spacing between text and date
              Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20), // Add spacing between text and date

              ElevatedButton(
                onPressed: () => _selectDate(),
                child: Text('Change Date'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> saveTodo(
    String title, String subtitle, DateTime selectedDate) async {
  print("in save");
  final todo = ParseObject('Todo')
    ..set('title', title)
    ..set('subtitle', subtitle)
    ..set('selectedDate', selectedDate)
    ..set('done', false);
  await todo.save();
}
