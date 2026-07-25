import '../database.dart';

class AssignmentRulesTable extends SupabaseTable<AssignmentRulesRow> {
  @override
  String get tableName => 'assignment_rules';

  @override
  AssignmentRulesRow createRow(Map<String, dynamic> data) =>
      AssignmentRulesRow(data);
}

class AssignmentRulesRow extends SupabaseDataRow {
  AssignmentRulesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AssignmentRulesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get siteId => getField<String>('site_id')!;
  set siteId(String value) => setField<String>('site_id', value);

  String get issueCategoryId => getField<String>('issue_category_id')!;
  set issueCategoryId(String value) =>
      setField<String>('issue_category_id', value);

  String get zoneCode => getField<String>('zone_code')!;
  set zoneCode(String value) => setField<String>('zone_code', value);

  String get technicianUserId => getField<String>('technician_user_id')!;
  set technicianUserId(String value) =>
      setField<String>('technician_user_id', value);

  int get priorityOrder => getField<int>('priority_order')!;
  set priorityOrder(int value) => setField<int>('priority_order', value);

  bool get isActive => getField<bool>('is_active')!;
  set isActive(bool value) => setField<bool>('is_active', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
