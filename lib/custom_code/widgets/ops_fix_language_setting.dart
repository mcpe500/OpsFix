// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Indonesian/English lookup shared by every OpsFix custom widget.
///
/// FlutterFlow's own localization handles FF-managed Text widgets. It cannot
/// reach custom Dart, which is where almost all of this app's copy lives, so
/// custom widgets route their user-visible strings through [t] / [tf].
///
/// The map is keyed by the Indonesian source string. That choice is
/// deliberate: an untranslated string falls through to the Indonesian original
/// instead of rendering blank, which is how FlutterFlow's own `getText`
/// behaves when a locale slot is empty.
class OpsFixI18n {
  const OpsFixI18n._();

  static const String defaultLanguage = 'id';

  /// The active language code (`'id'` or `'en'`).
  ///
  /// FlutterFlow's locale is the source of truth whenever a [BuildContext] is
  /// available. `FFAppState().appLanguage` mirrors it for the places that have
  /// no context — custom actions, and async callbacks that resolve after the
  /// element is gone.
  ///
  /// Resolving with a context also *repairs* a stale mirror. That matters on a
  /// first run: the user has chosen nothing, so the mirror is empty while
  /// FlutterFlow has already resolved a locale from the device. Without this,
  /// an English device would render FF-managed text in English and custom
  /// widgets in Indonesian. The assignment is deliberately made through the
  /// plain setter rather than `FFAppState().update(...)` — the setter writes
  /// SharedPreferences without calling `notifyListeners`, so it is safe to
  /// touch during a build.
  static String languageOf([BuildContext? context]) {
    // 1. The live locale, when the caller is inside the widget tree.
    if (context != null) {
      final localizations =
          Localizations.of<FFLocalizations>(context, FFLocalizations);
      final code = localizations?.languageCode.trim() ?? '';
      if (code.isNotEmpty) {
        final resolved = _normalize(code);
        if (FFAppState().appLanguage != resolved) {
          FFAppState().appLanguage = resolved;
        }
        return resolved;
      }
    }

    // 2. The locale FlutterFlow itself persisted. This is a *static* read, so
    //    it works with no context at all, and it is exact whenever the user has
    //    made a choice — which is always, once persistLanguageSelection is on.
    final stored = FFLocalizations.getStoredLocale();
    if (stored != null) return _normalize(stored.toString());

    // 3. The mirror, for the window before any choice has been stored.
    final mirrored = FFAppState().appLanguage.trim();
    if (mirrored.isNotEmpty) return _normalize(mirrored);

    // 4. No choice yet: reproduce what MaterialApp does with a null locale —
    //    match the device against supportedLocales, falling back to the first
    //    entry, which is Indonesian.
    final device =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return device == 'en' ? 'en' : defaultLanguage;
  }

  static String _normalize(String code) => code.split(RegExp('[_-]')).first;

  static bool isEnglish([BuildContext? context]) => languageOf(context) == 'en';

  /// Translates [source] for the active language.
  ///
  /// The app was authored in a mix of languages: most copy is Indonesian, but
  /// parts (the admin sidebar, the completion panel) were written in English.
  /// So the lookup runs in both directions — [_en] for Indonesian sources, [_id]
  /// for English ones. A source string that is already in the target language
  /// simply misses both maps and is returned unchanged, which is exactly right.
  static String t(String source, [BuildContext? context]) =>
      isEnglish(context) ? (_en[source] ?? source) : (_id[source] ?? source);

  /// Like [t], but replaces the `{0}`, `{1}`, ... placeholders with [args].
  ///
  /// Used for strings that were Dart interpolations before translation, so the
  /// English word order can differ from the Indonesian.
  static String tf(String source, List<Object?> args, [BuildContext? context]) {
    var out = t(source, context);
    for (var i = 0; i < args.length; i++) {
      out = out.replaceAll('{$i}', args[i]?.toString() ?? '');
    }
    return out;
  }

