import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/package_integration/package_integration_bloc.dart';

class ApiKeyStep extends StatelessWidget {
  const ApiKeyStep({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Google Maps API Key',
        border: OutlineInputBorder(),
        hintText: 'Enter your API key here',
      ),
      onChanged: (value) =>
          context.read<PackageIntegrationBloc>().add(UpdateApiKeyEvent(value)),
    );
  }
}
