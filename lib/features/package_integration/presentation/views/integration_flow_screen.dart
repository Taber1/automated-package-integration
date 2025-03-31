import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heyflutter_assignment/features/package_integration/presentation/bloc/package_integration_bloc.dart';

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
                context.read<PackageIntegrationBloc>().add(ResetEvent()),
          ),
        ],
      ),
      body: BlocConsumer<PackageIntegrationBloc, PackageIntegrationState>(
        listener: (context, state) {
          if (state is IntegrationErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Stepper(
            currentStep: state.currentStep,
            controlsBuilder: _controlsBuilder,
            steps: [
              _projectSelectionStep(context, state),
              _apiKeyStep(context, state),
              _integrationStep(state),
              _testRunApp(context, state)
            ],
          );
        },
      ),
    );
  }

  Step _projectSelectionStep(
      BuildContext context, PackageIntegrationState state) {
    return Step(
      title: const Text('Select Project'),
      content: Column(
        children: [
          if (state.projectPath.isNotEmpty)
            Text('Selected: ${state.projectPath}'),
          ElevatedButton(
            onPressed: () => context
                .read<PackageIntegrationBloc>()
                .add(SelectProjectEvent()),
            child: const Text('Choose Directory'),
          ),
        ],
      ),
      isActive: state.currentStep >= 0,
    );
  }

  Step _apiKeyStep(BuildContext context, PackageIntegrationState state) {
    return Step(
      title: const Text('API Key Configuration'),
      content: TextField(
        decoration: const InputDecoration(
          labelText: 'Google Maps API Key',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => context
            .read<PackageIntegrationBloc>()
            .add(UpdateApiKeyEvent(value)),
      ),
      isActive: state.currentStep >= 1,
    );
  }

  Step _integrationStep(PackageIntegrationState state) {
    return Step(
      title: const Text('Integration'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state is IntegrationProgressState)
            Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(state.message),
              ],
            ),
          if (state is IntegrationSuccessState)
            const Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 48),
                Text('Integration Successful!'),
              ],
            ),
        ],
      ),
      isActive: state.currentStep >= 2,
    );
  }

  Step _testRunApp(BuildContext context, PackageIntegrationState state) {
    return Step(
      title: const Text('Verification'),
      content: BlocBuilder<PackageIntegrationBloc, PackageIntegrationState>(
        builder: (context, state) {
          if (state is IntegrationProgressState) {
            return Column(
              children: [
                const CircularProgressIndicator(),
                Text(state.message),
                if (state.message.contains('Verifying'))
                  const Text('Automatically running app...'),
              ],
            );
          }
          if (state is IntegrationSuccessState) {
            return const Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 48),
                Text('Automated test passed!'),
                Text('App ran successfully with Google Maps'),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _controlsBuilder(BuildContext context, ControlsDetails details) {
    return Row(
      children: [
        if (details.stepIndex > 0)
          TextButton(
            onPressed: details.onStepCancel,
            child: const Text('BACK'),
          ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => _handleStepContinue(context, details.stepIndex),
          child: Text(details.stepIndex == 2 ? 'FINISH' : 'NEXT'),
        ),
      ],
    );
  }

  void _handleStepContinue(BuildContext context, int stepIndex) {
    final bloc = context.read<PackageIntegrationBloc>();

    switch (stepIndex) {
      case 0:
        if (bloc.state.projectPath.isNotEmpty) {
          bloc.add(const UpdateApiKeyEvent(''));
        }
        break;
      case 1:
        bloc.add(IntegratePackageEvent());
        break;
      case 2:
        bloc.add(ResetEvent());
        break;
    }
  }
}
