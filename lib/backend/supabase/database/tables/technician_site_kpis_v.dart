import '../database.dart';

class TechnicianSiteKpisVTable extends SupabaseTable<TechnicianSiteKpisVRow> {
  @override
  String get tableName => 'technician_site_kpis_v';

  @override
  TechnicianSiteKpisVRow createRow(Map<String, dynamic> data) =>
      TechnicianSiteKpisVRow(data);
}

class TechnicianSiteKpisVRow extends SupabaseDataRow {
  TechnicianSiteKpisVRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TechnicianSiteKpisVTable();

  String? get technicianId => getField<String>('technician_id');
  set technicianId(String? value) => setField<String>('technician_id', value);

  String? get siteId => getField<String>('site_id');
  set siteId(String? value) => setField<String>('site_id', value);

  int? get assignedOpenTickets => getField<int>('assigned_open_tickets');
  set assignedOpenTickets(int? value) =>
      setField<int>('assigned_open_tickets', value);

  int? get inProgressTickets => getField<int>('in_progress_tickets');
  set inProgressTickets(int? value) =>
      setField<int>('in_progress_tickets', value);

  int? get pendingVerificationTickets =>
      getField<int>('pending_verification_tickets');
  set pendingVerificationTickets(int? value) =>
      setField<int>('pending_verification_tickets', value);

  int? get fixedToday => getField<int>('fixed_today');
  set fixedToday(int? value) => setField<int>('fixed_today', value);
}
