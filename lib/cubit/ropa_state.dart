part of 'ropa_cubit.dart';


@immutable

sealed class RopaState {}

final class RopaInitial extends RopaState {}
final class RopaError extends RopaState{
  String error;
  RopaError({required this.error});
}
final  class RopaSuccess  extends RopaState{
  List<Producto> ropa;
  RopaSuccess({required this.ropa});
}
final class  RopaLoading extends  RopaState{}
