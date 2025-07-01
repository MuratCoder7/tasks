import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:tasks/presentation/bloc/completed_tasks_bloc.dart";
import "package:tasks/presentation/bloc/home_bloc.dart";
import "package:tasks/presentation/pages/starter_page.dart";

import "core/services/root_service.dart";

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await RootService.init();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MultiBlocProvider(
      providers:[
        BlocProvider(create: (_)=>HomeBloc()),
        BlocProvider(create: (_)=>CompletedTasksBloc()),
      ],
      child: MaterialApp(
        home:StarterPage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            hintStyle:TextStyle(
              fontSize:18,
              fontWeight:FontWeight.w300,
            ),
          ),
          textTheme: TextTheme(
            titleMedium: TextStyle(
              fontSize:16,
              fontWeight:FontWeight.w700,
              color:Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