  /// Indonesian source -> English.
  static const Map<String, String> _en = <String, String>{
    '1. Pilih perangkat dan jenis gangguan':
        '1. Choose the device and fault type',
    '1. Pilih perangkat yang bermasalah':
        '1. Choose the device with the problem',
    '2. Jelaskan gangguan dan sertakan foto':
        '2. Describe the fault and attach a photo',
    '2. Jelaskan gejala dan sertakan foto':
        '2. Describe the symptoms and attach a photo',
    '3. Kirim laporan untuk ditangani teknisi':
        '3. Submit the report for a technician to handle',
    '3. Pantau status hingga perbaikan selesai':
        '3. Track the status until the repair is done',
    'ADMIN OPERATIONS': 'ADMIN OPERATIONS',
    'ADMIN · ASSET REGISTRY': 'ADMIN · ASSET REGISTRY',
    'ADMIN · AUDIT LOG': 'ADMIN · AUDIT LOG',
    'ADMIN · TICKET REGISTRY': 'ADMIN · TICKET REGISTRY',
    'ADMIN · WORK BOARD': 'ADMIN · WORK BOARD',
    'AKTIVITAS': 'ACTIVITY',
    'AKTOR': 'ACTOR',
    'AKUN ADMIN': 'ADMIN ACCOUNT',
    'Ada aktivitas terbaru pada akun Anda.':
        'There is recent activity on your account.',
    'Admin OpsFix': 'OpsFix admin',
    'Akses aman sesuai peran pengguna.': 'Secure access based on user role.',
    'Akses manajer ditolak.': 'Manager access denied.',
    'Akses admin ditolak.': 'Admin access denied.',
    'Aktif': 'Active',
    'Aktivitas dimuat': 'Activity loaded',
    'Riwayat aktivitas dapat ditelusuri.': 'Operational activity is traceable.',
    'Pantau perubahan status, penugasan, dan tindakan pengguna pada lokasi aktif.':
        'Monitor status changes, assignments, and user actions at the active location.',
    'Aktivitas ditampilkan': 'Activities shown',
    'Aktor yang terlibat': 'Actors involved',
    'Aktivitas terakhir': 'Latest activity',
    'Hari ini · {0}': 'Today · {0}',
    'Kemarin · {0}': 'Yesterday · {0}',
    'Aktivitas diurutkan dari kejadian terbaru pada site aktif.':
        'Activity is ordered from the most recent event at the active site.',
    'Aktivitas terbaru': 'Recent activity',
    'Aktivitas tercatat': 'Activity recorded',
    'Aktivitas tiket': 'Ticket activity',
    'Aktivitas tiket terbaru akan muncul di sini.':
        'Recent ticket activity will appear here.',
    'Aktor tercatat': 'Actor recorded',
    'Akun aktif': 'Active account',
    'Akun belum dapat disiapkan. Hubungi administrator OpsFix.':
        'Your account could not be set up. Contact an OpsFix administrator.',
    'Akun berhasil dibuat. Silakan masuk.':
        'Account created successfully. Please sign in.',
    'Alur pekerjaan aktif': 'Active workflow',
    'Anda kerjakan.': 'to work on.',
    'Anda tidak memiliki akses manajer untuk aset ini.':
        'You do not have manager access to this asset.',
    'Anda tidak memiliki akses manajer untuk data ini.':
        'You do not have manager access to this data.',
    'Anda tidak memiliki akses manajer untuk mengarsipkan aset ini.':
        'You do not have manager access to archive this asset.',
    'Anda tidak memiliki akses untuk mengarsipkan lokasi ini.':
        'You do not have access to archive this location.',
    'Antrean aktif': 'Active queue',
    'Antrean belum dapat dimuat. Tarik layar untuk mencoba lagi.':
        'The queue could not be loaded. Pull to try again.',
    'Antrean prioritas': 'Priority queue',
    'Pantau tiket aktif yang paling membutuhkan perhatian.':
        'Monitor the active tickets that need attention most.',
    'Lihat semua di board': 'View all on board',
    'Belum ada tiket aktif dalam antrean.':
        'There are no active tickets in the queue.',
    'Semua tiket aktif saat ini sudah tertangani.':
        'All active tickets are currently being handled.',
    'Perangkat belum tersedia': 'Device unavailable',
    'Gangguan belum tersedia': 'Issue unavailable',
    'Normal': 'Normal',
    'Batas SLA belum tersedia': 'SLA deadline unavailable',
    'Terlambat {0}': 'Overdue by {0}',
    'Sisa {0}': '{0} remaining',
    'menit': 'minutes',
    'jam': 'hours',
    'hari': 'days',
    'Apa yang bermasalah?': 'What\'s wrong?',
    'Aplikasi mengalami gangguan': 'Application error',
    'Arahkan kamera ke QR yang tersedia di lokasi fasilitas.':
        'Point the camera at the QR code posted at the facility location.',
    'Arsipkan': 'Archive',
    'Arsipkan aset': 'Archive asset',
    'Arsipkan aset?': 'Archive this asset?',
    'Arsipkan lokasi': 'Archive location',
    'Aset': 'Asset',
    'Aset & Lokasi': 'Assets & Locations',
    'Aset akan dinonaktifkan. Tiket dan catatan lama tetap tersimpan. Aset dengan tiket terbuka tidak dapat diarsipkan.':
        'The asset will be deactivated. Existing tickets and notes are kept. An asset with open tickets cannot be archived.',
    'Aset aktif': 'Active assets',
    'Aset belum dapat diarsipkan karena masih memiliki tiket terbuka.':
        'This asset cannot be archived while it still has open tickets.',
    'Aset berhasil diarsipkan.': 'Asset archived.',
    'Aset diarsipkan': 'Asset archived',
    'Aset gagal diarsipkan. Periksa koneksi lalu coba lagi.':
        'The asset could not be archived. Check your connection and try again.',
    'Aset tidak dapat dimuat.': 'The asset could not be loaded.',
    'Aset tidak ditemukan atau tidak dapat diakses.':
        'Asset not found or not accessible.',
    'Aset tidak tersedia': 'Asset unavailable',
    'Aset tidak valid atau situs aktif belum dipilih.':
        'Invalid asset, or no active site has been selected.',
    'BUAT LAPORAN': 'CREATE REPORT',
    'Bahasa': 'Language',
    'Bahasa aplikasi': 'App language',
    'Baru dilaporkan': 'Newly reported',
    'Baru saja': 'Just now',
    'Batal': 'Cancel',
    'Batas pengiriman email tercapai. Tunggu beberapa saat lalu coba lagi.':
        'Email sending limit reached. Wait a moment and try again.',
    'Batas respons awal': 'First response deadline',
    'Batas waktu layanan dan catatan pembaruan tiket.':
        'Service deadlines and ticket update notes.',
    'Belum ada aktivitas yang tercatat.': 'No activity recorded yet.',
    'Belum ada catatan pemeliharaan.': 'No maintenance notes yet.',
    'Belum ada deskripsi lokasi.': 'No location description yet.',
    'Belum ada lokasi aktif': 'No active locations yet',
    'Belum ada pekerjaan yang selesai.': 'No completed work yet.',
    'Belum ada pembaruan': 'No updates yet',
    'Belum ada perangkat aktif pada lokasi ini.':
        'There are no active devices at this location yet.',
    'Belum ada perangkat di lokasi ini': 'No devices at this location yet',
    'Belum ada teknisi': 'No technician yet',
    'Belum ada teknisi aktif untuk lokasi tiket ini.':
        'There are no active technicians for this ticket location.',
    'Belum ada tiket': 'No tickets yet',
    'Belum ada tiket aktif': 'No open tickets yet',
    'Belum ada tiket pada tahap ini.': 'No tickets at this stage.',
    'Belum ada unit aktif': 'No active units yet',
    'Belum dapat dikerjakan': 'Not ready to start',
    'Belum dapat diproses. Periksa koneksi lalu coba lagi.':
        'Could not be processed. Check your connection and try again.',
    'Belum dapat keluar dari akun. Periksa koneksi lalu coba kembali.':
        'Could not sign out. Check your connection and try again.',
    'Belum dapat keluar dari akun. Periksa koneksi lalu coba lagi.':
        'Could not sign out. Check your connection and try again.',
    'Belum diisi': 'Not filled in',
    'Belum dimulai': 'Not started',
    'Belum dipilih': 'Not selected',
    'Belum ditambahkan': 'Not added',
    'Belum ditentukan': 'Not set',
    'Belum ditetapkan': 'Not assigned',
    'Belum ditugaskan': 'Unassigned',
    'Perlu ditetapkan': 'Needs assignment',
    'Perlu tindakan segera': 'Requires immediate action',
    'Waktu penyelesaian': 'Resolution time',
    'Melewati batas SLA': 'Past the SLA deadline',
    'Tiket selesai terbaru': 'Recently completed tickets',
    'Filter dashboard': 'Dashboard filter',
    'm': 'min',
    'j': 'h',
    'Belum punya akun?': 'Don\'t have an account?',
    'Belum tersedia': 'Not available yet',
    'Beranda': 'Home',
    'Beranda pengguna': 'User home',
    'Board pekerjaan': 'Work board',
    'Buat Laporan': 'Create Report',
    'Buat akun': 'Create account',
    'Buat akun baru': 'Create a new account',
    'Buat laporan': 'Create report',
    'Buat laporan terstruktur': 'Create a structured report',
    'Buka': 'Open',
    'Buka board': 'Open board',
    'Buka notifikasi': 'Open notifications',
    'Buka pekerjaan': 'Open job',
    'Buka profil admin': 'Open admin profile',
    'Buka tiket': 'Open ticket',
    'Bukti sudah lengkap': 'Evidence complete',
    'Cara laporan diproses': 'How a report is handled',
    'Cari berdasarkan ID, lokasi, atau deskripsi...':
        'Search by ID, location, or description...',
    'Cari, filter, dan prioritaskan antrean perbaikan lokasi.':
        'Search, filter, and prioritise the location repair queue.',
    'Catatan': 'Notes',
    'Catatan pemeliharaan': 'Maintenance notes',
    'Catatan pemeliharaan tidak dapat disimpan.':
        'The maintenance note could not be saved.',
    'Catatan perubahan operasional terbaru.':
        'Log of the most recent operational changes.',
    'Catatan perubahan sejak laporan dibuat.':
        'Change log since the report was created.',
    'Catatan tersimpan permanen pada riwayat aset.':
        'Notes are stored permanently in the asset history.',
    'Coba kamera lagi': 'Try the camera again',
    'Coba lagi': 'Try again',
    'Contoh: LAB-A': 'Example: LAB-A',
    'Contoh: tombol spasi tidak merespons saat digunakan.':
        'For example: the space bar does not respond when pressed.',
    'DETAIL': 'DETAILS',
    'DETAIL PEKERJAAN': 'JOB DETAILS',
    'Daftar lokasi gagal dimuat. Periksa koneksi lalu coba lagi.':
        'The location list could not be loaded. Check your connection and try again.',
    'Daftar sekarang': 'Sign up now',
    'Daftar tiket belum dapat dimuat. Tarik untuk mencoba lagi.':
        'The ticket list could not be loaded. Pull to try again.',
    'Daftar tugas': 'Task list',
    'Daftar tugas belum dapat dimuat. Periksa koneksi lalu coba lagi.':
        'The task list could not be loaded. Check your connection and try again.',
    'Daftar unit': 'Unit list',
    'Daftar untuk melaporkan fasilitas.': 'Sign up to report facility issues.',
    'Daftarkan lokasi operasional baru.':
        'Register a new operational location.',
    'Daftarkan unit baru pada lokasi ini.':
        'Register a new unit at this location.',
    'Dalam penanganan': 'Being handled',
    'Dalam proses': 'In progress',
    'Dashboard admin': 'Admin dashboard',
    'Dashboard belum dapat dimuat. Tarik ke bawah untuk mencoba lagi.':
        'The dashboard could not be loaded. Pull down to try again.',
    'Data aset gagal dimuat.': 'Asset data could not be loaded.',
    'Data aset gagal dimuat. Coba lagi.':
        'Asset data could not be loaded. Try again.',
    'Data aset gagal dimuat. Periksa koneksi lalu coba lagi.':
        'Asset data could not be loaded. Check your connection and try again.',
    'Data aset tidak valid.': 'Invalid asset data.',
    'Data formulir belum dapat dimuat. Coba lagi.':
        'The form data could not be loaded. Try again.',
    'Data gagal dimuat': 'Data could not be loaded',
    'Data lokasi gagal dimuat.': 'Location data could not be loaded.',
    'Data lokasi gagal dimuat. Coba lagi.':
        'Location data could not be loaded. Try again.',
    'Data lokasi tidak valid.': 'Invalid location data.',
    'Data penugasan belum lengkap.': 'Assignment details are incomplete.',
    'Data penugasan tidak dapat dimuat. Coba lagi.':
        'Assignment data could not be loaded. Try again.',
    'Deskripsi': 'Description',
    'Deskripsi laporan belum tersedia.':
        'The report description is not available yet.',
    'Deskripsi masalah': 'Problem description',
    'Detail & bukti': 'Details & evidence',
    'Detail Aset': 'Asset Details',
    'Detail Pekerjaan': 'Job Details',
    'Detail Tiket': 'Ticket Details',
    'Detail dan bukti kondisi': 'Details and condition evidence',
    'Detail lokasi belum tersedia': 'Location details not available yet',
    'Detail lokasi gagal dimuat. Periksa koneksi lalu coba lagi.':
        'Location details could not be loaded. Check your connection and try again.',
    'Detail pekerjaan belum dapat dimuat.': 'Job details could not be loaded.',
    'Detail pekerjaan belum dapat dimuat. Periksa koneksi lalu coba lagi.':
        'Job details could not be loaded. Check your connection and try again.',
    'Detail pekerjaan tidak ditemukan.': 'Job details not found.',
    'Detail tiket belum dapat dimuat. Coba lagi.':
        'Ticket details could not be loaded. Try again.',
    'Detail tiket tidak tersedia.': 'Ticket details are unavailable.',
    'Dibatalkan': 'Cancelled',
    'Dibuka kembali': 'Reopened',
    'Dikerjakan': 'In progress',
    'Dilaporkan': 'Reported',
    'Dipensiunkan': 'Retired',
    'Diperbarui': 'Updated',
    'Ditangani': 'Assigned',
    'Ditolak': 'Rejected',
    'Ditutup': 'Closed',
    'Edit aset': 'Edit asset',
    'Edit lokasi': 'Edit location',
    'Ekspor': 'Export',
    'Ekspor log': 'Export log',
    'Ekspor log audit dapat ditambahkan pada tahap berikutnya.':
        'Audit log export can be added in a later stage.',
    'Email belum tersedia': 'Email not available yet',
    'Email dan password wajib diisi.': 'Email and password are required.',
    'Email tersebut belum dapat menerima email dari OpsFix. Hubungi administrator.':
        'That address cannot receive email from OpsFix yet. Contact an administrator.',
    'Email tersebut sudah terdaftar. Silakan masuk atau reset password.':
        'That email is already registered. Sign in or reset your password.',
    'Email tidak tersedia': 'Email unavailable',
    'Fasilitas': 'Facility',
    'Fasilitas terjaga.': 'Facilities cared for.',
    'Filter tiket': 'Filter tickets',
    'Form tiket manual dapat ditambahkan pada tahap berikutnya.':
        'A manual ticket form can be added in a later stage.',
    'Format JPG, PNG, atau WebP, maksimal 5 MB.':
        'JPG, PNG, or WebP format, 5 MB maximum.',
    'Foto': 'Photo',
    'Foto {0} siap dikirim.': 'Photo {0} is ready to send.',
    'Gangguan': 'Issues',
    'Gangguan fasilitas': 'Facility fault',
    'Ganti': 'Replace',
    'Ganti foto · {0}': 'Change photo · {0}',
    'Gedung': 'Building',
    'Gunakan URL HTTPS yang valid.': 'Use a valid HTTPS URL.',
    'Gunakan akun yang telah terdaftar untuk membuka portal sesuai peranmu.':
        'Use your registered account to open the portal for your role.',
    'Gunakan foto JPG, PNG, atau WebP maksimal 5 MB.':
        'Use a JPG, PNG, or WebP photo of at most 5 MB.',
    'Gunakan password dengan minimal 8 karakter.':
        'Use a password of at least 8 characters.',
    'Gunakan tombol Tambah unit untuk membuat aset pertama pada lokasi ini.':
        'Use the Add unit button to create the first asset at this location.',
    'Gunakan tombol Tambah untuk membuat lokasi operasional pertama pada situs ini.':
        'Use the Add button to create the first operational location at this site.',
    'Hapus': 'Delete',
    'Hapus pencarian': 'Clear search',
    'Hasil dikirim untuk verifikasi': 'Result submitted for verification',
    'Hasil diverifikasi': 'Result verified',
    'Hasil perbaikan berhasil dikirim.': 'Repair result submitted.',
    'Hasil perbaikan dikirim': 'Repair result submitted',
    'Hasil perbaikan sudah dikirim. Pelapor sedang memeriksa pekerjaan Anda.':
        'The repair result has been submitted. The reporter is reviewing your work.',
    'ID pengguna': 'User ID',
    'ID tidak tersedia': 'ID unavailable',
    'Identitas akun dan akses portal pengelola.':
        'Account identity and manager portal access.',
    'Identitas akun dan akses portal admin.':
        'Account identity and admin portal access.',
    'Identitas, kondisi, dan riwayat pemeliharaan unit':
        'Unit identity, condition, and maintenance history',
    'Informasi akun': 'Account information',
    'Informasi akun dan akses portal Anda.':
        'Your account details and portal access.',
    'Informasi akun dan akses portal teknisi.':
        'Your account details and technician portal access.',
    'Informasi aset': 'Asset information',
    'Informasi pekerjaan': 'Job information',
    'Informasi pekerjaan belum dapat dimuat.':
        'Job information could not be loaded.',
    'Informasi waktu belum dapat dimuat.':
        'Timing information could not be loaded.',
    'Informasi waktu tiket tidak tersedia.':
        'Ticket timing information is unavailable.',
    'Ingat saya': 'Remember me',
    'Inspeksi': 'Inspection',
    'Isi data dasar. Akses portal mengikuti peran dan lokasi organisasi.':
        'Fill in the basics. Portal access follows your role and organisation site.',
    'Jaga bukti perbaikan.': 'Keep the repair evidence.',
    'Jaringan lambat atau tidak stabil': 'Slow or unstable network',
    'Jelaskan gejala minimal 5 karakter dan tambahkan foto kondisi perangkat.':
        'Describe the symptoms in at least 5 characters and add a photo of the device.',
    'Jelaskan gejala minimal 5 karakter.':
        'Describe the symptoms in at least 5 characters.',
    'Jelaskan gejala yang terlihat dan lampirkan foto terbaru.':
        'Describe the symptoms you can see and attach a recent photo.',
    'Jelaskan gejalanya': 'Describe the symptoms',
    'Jelaskan kondisi': 'Describe the condition',
    'Jenis': 'Type',
    'Jenis catatan': 'Note type',
    'Jenis gangguan belum tersedia': 'Fault type not available yet',
    'Kamera tidak dapat digunakan': 'The camera is unavailable',
    'Kategori': 'Category',
    'Kelola Tiket': 'Manage Tickets',
    'Kelola lokasi dan aset.': 'Manage locations and assets.',
    'Kelola lokasi operasional dan unit pemeliharaan.':
        'Manage operational locations and maintenance units.',
    'Kelola lokasi operasional. Daftar unit tersedia pada halaman detail setiap lokasi.':
        'Manage operational locations. The unit list is on each location’s detail page.',
    'Kelola pekerjaan aktif sesuai prioritas dan status.':
        'Manage active jobs by priority and status.',
    'Kelola penugasan': 'Manage assignment',
    'Keluar': 'Sign out',
    'Keluar dari akun': 'Sign out',
    'Keluar dari akun memerlukan waktu terlalu lama. Coba lagi.':
        'Signing out is taking too long. Try again.',
    'Keluar dengan aman dari portal pengelola.':
        'Sign out of the manager portal securely.',
    'Keluar dengan aman dari portal admin.':
        'Sign out of the admin portal securely.',
    'Keluar…': 'Signing out…',
    'Kembali': 'Back',
    'Kembali ke daftar lokasi': 'Back to location list',
    'Kembali ke dashboard': 'Back to dashboard',
    'Kembali ke semua tiket': 'Back to all tickets',
    'Kembali ke tiket': 'Back to tickets',
    'Kendalikan antrean.': 'Take control of the queue.',
    'Kerusakan furnitur': 'Furniture damage',
    'Kirim hasil perbaikan': 'Submit repair result',
    'Kirim laporan': 'Submit report',
    'Kode belum tersedia': 'Code not available yet',
    'Kode lokasi': 'Location code',
    'Kode lokasi digunakan di beberapa site. Pindai QR lokasi lengkap.':
        'That location code is used at several sites. Scan the full location QR.',
    'Kode sudah digunakan pada situs ini.':
        'That code is already used at this site.',
    'Kode tidak dikenali. Gunakan kode atau QR lokasi OpsFix.':
        'Code not recognised. Use an OpsFix location code or QR.',
    'Kode tiket belum tersedia': 'Ticket code not available yet',
    'Kode unit': 'Unit code',
    'Kode unit sudah digunakan pada lokasi ini.':
        'That unit code is already used at this location.',
    'Kode unit/aset': 'Unit / asset code',
    'Komponen': 'Components',
    'Komponen (pisahkan dengan koma)': 'Components (comma separated)',
    'Komputer tidak dapat menyala': 'Computer will not turn on',
    'Kondisi': 'Condition',
    'Koneksi gagal. Form tetap terbuka untuk dicoba lagi.':
        'Connection failed. The form stays open so you can try again.',
    'Konfirmasi password': 'Confirm password',
    'Konfirmasi password tidak cocok.': 'Password confirmation does not match.',
    'Konteks fasilitas': 'Facility context',
    'Korektif': 'Corrective',
    'Koridor': 'Corridor',
    'Kritikalitas': 'Criticality',
    'Kritis': 'Critical',
    'LOKASI AKTIF': 'ACTIVE LOCATION',
    'LOKASI LAPORAN': 'REPORT LOCATION',
    'Lainnya': 'Other',
    'Langkah pelaporan': 'Reporting steps',
    'Lanjutkan': 'Continue',
    'Lantai': 'Floor',
    'Lapor': 'Report',
    'Laporan baru': 'New report',
    'Laporan belum berhasil dikirim. Periksa data lalu coba lagi.':
        'The report was not submitted. Check the details and try again.',
    'Laporan berbasis lokasi': 'Location-based reporting',
    'Laporan dibuat': 'Report created',
    'Laporan fasilitas': 'Facility reports',
    'Laporan terbaru': 'Latest reports',
    'Laporan tingkat lokasi': 'Location-level reports',
    'Laporan {0} berhasil dibuat.': 'Report {0} created successfully.',
    'Laporkan gangguan fasilitas dan pantau progres berdasarkan data Anda.':
        'Report facility faults and follow their progress from your own data.',
    'Lengkapi informasi berikut agar laporan mudah diproses.':
        'Complete the information below so the report is easy to process.',
    'Lengkapi laporan agar teknisi menerima konteks yang tepat.':
        'Complete the report so the technician gets the right context.',
    'Lengkapi tiga langkah berikut.': 'Complete the three steps below.',
    'Lihat detail': 'View details',
    'Lihat detail lengkap': 'View full details',
    'Lihat lokasi & unit': 'View locations & units',
    'Lihat riwayat': 'View history',
    'Lihat status terbaru, teknisi yang menangani, dan riwayat laporan fasilitasmu.':
        'See the latest status, the technician handling it, and your facility report history.',
    'Lihat tiket saya': 'View my tickets',
    'Log Aktivitas Audit': 'Audit Activity Log',
    'Lokasi': 'Location',
    'Lokasi & Unit': 'Locations & Units',
    'Lokasi & aset': 'Locations & assets',
    'Lokasi aktif': 'Active location',
    'Lokasi belum dapat diarsipkan karena masih memiliki tiket terbuka.':
        'This location cannot be archived while it still has open tickets.',
    'Lokasi belum dapat dimuat': 'The location could not be loaded',
    'Lokasi belum dipilih': 'No location selected',
    'Lokasi belum siap untuk menerima unit baru.':
        'This location is not ready to take new units.',
    'Lokasi belum tersedia': 'Location not available yet',
    'Lokasi berhasil diarsipkan.': 'Location archived.',
    'Lokasi berhasil diperbarui.': 'Location updated.',
    'Lokasi berhasil ditambahkan.': 'Location added.',
    'Lokasi gagal diarsipkan. Periksa koneksi lalu coba lagi.':
        'The location could not be archived. Check your connection and try again.',
    'Lokasi induk': 'Parent location',
    'Lokasi ini': 'This location',
    'Lokasi ini tidak termasuk dalam akses site akun Anda.':
        'This location is not part of your account’s site access.',
    'Lokasi kerja belum dipilih. Masuk ulang lalu coba lagi.':
        'No work location selected. Sign in again and try once more.',
    'Lokasi laporan': 'Report location',
    'Lokasi tanpa nama': 'Unnamed location',
    'Lokasi tidak dapat dimuat.': 'The location could not be loaded.',
    'Lokasi tidak ditemukan atau tidak dapat diakses.':
        'Location not found or not accessible.',
    'Lokasi tidak ditemukan. Periksa kembali kode atau QR OpsFix.':
        'Location not found. Check the OpsFix code or QR again.',
    'Lokasi tidak valid atau situs aktif belum dipilih.':
        'Invalid location, or no active site has been selected.',
    'Lokasi, unit, pelapor, dan teknisi yang terkait.':
        'The related location, unit, reporter, and technician.',
    'Luar ruang': 'Outdoor',
    'Lupa password?': 'Forgot password?',
    'Manajer': 'Manager',
    'Masalah keyboard atau mouse': 'Keyboard or mouse problem',
    'Masalah pada layar': 'Screen problem',
    'Masalah pada ruangan': 'Room problem',
    'Masalah pada stopkontak': 'Power socket problem',
    'Masuk': 'Sign in',
    'Masuk di sini': 'Sign in here',
    'Masuk ke akunmu.': 'Sign in to your account.',
    'Masukkan alamat email yang valid.': 'Enter a valid email address.',
    'Masukkan kode lokasi': 'Enter location code',
    'Masukkan kode lokasi secara manual di bawah ini, atau izinkan akses kamera dan buka aplikasi melalui HTTPS lalu coba lagi.':
        'Enter the location code manually below, or allow camera access and open the app over HTTPS, then try again.',
    'Masukkan kode lokasi terlebih dahulu.': 'Enter a location code first.',
    'Masukkan nama lengkap Anda.': 'Enter your full name.',
    'Melewati SLA': 'SLA breached',
    'Memuat lokasi…': 'Loading locations…',
    'Memulai…': 'Starting…',
    'Mengambil daftar lokasi aktif dari Supabase.':
        'Fetching the active location list from Supabase.',
    'Mengambil lokasi, unit, dan konfigurasi QR.':
        'Fetching locations, units, and QR configuration.',
    'Mengarsipkan…': 'Archiving…',
    'Mengirim laporan…': 'Submitting report…',
    'Mengirim…': 'Submitting…',
    'Menit selesai': 'Minutes to completion',
    'Menunggu pelapor': 'Awaiting reporter',
    'Menunggu tindakan': 'Awaiting action',
    'Menunggu verifikasi': 'Awaiting verification',
    'Menyimpan…': 'Saving…',
    'Minimal 8 karakter · satu huruf kapital · satu angka · konfirmasi cocok':
        'At least 8 characters · one capital letter · one digit · confirmation matches',
    'Muat ulang board': 'Reload board',
    'Mulai pekerjaan': 'Start job',
    'Mulai pekerjaan saat Anda sudah berada di lokasi dan siap menangani unit.':
        'Start the job once you are on site and ready to work on the unit.',
    'Mulai tugas yang siap dikerjakan, lanjutkan pekerjaan aktif, lalu kirim hasil perbaikan.':
        'Start the tasks that are ready, continue active work, then submit the repair result.',
    'Nama harus terdiri dari 2 sampai 100 karakter.':
        'Name must be between 2 and 100 characters.',
    'Nama lengkap': 'Full name',
    'Nama lokasi': 'Location name',
    'Nama unit/aset': 'Unit / asset name',
    'Nomor telepon': 'Phone number',
    'Notifikasi belum dapat diperbarui. Coba kembali.':
        'Notifications could not be updated. Try again.',
    'Oleh': 'By',
    'Operasi tidak dapat diselesaikan.':
        'The operation could not be completed.',
    'Operasional': 'Operational',
    'PORTAL OPERASIONAL FASILITAS': 'FACILITY OPERATIONS PORTAL',
    'PORTAL PENGGUNA': 'USER PORTAL',
    'Paling lama diperbarui': 'Least recently updated',
    'Pantau alur kerja aktif berdasarkan status dan prioritas.':
        'Track the active workflow by status and priority.',
    'Pantau antrean, SLA, dan progres perbaikan lokasi.':
        'Track the queue, SLA, and repair progress for the location.',
    'Pantau konteks, SLA, penugasan, dan aktivitas tiket.':
        'Track ticket context, SLA, assignment, and activity.',
    'Pantau laporan dan perangkat lokasi aktif.':
        'Track reports and devices at the active location.',
    'Pantau laporan saya.': 'Track my reports.',
    'Pantau lokasi dan kelola unit pemeliharaan.':
        'Track locations and manage maintenance units.',
    'Pantau perkembangan seluruh laporan fasilitas.':
        'Track the progress of every facility report.',
    'Pantau perkembangan tiket dan aktivitas terbaru akun Anda.':
        'Follow your ticket progress and the latest activity on your account.',
    'Pantau progres laporan, prioritas penanganan, lokasi, dan teknisi dalam satu antrean.':
        'Track report progress, handling priority, location, and technician in one queue.',
    'Parkir': 'Parking',
    'Password minimal terdiri dari 8 karakter.':
        'Password must be at least 8 characters.',
    'Pastikan informasi berikut sudah benar sebelum dikirim.':
        'Check that the details below are correct before submitting.',
    'Pastikan laporan benar': 'Check the report',
    'Pekerjaan aktif yang ditugaskan kepada Anda.':
        'Active jobs assigned to you.',
    'Pekerjaan aktif yang ditugaskan kepada {0}.':
        'Active jobs assigned to {0}.',
    'Pekerjaan berhasil dimulai.': 'Job started.',
    'Pekerjaan dimulai': 'Job started',
    'Pekerjaan gagal dimulai. Muat ulang lalu coba lagi.':
        'The job could not be started. Reload and try again.',
    'Pekerjaan selesai': 'Job complete',
    'Pekerjaan selesai dan tiket yang telah ditutup.':
        'Completed jobs and closed tickets.',
    'Pekerjaan terlacak.': 'Work fully tracked.',
    'Pekerjaan yang': 'Work that is',
    'Pelapor': 'Reporter',
    'Pelapor fasilitas': 'Facility reporter',
    'Pelapor tidak tersedia': 'Reporter unavailable',
    'Pembaruan': 'Updates',
    'Pembaruan akun': 'Account updates',
    'Pembaruan belum dapat dimuat. Periksa koneksi lalu coba lagi.':
        'Updates could not be loaded. Check your connection and try again.',
    'Pembaruan pekerjaan': 'Job updates',
    'Pembaruan tugas tersedia pada daftar tugas.':
        'Task updates are available in the task list.',
    'Pemeliharaan aset': 'Asset maintenance',
    'Pendaftaran akun sedang tidak tersedia.':
        'Account registration is currently unavailable.',
    'Pendaftaran gagal. Periksa data Anda lalu coba lagi.':
        'Registration failed. Check your details and try again.',
    'Pendaftaran menggunakan email dan password sedang dinonaktifkan.':
        'Email and password registration is currently disabled.',
    'Pengelola': 'Manager',
    'Pengerjaan dimulai': 'Work started',
    'Pengerjaan selesai': 'Work complete',
    'Pengguna OpsFix': 'OpsFix user',
    'Penugasan diterima': 'Assignment accepted',
    'Penugasan tidak dapat disimpan. Muat ulang tiket lalu coba lagi.':
        'The assignment could not be saved. Reload the ticket and try again.',
    'Peran': 'Role',
    'Perangkat': 'Device',
    'Perangkat & gangguan': 'Device & fault',
    'Perangkat akan ditampilkan setelah pengelola menambahkannya ke lokasi aktif.':
        'Devices appear once a manager adds them to the active location.',
    'Perangkat dan jenis gangguan': 'Device and fault type',
    'Perangkat dipilih: {0}': 'Selected device: {0}',
    'Perangkat lokasi': 'Location devices',
    'Perangkat yang dilaporkan': 'Reported device',
    'Perbaikan dinyatakan selesai': 'Repair marked complete',
    'Perbaikan diverifikasi': 'Repair verified',
    'Perbaikan selesai': 'Repair complete',
    'Perbaikan telah diterima. Tidak ada tindakan lain yang perlu dilakukan.':
        'The repair has been accepted. No further action is needed.',
    'Perbarui informasi aset pada lokasi ini.':
        'Update the asset details at this location.',
    'Perbarui informasi atau arsipkan aset dengan aman.':
        'Update the details or archive the asset safely.',
    'Perbarui informasi lokasi operasional.':
        'Update the operational location details.',
    'Periksa jenis, waktu, dan isi catatan. Catatan minimal 3 karakter.':
        'Check the note type, time, and content. Notes need at least 3 characters.',
    'Periksa kembali nilai formulir.': 'Check the form values again.',
    'Perlu perhatian': 'Needs attention',
    'Perubahan status, penugasan, dan pekerjaan pada tiket ini.':
        'Status changes, assignments, and work on this ticket.',
    'Perubahan tercatat pada sistem.': 'The change has been recorded.',
    'Pilih bahasa tampilan aplikasi.': 'Choose the app display language.',
    'Bahasa berubah di perangkat ini. Sinkronisasi akun akan dicoba kembali.':
        'Language changed on this device. Account sync will be retried.',
    'Pilih foto kondisi perangkat': 'Choose a photo of the device',
    'Pilih jenis gangguan': 'Choose a fault type',
    'Pilih jenis gangguan terlebih dahulu.': 'Choose a fault type first.',
    'Pilih jenis gangguan, jelaskan gejalanya, lalu sertakan foto agar teknisi menerima konteks yang tepat.':
        'Choose the fault type, describe the symptoms, then attach a photo so the technician gets the right context.',
    'Pilih lokasi untuk membuat laporan':
        'Choose a location to create a report',
    'Pilih objek laporan dan masalah yang paling sesuai.':
        'Choose the report subject and the problem that fits best.',
    'Pilih perangkat': 'Choose a device',
    'Pilih perangkat dan jenis gangguan sebelum melanjutkan.':
        'Choose a device and a fault type before continuing.',
    'Pilih perangkat yang akan dilaporkan.': 'Choose the device to report.',
    'Pilih teknisi aktif yang memiliki akses ke lokasi tiket.':
        'Choose an active technician with access to the ticket location.',
    'Pilih tiket untuk melihat ringkasannya.':
        'Select a ticket to see its summary.',
    'Pilih unit atau perangkat': 'Choose a unit or device',
    'Pilih unit untuk melihat detail aset.':
        'Select a unit to see the asset details.',
    'Pilihan sudah lengkap': 'Selection complete',
    'Portal OpsFix': 'OpsFix portal',
    'Portal admin': 'Admin portal',
    'Portal pengguna': 'User portal',
    'Portal teknisi': 'Technician portal',
    'Posisi': 'Position',
    'Posisi belum diisi': 'Position not filled in',
    'Posisi belum ditentukan': 'Position not set',
    'Preventif': 'Preventive',
    'Prioritas': 'Priority',
    'Prioritas kritis': 'Critical priority',
    'Prioritas operasional': 'Operational priority',
    'Profil Admin': 'Admin Profile',
    'Profil Pengguna': 'User Profile',
    'Profil Teknisi': 'Technician Profile',
    'Profil admin': 'Admin profile',
    'Profil admin belum dapat dimuat. Coba lagi.':
        'The admin profile could not be loaded. Try again.',
    'Profil admin sedang tidak aktif.': 'This admin profile is inactive.',
    'Profil admin tidak ditemukan.': 'Admin profile not found.',
    'Profil admin tidak tersedia.': 'Admin profile unavailable.',
    'Profil akun belum lengkap. Informasi sesi tetap dapat digunakan.':
        'Your account profile is incomplete. Session details are still usable.',
    'Profil belum dapat dimuat. Periksa koneksi lalu coba kembali.':
        'The profile could not be loaded. Check your connection and try again.',
    'Profil belum dapat dimuat. Periksa koneksi lalu coba lagi.':
        'The profile could not be loaded. Check your connection and try again.',
    'Profil pengguna': 'User profile',
    'Profil teknisi': 'Technician profile',
    'Profil teknisi belum tersedia. Identitas sesi tetap dapat digunakan.':
        'The technician profile is not available yet. Session identity is still usable.',
    'Progres laporan': 'Report progress',
    'Proses keluar terlalu lama. Periksa koneksi lalu coba kembali.':
        'Signing out is taking too long. Check your connection and try again.',
    'Pusat pembaruan akun': 'Account update centre',
    'QR hanya digunakan untuk memilih lokasi laporan.':
        'The QR code is only used to choose the report location.',
    'QR hanya tersedia untuk lokasi induk.':
        'QR codes are only available for parent locations.',
    'QR lokasi': 'Location QR',
    'QR tersedia pada lokasi': 'QR available at the location',
    'QR tersedia pada lokasi induk, bukan per unit.':
        'The QR code lives on the parent location, not on each unit.',
    'Rata-rata resolusi': 'Average resolution',
    'Rendah': 'Low',
    'Riwayat': 'History',
    'Riwayat aktivitas': 'Activity history',
    'Riwayat aktivitas belum dapat dimuat.':
        'Activity history could not be loaded.',
    'Riwayat aktivitas belum dapat dimuat. Coba lagi.':
        'Activity history could not be loaded. Try again.',
    'Riwayat aktivitas tidak tersedia.': 'Activity history is unavailable.',
    'Riwayat append-only untuk unit ini.': 'Append-only history for this unit.',
    'Riwayat pekerjaan': 'Job history',
    'Riwayat pekerjaan belum dapat dimuat.': 'Job history could not be loaded.',
    'Riwayat pekerjaan belum dapat dimuat. Periksa koneksi lalu coba lagi.':
        'Job history could not be loaded. Check your connection and try again.',
    'Riwayat perbaikan': 'Repair history',
    'Ruangan': 'Room',
    'Salin tautan': 'Copy link',
    'Satu QR membuka lokasi dan seluruh unitnya.':
        'One QR opens the location and all of its units.',
    'Satu ruang kerja untuk melaporkan gangguan, mengatur penugasan, dan memastikan setiap perbaikan selesai dengan bukti.':
        'One workspace to report faults, manage assignments, and make sure every repair is completed with evidence.',
    'Saya menyetujui Kebijakan Privasi dan Ketentuan Penggunaan.':
        'I agree to the Privacy Policy and Terms of Use.',
    'Scan / kode': 'Scan / code',
    'Scan QR lokasi': 'Scan location QR',
    'Sedang': 'Medium',
    'Sedang bertugas': 'On duty',
    'Sedang dikerjakan': 'In progress',
    'Sedang keluar…': 'Signing out…',
    'Selamat datang di OpsFix': 'Welcome to OpsFix',
    'Selamat datang kembali di pusat operasi OpsFix.':
        'Welcome back to the OpsFix operations centre.',
    'Selesai': 'Done',
    'Selesai bulan ini': 'Completed this month',
    'Selesai hari ini': 'Completed today',
    'Sembunyikan password': 'Hide password',
    'Semua': 'All',
    'Semua notifikasi ditandai sudah dibaca.':
        'All notifications marked as read.',
    'Semua notifikasi sudah dibaca.': 'All notifications are already read.',
    'Semua prioritas': 'All priorities',
    'Semua status': 'All statuses',
    'Semua tiket': 'All tickets',
    'Semua tiket dalam satu antrean.': 'Every ticket in one queue.',
    'Sesi Anda telah berakhir. Silakan masuk kembali.':
        'Your session has ended. Please sign in again.',
    'Sesi admin tidak tersedia. Silakan masuk kembali.':
        'The admin session is unavailable. Please sign in again.',
    'Sesi akun': 'Account session',
    'Sesi akun tidak tersedia. Anda tetap dapat keluar dari akun.':
        'The account session is unavailable. You can still sign out.',
    'Sesi berakhir. Silakan masuk kembali.':
        'Your session has ended. Please sign in again.',
    'Setiap perubahan dapat diaudit.': 'Every change is auditable.',
    'Setujui Kebijakan Privasi dan Ketentuan Penggunaan untuk melanjutkan.':
        'Accept the Privacy Policy and Terms of Use to continue.',
    'Siap dikerjakan': 'Ready to start',
    'Siap dimulai': 'Ready to start',
    'Simpan': 'Save',
    'Simpan URL publik': 'Save public URL',
    'Simpan URL publik HTTPS terlebih dahulu untuk membuat QR.':
        'Save the public HTTPS URL first to generate a QR code.',
    'Simpan aset': 'Save asset',
    'Simpan catatan': 'Save note',
    'Simpan lokasi': 'Save location',
    'Sistem': 'System',
    'Sistem OpsFix': 'OpsFix system',
    'Site aktif belum tersedia. Masuk ulang lalu coba lagi.':
        'No active site yet. Sign in again and try once more.',
    'Situs aktif belum dipilih.': 'No active site has been selected.',
    'Situs aktif belum dipilih. Masuk ulang lalu coba lagi.':
        'No active site has been selected. Sign in again and try once more.',
    'Slug QR sudah digunakan. Gunakan kode lain.':
        'That QR slug is already in use. Choose another code.',
    'Slug QR tetap: {0}': 'QR slug stays: {0}',
    'Status': 'Status',
    'Status akun': 'Account status',
    'Status aset': 'Asset status',
    'Status belum tersedia': 'Status not available yet',
    'Status berubah dari {0} menjadi {1}.': 'Status changed from {0} to {1}.',
    'Status diperbarui': 'Status updated',
    'Status real-time': 'Real-time status',
    'Status sistem': 'System status',
    'Status tiket': 'Ticket status',
    'Status tiket diperbarui': 'Ticket status updated',
    'Status tiket ini tidak menerima penugasan baru.':
        'This ticket status does not accept a new assignment.',
    'Status tiket saat ini tidak memerlukan tindakan dari teknisi.':
        'The current ticket status needs no action from a technician.',
    'Sudah punya akun?': 'Already have an account?',
    'TEKNISI': 'TECHNICIAN',
    'TEKNISI · RIWAYAT': 'TECHNICIAN · HISTORY',
    'TICKET TRACKING': 'TICKET TRACKING',
    'TIKET AKTIF': 'OPEN TICKETS',
    'Tambah': 'Add',
    'Tambah catatan': 'Add note',
    'Tambah catatan pemeliharaan': 'Add maintenance note',
    'Tambah lokasi': 'Add location',
    'Tambah unit': 'Add unit',
    'Tambah unit/aset': 'Add unit / asset',
    'Tambahkan catatan dan foto hasil agar pelapor dapat memverifikasi pekerjaan.':
        'Add a note and a result photo so the reporter can verify the work.',
    'Tambahkan foto kondisi perangkat.': 'Add a photo of the device.',
    'Tampilkan password': 'Show password',
    'Tandai semua dibaca': 'Mark all as read',
    'Tanpa kategori': 'Uncategorised',
    'Target belum tersedia': 'Target not available yet',
    'Target penyelesaian': 'Completion target',
    'Target tiket tidak tersedia': 'Ticket target unavailable',
    'Target waktu penanganan': 'Handling time target',
    'Tautan lokasi disalin.': 'Location link copied.',
    'Tautan tiket tidak valid.': 'Invalid ticket link.',
    'Tekan unit untuk membuka detail aset.':
        'Tap a unit to open its asset details.',
    'Teknisi': 'Technician',
    'Teknisi OpsFix': 'OpsFix technician',
    'Teknisi ditetapkan': 'Technician assigned',
    'Teknisi ditugaskan': 'Technician assigned',
    'Teknisi lapangan': 'Field technician',
    'Teknisi pengganti': 'Replacement technician',
    'Teknisi telah ditetapkan': 'A technician has been assigned',
    'Teknisi tersedia': 'Available technicians',
    'Telusuri perubahan operasional terbaru pada site aktif.':
        'Browse the most recent operational changes at the active site.',
    'Tenggat SLA terdekat': 'Nearest SLA deadline',
    'Tentukan masalah': 'Identify the problem',
    'Terakhir diperbarui': 'Last updated',
    'Terapkan': 'Apply',
    'Terjadi kendala': 'Something went wrong',
    'Terlalu banyak percobaan pendaftaran. Tunggu beberapa menit lalu coba lagi.':
        'Too many registration attempts. Wait a few minutes and try again.',
    'Tersedia di lokasi tiket': 'Available at the ticket location',
    'Tetap kirim': 'Submit anyway',
    'Tetapkan': 'Assign',
    'Tetapkan teknisi': 'Assign technician',
    'Tidak ada keterangan tambahan.': 'No additional notes.',
    'Tidak ada koneksi jaringan': 'No network connection',
    'Tidak ada pekerjaan aktif.': 'No active jobs.',
    'Tidak ada teknisi lain yang tersedia untuk mengganti penugasan.':
        'No other technician is available to take over the assignment.',
    'Tidak ada tiket untuk ditampilkan': 'No tickets to show',
    'Tidak ada tiket untuk status ini.': 'No tickets with this status.',
    'Tidak ada tiket yang sesuai.': 'No matching tickets.',
    'Tidak aktif': 'Inactive',
    'Tidak beroperasi': 'Not operating',
    'Tidak dapat masuk ke akun': 'Cannot sign in to the account',
    'Tidak dapat terhubung ke server. Periksa koneksi lalu coba lagi.':
        'Cannot reach the server. Check your connection and try again.',
    'Tidak diketahui': 'Unknown',
    'Tiket': 'Tickets',
    'Tiket aktif': 'Open tickets',
    'Tiket baru akan muncul di sini setelah Anda ditugaskan.':
        'New tickets appear here once you are assigned.',
    'Tiket belum dapat dibuka. Coba kembali.':
        'The ticket could not be opened. Try again.',
    'Tiket belum dipilih.': 'No ticket selected.',
    'Tiket dibuka kembali': 'Ticket reopened',
    'Tiket dikelompokkan menurut status dan prioritas.':
        'Tickets grouped by status and priority.',
    'Tiket ditutup': 'Ticket closed',
    'Tiket ini sudah memiliki teknisi. Pilih pengganti hanya jika diperlukan.':
        'This ticket already has a technician. Only choose a replacement if necessary.',
    'Tiket kritis': 'Critical tickets',
    'Tiket saya': 'My tickets',
    'Tiket serupa masih aktif. Tinjau peringatan sebelum melanjutkan.':
        'A similar ticket is still open. Review the warning before continuing.',
    'Tiket terbaru': 'Latest tickets',
    'Tiket terbaru akan muncul setelah Anda mengirim laporan pertama.':
        'Your latest tickets appear once you submit your first report.',
    'Tiket terlambat': 'Overdue tickets',
    'Tiket tidak dapat dimuat.': 'The ticket could not be loaded.',
    'Tiket tidak dapat dimuat. Periksa koneksi lalu coba lagi.':
        'The ticket could not be loaded. Check your connection and try again.',
    'Tiket tidak ditemukan atau tidak dapat diakses.':
        'Ticket not found or not accessible.',
    'Tiket {0} dengan perangkat dan gangguan serupa masih aktif. Periksa tiket tersebut atau pilih “Tetap kirim” bila ini masalah berbeda.':
        'Ticket {0} for a similar device and fault is still open. Check that ticket, or choose “Submit anyway” if this is a different problem.',
    'Tindakan aset': 'Asset actions',
    'Tinggi': 'High',
    'Tinjau & kirim': 'Review & submit',
    'Tinjau informasi dan kelola progres pekerjaan.':
        'Review the details and manage job progress.',
    'Tinjau kembali perbaikan yang telah ditutup beserta lokasi dan detail laporannya.':
        'Review closed repairs together with their location and report details.',
    'Tinjau laporan': 'Review report',
    'Tinjau pekerjaan yang telah selesai dan ditutup.':
        'Review jobs that have been completed and closed.',
    'Tipe': 'Type',
    'Tipe lokasi': 'Location type',
    'Toilet': 'Toilet',
    'Total pekerjaan selesai': 'Total jobs completed',
    'Tugas': 'Tasks',
    'Tugas yang perlu': 'Tasks you need',
    'Tutup': 'Close',
    'URL gagal disimpan. Periksa koneksi.':
        'The URL could not be saved. Check your connection.',
    'URL publik aplikasi (https://...)': 'Public app URL (https://...)',
    'URL publik tersimpan. QR lokasi telah diperbarui.':
        'Public URL saved. The location QR has been updated.',
    'Ubah pencarian atau filter untuk melihat antrean lain.':
        'Change the search or filter to see a different queue.',
    'Unit': 'Unit',
    'Unit aktif di lokasi ini siap dipantau dan dikelola.':
        'Active units at this location are ready to track and manage.',
    'Unit belum tersedia': 'Unit not available yet',
    'Unit berhasil ditambahkan.': 'Unit added.',
    'Unit fasilitas': 'Facility unit',
    'Urutan': 'Order',
    'Urutkan tiket': 'Sort tickets',
    'WAKTU': 'TIME',
    'Waktu': 'Time',
    'Waktu belum tersedia': 'Time not available yet',
    'Waktu pelaksanaan (YYYY-MM-DD HH:mm)': 'Performed at (YYYY-MM-DD HH:mm)',
    'Waktu tidak tersedia': 'Time not available',
    'Work Board Operasional': 'Operational Work Board',
    'Work Board belum dapat dimuat. Coba lagi.':
        'The work board could not be loaded. Try again.',
    'Work Board tidak tersedia.': 'The work board is unavailable.',
    'Zona': 'Zone',
    'Zona (kosong = kode lokasi)': 'Zone (empty = location code)',
    'atau masukkan kode lokasi': 'or enter the location code',
    'diarsipkan. Riwayat tiket dan pemeliharaan tetap tersimpan.':
        'archived. Ticket and maintenance history is preserved.',
    'sudah selesai.': 'already complete.',
    '{0} aktor': '{0} actors',
    '{0} dan unit aktifnya akan diarsipkan. Riwayat tiket dan pemeliharaan tetap tersimpan.':
        '{0} and its active units will be archived. Ticket and maintenance history is preserved.',
    '{0} dari maksimal 100': '{0} of a maximum of 100',
    '{0} hari lalu': '{0} days ago',
    '{0} jam lalu': '{0} hours ago',
    '{0} lokasi aktif': '{0} active locations',
    '{0} menit lalu': '{0} minutes ago',
    '{0} notifikasi belum dibaca.': '{0} unread notifications.',
    '{0} unit aktif': '{0} active units',
    'Gangguan lokasi': 'Location issues',
    'Buka profil': 'Open profile',
    'Gangguan aktif': 'Active issues',
    'Gangguan aktif di lokasi ini': 'Active issues at this location',
    'Laporan terbuka dari pengguna di lokasi aktif.':
        'Open reports from users at the active location.',
    'Lihat semua': 'View all',
    'Saya juga terdampak': 'I’m also affected',
    'Anda juga terdampak': 'You’re also affected',
    'Buka gangguan': 'View issue',
    'Belum ada gangguan aktif di lokasi ini.':
        'There are no active issues at this location.',
    'Gangguan lokasi belum dapat dimuat. Periksa akses atau koneksi.':
        'Location issues could not be loaded. Check your access or connection.',
    'Lokasi aktif Anda': 'Your active location',
    'STATUS LOKASI': 'LOCATION STATUS',
    '{0} orang terdampak': '{0} people affected',
    '{0} terdampak': '{0} affected',
    'Kembali ke tiket saya': 'Back to my tickets',
    'Pantau status dan hasil perbaikan laporan Anda.':
        'Track the status and repair result of your report.',
    'Memuat detail tiket...': 'Loading ticket details...',
    'Tiket tidak valid': 'Invalid ticket',
    'Detail tiket tidak dapat diakses.':
        'The ticket details cannot be accessed.',
    'Informasi laporan': 'Report information',
    'Verifikasi perbaikan': 'Verify repair',
    'Periksa catatan hasil teknisi. Terima jika masalah selesai, atau buka kembali bila masih bermasalah.':
        'Review the technician notes. Accept the repair if the issue is resolved, or reopen it if the problem remains.',
    'Belum ada hasil perbaikan.': 'No repair result is available yet.',
    'Percobaan {0}': 'Attempt {0}',
    'Terima': 'Accept',
    'Buka lagi': 'Reopen',
    'Perbaikan diterima.': 'Repair accepted.',
    'Tiket dibuka kembali.': 'Ticket reopened.',
    'Verifikasi gagal. Silakan coba lagi.':
        'Verification failed. Please try again.',
    'Linimasa tiket': 'Ticket timeline',
    'Belum ada aktivitas tiket.': 'No ticket activity is available yet.',
    'PELACAKAN TIKET': 'TICKET TRACKING',
    'Menunggu suku cadang': 'Waiting for parts',
    'Ditunda': 'On hold',
    'Ditingkatkan': 'Escalated',
    'Pengguna lain terdampak': 'Another user is affected',
    'Unduh QR': 'Download QR',
    'Unduh semua QR': 'Download all QR codes',
    'Unduh PNG': 'Download PNG',
    'Unduh PDF': 'Download PDF',
    'Cetak': 'Print',
    'Pratinjau, unduh, atau cetak QR lokasi ini.':
        'Preview, download, or print this location QR code.',
    'Siapkan QR lokasi aktif untuk dicetak.':
        'Prepare active location QR codes for printing.',
    'Pilih tata letak cetak': 'Choose a print layout',
    '6 kartu per lembar': '6 cards per sheet',
    '1 poster per halaman': '1 poster per page',
    'Hemat kertas dan mudah dipotong.':
        'Save paper with cards that are easy to cut.',
    'Siap ditempel dengan QR berukuran besar.':
        'Ready to display with a large QR code.',
    'Menyiapkan file…': 'Preparing file…',
    'File QR berhasil disimpan.': 'The QR file was saved.',
    'Dialog cetak telah dibuka.': 'The print dialog is open.',
    'Ekspor dibatalkan.': 'Export cancelled.',
    'Data lokasi belum tersedia.': 'Location data is not available yet.',
    'QR gagal dibuat. Coba lagi.':
        'The QR document could not be generated. Try again.',
    'File gagal disimpan. Coba lagi.':
        'The file could not be saved. Try again.',
    'Simpan URL publik HTTPS sebelum mengekspor QR.':
        'Save the public HTTPS URL before exporting QR codes.',
    'URL publik berhasil disimpan.': 'Public URL saved.',
    'Konfigurasi QR gagal dimuat. Periksa koneksi.':
        'QR configuration could not be loaded. Check your connection.',
    'Situs aktif tidak dapat diakses.': 'The active site cannot be accessed.',
    'Situs aktif': 'Active site',
    'Satu atau beberapa lokasi tidak memiliki kode QR yang valid.':
        'One or more locations do not have a valid QR code.',
    'Anda adalah pelapor awal gangguan ini.':
        'You are the original reporter of this issue.',
    'Anda ditambahkan sebagai pengguna yang terdampak.':
        'You were added as an affected user.',
    'Anda sekarang mengikuti progres gangguan ini.':
        'You are now following the progress of this issue.',
    'Anda sudah melaporkan gangguan ini.':
        'You have already reported this issue.',
    'Anda sudah menandai diri sebagai pengguna yang terdampak.':
        'You have already marked yourself as an affected user.',
    'Anda sudah menandai terdampak.':
        'You have already marked yourself as affected.',
    'Belum dapat menandai terdampak. Periksa koneksi lalu coba lagi.':
        'Could not mark you as affected. Check your connection and try again.',
    'Belum dapat menandai terdampak. Silakan coba lagi.':
        'Could not mark you as affected. Please try again.',
    'Gangguan ini sudah dilaporkan': 'This issue has already been reported',
    'Gangguan ini sudah ditutup. Periksa kembali pilihan Anda.':
        'This issue has been closed. Review your selection.',
    'Keluar dengan aman dari portal pengguna.':
        'Sign out securely from the user portal.',
    'Keluar dengan aman dari portal teknisi.':
        'Sign out securely from the technician portal.',
    'Laporan belum berhasil dikirim. Periksa koneksi lalu coba lagi.':
        'The report could not be submitted. Check your connection and try again.',
    'Laporan serupa baru saja dibuat. Anda dapat menandai diri sebagai terdampak.':
        'A similar report was just created. You can mark yourself as affected.',
    'Pemeriksaan gangguan belum berhasil. Periksa koneksi lalu coba lagi.':
        'The issue check could not be completed. Check your connection and try again.',
    'Profil': 'Profile',
    'Status terdampak sudah tercatat.':
        'Your affected status has been recorded.',
    'Tiket {0} dengan perangkat dan gangguan serupa masih aktif. Periksa tiket tersebut atau pilih “Kirim laporan” bila ini masalah berbeda.':
        'Ticket {0} with the same device and issue is still active. Review that ticket or choose “Submit report” if this is a different problem.',
    'Selesai {0}': 'Completed {0}',
    'Penugasan {0}': '{0} assignment',
    'Ditangani oleh {0}': 'Handled by {0}',
  };

