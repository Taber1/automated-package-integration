import 'package:flutter/material.dart';
import '../../../bloc/package_integration/package_integration_bloc.dart';
import '../../core/helpers/ui_helpers.dart';

class IntegrationStep extends StatelessWidget {
  final PackageIntegrationState state;

  const IntegrationStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state is IntegrationProgressState && state.currentStep == 2)
          _buildProgressIndicator(state as IntegrationProgressState),
        if (state is IntegrationSuccessState) _buildSuccessIndicator(),
      ],
    );
  }

  Widget _buildProgressIndicator(IntegrationProgressState state) {
    return Column(
      children: [
        verticalSpaceSmall,
        const CircularProgressIndicator(),
        verticalSpaceSmall,
        Text(state.message),
      ],
    );
  }

  Widget _buildSuccessIndicator() {
    return const Column(
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 48),
        Text('Integration Completed Successfully!'),
      ],
    );
  }
}
