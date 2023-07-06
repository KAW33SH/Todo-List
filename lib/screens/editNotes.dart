import 'package:flutter/material.dart';

import '../database/database.dart';

class EditNotesPage extends StatefulWidget {
  final int? id;
  final String? title;
  final String? description;
  const EditNotesPage({
    Key? key,
    this.id,
    this.title,
    this.description,
  });

  @override
  State<EditNotesPage> createState() => _EditNotesPageState();
}

class _EditNotesPageState extends State<EditNotesPage> {
  final TextEditingController _titleCtrlr = TextEditingController();
  final TextEditingController _descriptionCtrlr = TextEditingController();

  String get title => _titleCtrlr.text;
  String get description => _descriptionCtrlr.text;

  @override
  void initState() {
    super.initState();
    _titleCtrlr.text = widget.title!;
    _descriptionCtrlr.text = widget.description!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
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

                  if (widget.id != null) {
                    await SQLHelper.editNote(
                      widget.id!,
                      title,
                      description,
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
                // await SQLHelper.editNote(
                //   widget.id!,
                //   title,
                //   description,
                // );
              },
              child: const Text('Update'),
            ),
          ),
        ],
      ),
    );
  }
}
