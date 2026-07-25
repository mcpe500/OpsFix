import '../database.dart';

class OrganizationsTable extends SupabaseTable<OrganizationsRow> {
  @override
  String get tableName => 'organizations';

  @override
  OrganizationsRow createRow(Map<String, dynamic> data) =>
      OrganizationsRow(data);
}

class OrganizationsRow extends SupabaseDataRow {
  OrganizationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrganizationsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  bool get isActive => getField<bool>('is_active')!;
  set isActive(bool value) => setField<bool>('is_active', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
