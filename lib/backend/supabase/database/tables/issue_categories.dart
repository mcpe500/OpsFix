import '../database.dart';

class IssueCategoriesTable extends SupabaseTable<IssueCategoriesRow> {
  @override
  String get tableName => 'issue_categories';

  @override
  IssueCategoriesRow createRow(Map<String, dynamic> data) =>
      IssueCategoriesRow(data);
}

class IssueCategoriesRow extends SupabaseDataRow {
  IssueCategoriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => IssueCategoriesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  String get label => getField<String>('label')!;
  set label(String value) => setField<String>('label', value);

  String? get iconName => getField<String>('icon_name');
  set iconName(String? value) => setField<String>('icon_name', value);

  String get defaultPriority => getField<String>('default_priority')!;
  set defaultPriority(String value) =>
      setField<String>('default_priority', value);

  bool get isActive => getField<bool>('is_active')!;
  set isActive(bool value) => setField<bool>('is_active', value);

  int get sortOrder => getField<int>('sort_order')!;
  set sortOrder(int value) => setField<int>('sort_order', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
