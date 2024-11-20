part of 'camera_bloc.dart';

sealed class CameraState extends Equatable {
  const CameraState();
}

final class CameraInitial extends CameraState {
  @override
  List<Object> get props => [];
}
