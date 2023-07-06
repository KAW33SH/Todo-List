import 'package:flutter/material.dart';

import '../database/database.dart';

class AddNotesPage extends StatefulWidget {
  final int? id;
  final String? title;
  final String? description;
  // final Function() onEdit;
  const AddNotesPage({
    Key? key,
    this.id,
    this.title,
    this.description,
  });

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  final TextEditingController _titleCtrlr = TextEditingController();
  final TextEditingController _descriptionCtrlr = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleCtrlr.clear();
    _descriptionCtrlr.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // add note button
        title: const Text('Add Note'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleCtrlr,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descriptionCtrlr,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  if (_titleCtrlr.text.isEmpty) {
                    throw Exception('Title cannot be empty');
                  }
                  if (_descriptionCtrlr.text.isEmpty) {
                    throw Exception('Description cannot be empty');
                  }

                  if (widget.id == null) {
                    await SQLHelper.createNote(
                      _titleCtrlr.text,
                      _descriptionCtrlr.text,
                    );
                  }
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
                // await SQLHelper.createNote(
                //   _titleCtrlr.text,
                //   _descriptionCtrlr.text,
                // );
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
