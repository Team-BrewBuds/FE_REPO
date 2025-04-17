sealed class SuggestState {
  factory SuggestState.init() = InitialState;

  factory SuggestState.loading() = LoadingState;

  factory SuggestState.complete({required List<String> results}) = CompleteState;
}

final class InitialState implements SuggestState {}

final class LoadingState implements SuggestState {}

final class CompleteState implements SuggestState {
  final List<String> results;

  const CompleteState({
    required this.results,
  });
}
