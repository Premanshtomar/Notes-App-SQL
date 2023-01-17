import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled1/utils/gradients/gradient_widget.dart';

import '../../services/crud/notes_services.dart';
import '../../utils/gradients/linear_gradient.dart';
import '../../utils/show_dialogs.dart';

typedef NoteCallBack = void Function(DataBaseNote note);

class AllNotes extends StatelessWidget {
  const AllNotes(
      {Key? key,
      required this.notes,
      required this.onDeleteNote,
      required this.onTaped})
      : super(key: key);

  final List<DataBaseNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTaped;

  @override
  Widget build(BuildContext context) {
    return notes.isEmpty
        ? const Center(
            child: GradientWidget(
              child: Text('All set to add your\nnotes Here!',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  textScaleFactor: 2,
                  textAlign: TextAlign.center),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(18),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              var note = notes[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onLongPressStart: (LongPressStartDetails details) {
                    var position = details.globalPosition;

                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                          position.dx, position.dy, 10000, 0),
                      items: [
                        PopupMenuItem(
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final shouldDelete =
                                  await showDeleteDialog(context);
                              if (shouldDelete) {
                                onDeleteNote(note);
                              }
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: IconButton(
                            onPressed: () {
                              Share.share(note.text);
                            },
                            icon: const Icon(Icons.share),
                          ),
                        )
                      ],
                    );
                  },
                  onTap: () {
                    onTaped(note);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      gradient: Gradients.getGradient(index),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          spreadRadius: 0,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    // height: MediaQuery.of(context).size.height*0.1,
                    // width: 200,
                    child: Text(
                      note.text,
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
