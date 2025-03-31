import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/package_integration_repository.dart';

part 'package_integration_event.dart';
part 'package_integration_state.dart';

class PackageIntegrationBloc
    extends Bloc<PackageIntegrationEvent, PackageIntegrationState> {
  final PackageIntegrationRepository repo;

  PackageIntegrationBloc(this.repo) : super(InitialState()) {
    on<SelectProjectEvent>(_selectProject);
    on<UpdateApiKeyEvent>(_updateKey);
    on<IntegratePackageEvent>(_integrate);
    on<RunVerificationEvent>(_runVerification);
    on<ResetEvent>(_reset);
  }

  Future<void> _selectProject(
      SelectProjectEvent event, Emitter<PackageIntegrationState> emit) async {
    final path = await repo.pickProjectDirectory();
    if (path != null) emit(ProjectSelectedState(path, state.apiKey));
  }

  void _updateKey(
      UpdateApiKeyEvent event, Emitter<PackageIntegrationState> emit) {
    if (state is ProjectSelectedState) {
      emit(ProjectSelectedState(state.projectPath, event.key));
    }
  }

  Future<void> _integrate(IntegratePackageEvent event,
      Emitter<PackageIntegrationState> emit) async {
    try {
      emit(IntegrationProgressState(
        path: state.projectPath,
        key: state.apiKey,
        message: 'Starting integration...',
      ));

      await repo.addPackage(state.projectPath);
      emit(IntegrationProgressState(
        path: state.projectPath,
        key: state.apiKey,
        message: 'Added package to pubspec',
      ));

      await repo.configureAndroid(state.projectPath, state.apiKey);
      emit(IntegrationProgressState(
        path: state.projectPath,
        key: state.apiKey,
        message: 'Configured Android',
      ));

      await repo.configureIOS(state.projectPath, state.apiKey);
      emit(IntegrationProgressState(
        path: state.projectPath,
        key: state.apiKey,
        message: 'Configured iOS',
      ));

      await repo.configureWeb(state.projectPath, state.apiKey);
      emit(IntegrationProgressState(
        path: state.projectPath,
        key: state.apiKey,
        message: 'Configured Web',
      ));

      await repo.addExampleCode(state.projectPath);
      emit(IntegrationSuccessState(state.projectPath, state.apiKey));
    } catch (e) {
      emit(IntegrationErrorState(
        path: state.projectPath,
        key: state.apiKey,
        error: 'Integration failed: ${e.toString()}',
        step: 2,
      ));
    }
  }

  Future<void> _runVerification(
    RunVerificationEvent event,
    Emitter<PackageIntegrationState> emit,
  ) async {
    try {
      emit(VerificationInProgressState(
        projectPath: state.projectPath,
        apiKey: state.apiKey,
        message: 'Building and launching app...',
      ));

      final success = await repo.testRunOnWeb(state.projectPath);
      log("Success return from repo $success");
      if (success) {
        emit(VerificationSuccessState(
          projectPath: state.projectPath,
          apiKey: state.apiKey,
          message: 'App built and launched successfully!',
        ));
      } else {
        emit(VerificationFailedState(
          projectPath: state.projectPath,
          apiKey: state.apiKey,
          error: 'Failed to build or launch app',
        ));
      }
    } catch (e) {
      emit(VerificationFailedState(
        projectPath: state.projectPath,
        apiKey: state.apiKey,
        error: 'Verification error: ${e.toString()}',
      ));
    }
  }

  void _reset(ResetEvent event, Emitter<PackageIntegrationState> emit) {
    emit(InitialState());
  }
}
