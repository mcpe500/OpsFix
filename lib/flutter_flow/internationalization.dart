import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['id', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? idText = '',
    String? enText = '',
  }) =>
      [idText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // homeUserPageCopy
  {
    'jhlxr3kt': {
      'id': 'OpsFix',
      'en': 'OpsFix',
    },
    '96bl50az': {
      'id': 'N',
      'en': 'N',
    },
    'fobqlqwa': {
      'id': 'Portal Pengguna',
      'en': 'User Portal',
    },
    'racv4rx4': {
      'id': 'Selamat datang, Nadia.',
      'en': 'Welcome, Nadia.',
    },
    'wufoou20': {
      'id':
          'Pantau fasilitas yang kamu laporkan dan buka lokasi sebelum mengirim laporan baru.',
      'en':
          'Monitor the facility you are reporting and open the location before submitting a new report.',
    },
    'pasmhqas': {
      'id': 'Lokasi aktif / terakhir',
      'en': 'Active / last location',
    },
    'ue6mn122': {
      'id': 'Lab Komputer A',
      'en': 'Computer Lab A',
    },
    '9tmjfaqr': {
      'id': 'Gedung Teknik · Lantai 2 · LAB-A',
      'en': 'Engineering Building · 2nd Floor · LAB-A',
    },
    '8ub9jf9t': {
      'id': 'Tiket terbaru saya',
      'en': 'My latest ticket',
    },
    'h0eupk7z': {
      'id': 'Lihat semua',
      'en': 'See all',
    },
    '9osmt8ok': {
      'id': 'OPS-24017',
      'en': 'OPS-24017',
    },
    '8lvb0rwd': {
      'id': 'Assigned',
      'en': 'Assigned',
    },
    '2t4lab0h': {
      'id': 'PC-05 · Keyboard',
      'en': 'PC-05 · Keyboard',
    },
    'i3szjoo4': {
      'id': 'Tidak berfungsi',
      'en': 'Does not work',
    },
    'k17rejdu': {
      'id': 'DP',
      'en': 'DP',
    },
    'mkzpl2ok': {
      'id': 'Teknisi: Dimas Pratama',
      'en': 'Technician: Dimas Pratama',
    },
    'm0p3vuro': {
      'id': 'Lapor',
      'en': 'Report',
    },
  },
  // myTicketsPageCopy
  {
    'avmmmq9s': {
      'id': 'Nadia · Ticket Tracking',
      'en': 'Nadia · Ticket Tracking',
    },
    'pdk2j1n0': {
      'id': 'Pantau laporan saya.',
      'en': 'Monitor my report.',
    },
    '3iynyyge': {
      'id':
          'Lihat status terbaru, teknisi yang menangani, dan histori laporan fasilitasmu.',
      'en':
          'View the latest status, technician handling, and report history of your facility.',
    },
    'xvwmgc95': {
      'id': 'Semua',
      'en': 'All',
    },
    '1upn2kce': {
      'id': 'Reported',
      'en': 'Reported',
    },
    '7dzertp3': {
      'id': 'Assigned',
      'en': 'Assigned',
    },
    'm7lf4cs3': {
      'id': 'In Progress',
      'en': 'In Progress',
    },
    '9y8h2dig': {
      'id': 'Pending Verification',
      'en': 'Pending Verification',
    },
    'p2wfhsub': {
      'id': 'Fixed',
      'en': 'Fixed',
    },
    'zwmakbcl': {
      'id': '1 tiket ditemukan',
      'en': '1 ticket found',
    },
    '4d2qr9kq': {
      'id': 'OpsFix',
      'en': 'OpsFix',
    },
    '71ozsyfj': {
      'id': 'N',
      'en': 'N',
    },
    'igzhzamp': {
      'id': 'Beranda',
      'en': 'Home page',
    },
    'hdom4owe': {
      'id': 'Lapor',
      'en': 'Report',
    },
    'o11xaqlo': {
      'id': 'Tiket',
      'en': 'Tickets',
    },
  },
  // RegisterPageCopy
  {
    '4dgmsfqp': {
      'id': 'OpsFix',
      'en': 'OpsFix',
    },
    '6sosoy63': {
      'id': 'Create an Account',
      'en': 'Create an Account',
    },
    '2k1jf4vo': {
      'id': 'Fill out the information below in order to create account.',
      'en': 'Fill out the information below in order to create an account.',
    },
    '4d0efhql': {
      'id': 'Name',
      'en': 'Name',
    },
    'onq32ocm': {
      'id': 'Email',
      'en': 'E-mail',
    },
    'uco0yhrw': {
      'id': 'Password',
      'en': 'Password',
    },
    'ela6x3q4': {
      'id': 'Confirm Password',
      'en': 'Confirm Password',
    },
    '873m1avj': {
      'id': 'Register',
      'en': 'Register',
    },
    'hzpbguxs': {
      'id': 'Already have an account?  ',
      'en': 'Already have an account?',
    },
    'eacqemjl': {
      'id': 'Sign In here',
      'en': 'Sign In here',
    },
    'wa4kcism': {
      'id': 'Home',
      'en': 'Home',
    },
  },
  // reportIssuePageCopy
  {
    'kjqk2vwz': {
      'id': 'Buat Laporan',
      'en': 'Create a Report',
    },
    's3onbyav': {
      'id': 'Buat Laporan · LAB-A',
      'en': 'Create Report · LAB-A',
    },
    'ckg9t1cr': {
      'id': 'Apa yang bermasalah?',
      'en': 'What\'s the problem?',
    },
    '2ewz31m0': {
      'id':
          'Pilih fasilitas secara bertahap. Lokasi sudah terisi agar teknisi menerima konteks yang tepat.',
      'en':
          'Select facilities in stages. Locations are pre-populated so technicians receive the proper context.',
    },
    'icpal9fx': {
      'id': 'Lokasi laporan',
      'en': 'Report location',
    },
    'y3ouk864': {
      'id': 'Lab Komputer A',
      'en': 'Computer Lab A',
    },
    'oxp75gsa': {
      'id': 'Gedung Teknik · Lantai 2 · 34 unit',
      'en': 'Engineering Building · 2nd Floor · 34 units',
    },
    '14gbg0sh': {
      'id': 'Ganti lokasi',
      'en': 'Change location',
    },
    '7fl3jp8d': {
      'id': 'Buat laporan terstruktur',
      'en': 'Create structured reports',
    },
    'z7le8gx2': {
      'id': 'Pilih bertahap agar lokasi dan aset tidak ambigu.',
      'en':
          'Select in stages so that the location and assets are not ambiguous.',
    },
    '0104eqgg': {
      'id': 'LAB-A',
      'en': 'PROFIT',
    },
    'lilojdeo': {
      'id': '1',
      'en': '1',
    },
    '365k0jgs': {
      'id': 'Target',
      'en': 'Target',
    },
    'stvie4ia': {
      'id': '2',
      'en': '2',
    },
    'xs9lz1i4': {
      'id': 'Unit',
      'en': 'Unit',
    },
    'e16hoi2n': {
      'id': '3',
      'en': '3',
    },
    'rnoje8oz': {
      'id': 'Detail',
      'en': 'Detail',
    },
    'frcg4psc': {
      'id': '4',
      'en': '4',
    },
    'afnm98lq': {
      'id': 'Kirim',
      'en': 'Send',
    },
    '06zfsnmd': {
      'id': 'Pilih jenis target',
      'en': 'Select target type',
    },
    'vxo1r2nu': {
      'id': 'Workstation',
      'en': 'Workstation',
    },
    'rxhr5bci': {
      'id': '34 unit bernomor',
      'en': '34 numbered units',
    },
    '1srs8j92': {
      'id': 'Air Conditioner',
      'en': 'Air Conditioner',
    },
    'wz17q8so': {
      'id': 'Pendingin ruangan',
      'en': 'Air conditioner',
    },
    '81cmdeyx': {
      'id': 'Projector',
      'en': 'Projector',
    },
    '8iqd5i1i': {
      'id': 'Presentasi & kabel',
      'en': 'Presentation & cables',
    },
    'dzovr6k6': {
      'id': 'Display',
      'en': 'Display',
    },
    'yfe2y6p4': {
      'id': 'Layar ruang rapat',
      'en': 'Meeting room screen',
    },
    's4naxbzr': {
      'id': 'Masalah Ruangan',
      'en': 'Room Problems',
    },
    'v9rf0uc9': {
      'id': 'Lampu, plafon, area',
      'en': 'Lights, ceiling, area',
    },
    'pulxh7c6': {
      'id': 'Pilih unit atau posisi',
      'en': 'Select unit or position',
    },
    'r7kay9d4': {
      'id': 'Cari PC-17 atau meja 17',
      'en': 'Look for PC-17 or table 17',
    },
    'iadpka2f': {
      'id': 'Pilih nomor unit (misal PC-05)',
      'en': 'Select unit number (e.g. PC-05)',
    },
    'pqiv03pd': {
      'id': 'Pilih unit',
      'en': 'Select unit',
    },
    'xlj5lclg': {
      'id': 'PC-01',
      'en': 'PC-01',
    },
    't7kdaj93': {
      'id': 'PC-02',
      'en': 'PC-02',
    },
    'jq5v8z4a': {
      'id': 'PC-03',
      'en': 'PC-03',
    },
    '2rd6c8ab': {
      'id': 'PC-04',
      'en': 'PC-04',
    },
    'yfyvbgmp': {
      'id': 'PC-05',
      'en': 'PC-05',
    },
    '7hpidjo0': {
      'id': 'PC-06',
      'en': 'PC-06',
    },
    'bocjp8rv': {
      'id': 'Pilih komponen terdampak',
      'en': 'Select the affected components',
    },
    'vmv9bsj3': {
      'id': 'CPU',
      'en': 'CPU',
    },
    'dagz61io': {
      'id': 'Monitor',
      'en': 'Monitor',
    },
    'q8a7dowr': {
      'id': 'Keyboard',
      'en': 'Keyboard',
    },
    '1e8hihvl': {
      'id': 'Keyboard',
      'en': 'Keyboard',
    },
    '0fijrpbe': {
      'id': 'Mouse',
      'en': 'Mouse',
    },
    'qfogn211': {
      'id': 'Pilih kategori gangguan',
      'en': 'Select a category of disturbance',
    },
    'aw7kj00y': {
      'id': 'Kategori masalah',
      'en': 'Problem categories',
    },
    'hj42ds08': {
      'id': 'Hardware',
      'en': 'Hardware',
    },
    'uws2tzas': {
      'id': 'Software',
      'en': 'Software',
    },
    'kxvz5i8l': {
      'id': 'Jaringan',
      'en': 'Network',
    },
    'jsd3opfb': {
      'id': 'Fisik/Ruangan',
      'en': 'Physical/Space',
    },
    'x616hgm8': {
      'id': 'Pilih jenis gangguan',
      'en': 'Select the type of disturbance',
    },
    'iadi2rpx': {
      'id': 'Jenis gangguan',
      'en': 'Types of disorders',
    },
    'q84eyjcl': {
      'id': 'Restart berulang',
      'en': 'Repeated restarts',
    },
    'fshv2459': {
      'id': 'Tidak ada tampilan',
      'en': 'No display',
    },
    '1xlalmkv': {
      'id': 'Mati total',
      'en': 'Totally dead',
    },
    'zlbmo731': {
      'id': 'Kipas bising',
      'en': 'Noisy fan',
    },
    'jxxwz8c9': {
      'id': 'Lainnya',
      'en': 'Other',
    },
    'uxjw3com': {
      'id': 'Jelaskan gejalanya',
      'en': 'Describe the symptoms',
    },
    'ygrbb6by': {
      'id': 'Contoh: monitor tidak menampilkan gambar meski CPU menyala.',
      'en':
          'Example: the monitor does not display an image even though the CPU is on.',
    },
    'wenrc3tq': {
      'id': 'Pilih tingkat dampak',
      'en': 'Select impact level',
    },
    '9vw7ggmo': {
      'id': 'Dampak',
      'en': 'Impact',
    },
    'zu5vd7xy': {
      'id': 'Low',
      'en': 'Low',
    },
    'qwvhfryu': {
      'id': 'Medium',
      'en': 'Medium',
    },
    'ey10islc': {
      'id': 'High',
      'en': 'High',
    },
    's05foc22': {
      'id': 'Critical',
      'en': 'Critical',
    },
    'q050o0ch': {
      'id': 'Waktu kejadian',
      'en': 'Time of incident',
    },
    'k5nwhdkc': {
      'id': '20 Jul 2026 · 12:45',
      'en': 'Jul 20, 2026 · 12:45 PM',
    },
    'um34bqpi': {
      'id': 'Kontak opsional',
      'en': 'Optional contact',
    },
    'u8v7yjzj': {
      'id': 'Nomor HP atau Ext.',
      'en': 'Mobile Number or Ext.',
    },
    '3j7nxiu3': {
      'id': 'Petunjuk akses',
      'en': 'Access instructions',
    },
    'qpi0v7mp': {
      'id': 'Contoh: Kunci di resepsionis lantai 2',
      'en': 'Example: Key at the 2nd floor reception',
    },
    'mils7qxn': {
      'id': 'Bukti foto awal',
      'en': 'Initial photographic evidence',
    },
    '63f4xasr': {
      'id': 'Tambahkan foto bukti awal',
      'en': 'Add initial proof photo',
    },
    'ggra6crl': {
      'id': 'Maks. 2 MB · JPG, PNG, atau WebP',
      'en': 'Max. 2 MB · JPG, PNG, or WebP',
    },
    'n2tfced7': {
      'id': 'Buka kamera',
      'en': 'Open the camera',
    },
    '36r11nhi': {
      'id': 'Pilih galeri',
      'en': 'Select gallery',
    },
    '0uuy5d4q': {
      'id': 'Ringkasan laporan',
      'en': 'Report summary',
    },
    'w8lqcfe8': {
      'id': 'Lokasi',
      'en': 'Location',
    },
    'mgl5w5r3': {
      'id': 'Lab Komputer A',
      'en': 'Computer Lab A',
    },
    'lwdqaca1': {
      'id': 'Target',
      'en': 'Target',
    },
    '9mf9l2o8': {
      'id': 'PC-05 · Workstation',
      'en': 'PC-05 · Workstation',
    },
    '67nj26d3': {
      'id': 'Komponen',
      'en': 'Component',
    },
    'eru89go0': {
      'id': 'Keyboard',
      'en': 'Keyboard',
    },
    'ou7434bh': {
      'id': 'Gangguan',
      'en': 'Disturbance',
    },
    '7tajxv8i': {
      'id': 'Restart berulang',
      'en': 'Repeated restart',
    },
    '66m9846b': {
      'id': 'Dampak',
      'en': 'Impact',
    },
    'o0ii9jjt': {
      'id': 'Medium',
      'en': 'Medium',
    },
    'qkozy0zx': {
      'id': 'Bukti awal',
      'en': 'Initial evidence',
    },
    'xq8betm1': {
      'id': '1 foto terlampir',
      'en': '1 photo attached',
    },
    'ryxfhese': {
      'id': 'Kirim laporan',
      'en': 'Submit a report',
    },
    'ioar8nrx': {
      'id': 'Bersihkan pilihan',
      'en': 'Clear selection',
    },
  },
  // technicianHistoryPageCopy
  {
    '2frlm53y': {
      'id': 'OpsFix',
      'en': 'OpsFix',
    },
    'w5cd9qpx': {
      'id': 'TEKNISI',
      'en': 'TECHNICIAN',
    },
    '2fzkqxpp': {
      'id': 'DP',
      'en': 'DP',
    },
    'ed59qcg2': {
      'id': 'Teknisi · Dimas Pratama',
      'en': 'Technician · Dimas Pratama',
    },
    'xsqst04x': {
      'id': 'Riwayat pekerjaan saya.',
      'en': 'My work history.',
    },
    '8gmrl4jn': {
      'id':
          'Lihat dan pantau semua tiket pemeliharaan aktif maupun yang telah selesai Anda tangani.',
      'en':
          'View and monitor all active and completed maintenance tickets you have handled.',
    },
    'kk9pidox': {
      'id': '8 Total tiket ditangani',
      'en': '8 Total tickets handled',
    },
    'ql3qh7nq': {
      'id': 'Performa bulan ini',
      'en': 'This month\'s performance',
    },
    '5i8cdo8w': {
      'id': '87% SLA',
      'en': '87% SLA',
    },
    'ahx9duq3': {
      'id': '5',
      'en': '5',
    },
    'vo6g5zug': {
      'id': 'Selesai',
      'en': 'Finished',
    },
    '9sy0qbxh': {
      'id': '2',
      'en': '2',
    },
    'vs3ztch5': {
      'id': 'Aktif',
      'en': 'Active',
    },
    '90trwtoq': {
      'id': '1',
      'en': '1',
    },
    '8hiujgbi': {
      'id': 'Reopened',
      'en': 'Reopened',
    },
    'uug3l447': {
      'id': 'Periode',
      'en': 'Period',
    },
    '65y33yt4': {
      'id': '7 hari',
      'en': '7 days',
    },
    'o7upmtlp': {
      'id': '30 hari',
      'en': '30 days',
    },
    'a5ah308i': {
      'id': '90 hari',
      'en': '90 days',
    },
    'dn86gw1r': {
      'id': 'Semua waktu',
      'en': 'All the time',
    },
    'ci77qvyx': {
      'id': 'Status',
      'en': 'Status',
    },
    '44zpfqto': {
      'id': 'Semua',
      'en': 'All',
    },
    '7ys6tnq6': {
      'id': 'Assigned',
      'en': 'Assigned',
    },
    'hv74px1z': {
      'id': 'In Progress',
      'en': 'In Progress',
    },
    '3s5p71hb': {
      'id': 'Fixed',
      'en': 'Fixed',
    },
    'oqjiv9r8': {
      'id': 'Reopened',
      'en': 'Reopened',
    },
    'klxgwek6': {
      'id': 'Masih aktif',
      'en': 'Still active',
    },
    'nz00y7ni': {
      'id': 'OPS-24017',
      'en': 'OPS-24017',
    },
    'b3yhtwkf': {
      'id': 'PC-05 · Keyboard',
      'en': 'PC-05 · Keyboard',
    },
    '6vmgv0gm': {
      'id': 'Tidak berfungsi',
      'en': 'Does not work',
    },
    'qpx5domi': {
      'id': 'Lab Komputer A',
      'en': 'Computer Lab A',
    },
    'hq41qqoi': {
      'id': 'Pelapor: Nadia',
      'en': 'Reporter: Nadia',
    },
    '5k2ma62s': {
      'id': 'Target: 20 Jul 2026 · 16:18',
      'en': 'Target: Jul 20, 2026 · 4:18 PM',
    },
    'ytip0xyx': {
      'id': 'OPS-24016',
      'en': 'OPS-24016',
    },
    'no156yic': {
      'id': 'PC-12 · CPU',
      'en': 'PC-12 · CPU',
    },
    'kvzetg2q': {
      'id': 'Restart berulang',
      'en': 'Repeated restarts',
    },
    '8vgpu632': {
      'id': '55%',
      'en': '55%',
    },
    'piabkx7t': {
      'id': 'Pekerjaan selesai',
      'en': 'Completed work',
    },
    'e96dd5bm': {
      'id': 'OPS-24015',
      'en': 'OPS-24015',
    },
    'vrrir1ap': {
      'id': 'AC-01 · Drainase',
      'en': 'AC-01 · Drainage',
    },
    'z06kj423': {
      'id': 'Air menetes',
      'en': 'Dripping water',
    },
    'efr6zea4': {
      'id': 'Catatan teknisi:',
      'en': 'Technician\'s notes:',
    },
    'f24glde4': {
      'id':
          'Penyumbatan pada pipa pembuangan sudah dibersihkan. Drainase kembali lancar.',
      'en':
          'The blockage in the drain pipe has been cleared, and drainage is flowing smoothly again.',
    },
    'iba7w3vb': {
      'id': 'Selesai: 19 Jul 2026 · 16:42',
      'en': 'Completed: Jul 19, 2026 · 4:42 PM',
    },
    '7ax5pu0r': {
      'id': 'Durasi: 2j 14m',
      'en': 'Duration: 2h 14m',
    },
    'rlab5cpl': {
      'id': 'OPS-24009 Perlu perhatian',
      'en': 'OPS-24009 Attention required',
    },
    '2zm642r6': {
      'id': 'Tiket ini dibuka kembali oleh user.',
      'en': 'This ticket was reopened by the user.',
    },
  },
  // technicianTasksPageCopy
  {
    '5lkxob14': {
      'id': 'OpsFix',
      'en': 'OpsFix',
    },
    'ft3v3c2v': {
      'id': 'Teknisi',
      'en': 'Technician',
    },
    '39sie4a6': {
      'id': 'PORTAL TEKNISI',
      'en': 'TECHNICIAN PORTAL',
    },
    'v3o7d0nx': {
      'id': 'Selamat bertugas, Dimas Pratama',
      'en': 'Good luck with your duties, Dimas Pratama',
    },
    'c4okczve': {
      'id': 'Ada 3 pekerjaan aktif yang memerlukan tindakan Anda hari ini.',
      'en': 'There are 3 active jobs that require your action today.',
    },
    'y82owiz3': {
      'id': 'Tugas Aktif',
      'en': 'Active Duty',
    },
    '11ztgil8': {
      'id': '3',
      'en': '3',
    },
    '8oild873': {
      'id': 'SLA Terjaga',
      'en': 'Maintained SLA',
    },
    '1tkw7fg8': {
      'id': '100%',
      'en': '100%',
    },
    'gd24oi1w': {
      'id': 'Selesai Hari Ini',
      'en': 'Finished Today',
    },
    'mlhei723': {
      'id': '4',
      'en': '4',
    },
    'v1cx1qnc': {
      'id': 'Semua (3)',
      'en': 'All (3)',
    },
    'h13tvgdj': {
      'id': 'Semua (3)',
      'en': 'All (3)',
    },
    '3ns5tkuk': {
      'id': 'In Progress (1)',
      'en': 'In Progress (1)',
    },
    'dp7vmxii': {
      'id': 'Assigned (2)',
      'en': 'Assigned (2)',
    },
    'urxk3n2x': {
      'id': 'Tugas Aktif (3)',
      'en': 'Active Duty (3)',
    },
    'znege5f0': {
      'id': 'Urutkan: SLA Terdekat',
      'en': 'Sort by: Closest SLA',
    },
    'c0zl9drx': {
      'id': 'OPS-24016',
      'en': 'OPS-24016',
    },
    'fzd6tjl7': {
      'id': 'In Progress',
      'en': 'In Progress',
    },
    'ex0lt8wb': {
      'id': 'PC-12 · CPU',
      'en': 'PC-12 · CPU',
    },
    'jeey27ia': {
      'id': 'Restart berulang saat digunakan',
      'en': 'Repeated restarts during use',
    },
    'yqazumlv': {
      'id': 'Lab Komputer A · Gedung Teknik L2',
      'en': 'Computer Lab A · Engineering Building L2',
    },
    'rthp13a9': {
      'id': 'Critical Priority',
      'en': 'Critical Priority',
    },
    'hyyv3zq2': {
      'id': 'SLA sisa: 2j 23m',
      'en': 'Remaining SLA: 2h 23m',
    },
    'i9lhmogd': {
      'id': 'Kerjakan / Detail Pekerjaan',
      'en': 'Work / Job Details',
    },
    '7jm4s54s': {
      'id': 'OPS-24018',
      'en': 'OPS-24018',
    },
    '11afw0q2': {
      'id': 'Assigned',
      'en': 'Assigned',
    },
    '1aryohaf': {
      'id': 'AC Ruang Dosen 204',
      'en': 'AC Lecturer Room 204',
    },
    'eqzllujk': {
      'id': 'Bising dan kurang dingin',
      'en': 'Noisy and not cold enough',
    },
    'ywdn32px': {
      'id': 'Gedung Utama · Lantai 2',
      'en': 'Main Building · 2nd Floor',
    },
    'k4tfbv2o': {
      'id': 'High Priority',
      'en': 'High Priority',
    },
    'j83ymmqm': {
      'id': 'SLA sisa: 4j 15m',
      'en': 'Remaining SLA: 4h 15m',
    },
    'nqbo55dp': {
      'id': 'Mulai Pekerjaan',
      'en': 'Start Work',
    },
    'qeanrr9s': {
      'id': 'OPS-24019',
      'en': 'OPS-24019',
    },
    '4ck5ye19': {
      'id': 'Assigned',
      'en': 'Assigned',
    },
    'efxn8a41': {
      'id': 'Projector R. Meeting B',
      'en': 'Projector R. Meeting B',
    },
    'hz26n6n9': {
      'id': 'Lampu indikator merah / tidak menyala',
      'en': 'Indicator light is red / not on',
    },
    '89gjma1c': {
      'id': 'Gedung Rektorat · Lantai 3',
      'en': 'Rectorate Building · 3rd Floor',
    },
    'bo7g16hb': {
      'id': 'Medium Priority',
      'en': 'Medium Priority',
    },
    's9po670a': {
      'id': 'SLA sisa: 6j 00m',
      'en': 'Remaining SLA: 6h 00m',
    },
    'bzzcwa6b': {
      'id': 'Mulai Pekerjaan',
      'en': 'Start Work',
    },
    'eqliz46k': {
      'id': 'Performa Hari Ini',
      'en': 'Today\'s Performance',
    },
    'bhyu5bsm': {
      'id': 'Waktu Respon Rata-rata',
      'en': 'Average Response Time',
    },
    '6w4gmh6r': {
      'id': '8 menit',
      'en': '8 minutes',
    },
    '2qenuf7z': {
      'id': 'Resolusi Tepat Waktu',
      'en': 'Timely Resolution',
    },
    'lvd69f58': {
      'id': '100%',
      'en': '100%',
    },
    'gee1v3o4': {
      'id': 'Kepuasan Pelapor',
      'en': 'Reporter Satisfaction',
    },
    'y83l6t8a': {
      'id': '4.9 / 5.0 ⭐',
      'en': '4.9 / 5.0 ⭐',
    },
    'kvuor58r': {
      'id': 'Tugas',
      'en': 'Task',
    },
    '6m5eobqq': {
      'id': 'Riwayat',
      'en': 'History',
    },
  },
  // technicianTicketDetailPageCopy
  {
    '2sgwotdu': {
      'id': 'Detail Pekerjaan',
      'en': 'Job Details',
    },
    '3dq5o1xq': {
      'id': 'Detail Pekerjaan',
      'en': 'Job Details',
    },
    'jwl9g1dv': {
      'id': 'PEKERJAAN AKTIF',
      'en': 'ACTIVE WORK',
    },
    'frj56p0o': {
      'id': 'In Progress',
      'en': 'In Progress',
    },
    'gdtixooo': {
      'id': 'OPS-24016',
      'en': 'OPS-24016',
    },
    'ajxff45t': {
      'id': 'PC-12 · CPU',
      'en': 'PC-12 · CPU',
    },
    '5s13l6re': {
      'id': 'Restart berulang',
      'en': 'Repeated restart',
    },
    '48zw5mdn': {
      'id': 'Lab Komputer A',
      'en': 'Computer Lab A',
    },
    'v6u6gnud': {
      'id': 'Baris B · Gedung Teknik · Lantai 2 · LAB-A',
      'en': 'Row B · Engineering Building · 2nd Floor · LAB-A',
    },
    'q74tznhl': {
      'id': 'Critical',
      'en': 'Critical',
    },
    'n21gso2e': {
      'id': 'F',
      'en': 'F',
    },
    'tnpzqed8': {
      'id': 'Dilaporkan oleh Fajar',
      'en': 'Reported by Fajar',
    },
    'gvzdm3uv': {
      'id': '20 Jul 2026 · 12:58',
      'en': 'Jul 20, 2026 · 12:58',
    },
    'v9gvddpd': {
      'id': 'Status pekerjaan',
      'en': 'Employment status',
    },
    'pr04xynl': {
      'id': 'Tahap pengerjaan dan target layanan',
      'en': 'Work stages and service targets',
    },
    'v4us3icq': {
      'id': 'In Progress',
      'en': 'In Progress',
    },
    'o9fmg3r8': {
      'id': 'Dilaporkan',
      'en': 'Reported',
    },
    'f8g62akv': {
      'id': 'Ditugaskan',
      'en': 'Assigned',
    },
    '9c5t1tij': {
      'id': '3',
      'en': '3',
    },
    'a6ga0rvy': {
      'id': 'Dikerjakan',
      'en': 'Done',
    },
    'himasyn2': {
      'id': '4',
      'en': '4',
    },
    'as500kyw': {
      'id': 'Verifikasi',
      'en': 'Verification',
    },
    'wq52ovss': {
      'id': '5',
      'en': '5',
    },
    'vvmx9p1k': {
      'id': 'Selesai',
      'en': 'Finished',
    },
    '3ob3ij3m': {
      'id': 'Pekerjaan dimulai',
      'en': 'Work begins',
    },
    'jdw9xw8v': {
      'id': '20 Jul 2026 · 13:12',
      'en': 'Jul 20, 2026 · 1:12 PM',
    },
    'wzdt9sgr': {
      'id': 'Durasi berjalan',
      'en': 'Running duration',
    },
    'b1fr3qe1': {
      'id': '1j 10m',
      'en': '1h 10m',
    },
    'cmodicnm': {
      'id': 'Aktif',
      'en': 'Active',
    },
    '9pxqm1b8': {
      'id': 'Target resolusi',
      'en': 'Resolution target',
    },
    'nqdb7xg3': {
      'id': '20 Jul 2026 · 16:45',
      'en': 'Jul 20, 2026 · 4:45 PM',
    },
    'gq9okjj5': {
      'id': 'Dalam target',
      'en': 'In target',
    },
    '83onwz9r': {
      'id': 'Sisa waktu SLA',
      'en': 'SLA time remaining',
    },
    'soy70tyy': {
      'id': '2j 23m',
      'en': '2h 23m',
    },
    'frlvt09w': {
      'id': 'Aset dan lokasi',
      'en': 'Assets and locations',
    },
    'z613kn08': {
      'id': 'PC-12',
      'en': 'PC-12',
    },
    'r93sc62z': {
      'id': 'Jenis aset',
      'en': 'Asset type',
    },
    '52kp8e14': {
      'id': 'Workstation',
      'en': 'Workstation',
    },
    'u3kv6f75': {
      'id': 'Unit',
      'en': 'Unit',
    },
    'msvtotmp': {
      'id': 'PC-12 · Baris B',
      'en': 'PC-12 · Row B',
    },
    'vguilrcq': {
      'id': 'Komponen',
      'en': 'Component',
    },
    'mu6oqoyj': {
      'id': 'CPU',
      'en': 'CPU',
    },
    'br43o6bx': {
      'id': 'Kode aset',
      'en': 'Asset code',
    },
    'l5iu00rw': {
      'id': 'LAB-A-PC-12',
      'en': 'LAB-A-PC-12',
    },
    '3qjbfy4l': {
      'id': 'Status aset',
      'en': 'Asset status',
    },
    'turnakpk': {
      'id': 'Dalam perbaikan',
      'en': 'In repair',
    },
    '0ej1hhvc': {
      'id': 'Lab Komputer A',
      'en': 'Computer Lab A',
    },
    'n96zxts3': {
      'id': 'Gedung Teknik · Lantai 2',
      'en': 'Engineering Building · 2nd Floor',
    },
    '1hn58oxl': {
      'id': 'Lihat lokasi',
      'en': 'View location',
    },
    'wdlgsukd': {
      'id': 'Petunjuk akses',
      'en': 'Access instructions',
    },
    'do0o9q57': {
      'id':
          'Lab dibuka oleh petugas lantai 2. Hubungi resepsionis sebelum masuk.',
      'en':
          'The lab is opened by the 2nd floor attendant. Contact the receptionist before entering.',
    },
    'p8zhbtir': {
      'id': 'Detail gangguan',
      'en': 'Disturbance details',
    },
    'yzi2uzuf': {
      'id': 'Kategori',
      'en': 'Category',
    },
    'qt8hwzlm': {
      'id': 'Hardware',
      'en': 'Hardware',
    },
    '869vvbpj': {
      'id': 'Jenis gangguan',
      'en': 'Types of disorders',
    },
    'c834hyif': {
      'id': 'Restart berulang',
      'en': 'Repeated restart',
    },
    'bl8m56ct': {
      'id': 'Dampak',
      'en': 'Impact',
    },
    'naa6jn02': {
      'id': 'Critical',
      'en': 'Critical',
    },
    'c7tb7yhk': {
      'id': 'Jumlah terdampak',
      'en': 'Number of affected',
    },
    'q7cmtqh8': {
      'id': '1 unit',
      'en': '1 unit',
    },
    'gefpbvjd': {
      'id': 'Waktu kejadian',
      'en': 'Time of incident',
    },
    'toz4v3k4': {
      'id': '20 Jul 2026 · 12:45',
      'en': 'Jul 20, 2026 · 12:45 PM',
    },
    'p6l5rqlt': {
      'id': 'Deskripsi pelapor',
      'en': 'Reporter description',
    },
    '012xe6yg': {
      'id':
          'Komputer melakukan restart sendiri beberapa kali saat digunakan. Setelah menyala kembali, kipas CPU terdengar lebih keras dari biasanya.',
      'en':
          'The computer restarted itself several times while in use. After restarting, the CPU fan sounded louder than usual.',
    },
    '6v60fhjs': {
      'id': 'Fajar',
      'en': 'Dawn',
    },
    'pre2q7lv': {
      'id': 'Ext. 219',
      'en': 'Ext. 219',
    },
    'kgmea7xv': {
      'id': 'Bukti awal',
      'en': 'Initial evidence',
    },
    't11vp6ba': {
      'id': '1 foto',
      'en': '1 photo',
    },
    '8vncu5g1': {
      'id': 'Foto pelapor',
      'en': 'Photo of the reporter',
    },
    '68ebaf8w': {
      'id': 'F',
      'en': 'F',
    },
    '19nwrg0j': {
      'id': 'Diunggah oleh Fajar',
      'en': 'Uploaded by Fajar',
    },
    'ef8bc4rn': {
      'id': '20 Jul 2026 · 12:58',
      'en': 'Jul 20, 2026 · 12:58',
    },
    'ch4b62bm': {
      'id': 'Ruang kerja teknisi',
      'en': 'Technician\'s workspace',
    },
    'q9kmqvao': {
      'id': 'Lengkapi bukti pekerjaan sebelum dikirim untuk verifikasi',
      'en': 'Complete proof of employment before submitting for verification.',
    },
    'b5gxvobh': {
      'id': 'Dimas Pratama',
      'en': 'Dimas Pratama',
    },
    'l5d5eu4k': {
      'id': 'DP',
      'en': 'DP',
    },
    'wmobvd59': {
      'id': 'Pekerjaan sedang berlangsung',
      'en': 'Work in progress',
    },
    'w6ffuop8': {
      'id': 'Dimulai 20 Jul 2026 · 13:12',
      'en': 'Started Jul 20, 2026 · 13:12',
    },
    'rdbwjw63': {
      'id': '1j 10m',
      'en': '1h 10m',
    },
    'yxk8gjg3': {
      'id': 'Checklist penyelesaian',
      'en': 'Completion checklist',
    },
    'nzlaqwj5': {
      'id': 'Semua langkah wajib diselesaikan sebelum dikirim.',
      'en': 'All steps must be completed before submitting.',
    },
    'ds2076ne': {
      'id': 'Diagnosis dilakukan',
      'en': 'Diagnosis is made',
    },
    '7z64mcjf': {
      'id': 'Sumber gangguan sudah diidentifikasi',
      'en': 'The source of the disturbance has been identified',
    },
    '4r1uy6si': {
      'id': 'Selesai',
      'en': 'Finished',
    },
    '9gcg7but': {
      'id': 'Tindakan perbaikan dilakukan',
      'en': 'Corrective action taken',
    },
    'tng8qwl2': {
      'id': 'Perbaikan atau penggantian sudah diterapkan',
      'en': 'Repair or replacement has been implemented',
    },
    'jkv81ze9': {
      'id': 'Selesai',
      'en': 'Finished',
    },
    'e736fedl': {
      'id': 'Uji fungsi berhasil',
      'en': 'Functional test successful',
    },
    'z224otgg': {
      'id': 'Pastikan aset bekerja normal setelah perbaikan',
      'en': 'Ensure assets are working normally after repairs',
    },
    'omxyfwlf': {
      'id': 'Belum',
      'en': 'Not yet',
    },
    'vkj8e52m': {
      'id': 'Suku cadang dan material',
      'en': 'Spare parts and materials',
    },
    'qns6awai': {
      'id':
          'Catat material yang digunakan atau nyatakan tidak menggunakan suku cadang.',
      'en': 'Note the materials used or state that no spare parts are used.',
    },
    'kc6h74jh': {
      'id': 'Menggunakan suku cadang',
      'en': 'Using spare parts',
    },
    '7pyaov5f': {
      'id': 'Tidak menggunakan suku cadang',
      'en': 'No spare parts used',
    },
    '1m3m53hu': {
      'id': 'Thermal Paste',
      'en': 'Thermal Paste',
    },
    '0askz739': {
      'id': 'Jumlah: 1 · Ref: TP-001',
      'en': 'Quantity: 1 · Ref: TP-001',
    },
    'wo8b7zvh': {
      'id': '+ Tambah suku cadang',
      'en': '+ Add spare parts',
    },
    'gn0d60sw': {
      'id': 'Biaya perbaikan',
      'en': 'Repair costs',
    },
    'jgzmqvtl': {
      'id': 'Estimasi dan realisasi biaya pekerjaan',
      'en': 'Estimation and realization of work costs',
    },
    'c975c6hb': {
      'id': 'Kelola biaya',
      'en': 'Manage costs',
    },
    'lvjtkn5b': {
      'id': 'Estimasi',
      'en': 'Estimate',
    },
    '77p6y3nt': {
      'id': 'Rp175.000',
      'en': 'Rp. 175,000',
    },
    'b72wbarm': {
      'id': 'Tenaga kerja: Rp75.000',
      'en': 'Labor: Rp. 75,000',
    },
    'ofox0igr': {
      'id': 'Suku cadang: Rp100.000',
      'en': 'Spare parts: Rp. 100,000',
    },
    'fgrueid1': {
      'id': 'Aktual',
      'en': 'Current',
    },
    'lw2vivic': {
      'id': 'Rp125.000',
      'en': 'Rp. 125,000',
    },
    'sc1qgyst': {
      'id': 'Tenaga kerja: Rp75.000',
      'en': 'Labor: Rp. 75,000',
    },
    'vz56jb9v': {
      'id': 'Suku cadang: Rp50.000',
      'en': 'Spare parts: Rp. 50,000',
    },
    '62ub768o': {
      'id': 'Biaya aktual masih di bawah estimasi',
      'en': 'Actual costs are still below estimates',
    },
    'p4iv3h92': {
      'id': 'Hemat Rp50.000',
      'en': 'Save Rp. 50,000',
    },
    'q75p6coc': {
      'id': 'Catatan pekerjaan',
      'en': 'Job notes',
    },
    'rh7tl0c0': {
      'id': 'Jelaskan diagnosis, tindakan, dan hasil pengujian.',
      'en': 'Describe the diagnosis, procedures, and test results.',
    },
    'fkuh9f7k': {
      'id':
          'Suhu CPU terlalu tinggi karena thermal paste mengering. Thermal paste sudah diganti dan heatsink dibersihkan. Sistem sedang diuji selama 15 menit untuk memastikan restart tidak kembali terjadi.',
      'en':
          'The CPU temperature was too high due to dried thermal paste. The thermal paste has been replaced and the heatsink cleaned. The system is being tested for 15 minutes to ensure a restart does not occur again.',
    },
    'of98864s': {
      'id': 'Foto hasil pekerjaan',
      'en': 'Photos of work results',
    },
    'q143s07b': {
      'id': 'Unggah foto aset setelah tindakan perbaikan.',
      'en': 'Upload photos of the asset after the repair action.',
    },
    'lby3b5ld': {
      'id': 'Tambahkan foto hasil',
      'en': 'Add a photo of the result',
    },
    'o9xfjr2r': {
      'id': 'Gunakan kamera atau pilih dari galeri',
      'en': 'Use camera or select from gallery',
    },
    'v14mkdqk': {
      'id': 'JPG, PNG, atau WebP · Maks. 2 MB',
      'en': 'JPG, PNG, or WebP · Max. 2 MB',
    },
    'opecsrjf': {
      'id': 'Buka kamera',
      'en': 'Open the camera',
    },
    '5m6do231': {
      'id': 'Pilih galeri',
      'en': 'Select gallery',
    },
    'b99zo21r': {
      'id': 'Checklist, catatan, dan minimal satu foto hasil wajib dilengkapi.',
      'en':
          'Checklist, notes, and at least one photo of the results must be completed.',
    },
    '2ukugugj': {
      'id': 'Perlu mengubah status?',
      'en': 'Need to change status?',
    },
    'xwug0fu0': {
      'id': 'Gunakan hanya jika pekerjaan tidak dapat dilanjutkan.',
      'en': 'Use only if work cannot be continued.',
    },
    'o0ffzznj': {
      'id': 'Menunggu suku cadang',
      'en': 'Waiting for spare parts',
    },
    '2n5krcuh': {
      'id': 'Tunda pekerjaan',
      'en': 'Postpone work',
    },
    '6yrosl3k': {
      'id': 'Eskalasi',
      'en': 'Escalation',
    },
    '2d7j3keo': {
      'id': 'Perubahan status akan meminta alasan dan dicatat pada timeline.',
      'en':
          'Status changes will ask for a reason and be noted on the timeline.',
    },
    'g4of10ri': {
      'id': 'Timeline pekerjaan',
      'en': 'Job timeline',
    },
    '8kijfhnd': {
      'id': 'Aktivitas terbaru tiket',
      'en': 'Latest ticket activity',
    },
    '24lmzqek': {
      'id': 'Pekerjaan dimulai',
      'en': 'Work begins',
    },
    'uyyc2iqq': {
      'id': 'Dimas Pratama memulai pemeriksaan CPU PC-12.',
      'en': 'Dimas Pratama starts checking the PC-12 CPU.',
    },
    'vi3d7tng': {
      'id': 'Dimas Pratama · 20 Jul 2026 · 13:12',
      'en': 'Dimas Pratama · Jul 20, 2026 · 1:12 PM',
    },
    'dqfv92fh': {
      'id': 'Teknisi ditugaskan',
      'en': 'Technician assigned',
    },
    '4p27ksht': {
      'id': 'OpsFix menugaskan tiket kepada Dimas Pratama.',
      'en': 'OpsFix assigns the ticket to Dimas Pratama.',
    },
    'nn3u80pm': {
      'id': 'OpsFix Auto Assignment · 20 Jul 2026 · 13:04',
      'en': 'OpsFix Auto Assignment · Jul 20, 2026 · 13:04',
    },
    'pmr8d7tz': {
      'id': 'Laporan dibuat',
      'en': 'Report created',
    },
    'v5ts2757': {
      'id': 'Fajar melaporkan CPU PC-12 mengalami restart berulang.',
      'en':
          'Fajar reported that the PC-12 CPU was experiencing repeated restarts.',
    },
    '0fu84m35': {
      'id': 'Fajar · 20 Jul 2026 · 12:58',
      'en': 'Fajar · Jul 20, 2026 · 12:58',
    },
    'o89t2vep': {
      'id': 'Simpan progres',
      'en': 'Save progress',
    },
    '2cxpsa1m': {
      'id': 'Kirim untuk verifikasi',
      'en': 'Submit for verification',
    },
  },
  // ticketDetailPageCopy
  {
    'rxozyd3b': {
      'id': 'Detail Tiket',
      'en': 'Ticket Details',
    },
    '06cjnlme': {
      'id': 'TIKET FASILITAS',
      'en': 'FACILITY TICKET',
    },
    '14kwpr25': {
      'id': 'Assigned',
      'en': 'Assigned',
    },
    'jn5p2gll': {
      'id': 'OPS-24017',
      'en': 'OPS-24017',
    },
    '149c1181': {
      'id': 'PC-05 · Keyboard',
      'en': 'PC-05 · Keyboard',
    },
    'zt1t8jha': {
      'id': 'Tidak berfungsi',
      'en': 'Does not work',
    },
    'x5nm717z': {
      'id': 'Lab Komputer A',
      'en': 'Computer Lab A',
    },
    'mloe5va9': {
      'id': 'Gedung Teknik · Lantai 2 · LAB-A',
      'en': 'Engineering Building · 2nd Floor · LAB-A',
    },
    'wo6r2nb9': {
      'id': 'N',
      'en': 'N',
    },
    '5iscs6og': {
      'id': 'Dilaporkan oleh Nadia',
      'en': 'Reported by Nadia',
    },
    'a83v3y2y': {
      'id': '20 Jul 2026 · 14:18',
      'en': 'Jul 20, 2026 · 2:18 PM',
    },
    '9tsd2ntd': {
      'id': 'High',
      'en': 'High',
    },
    '7arcu5q6': {
      'id': 'Status penanganan',
      'en': 'Handling status',
    },
    'gcbpxdhi': {
      'id': 'Perkembangan terbaru laporan',
      'en': 'Latest developments in the report',
    },
    '0bza4838': {
      'id': 'Assigned',
      'en': 'Assigned',
    },
    'dqbd3436': {
      'id': 'DP',
      'en': 'DP',
    },
    'mx5rm89s': {
      'id': 'Dimas Pratama',
      'en': 'Dimas Pratama',
    },
    'hf38ouew': {
      'id': 'Teknisi fasilitas',
      'en': 'Facility technician',
    },
    'qw97fli7': {
      'id': 'Sudah menerima penugasan',
      'en': 'Have received the assignment',
    },
    'wdrmlqoy': {
      'id': 'Dilaporkan',
      'en': 'Reported',
    },
    'mwikx17x': {
      'id': '2',
      'en': '2',
    },
    'xi1nih2c': {
      'id': 'Ditugaskan',
      'en': 'Assigned',
    },
    '6cxp3xo2': {
      'id': '3',
      'en': '3',
    },
    '569tjtzc': {
      'id': 'Dikerjakan',
      'en': 'Done',
    },
    'q0k2iwls': {
      'id': '4',
      'en': '4',
    },
    'x1p3op23': {
      'id': 'Selesai',
      'en': 'Finished',
    },
    'oq3r029p': {
      'id': 'Target respons',
      'en': 'Response target',
    },
    'nt45aie5': {
      'id': '20 Jul 2026 · 16:18',
      'en': 'Jul 20, 2026 · 4:18 PM',
    },
    '11kyhyow': {
      'id': 'Dalam target',
      'en': 'In target',
    },
    'k7l5dtu7': {
      'id': 'Target resolusi',
      'en': 'Resolution target',
    },
    '16erojrn': {
      'id': '20 Jul 2026 · 22:18',
      'en': 'Jul 20, 2026 · 10:18 PM',
    },
    'gdztzzp6': {
      'id': 'Informasi laporan',
      'en': 'Report information',
    },
    'dk6z2in3': {
      'id': 'Petunjuk akses',
      'en': 'Access instructions',
    },
    'zk9myxrt': {
      'id':
          'Lab dibuka oleh petugas lantai 2. Hubungi resepsionis sebelum masuk.',
      'en':
          'The lab is opened by the 2nd floor attendant. Contact the receptionist before entering.',
    },
    'n60txuih': {
      'id': 'Deskripsi gangguan',
      'en': 'Description of the disorder',
    },
    'ps2phld0': {
      'id':
          'Tombol spasi tidak merespons saat digunakan. Keyboard sudah dicoba dilepas dan dipasang kembali, tetapi masalah masih terjadi.',
      'en':
          'The space bar is unresponsive when used. I\'ve tried removing and reattaching the keyboard, but the problem persists.',
    },
    'o1llx76z': {
      'id': '1 unit terdampak',
      'en': '1 unit affected',
    },
    's5kck2aa': {
      'id': 'Dilaporkan 8 menit lalu',
      'en': 'Reported 8 minutes ago',
    },
    'p905nnco': {
      'id': 'Bukti foto',
      'en': 'Photographic evidence',
    },
    '7rrpkit1': {
      'id': '1 dari 2 tersedia',
      'en': '1 of 2 available',
    },
    'kaf165az': {
      'id': 'Foto awal',
      'en': 'Early photo',
    },
    'p06xlew0': {
      'id': 'Diunggah oleh Nadia · 20 Jul 2026 · 14:18',
      'en': 'Uploaded by Nadia · Jul 20, 2026 · 2:18 PM',
    },
    '9xr0il0v': {
      'id': 'Foto hasil pekerjaan',
      'en': 'Photos of work results',
    },
    '7gi0hbhd': {
      'id': 'Belum ada foto hasil',
      'en': 'There are no photos of the results yet',
    },
    'r1dnje2a': {
      'id': 'Foto akan tersedia setelah teknisi menyelesaikan pekerjaan.',
      'en': 'Photos will be available once the technician completes the work.',
    },
    'trppoeb1': {
      'id': 'Catatan teknisi',
      'en': 'Technician\'s notes',
    },
    'irufe6xj': {
      'id': 'Belum ada catatan teknisi',
      'en': 'There are no technical notes yet',
    },
    'erhhuz1b': {
      'id':
          'Catatan pemeriksaan akan muncul setelah teknisi memulai pekerjaan.',
      'en':
          'Inspection notes will appear after the technician starts the work.',
    },
    '5vnhxlou': {
      'id': 'Timeline tiket',
      'en': 'Ticket timeline',
    },
    'okz9cok3': {
      'id': 'Riwayat aktivitas dan perubahan status',
      'en': 'Activity history and status changes',
    },
    '04b9jjta': {
      'id': 'Edit hanya tersedia sebelum teknisi memulai pekerjaan.',
      'en': 'Editing is only available before the technician starts work.',
    },
  },
  // LoginPage
  {
    'wsm222is': {
      'id': 'Home',
      'en': 'Home',
    },
  },
  // ticketDetailPage
  {
    'u3xbj2aa': {
      'id': 'Detail Tiket',
      'en': 'Ticket Details',
    },
    'okdjsiqh': {
      'id': 'TICKET TRACKING',
      'en': 'TICKET TRACKING',
    },
    'pi678r9b': {
      'id': 'Informasi laporan',
      'en': 'Report information',
    },
    'e7no2xuj': {
      'id': 'Status',
      'en': 'Status',
    },
    '6o4dlirm': {
      'id': 'Prioritas',
      'en': 'Priority',
    },
    '7kcwrgj5': {
      'id': 'Unit',
      'en': 'Unit',
    },
    'bgs7jrua': {
      'id': 'Teknisi',
      'en': 'Technician',
    },
    '4zzhlgf9': {
      'id': 'Kategori',
      'en': 'Category',
    },
    'viveivea': {
      'id': 'Verifikasi perbaikan',
      'en': 'Verify repair',
    },
    'kr1brbhj': {
      'id':
          'Periksa catatan hasil teknisi. Terima jika masalah selesai, atau buka kembali bila masih bermasalah.',
      'en':
          'Review the technician\'s notes. Accept them if the problem is resolved, or reopen them if the issue persists.',
    },
    '3y66ojic': {
      'id': 'Terima',
      'en': 'Accept',
    },
    'n4kb7hzr': {
      'id': 'Buka lagi',
      'en': 'Open again',
    },
    'idr0j999': {
      'id': 'Linimasa tiket',
      'en': 'Ticket timeline',
    },
  },
  // LoginPageCopy
  {
    'oh3w0zcr': {
      'id': 'OpsFix',
      'en': 'OpsFix',
    },
    'ddowjdfy': {
      'id': 'Welcome Back',
      'en': 'Welcome Back',
    },
    '5zcogi5l': {
      'id': 'Fill out the information below in order to access your account.',
      'en': 'Fill out the information below in order to access your account.',
    },
    'kc4e2rol': {
      'id': 'Email',
      'en': 'Email',
    },
    'qdag2zyb': {
      'id': 'Password',
      'en': 'Password',
    },
    'vhmrnjr8': {
      'id': 'Sign In',
      'en': 'Sign In',
    },
    'xy9w6m1g': {
      'id': 'Or sign in with',
      'en': 'Or sign in with',
    },
    'g860a1m9': {
      'id': 'Continue with Google',
      'en': 'Continue with Google',
    },
    'js7ebm5l': {
      'id': 'Continue with Apple',
      'en': 'Continue with Apple',
    },
    '81s6je83': {
      'id': 'Don\'t have an account?  ',
      'en': 'Don\'t have an account?  ',
    },
    'oyyoicgm': {
      'id': 'Sign Up here',
      'en': 'Sign Up here',
    },
    'r9weq5y5': {
      'id': 'Home',
      'en': 'Home',
    },
  },
  // UpdatePasswordPage
  {
    't1dfm82l': {
      'id': 'Update password',
      'en': 'Update password',
    },
    'pbir1ssv': {
      'id': 'Choose a new password',
      'en': 'Choose a new password',
    },
    'io7h8q0c': {
      'id': 'New password',
      'en': 'New password',
    },
    '6wc3rmoa': {
      'id': 'Confirm password',
      'en': 'Confirm password',
    },
    'hphz4vjx': {
      'id': 'Save new password',
      'en': 'Save new password',
    },
  },
  // LocationEntryPage
  {
    '1prjy5yo': {
      'id': 'OpsFix Location',
      'en': 'OpsFix Location',
    },
    '4vp2c9em': {
      'id': 'Pilih lokasi OpsFix',
      'en': 'Choose an OpsFix location',
    },
    '02atrcmy': {
      'id': 'Kode, slug, atau URL lokasi',
      'en': 'Location code, slug, or URL',
    },
    '3ngcjyqd': {
      'id': 'Gunakan lokasi',
      'en': 'Use location',
    },
    'hfkt0x32': {
      'id': 'Masuk terlebih dahulu',
      'en': 'Sign in first',
    },
    'vpubcim7': {
      'id':
          'Pemindaian QR dan input manual menggunakan resolver database yang sama.',
      'en': 'QR scanning and manual entry resolve against the same database.',
    },
  },
  // LaunchPage
  {
    't5azg1ud': {
      'id': 'O',
      'en': 'O',
    },
    '4d6za6ym': {
      'id': 'OpsFix',
      'en': 'OpsFix',
    },
    'onhlkd0r': {
      'id': 'Facility care, made traceable.',
      'en': 'Facility care, made traceable.',
    },
  },
  // forgotPasswordPage
  {
    '7ie3bza4': {
      'id': 'Lupa Password',
      'en': 'Forgot Password',
    },
    'yzg6di0m': {
      'id': 'Pemulihan akun',
      'en': 'Account recovery',
    },
    'bwoufeg8': {
      'id': 'Atur ulang password.',
      'en': 'Reset your password.',
    },
    '28mqp74k': {
      'id':
          'Masukkan email akun yang terdaftar. Kami akan mengirimkan tautan instruksi pemulihan.',
      'en':
          'Enter your registered account email. We will send you a link with recovery instructions.',
    },
    'onsxz7ak': {
      'id': 'Email terdaftar',
      'en': 'Registered email',
    },
    '82aj57ms': {
      'id': 'nama@perusahaan.com',
      'en': 'name@company.com',
    },
    'tgfnc0ar': {
      'id': 'Kirim tautan pemulihan',
      'en': 'Send recovery link',
    },
  },
  // RegisterPage
  {
    '4qidcppt': {
      'id': 'Home',
      'en': 'Home',
    },
  },
  // TicketCard
  {
    'nh0nmohl': {
      'id': 'Target respons',
      'en': 'Response target',
    },
    'i6mfspku': {
      'id': 'Dalam target',
      'en': 'In target',
    },
  },
  // TimelineItem
  {
    'ehvem51d': {
      'id': '·',
      'en': '·',
    },
  },
  // InfoRow2
  {
    '4lvt72fz': {
      'id': 'High',
      'en': 'High',
    },
  },
  // TimelineItem2
  {
    '9572tw7l': {
      'id': '·',
      'en': '·',
    },
  },
  // AdminLocationQrSheet
  {
    '28pgiw77': {
      'id': 'QR lokasi',
      'en': 'Location QR',
    },
    '2j7d8l2r': {
      'id': 'Satu QR membuka seluruh lokasi dan daftar unitnya.',
      'en': 'One QR opens the whole location and its unit list.',
    },
    'l1qoisie': {
      'id': 'Simpan URL publik HTTPS terlebih dahulu untuk membuat QR.',
      'en': 'Save the public HTTPS URL first to generate a QR code.',
    },
    'l4s5pfjs': {
      'id': 'Salin tautan',
      'en': 'Copy link',
    },
    'y3iuybm0': {
      'id': 'URL publik aplikasi (https://...)',
      'en': 'Public app URL (https://...)',
    },
    'oerdnbmm': {
      'id': 'Simpan URL publik',
      'en': 'Save public URL',
    },
  },
  // Miscellaneous
  {
    'smqahtle': {
      'id': 'Login',
      'en': 'Login',
    },
    'shajwqwj': {
      'id': 'Search for friends...',
      'en': 'Search for friends...',
    },
    '11u6krgu': {
      'id': 'Search for friends...',
      'en': 'Search for friends...',
    },
    'rpatgges': {
      'id': 'Continue as guest',
      'en': 'Continue as a guest',
    },
    'doggw5qo': {
      'id': '',
      'en': '',
    },
    'qngqac46': {
      'id': '',
      'en': '',
    },
    'oujlob6v': {
      'id': '',
      'en': '',
    },
    'vv958wg7': {
      'id': '',
      'en': '',
    },
    'vkom2e9e': {
      'id': '',
      'en': '',
    },
    'qiad8m7s': {
      'id': '',
      'en': '',
    },
    '85f0e48q': {
      'id': '',
      'en': '',
    },
    '0q37vgxa': {
      'id': '',
      'en': '',
    },
    'nnz3qejw': {
      'id': '',
      'en': '',
    },
    'omhl3qbx': {
      'id': '',
      'en': '',
    },
    'h7l7jntl': {
      'id': '',
      'en': '',
    },
    'l4y6yukg': {
      'id': '',
      'en': '',
    },
    'q0dtzz0q': {
      'id': '',
      'en': '',
    },
    'i8vcafyo': {
      'id': '',
      'en': '',
    },
    'rv6w9xj5': {
      'id': '',
      'en': '',
    },
    'ysraqehz': {
      'id': '',
      'en': '',
    },
    'oq2we41y': {
      'id': '',
      'en': '',
    },
    'me6v03ws': {
      'id': '',
      'en': '',
    },
    'fvigzwsy': {
      'id': '',
      'en': '',
    },
    'xjwkuwco': {
      'id': '',
      'en': '',
    },
    '7zvk318c': {
      'id': '',
      'en': '',
    },
    'm9tjw870': {
      'id': '',
      'en': '',
    },
    '3363ph6w': {
      'id': '',
      'en': '',
    },
    'xxg7wmqa': {
      'id': '',
      'en': '',
    },
    'z4gvdocn': {
      'id': '',
      'en': '',
    },
  },
].reduce((a, b) => a..addAll(b));
