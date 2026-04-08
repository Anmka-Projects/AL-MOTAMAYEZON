part of 'on_boarding_cubit.dart';

sealed class OnBoardingState extends BaseState<OnBoardingModel> {
  const OnBoardingState();
}

final class OnBoardingInitial extends OnBoardingState {
  @override
  List<Object> get props => [];
}

class UpdateOnBoardingLoadingState extends OnBoardingState{
  @override
  List<Object?> get props => [];
}

class UpdateOnBoardingState extends OnBoardingState{
  @override
  List<Object?> get props => [];
}