import 'package:app_ropa/models/ropaModel.dart';
import 'package:app_ropa/service/ropaService.dart';

class RopaRepositorie{
  final RopaServiceFirebase ropaService = RopaServiceFirebase();
  Future<List<Producto>> getAllRopa() async {
    try{
          return await ropaService.getAllRopa();
    }catch(e){
      throw Exception(e);
    }
    }
  } 
