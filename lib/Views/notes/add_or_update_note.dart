import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/services/crud/notes_services.dart';
import 'package:untitled1/utils/gradients/gradient_widget.dart';

import '../../services/auth/auth_services.dart';

class AddOrUpdateNewNote extends StatefulWidget {
  const AddOrUpdateNewNote({Key? key}) : super(key: key);

  @override
  State<AddOrUpdateNewNote> createState() => _AddOrUpdateNewNoteState();
}

class _AddOrUpdateNewNoteState extends State<AddOrUpdateNewNote> {
  DataBaseNote? _note;
  late final NotesServices _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesServices();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
   }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DataBaseNote> createOrUpdateNewNote(BuildContext context) async {
    DataBaseNote? notes =
        ModalRoute.of(context)?.settings.arguments as DataBaseNote?;

    if (notes != null) {
      _note = notes;
      _textController.text = notes.text;
      return notes;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthServices.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getDataBaseUser(email: email);
    final newNote = await _notesService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {

    final note = _note;
    if (_textController.text.trim().isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text.trim();
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GradientWidget(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.arrow_left),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: createOrUpdateNewNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // _note = snapshot.data as DataBaseNote?;
              _setupTextControllerListener();
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(

                  cursorColor: Colors.black,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                  ),
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your note...',
                  ),
                ),
              );
            default:
              return const Center(child:
              CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
