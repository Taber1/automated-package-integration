import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/package_integration/package_integration_bloc.dart';

class StepperControls extends StatelessWidget {
  final ControlsDetails details;
  final PackageIntegrationState state;

  const StepperControls(
      {super.key, required this.details, required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PackageIntegrationBloc>();
    final disableButton =
        (state is IntegrationProgressState && details.stepIndex == 2) ||
            (state is VerificationInProgressState && details.stepIndex == 3);

    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            if (details.stepIndex > 0)
              TextButton(
                  onPressed: details.onStepCancel, child: const Text('BACK')),
            const Spacer(),
            ElevatedButton(
              onPressed: disableButton
                  ? null
                  : () => _handleContinue(bloc, details.stepIndex),
              child: Text(_getButtonText(details.stepIndex, state)),
            ),
          ],
        ),
      ],
    );
  }

  String _getButtonText(int stepIndex, PackageIntegrationState state) {
    if (stepIndex == 3) return 'DONE';
    return 'NEXT';
  }

  void _handleContinue(PackageIntegrationBloc bloc, int stepIndex) {
    switch (stepIndex) {
      case 0:
        if (bloc.state.projectPath.isNotEmpty) {
          bloc.add(const UpdateApiKeyEvent(''));
        }
      case 1:
        bloc.add(IntegratePackageEvent());
      case 2:
        bloc.add(RunVerificationEvent());
      case 3:
        bloc.add(ResetEvent());
    }
  }
}
