import '../database.dart';

class TicketCardsVTable extends SupabaseTable<TicketCardsVRow> {
  @override
  String get tableName => 'ticket_cards_v';

  @override
  TicketCardsVRow createRow(Map<String, dynamic> data) => TicketCardsVRow(data);
}

class TicketCardsVRow extends SupabaseDataRow {
  TicketCardsVRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TicketCardsVTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get siteId => getField<String>('site_id');
  set siteId(String? value) => setField<String>('site_id', value);

  String? get ticketCode => getField<String>('ticket_code');
  set ticketCode(String? value) => setField<String>('ticket_code', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get assignmentState => getField<String>('assignment_state');
  set assignmentState(String? value) =>
      setField<String>('assignment_state', value);

  String? get priority => getField<String>('priority');
  set priority(String? value) => setField<String>('priority', value);

  int? get priorityRank => getField<int>('priority_rank');
  set priorityRank(int? value) => setField<int>('priority_rank', value);

  String? get locationId => getField<String>('location_id');
  set locationId(String? value) => setField<String>('location_id', value);

  String? get unitId => getField<String>('unit_id');
  set unitId(String? value) => setField<String>('unit_id', value);

  String? get locationCodeSnapshot =>
      getField<String>('location_code_snapshot');
  set locationCodeSnapshot(String? value) =>
      setField<String>('location_code_snapshot', value);

  String? get locationNameSnapshot =>
      getField<String>('location_name_snapshot');
  set locationNameSnapshot(String? value) =>
      setField<String>('location_name_snapshot', value);

  String? get unitCodeSnapshot => getField<String>('unit_code_snapshot');
  set unitCodeSnapshot(String? value) =>
      setField<String>('unit_code_snapshot', value);

  String? get unitNameSnapshot => getField<String>('unit_name_snapshot');
  set unitNameSnapshot(String? value) =>
      setField<String>('unit_name_snapshot', value);

  String? get targetLabelSnapshot => getField<String>('target_label_snapshot');
  set targetLabelSnapshot(String? value) =>
      setField<String>('target_label_snapshot', value);

  String? get issueCategorySnapshot =>
      getField<String>('issue_category_snapshot');
  set issueCategorySnapshot(String? value) =>
      setField<String>('issue_category_snapshot', value);

  String? get issueTypeSnapshot => getField<String>('issue_type_snapshot');
  set issueTypeSnapshot(String? value) =>
      setField<String>('issue_type_snapshot', value);

  String? get reporterId => getField<String>('reporter_id');
  set reporterId(String? value) => setField<String>('reporter_id', value);

  String? get reporterNameSnapshot =>
      getField<String>('reporter_name_snapshot');
  set reporterNameSnapshot(String? value) =>
      setField<String>('reporter_name_snapshot', value);

  String? get assignedTechnicianId =>
      getField<String>('assigned_technician_id');
  set assignedTechnicianId(String? value) =>
      setField<String>('assigned_technician_id', value);

  String? get technicianNameSnapshot =>
      getField<String>('technician_name_snapshot');
  set technicianNameSnapshot(String? value) =>
      setField<String>('technician_name_snapshot', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get resolutionDueAt => getField<DateTime>('resolution_due_at');
  set resolutionDueAt(DateTime? value) =>
      setField<DateTime>('resolution_due_at', value);

  String? get beforePhotoUrl => getField<String>('before_photo_url');
  set beforePhotoUrl(String? value) =>
      setField<String>('before_photo_url', value);

  String? get afterPhotoUrl => getField<String>('after_photo_url');
  set afterPhotoUrl(String? value) =>
      setField<String>('after_photo_url', value);

  bool? get isOpen => getField<bool>('is_open');
  set isOpen(bool? value) => setField<bool>('is_open', value);

  int? get version => getField<int>('version');
  set version(int? value) => setField<int>('version', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
