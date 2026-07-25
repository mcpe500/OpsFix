import '../database.dart';

class MaintenanceNoteCardsVTable
    extends SupabaseTable<MaintenanceNoteCardsVRow> {
  @override
  String get tableName => 'maintenance_note_cards_v';

  @override
  MaintenanceNoteCardsVRow createRow(Map<String, dynamic> data) =>
      MaintenanceNoteCardsVRow(data);
}

class MaintenanceNoteCardsVRow extends SupabaseDataRow {
  MaintenanceNoteCardsVRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MaintenanceNoteCardsVTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get organizationId => getField<String>('organization_id');
  set organizationId(String? value) =>
      setField<String>('organization_id', value);

  String? get siteId => getField<String>('site_id');
  set siteId(String? value) => setField<String>('site_id', value);

  String? get locationId => getField<String>('location_id');
  set locationId(String? value) => setField<String>('location_id', value);

  String? get unitId => getField<String>('unit_id');
  set unitId(String? value) => setField<String>('unit_id', value);

  String? get authorId => getField<String>('author_id');
  set authorId(String? value) => setField<String>('author_id', value);

  String? get authorName => getField<String>('author_name');
  set authorName(String? value) => setField<String>('author_name', value);

  String? get noteType => getField<String>('note_type');
  set noteType(String? value) => setField<String>('note_type', value);

  String? get note => getField<String>('note');
  set note(String? value) => setField<String>('note', value);

  DateTime? get performedAt => getField<DateTime>('performed_at');
  set performedAt(DateTime? value) => setField<DateTime>('performed_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
