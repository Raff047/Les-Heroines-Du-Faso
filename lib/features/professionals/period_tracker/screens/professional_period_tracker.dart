import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/theme/pallete.dart';

class ProfessionalPeriodTrackerScreen extends ConsumerWidget {
  const ProfessionalPeriodTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proUser = ref.watch(professionalUserProvider);
    return Scaffold(
      body: Center(
        child: Text(proUser?.name ?? 'no name'),
      ),
    );
  }
}
