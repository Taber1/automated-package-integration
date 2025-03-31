import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/package_integration/package_integration_bloc.dart';
import '../../core/helpers/ui_helpers.dart';

class VerificationStep extends StatelessWidget {
  final PackageIntegrationState state;

  const VerificationStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state is VerificationInProgressState)
          _buildInProgress(state as VerificationInProgressState),
        if (state is VerificationSuccessState)
          _buildSuccess(state as VerificationSuccessState),
        if (state is VerificationFailedState)
          _buildFailure(context, state as VerificationFailedState),
      ],
    );
  }

  Widget _buildInProgress(VerificationInProgressState state) {
    return Column(
      children: [
        verticalSpaceSmall,
        const CircularProgressIndicator(),
        verticalSpaceSmall,
        Text(state.message),
        verticalSpaceSmall,
        const Text('Build output:'),
        verticalSpaceSmall,
        if (state.projectPath.isNotEmpty)
          Text(
            'Project: ${state.projectPath}',
            style: const TextStyle(fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildSuccess(VerificationSuccessState state) {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 48),
        verticalSpaceSmall,
        Text(state.message),
        verticalSpaceSmall,
        const Text('You can now close this window'),
      ],
    );
  }

  Widget _buildFailure(BuildContext context, VerificationFailedState state) {
    return Column(
      children: [
        const Icon(Icons.error, color: Colors.red, size: 48),
        verticalSpaceSmall,
        Text(
          state.error,
          style: const TextStyle(color: Colors.red),
        ),
        verticalSpaceSmall,
        ElevatedButton(
          onPressed: () => context
              .read<PackageIntegrationBloc>()
              .add(RunVerificationEvent()),
          child: const Text('Retry Verification'),
        ),
      ],
    );
  }
}
