part of 'manage_cubit.dart';

@immutable
sealed class ManageState {}

final class ManageInitial extends ManageState {}

final class ManageLoading extends ManageState {}

final class ManageLoaded extends ManageState {
  final String userType;
  final bool? hasStore;
  final CreateStoreModel? createStoreModel;
  final UserModel? userModel;

  ManageLoaded({required this.userType, this.hasStore, this.createStoreModel, required this.userModel});
}

final class ManageError extends ManageState {
  final String error;

  ManageError({required this.error});
}
