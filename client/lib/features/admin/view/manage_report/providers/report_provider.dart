import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/models/report_models.dart';
import 'package:smartclass_fyp_2024/features/admin/view/manage_report/services/report_api.dart';

// This provider fetches the list of reports from the API
final reportListProvider = FutureProvider<List<UtilityIssueModel>>((ref) async {
  return await ReportApi.fetchreports();
});

// This provider fetches a single report by its ID
final reportByIdProvider =
    FutureProvider.family<UtilityIssueModel, int>((ref, id) async {
  return await ReportApi.fetchReportById(id);
});

// THis provider use to fetch the report by userId
final reportByUserIdProvider =
    FutureProvider.family<List<UtilityIssueModel>, String>((ref, userId) async {
  return await ReportApi.fetchReportByUserId(userId);
});
