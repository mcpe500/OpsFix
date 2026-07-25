import '../database.dart';

class MaintenanceUnitsTable extends SupabaseTable<MaintenanceUnitsRow> {
  @override
  String get tableName => 'maintenance_units';

  @override
  MaintenanceUnitsRow createRow(Map<String, dynamic> data) =>
      MaintenanceUnitsRow(data);
}

class MaintenanceUnitsRow extends SupabaseDataRow {
  MaintenanceUnitsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MaintenanceUnitsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get siteId => getField<String>('site_id')!;
  set siteId(String value) => setField<String>('site_id', value);

  String get locationId => getField<String>('location_id')!;
  set locationId(String value) => setField<String>('location_id', value);

  String get unitCode => getField<String>('unit_code')!;
  set unitCode(String value) => setField<String>('unit_code', value);

  int get codeSort => getField<int>('code_sort')!;
  set codeSort(int value) => setField<int>('code_sort', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get categoryCode => getField<String>('category_code')!;
  set categoryCode(String value) => setField<String>('category_code', value);

  String? get positionLabel => getField<String>('position_label');
  set positionLabel(String? value) => setField<String>('position_label', value);

  List<String> get componentOptions =>
      getListField<String>('component_options')!;
  set componentOptions(List<String> value) =>
      setListField<String>('component_options', value);

  String? get photoUrl => getField<String>('photo_url');
  set photoUrl(String? value) => setField<String>('photo_url', value);

  String get criticality => getField<String>('criticality')!;
  set criticality(String value) => setField<String>('criticality', value);

  String get condition => getField<String>('condition')!;
  set condition(String value) => setField<String>('condition', value);

  bool get individualQrEnabled => getField<bool>('individual_qr_enabled')!;
  set individualQrEnabled(bool value) =>
      setField<bool>('individual_qr_enabled', value);

  bool get isActive => getField<bool>('is_active')!;
  set isActive(bool value) => setField<bool>('is_active', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
