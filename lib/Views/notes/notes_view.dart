// import 'package:flutter/cupertino.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/Views/notes/displaying_notes.dart';
import 'package:untitled1/enum/menu_action.dart';
import 'package:untitled1/services/auth/auth_services.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc.dart';
import 'package:untitled1/services/auth/bloc/auth_bloc_events.dart';
import 'package:untitled1/services/crud/notes_services.dart';
import 'package:untitled1/utils/gradients/gradient_widget.dart';
import 'package:untitled1/utils/dialog/show_dialogs.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late final NotesServices _notesServices;

  String get userEmail => AuthServices.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesServices = NotesServices();
    _notesServices.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.white,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/notes.png'),
            fit: BoxFit.fill,
          ),
        ),
        // drawer: const Drawer(),

        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            title: GradientWidget(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Icon(Icons.favorite_border),
                  Text(
                    'All Notes!',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'pac',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              GradientWidget(
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_new_note/');
                    // showCustomErrorDialog(context);
                  },
                  icon: const Icon(
                    CupertinoIcons.add_circled,
                    color: Colors.black,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: GradientWidget(
                  colors: const [
                    Colors.blue,
                    Colors.pink,
                  ],
                  blendMode: BlendMode.srcIn,
                  child: Icon(
                    Icons.adaptive.more,
                    color: Colors.black,
                  ),
                ),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                        value: MenuAction.logout, child: Text('Log Out'))
                  ];
                },
                onSelected: (value) async {
                  switch (value) {
                    case MenuAction.logout:
                      final shouldLogout = await showLogOutDialog(context);
                      if (shouldLogout) {
                        // ignore: use_build_context_synchronously
                        context.read<AuthBloc>().add(const LogOutEvent());
                      }
                  }
                },
              ),
            ],
          ),
          body: FutureBuilder(
            future: _notesServices.getOrCreateUser(email: userEmail),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: _notesServices.allNOtes,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as List<DataBaseNote>;
                            return AllNotes(notes: allNotes,onDeleteNote: (note) async{
                              await _notesServices.deleteNote(id: note.id);
                            }, onTaped: (DataBaseNote note) {
                              Navigator.pushNamed(context, '/add_new_note/',
                              arguments: note,
                              );
                            },);
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        default:
                          return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}
