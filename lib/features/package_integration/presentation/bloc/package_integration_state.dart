part of 'package_integration_bloc.dart';

abstract class PackageIntegrationState extends Equatable {
  final String projectPath;
  final String apiKey;
  final int currentStep;

  const PackageIntegrationState({
    this.projectPath = '',
    this.apiKey = '',
    this.currentStep = 0,
  });

  @override
  List<Object> get props => [projectPath, apiKey, currentStep];
}

class InitialState extends PackageIntegrationState {
  const InitialState() : super();
}

class ProjectSelectedState extends PackageIntegrationState {
  const ProjectSelectedState({required String path, required String key})
      : super(projectPath: path, apiKey: key, currentStep: 1);
}

class IntegrationProgressState extends PackageIntegrationState {
  final String message;

  const IntegrationProgressState({
    required String path,
    required String key,
    required this.message,
  }) : super(projectPath: path, apiKey: key, currentStep: 2);
}

class IntegrationSuccessState extends PackageIntegrationState {
  const IntegrationSuccessState({
    required String path,
    required String key,
  }) : super(projectPath: path, apiKey: key, currentStep: 2);
}

class IntegrationErrorState extends PackageIntegrationState {
  final String error;

  const IntegrationErrorState({
    required String path,
    required String key,
    required this.error,
  }) : super(projectPath: path, apiKey: key);
}
