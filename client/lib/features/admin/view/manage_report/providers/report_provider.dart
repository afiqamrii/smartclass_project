import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/models/report_models.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/services/report_api.dart';

final reportListProvider = FutureProvider<List<UtilityIssueModel>>((ref) async {
  return await ReportApi.fetchreports();
});
