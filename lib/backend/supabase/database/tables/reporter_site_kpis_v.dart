import '../database.dart';

class ReporterSiteKpisVTable extends SupabaseTable<ReporterSiteKpisVRow> {
  @override
  String get tableName => 'reporter_site_kpis_v';

  @override
  ReporterSiteKpisVRow createRow(Map<String, dynamic> data) =>
      ReporterSiteKpisVRow(data);
}

class ReporterSiteKpisVRow extends SupabaseDataRow {
  ReporterSiteKpisVRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReporterSiteKpisVTable();

  String? get reporterId => getField<String>('reporter_id');
  set reporterId(String? value) => setField<String>('reporter_id', value);

  String? get siteId => getField<String>('site_id');
  set siteId(String? value) => setField<String>('site_id', value);

  int? get activeTickets => getField<int>('active_tickets');
  set activeTickets(int? value) => setField<int>('active_tickets', value);

  int? get inProgressTickets => getField<int>('in_progress_tickets');
  set inProgressTickets(int? value) =>
      setField<int>('in_progress_tickets', value);

  int? get completedTickets => getField<int>('completed_tickets');
  set completedTickets(int? value) => setField<int>('completed_tickets', value);

  String? get latestTicketId => getField<String>('latest_ticket_id');
  set latestTicketId(String? value) =>
      setField<String>('latest_ticket_id', value);

  String? get latestTicketCode => getField<String>('latest_ticket_code');
  set latestTicketCode(String? value) =>
      setField<String>('latest_ticket_code', value);

  String? get latestTicketTitle => getField<String>('latest_ticket_title');
  set latestTicketTitle(String? value) =>
      setField<String>('latest_ticket_title', value);

  String? get latestTicketStatus => getField<String>('latest_ticket_status');
  set latestTicketStatus(String? value) =>
      setField<String>('latest_ticket_status', value);

  DateTime? get latestTicketUpdatedAt =>
      getField<DateTime>('latest_ticket_updated_at');
  set latestTicketUpdatedAt(DateTime? value) =>
      setField<DateTime>('latest_ticket_updated_at', value);
}
