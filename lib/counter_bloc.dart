// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _textController;
//
//   @override
//   void initState() {
//     _textController = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => (CounterBloc()),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('testing bloc'),
//         ),
//         body: Center(child: const Text('testing')),
//       ),
//     );
//   }
// }
// abstract class CounterState {
//   final int value;
//
//   const CounterState(this.value);
// }
//
// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }
//
// class CounterStateInvalid extends CounterState {
//   final String invalidValue;
//
//   const CounterStateInvalid(
//       {required this.invalidValue, required int previousValue})
//       : super(previousValue);
// }
//
// abstract class CounterEvent {
//   final String value;
//
//   const CounterEvent(this.value);
// }
//
// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }
//
// class DecrementValue extends CounterEvent {
//   const DecrementValue(String value) : super(value);
// }
//
// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on(<IncrementValue>(event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalid(
//           previousValue: state.value,
//           invalidValue: event.value,
//         ));
//       } else {
//         emit(CounterStateValid(state.value + integer));
//       }
//     });
//     on(<DecrementValue>(event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalid(
//           invalidValue: event.value,
//           previousValue: state.value,
//         ));
//       }else{
//         emit(CounterStateValid(state.value - integer));
//       }
//     });
//   }
// }