  /// English source -> Indonesian, for the parts of the app authored in English.
  static const Map<String, String> _id = <String, String>{
    'Activity log': 'Log aktivitas',
    'Add a description and evidence photo.':
        'Tambahkan deskripsi dan foto bukti.',
    'Add a repair note and proof photo first.':
        'Tambahkan catatan perbaikan dan foto bukti terlebih dahulu.',
    'Board': 'Papan',
    'Change evidence photo': 'Ganti foto bukti',
    'Change proof photo': 'Ganti foto bukti',
    'Choose an issue type first.': 'Pilih jenis gangguan terlebih dahulu.',
    'Choose evidence photo': 'Pilih foto bukti',
    'Choose proof photo': 'Pilih foto bukti',
    'Complete repair': 'Selesaikan perbaikan',
    'Completion request failed.': 'Permintaan penyelesaian gagal.',
    'Could not create the ticket. Check the form and try again.':
        'Tiket gagal dibuat. Periksa formulir lalu coba lagi.',
    'Could not submit completion. Check the proof and retry.':
        'Hasil penyelesaian gagal dikirim. Periksa bukti lalu coba lagi.',
    'Dashboard': 'Dasbor',
    'Edit': 'Ubah',
    'Email': 'Email',
    'Facility care, made traceable.': 'Perawatan fasilitas yang terlacak.',
    'Filter': 'Filter',
    'Invalid session or ticket.': 'Sesi atau tiket tidak valid.',
    'Locations & assets': 'Lokasi & aset',
    'Log': 'Log',
    'Manager': 'Pengelola',
    'OpsFix Admin': 'Admin OpsFix',
    'Password': 'Kata sandi',
    'Please sign in again.': 'Silakan masuk kembali.',
    'Repair note': 'Catatan perbaikan',
    'Reset': 'Atur ulang',
    'Select a valid location first.':
        'Pilih lokasi yang valid terlebih dahulu.',
    'Send for verification': 'Kirim untuk verifikasi',
    'Submit report with evidence': 'Kirim laporan dengan bukti',
    'Technician is not assigned to this site.':
        'Teknisi tidak ditugaskan pada situs ini.',
    'The evidence photo must be 5 MB or smaller.':
        'Foto bukti maksimal berukuran 5 MB.',
    'The proof photo must be 5 MB or smaller.':
        'Foto bukti maksimal berukuran 5 MB.',
    'Ticket changed. Refresh and try again.':
        'Tiket berubah. Muat ulang lalu coba lagi.',
    'Ticket not found or access denied.':
        'Tiket tidak ditemukan atau akses ditolak.',
    'Ticket site is missing.': 'Situs tiket tidak tersedia.',
    'Ticket status no longer allows assignment.':
        'Status tiket tidak lagi menerima penugasan.',
    'Ticket status was not updated.': 'Status tiket tidak diperbarui.',
    'Tickets': 'Tiket',
    'Use a JPEG, PNG, or WebP image.': 'Gunakan gambar JPEG, PNG, atau WebP.',
    'Work board': 'Papan kerja',
  };
}

