import '../database.dart';

class ManagerSiteKpisVTable extends SupabaseTable<ManagerSiteKpisVRow> {
  @override
  String get tableName => 'manager_site_kpis_v';

  @override
  ManagerSiteKpisVRow createRow(Map<String, dynamic> data) =>
      ManagerSiteKpisVRow(data);
}

class ManagerSiteKpisVRow extends SupabaseDataRow {
  ManagerSiteKpisVRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ManagerSiteKpisVTable();

  String? get siteId => getField<String>('site_id');
  set siteId(String? value) => setField<String>('site_id', value);

  int? get openTickets => getField<int>('open_tickets');
  set openTickets(int? value) => setField<int>('open_tickets', value);

  int? get unassignedTickets => getField<int>('unassigned_tickets');
  set unassignedTickets(int? value) =>
      setField<int>('unassigned_tickets', value);

  int? get overdueTickets => getField<int>('overdue_tickets');
  set overdueTickets(int? value) => setField<int>('overdue_tickets', value);

  int? get criticalOpenTickets => getField<int>('critical_open_tickets');
  set criticalOpenTickets(int? value) =>
      setField<int>('critical_open_tickets', value);

  int? get fixedThisMonth => getField<int>('fixed_this_month');
  set fixedThisMonth(int? value) => setField<int>('fixed_this_month', value);

  int? get averageResolutionMinutes =>
      getField<int>('average_resolution_minutes');
  set averageResolutionMinutes(int? value) =>
      setField<int>('average_resolution_minutes', value);
}
