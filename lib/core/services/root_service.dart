


import 'hive_service.dart';

class RootService{
  static Future<void> init()async{
    await HiveService.init();
  }
}