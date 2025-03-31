import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/package_integration/presentation/views/integration_flow_screen.dart';
import 'features/package_integration/presentation/bloc/package_integration_bloc.dart';
import 'features/package_integration/data/package_integration_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Package Integrator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => PackageIntegrationBloc(
          PackageIntegrationRepository(),
        ),
        child: const IntegrationFlowScreen(),
      ),
    );
  }
}
