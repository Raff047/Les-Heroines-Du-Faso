import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/admin/repository/admin_repository.dart';

import '../../../core/common/widgets/show_snack_bar.dart';

final adminControllerProvider =
    Provider((ref) => AdminController(ref.read(adminRepositoryProvider)));

class AdminController {
  final AdminRepository _adminRepository;

  AdminController(this._adminRepository);

  //create professional user
  Future<void> createProfessional(
      {required String? name,
      required String? email,
      required String? password,
      required String? category,
      required BuildContext? context}) async {
    try {
      await _adminRepository.createProfessional(
          name!, email!, password!, category!);
      showSnackBar(context: context!, content: '$email has been added');
    } catch (e) {
      showSnackBar(context: context!, content: e.toString());
    }
  }

  //create admin user
  Future<void> createAdmin(
      {required String? name,
      required String? email,
      required String? password,
      required BuildContext? context}) async {
    try {
      await _adminRepository.createAdmin(name!, email!, password!);
      showSnackBar(context: context!, content: '$email a été ajouté');
    } catch (e) {
      showSnackBar(context: context!, content: e.toString());
    }
  }
}
