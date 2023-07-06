import 'package:flutter/material.dart';

import 'addNotes.dart';
import '../database/database.dart';
import 'editNotes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> notes = [];

  void _refresh() async {
    final data = await SQLHelper.getNotes();
    setState(() {
      notes = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  final TextEditingController _searchCtrlr = TextEditingController();

  void _search(String text) async {
    final data = await SQLHelper.searchNotes(text);
    setState(() {
      notes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // bold title text
        title: const Text('Notes'),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    _refresh();
                  },
                  icon: const Icon(Icons.refresh)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final data = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddNotesPage()));
                  if (data == null) {
                    _refresh();
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrlr,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                labelText: 'Search',
              ),
              onChanged: _search,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(note['title']),
                      subtitle: Text(note['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final data = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditNotesPage(
                                    id: note['id'],
                                    title: note['title'],
                                    description: note['description'],
                                  ),
                                ),
                              );
                              if (data == null) {
                                _refresh();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
// confirmation box
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Note?'),
                                  content: const Text(
                                      'Are you sure you want to delete this note?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await SQLHelper.deleteNote(note['id']);
                                        _refresh();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
