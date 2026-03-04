part of 'info_cubit.dart';

@immutable
sealed class InfoState {}

final class InfoInitial extends InfoState {}

final class InfoLoading extends InfoState {}

final class InfoLoaded extends InfoState {
  final UserModel userModel;

  InfoLoaded({required this.userModel});
}

final class InfoError extends InfoState {
  final String error;

  InfoError({required this.error});
}
