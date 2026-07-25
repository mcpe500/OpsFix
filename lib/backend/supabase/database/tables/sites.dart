import '../database.dart';

class SitesTable extends SupabaseTable<SitesRow> {
  @override
  String get tableName => 'sites';

  @override
  SitesRow createRow(Map<String, dynamic> data) => SitesRow(data);
}

class SitesRow extends SupabaseDataRow {
  SitesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SitesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get timezone => getField<String>('timezone')!;
  set timezone(String value) => setField<String>('timezone', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  bool get isDefaultSignupSite => getField<bool>('is_default_signup_site')!;
  set isDefaultSignupSite(bool value) =>
      setField<bool>('is_default_signup_site', value);

  bool get isActive => getField<bool>('is_active')!;
  set isActive(bool value) => setField<bool>('is_active', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);

  String? get publicAppUrl => getField<String>('public_app_url');
  set publicAppUrl(String? value) => setField<String>('public_app_url', value);
}
