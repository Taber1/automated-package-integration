part of 'package_integration_bloc.dart';

abstract class PackageIntegrationEvent extends Equatable {
  const PackageIntegrationEvent();

  @override
  List<Object> get props => [];
}

class SelectProjectEvent extends PackageIntegrationEvent {}

class UpdateApiKeyEvent extends PackageIntegrationEvent {
  final String key;
  const UpdateApiKeyEvent(this.key);

  @override
  List<Object> get props => [key];
}

class IntegratePackageEvent extends PackageIntegrationEvent {}

class RunVerificationEvent extends PackageIntegrationEvent {}

class ResetEvent extends PackageIntegrationEvent {}
