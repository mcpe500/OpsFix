import '../database.dart';

class UserSiteScopesTable extends SupabaseTable<UserSiteScopesRow> {
  @override
  String get tableName => 'user_site_scopes';

  @override
  UserSiteScopesRow createRow(Map<String, dynamic> data) =>
      UserSiteScopesRow(data);
}

class UserSiteScopesRow extends SupabaseDataRow {
  UserSiteScopesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserSiteScopesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get siteId => getField<String>('site_id')!;
  set siteId(String value) => setField<String>('site_id', value);

  bool get isDefault => getField<bool>('is_default')!;
  set isDefault(bool value) => setField<bool>('is_default', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
