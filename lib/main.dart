//ENTRY POINT - Sets up DI, provides the BLoC, launches the app.
//
//Blocprovider sits here (above MaterialApp) so the bloC is availabe.
//throughout the entire widget tree.

import 'package:bloc_todo/features/presentation/bloc/todo_bloc.dart';
import 'package:bloc_todo/features/presentation/pages/todo_page.dart';
import 'package:bloc_todo/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Wire up all dependencies before the app starts
  await di.initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //di.sl<TodoBloc>() pulls the factory-registered BLoC from get_it
    return BlocProvider(
    /// In the provided Dart code snippet, the line `create: (_) => di.sl<TodoBloc>(),` is setting up
    /// the creation of a `TodoBloc` instance using a dependency injection container.
      create: (_) => di.sl<TodoBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
          useMaterial3: true,
          fontFamily: 'SF Pro Display',
        ),
        home: const TodoPage(),
      ),
    );
  }
}