/// Compact `ID | EN` selector.
///
/// Writes both halves of the language state in one place:
///   * `setAppLanguage(...)` drives FlutterFlow's own locale, so every
///     FF-managed Text switches;
///   * `FFAppState().appLanguage` mirrors it so [OpsFixI18n] can resolve a
///     language without a BuildContext.
///
/// Intentionally self-sizing (`MainAxisSize.min`, no fixed height). The
/// previous language switcher was removed in prompts12 because it was inserted
/// as a fixed-height sibling above the logout footer and pushed it off-screen;
/// this control is designed to be dropped into a scrolling profile column
/// without displacing anything.
class OpsFixLanguageSetting extends StatefulWidget {
  const OpsFixLanguageSetting({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<OpsFixLanguageSetting> createState() => _OpsFixLanguageSettingState();
}

class _OpsFixLanguageSettingState extends State<OpsFixLanguageSetting> {
  static const List<List<String>> _options = <List<String>>[
    <String>['id', 'ID', 'Bahasa Indonesia'],
    <String>['en', 'EN', 'English'],
  ];

  Future<void> _select(String code) async {
    if (OpsFixI18n.languageOf(context) == code) return;
    FFAppState().update(() {
      FFAppState().appLanguage = code;
    });
    setAppLanguage(context, code);
    if (SupaFlow.client.auth.currentUser == null) return;
    try {
      final result = await SupaFlow.client.rpc(
        'set_opsfix_preferred_language',
        params: {'p_language': code},
      );
      if (result != 'updated') throw StateError('language_not_updated');
    } catch (error) {
      debugPrint(
          'OpsFix language preference unavailable: ${error.runtimeType}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            OpsFixI18n.t(
              'Bahasa berubah di perangkat ini. Sinkronisasi akun akan dicoba kembali.',
              context,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = OpsFixI18n.languageOf(context);
    return Container(
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EDFF),
              borderRadius: BorderRadius.circular(13),
            ),
            child:
                const Icon(Icons.language, color: Color(0xFF6C5CE7), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  OpsFixI18n.t('Bahasa aplikasi', context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  OpsFixI18n.t('Pilih bahasa tampilan aplikasi.', context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F2),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in _options)
                  _segment(
                    code: option[0],
                    label: option[1],
                    tooltip: option[2],
                    selected: active == option[0],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _segment({
    required String code,
    required String label,
    required String tooltip,
    required bool selected,
  }) =>
      Tooltip(
        message: tooltip,
        child: Semantics(
          button: true,
          selected: selected,
          label: tooltip,
          child: InkWell(
            borderRadius: BorderRadius.circular(9),
            onTap: () => _select(code),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF6C5CE7) : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      );
}
