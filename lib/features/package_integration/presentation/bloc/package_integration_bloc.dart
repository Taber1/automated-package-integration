import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/package_integration_repository.dart';

part 'package_integration_event.dart';
part 'package_integration_state.dart';

class PackageIntegrationBloc
    extends Bloc<PackageIntegrationEvent, PackageIntegrationState> {
  final PackageIntegrationRepository repo;

  PackageIntegrationBloc(this.repo) : super(InitialState()) {
    on<SelectProjectEvent>(_selectProject);
    on<UpdateApiKeyEvent>(_updateKey);
    on<IntegratePackageEvent>(_integrate);
    on<ResetEvent>(_reset);
  }

  Future<void> _selectProject(
    SelectProjectEvent event,
    Emitter<PackageIntegrationState> emit,
  ) async {
    final path = await repo.pickProjectDirectory();
    if (path != null) emit(ProjectSelectedState(path: path, key: ''));
  }

  void _updateKey(
    UpdateApiKeyEvent event,
    Emitter<PackageIntegrationState> emit,
  ) {
    if (state is ProjectSelectedState) {
      emit(ProjectSelectedState(path: state.projectPath, key: event.key));
    }
  }

  Future<void> _integrate(
    IntegratePackageEvent event,
    Emitter<PackageIntegrationState> emit,
  ) async {
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

      await repo.addExampleCode(state.projectPath);
      emit(IntegrationSuccessState(
        path: state.projectPath,
        key: state.apiKey,
      ));

      // Add automated run test
      emit(IntegrationProgressState(
        message: 'Verifying integration...',
        path: state.projectPath,
        key: state.apiKey,
      ));

      final success = await repo.testRunFlutterApp(state.projectPath);

      if (!success) {
        throw Exception('Failed to run app - verify API keys and setup');
      }

      emit(IntegrationSuccessState(
        path: state.projectPath,
        key: state.apiKey,
      ));
    } catch (e) {
      emit(IntegrationErrorState(
        path: state.projectPath,
        key: state.apiKey,
        error: e.toString(),
      ));
    }
  }

  void _reset(ResetEvent event, Emitter<PackageIntegrationState> emit) {
    emit(InitialState());
  }
}
