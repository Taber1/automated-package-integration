import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/package_integration/package_integration_bloc.dart';
import 'widgets/api_key_step.dart';
import 'widgets/integration_step.dart';
import 'widgets/project_selection_step.dart';
import 'widgets/stepper_controls.dart';
import 'widgets/verification_step.dart';

class IntegrationFlowScreen extends StatelessWidget {
  const IntegrationFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Integrator'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  context.read<PackageIntegrationBloc>().add(ResetEvent()))
        ],
      ),
      body: BlocConsumer<PackageIntegrationBloc, PackageIntegrationState>(
        listener: (context, state) {
          if (state is IntegrationErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          return Stepper(
            currentStep: state.currentStep,
            controlsBuilder: (context, details) =>
                StepperControls(details: details, state: state),
            steps: [
              Step(
                title: const Text('Select Project'),
                content: ProjectSelectionStep(projectPath: state.projectPath),
                isActive: state.currentStep >= 0,
                state: state.projectPath.isEmpty
                    ? StepState.indexed
                    : StepState.complete,
              ),
              Step(
                title: const Text('API Key Configuration'),
                content: const ApiKeyStep(),
                isActive: state.currentStep >= 1,
                state: state.apiKey.isEmpty
                    ? StepState.indexed
                    : StepState.complete,
              ),
              Step(
                title: const Text('Integration'),
                content: IntegrationStep(state: state),
                isActive: state.currentStep >= 2,
              ),
              Step(
                title: const Text('Verification'),
                content: VerificationStep(state: state),
                isActive: state.currentStep >= 3,
                state: _getVerificationStepState(state),
              ),
            ],
          );
        },
      ),
    );
  }

  StepState _getVerificationStepState(PackageIntegrationState state) {
    if (state is VerificationSuccessState) return StepState.complete;
    if (state is VerificationFailedState) return StepState.error;
    return StepState.indexed;
  }
}
