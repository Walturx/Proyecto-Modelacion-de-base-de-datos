import 'package:app_ropa/repositories/ropaRepositorie.dart';
import 'package:meta/meta.dart';
import 'package:app_ropa/models/ropaModel.dart';
import 'package:app_ropa/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ropa/models/ropaModel.dart';

part 'ropa_state.dart';

class RopaCubit extends Cubit<RopaState>{
 RopaCubit(): super(RopaInitial());
 Future<bool> getRopa() async{
  try{
    List<Producto> ropa = await RopaRepositorie().getAllRopa();
    emit(RopaSuccess(ropa: ropa));
    return true;
  }catch(e){
    emit(RopaError(error: e.toString()));
    return false;
  }
 }
}