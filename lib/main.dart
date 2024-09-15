import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workoutapp/view/work_out/work_out_listing/work_out_listing.dart';

Future<void> main() async {
  await GetStorage.init("work_out");
  // await Storage.instance.cleanData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkOutApp',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WorkOutListingScreen(),
    );
  }
}
