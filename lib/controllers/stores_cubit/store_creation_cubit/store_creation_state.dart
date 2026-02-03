part of 'store_creation_cubit.dart';

@immutable
class StoreCreationState {
  final bool isLoading;
  final bool? hasStore;
  final CreateStoreModel? store;
  final String? error;
  final bool isSuccess;

  const StoreCreationState({
    this.isLoading = false,
    this.hasStore,
    this.store,
    this.error,
    this.isSuccess = false,
  });

  factory StoreCreationState.initial() {
    return const StoreCreationState();
  }

  StoreCreationState copyWith({
    bool? isLoading,
    bool? hasStore,
    CreateStoreModel? store,
    String? error,
    bool? isSuccess,
  }) {
    return StoreCreationState(
      isLoading: isLoading ?? this.isLoading,
      hasStore: hasStore ?? this.hasStore,
      store: store ?? this.store,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
