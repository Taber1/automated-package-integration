import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/package_integration/package_integration_bloc.dart';

class ProjectSelectionStep extends StatelessWidget {
  final String projectPath;
  const ProjectSelectionStep({super.key, required this.projectPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (projectPath.isNotEmpty) Text('Selected: $projectPath'),
        ElevatedButton(
          onPressed: () =>
              context.read<PackageIntegrationBloc>().add(SelectProjectEvent()),
          child: const Text('Choose Directory'),
        ),
      ],
    );
  }
}
