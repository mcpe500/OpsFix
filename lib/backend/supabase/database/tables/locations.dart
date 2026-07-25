import '../database.dart';

class LocationsTable extends SupabaseTable<LocationsRow> {
  @override
  String get tableName => 'locations';

  @override
  LocationsRow createRow(Map<String, dynamic> data) => LocationsRow(data);
}

class LocationsRow extends SupabaseDataRow {
  LocationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LocationsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get organizationId => getField<String>('organization_id')!;
  set organizationId(String value) =>
      setField<String>('organization_id', value);

  String get siteId => getField<String>('site_id')!;
  set siteId(String value) => setField<String>('site_id', value);

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  String get slug => getField<String>('slug')!;
  set slug(String value) => setField<String>('slug', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get locationType => getField<String>('location_type')!;
  set locationType(String value) => setField<String>('location_type', value);

  String? get building => getField<String>('building');
  set building(String? value) => setField<String>('building', value);

  String? get floor => getField<String>('floor');
  set floor(String? value) => setField<String>('floor', value);

  String get zoneCode => getField<String>('zone_code')!;
  set zoneCode(String value) => setField<String>('zone_code', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get photoUrl => getField<String>('photo_url');
  set photoUrl(String? value) => setField<String>('photo_url', value);

  double? get latitude => getField<double>('latitude');
  set latitude(double? value) => setField<double>('latitude', value);

  double? get longitude => getField<double>('longitude');
  set longitude(double? value) => setField<double>('longitude', value);

  bool get isActive => getField<bool>('is_active')!;
  set isActive(bool value) => setField<bool>('is_active', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime get updatedAt => getField<DateTime>('updated_at')!;
  set updatedAt(DateTime value) => setField<DateTime>('updated_at', value);
}
