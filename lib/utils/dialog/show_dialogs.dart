import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      builder: (context) {
       return AlertDialog(
          title: const Text('Error!'),
          content: Text(text),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            },
                child: const Text('ok')
          )
          ],
        );
      });
}


//Used in Notes View.
Future<bool> showLogOutDialog(BuildContext context){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: const Text('Logout?'),
      content: const Text("Sure you want to Logout?"),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop(false);
        },
            child: const Text('Cancel')),
        TextButton(onPressed: () {
          Navigator.of(context).pop(true);
        },
            child: const Text('Logout'))

      ],
    );
  }).then((value) => value ?? false);
}


Future<bool> showDeleteDialog(BuildContext context){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: const Text('Delete?'),
      content: const Text("Sure you want to Delete?"),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop(false);
        },
            child: const Text('Cancel')),
        TextButton(onPressed: () {
          Navigator.of(context).pop(true);
        },
            child: const Text('Delete?'))

      ],
    );
  }).then((value) => value ?? false);
}

Future<void> showCanNotShareDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('sharing!'),
          content: Text(text),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            },
                child: const Text('ok')
            )
          ],
        );
      });
}


// Future<void> showCustomErrorDialog(BuildContext context){
//   return showDialog(context: context, builder: (context){
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Container(
//         decoration: BoxDecoration(),
//         height: 200,
//         child: Column(
//           children: [
//             Container(
//               height: 100,
//               color: Colors.white,
//               child: const Icon(Icons.delete_forever,size: 100,)
//             ),
//             Container(
//               height: 100,
//               color: Colors.yellow,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: const [Icon(Icons.add),
//                 Icon(Icons.safety_divider)],
//               ),
//               // child: const Text('tt'),
//             )
//           ],
//         ),
//       ),
//     );
//   });
// }