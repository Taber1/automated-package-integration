part of 'package_integration_bloc.dart';

abstract class PackageIntegrationState extends Equatable {
  final String projectPath;
  final String apiKey;
  final int currentStep;
  final String message;

  const PackageIntegrationState({
    this.projectPath = '',
    this.apiKey = '',
    this.currentStep = 0,
    this.message = '',
  });

  @override
  List<Object> get props => [projectPath, apiKey, currentStep, message];
}

class InitialState extends PackageIntegrationState {
  const InitialState() : super();
}

class ProjectSelectedState extends PackageIntegrationState {
  const ProjectSelectedState(String path, String key)
      : super(projectPath: path, apiKey: key, currentStep: 1);
}

class IntegrationProgressState extends PackageIntegrationState {
  const IntegrationProgressState({
    required String path,
    required String key,
    required super.message,
    int step = 2,
  }) : super(projectPath: path, apiKey: key, currentStep: step);
}

class IntegrationSuccessState extends PackageIntegrationState {
  const IntegrationSuccessState(String path, String key)
      : super(projectPath: path, apiKey: key, currentStep: 2);
}

class VerificationInProgressState extends PackageIntegrationState {
  const VerificationInProgressState({
    required super.projectPath,
    required super.apiKey,
    required super.message,
  }) : super(
          currentStep: 3,
        );
}

class VerificationSuccessState extends PackageIntegrationState {
  const VerificationSuccessState({
    required super.projectPath,
    required super.apiKey,
    required super.message,
  }) : super(
          currentStep: 3,
        );
}

class VerificationFailedState extends PackageIntegrationState {
  final String error;

  const VerificationFailedState({
    required super.projectPath,
    required super.apiKey,
    required this.error,
  }) : super(
          currentStep: 3,
          message: error,
        );

  @override
  List<Object> get props => [error, ...super.props];
}

class IntegrationErrorState extends PackageIntegrationState {
  final String error;

  const IntegrationErrorState({
    required String path,
    required String key,
    required this.error,
    required int step,
  }) : super(projectPath: path, apiKey: key, currentStep: step);

  @override
  List<Object> get props => [error, ...super.props];
}
