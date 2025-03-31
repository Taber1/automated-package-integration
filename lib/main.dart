import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heyflutter_assignment/core/helpers/ui_helpers.dart';
import 'views/integration_flow_screen.dart';
import 'bloc/package_integration/package_integration_bloc.dart';
import 'data/repositories/package_integration_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
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
