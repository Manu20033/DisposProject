part of 'detection_bloc.dart';

sealed class DetectionState extends Equatable {
  const DetectionState();
}

final class DetectionInitial extends DetectionState {
  @override
  List<Object> get props => [];
}
