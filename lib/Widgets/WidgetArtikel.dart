import 'dart:async'; // yang benar

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_hear/Pages/Detail/DetailBerita.dart';

class WidgetArtikel extends StatefulWidget {
  const WidgetArtikel({super.key});

  @override
  State<WidgetArtikel> createState() => _WidgetArtikelState();
}

class _WidgetArtikelState extends State<WidgetArtikel> {
  int selectedIndex = 0;
  int currentIndex = 0;
  Timer? timer;

  final List<String> items = ["Semua", "Acara", "Webinar", "Promosi", "Tokoh"];

  final List<String> images = [
    "assets/images/newsCard1.png",
    "assets/images/newsCard2.png",
    "assets/images/newsCard3.png",
  ];

  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  final List<Map<String, String>> berita = [
    {
      "judul": "Istilah Tuli dan Tunarungu, Mana yang Sebaiknya Digunakan?",
      "logo berita": "assets/Icon/logoLiputan6.png",
      "nama berita": "Liputan6.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/Berita1.png",
      "deskripsi":
          "Masyarakat kerap bingung tentang penyandang disabilitas, salah satunya soal penggunaan istilah...",
      "isi berita": """
Definisi dalam KBBI
Menurut Kamus Besar Bahasa Indonesia (KBBI), tunarungu berarti rusak pendengaran, sedangkan tuli berarti tidak dapat mendengar.

Perspektif Medis vs. Budaya
Istilah tunarungu sering digunakan dalam konteks medis untuk merujuk pada individu yang mengalami gangguan pendengaran dan dianggap sebagai kondisi yang memerlukan intervensi atau perbaikan. 
Di sisi lain, Tuli dengan huruf kapital T digunakan oleh komunitas sebagai identitas budaya yang menekankan bahasa isyarat sebagai bahasa ibu dan menolak pandangan bahwa mereka memiliki kekurangan yang perlu diperbaiki.

Preferensi Komunitas
Banyak anggota komunitas lebih memilih istilah Tuli karena dianggap lebih mewakili identitas sosial dan budaya mereka, serta menolak stigma yang mungkin terkait dengan istilah medis seperti tunarungu.

Kesimpulan
Memahami perbedaan antara Tuli dan Tunarungu penting untuk menghormati preferensi individu dan komunitas terkait. Penggunaan istilah yang tepat dapat membantu mengurangi stigma dan meningkatkan pemahaman serta inklusi dalam masyarakat.
""",
    },
    {
      "judul":
          "Perempuan Tunarungu Wicara di Bandung jadi Korban Kekerasan Seksual",
      "logo berita": "assets/Icon/logoSB.png",
      "nama berita": "Sekitar Bandung.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/Berita2.png",
      "deskripsi":
          "Para pelaku diduga merupakan debt collector yang biasa berkumpul di sekitar tempat kerja korban...",
      "isi berita": """
Seorang perempuan tunarungu wicara berusia 24 tahun di Kota Bandung menjadi korban kekerasan seksual yang diduga dilakukan oleh sembilan pelaku. Akibat kejadian tersebut, korban kini hamil enam bulan dan menerima pendampingan dari Dinas Pemberdayaan Perempuan dan Perlindungan Anak (DP3A) Kota Bandung.

Para pelaku diduga merupakan debt collector yang biasa berkumpul di sekitar tempat kerja korban, dengan salah satu pelaku berpura-pura menjalin hubungan pacaran untuk memanfaatkan kondisi korban. Kasus ini telah dilaporkan ke Polda Jawa Barat dan proses visum telah dilakukan untuk mendukung penyelidikan.

DP3A Kota Bandung memastikan bahwa korban mendapatkan dukungan mental dan materi, khususnya menjelang proses persalinan. Mereka juga berkoordinasi dengan Dinas Pemberdayaan Perempuan Perlindungan Anak dan Keluarga Berencana Jawa Barat untuk memberikan pendampingan hukum dan psikologis secara intensif.

Pemerintah Kota Bandung menegaskan komitmennya untuk melindungi dan mendukung korban kekerasan serta mendorong penegakan hukum yang tegas terhadap para pelaku.

Kasus ini menyoroti pentingnya perlindungan terhadap perempuan dan anak dari segala bentuk kekerasan, terutama bagi mereka yang memiliki disabilitas. Dukungan dari berbagai pihak diperlukan untuk memastikan keadilan bagi korban dan mencegah kejadian serupa di masa mendatang.
""",
    },
    {
      "judul":
          "Siswa Tuna Rungu-Tuna Wicara di Tasikmalaya Belajar Bahasa Isyarat Lewat I-Chat",
      "logo berita": "assets/Icon/logoTempo.png",
      "nama berita": "Tempo.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B1.png",
      "deskripsi":
          "Teknologi digital, termasuk aplikasi dan inovasi berbasis AI, membantu penyandang tunarungu dalam komunikasi dan aktivitas sehari-hari",
      "isi berita": """
Inklusivitas di dunia pendidikan mempunyai peran penting dalam mewujudkan lingkungan yang ramah dan aman bagi setiap anak, khususnya bagi penyandang disabilitas. Pendidikan inklusif merupakan pendekatan dalam sistem pendidikan yang berupaya memberikan akses pendidikan yang setara bagi semua anak, termasuk anak-anak dengan disabilitas.

Salah satu bentuk pendidikan inklusif diterapkan oleh Sekolah Luar Biasa Negeri (SLB) Tamansari Kota Tasikmalaya bagi siswa-siswi penyandang tuna rungu dan tuna wicara melalui pemanfaatan teknologi digital. Teknologi digital memungkinkan penyediaan akses yang lebih luas, fleksibel, dan adaptif bagi semua siswa, termasuk mereka yang memiliki kebutuhan khusus.

Dengan memanfaatkan sebuah aplikasi bernama I-Chat (I Can Hear and Talk) yang terpasang di perangkat komputer, proses pembelajaran bahasa isyarat bagi para siswa tuna rungu dan tuna wicara menjadi lebih mudah. I-Chat merupakan karya inovasi PT Telkom Indonesia berupa aplikasi pembelajaran bahasa isyarat melalui kamus audio-visual.

Sebelumnya, pembelajaran masih mengandalkan buku kamus Sistem Isyarat Bahasa Indonesia (SIBI). Proses itu cukup menghambat karena siswa membutuhkan waktu lama untuk mencari kosakata, dan sering kesulitan fokus karena media pembelajaran kurang menarik.

Aplikasi I-Chat dilengkapi dengan fitur video tutorial bahasa isyarat mulai dari huruf abjad hingga susunan kosakata kalimat. Fitur ini membantu guru membangun suasana kelas yang lebih interaktif dan menyenangkan.

Pemanfaatan teknologi digital ini merupakan salah satu bentuk inklusivitas, memberi kesempatan yang sama bagi penyandang disabilitas untuk berkembang secara optimal. Harapannya, ke depan semakin banyak inovasi teknologi yang mampu membantu penyandang disabilitas untuk mandiri dan berkarya.
""",
    },
    {
      "judul":
          "Pantang Menyerah! Penyandang Tuna Rungu Wicara Asal Jombang Ini Berhasil Raih Medali Perak di Ajang Peparpeda 2024",
      "logo berita": "assets/Icon/logoSB.png",
      "nama berita": "Sekitar Bandung.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B2.png",
      "deskripsi": "Atlet Tunarungu Raih Medali Perak di Peparpeda 2024",
      "isi berita": """
Hambatan dalam pendengaran bukan menjadi penghalang untuk tetap berprestasi.
Seperti dibuktikan Muhammad Abid Zakariya, yang jago berenang dan sudah meraih prestasi tingkat provinsi sebagai peraih medali perak pada Pekan Paralympic Pelajar Daerah (Peparpeda) di Bangkalan 2024.

"Itu kejuaraan pertama, langsung menang, alhamdulillah anaknya semakin semangat," kata Ahmad Suhadi, ayah Zaka.
Zakariya lahir di Jombang pada 22 Juli 2011. Terlahir prematur, Zaka memiliki hambatan tunawicara dan tunarungu. Sekolahnya juga terhambat.

Ia harusnya sudah duduk di bangku kelas 6 SD, kini masih duduk di bangku kelas 3 SDLB di SLBN Jombang.
Orang tuanya, Ahmad Suhadi dan istrinya, Betty Nuraini, ingin sang buah hati tumbuh menjadi anak yang berprestasi. Mereka kemudian menggali bakat Zaka melalui olahraga.

"Setahu saya, anak hambatan tunarungu dan wicara, paling baik diarahkan ke olahraga," kata warga Desa Ngudirejo, Kecamatan Diwek. Berenang menjadi olahraga yang dipilih.
Beruntungnya, Zaka yang baru pertama kali belajar berenang langsung mau dan enjoy menjalani latihan privat yang dilakukan dua kali seminggu di Kolam Renang Aquatic UPJB Jombang.

Pelatih yang melatih Zaka memiliki kesabaran dan ketelatenan tinggi. Zaka tidak hanya dibimbing dengan menggunakan bahasa isyarat, tapi juga dibimbing secara langsung, dituntun dengan sabar hingga Zaka bisa berenang.
""",
    },
    {
      "judul": "Bahasa Isyarat Bantu Pendidikan Anak Tuna Rungu Wicara",
      "logo berita": "assets/Icon/logoTempo.png",
      "nama berita": "Tempo.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B3.png",
      "deskripsi":
          "Bahasa isyarat berperan penting dalam mendukung pendidikan anak-anak tunarungu-wicara agar mereka tidak tertinggal dalam pembelajaran.",
      "isi berita": """
Bahasa isyarat membantu dalam memberikan pendidikan anak dengan tuna rungu wicara atau gangguan pendengaran dan berbicara di Sekolah Luar Biasa (SLB).
Siti Afifah, guru SLB B Dharma Wanita Pare, Kabupaten Kediri, menyampaikan bahwa karena SLB berada di daerah, siswa diajarkan bahasa oral (gerak bibir) dan bahasa isyarat.

 “Bahasa isyarat untuk anak-anak terutama di SLB memang membantu sekali, tapi kita tetap mengusahakan anak-anak bisa komunikasi total. Diusahakan anak-anak bisa pakai bahasa gerak bibir dan bahasa isyarat karena rata-rata anak-anak dari daerah, keluarga di rumah kurang menguasai bahasa isyarat,” ujar Siti Afifah.

Hari Bahasa Isyarat Internasional diperingati setiap tanggal 23 September untuk meningkatkan kesadaran pentingnya bahasa isyarat bagi jutaan orang tuli dan tunarungu serta mendorong hak mereka untuk mengakses komunikasi yang setara.

Wiwin, salah satu wali murid SLB B Dharma Wanita Pare, mengatakan bahwa di rumah lebih banyak menggunakan bahasa isyarat dan gerak bibir.

“Bahasa isyarat penting karena setiap anak berbeda-beda. Kalau di rumah memakai bahasa ibu, di sekolah bahasanya berbeda. Selama ini pakai bahasa isyarat, sementara bahasa gerak bibir masih belajar. Harapannya anak bisa diterima di masyarakat umum dengan baik,” kata Wiwin.
Tanggal 23 September dipilih karena bertepatan dengan berdirinya Federasi Tuli Sedunia pada tahun 1951, yang memperjuangkan hak-hak komunitas tuli secara internasional.

""",
    },
  ];

  final List<Map<String, String>> berita2 = [
    {
      "judul":
          "Pemkab Jember Siap Tingkatkan Aksesibilitas Layanan Publik untuk Disabilitas Tuna Rungu dan Wicara?",
      "logo berita": "assets/Icon/logoLiputan6.png",
      "nama berita": "Liputan6.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B4.png",
      "deskripsi":
          "Pemerintah Kabupaten Jember berkomitmen memperbaiki layanan publik agar lebih ramah bagi penyandang tunarungu dan tunawicara",
      "isi berita": """
Perwakilan komunitas penyandang disabilitas rungu dan wicara yang tergabung dalam Gerakan untuk Kesejahteraan Tuna Rungu Indonesia (Gergatin) menyampaikan aspirasi mereka terkait keterbatasan akses terhadap layanan publik di Jember. Mereka berharap Pemerintah Kabupaten Jember memberikan perhatian agar pelayanan publik bisa diakses secara setara.

Perwakilan komunitas penyandang disabilitas rungu dan wicara yang tergabung dalam Gerakan untuk Kesejahteraan Tuna Rungu Indonesia (Gergatin) menyampaikan aspirasi mereka terkait keterbatasan akses terhadap layanan publik di Jember. Mereka berharap Pemerintah Kabupaten Jember memberikan perhatian agar pelayanan publik bisa diakses secara setara.

“Prinsip kami jelas, tidak boleh ada diskriminasi. Saudara-saudara kita penyandang disabilitas juga berhak mendapatkan pelayanan kesehatan yang optimal,” ujar Bupati Fawait.
Ia menambahkan bahwa aspirasi ini akan diteruskan ke seluruh fasilitas kesehatan di bawah kewenangan pemerintah daerah, termasuk 3 rumah sakit daerah dan 50 puskesmas di Jember. Tenaga kesehatan akan dibekali pengetahuan dan pelatihan untuk menghadirkan pelayanan yang inklusif.

Bupati Fawait menekankan seluruh fasilitas kesehatan harus ramah terhadap penyandang disabilitas. Aksesibilitas menjadi kunci agar semua masyarakat memperoleh layanan kesehatan secara adil.

Ia juga mengajak masyarakat menyampaikan keluhan dan saran melalui kanal Wadul Gus'e, terutama terkait kebutuhan layanan publik bagi kelompok difabel. Penyediaan juru bahasa isyarat (JBI) di fasilitas kesehatan diharapkan membantu penyandang disabilitas rungu dan wicara mengakses layanan secara mandiri dan nyaman.

""",
    },
    {
      "judul": "Bekali Disabilitas Rungu Wicara agar Bangun Kemandirian Sosial",
      "logo berita": "assets/Icon/logoSB.png",
      "nama berita": "Sekitar Bandung.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B5.png",
      "deskripsi":
          "Program pelatihan diberikan untuk mendukung kemandirian sosial dan ekonomi penyandang disabilitas rungu-wicara di Jawa Timur.",
      "isi berita": """
Dinas Sosial Provinsi Jawa Timur memiliki UPT Rehabilitasi Sosial Bina Rungu Wicara (RSBRW) Pasuruan, yang memberikan pembekalan keterampilan bagi penerima manfaat berusia 15-35 tahun untuk meraih kemandirian sosial.

Tersedia empat keterampilan utama: bordir, jahit putri, jahit putra, dan las, dilaksanakan Senin–Kamis. Pada hari Jumat, penerima manfaat juga mendapatkan keterampilan tambahan: tata boga, handycraft, dan desain grafis. Selain itu, ada kegiatan mengaji dengan metode oral dan bahasa isyarat, bekerjasama dengan Gerkatin (Gerakan untuk Kesejahteraan Tuna Rungu Indonesia).

Beberapa penerima manfaat merasa senang dan berkembang dalam keterampilan yang dipelajari, seperti Hilma (bordir), Alvia (jahit putri), dan Kiki (jahit putra). Mereka berharap setelah lulus, bisa membuka usaha sendiri atau bekerja di bidang keterampilan yang dimiliki, sehingga memiliki kemandirian sosial.

Kepala UPT RSBRW Pasuruan, Sri Mariyani, menambahkan bahwa penerima manfaat direkrut melalui Dinas Sosial kabupaten/kota masing-masing, dan lama pelatihan adalah dua tahun, dengan kemungkinan perpanjangan satu tahun jika masih membutuhkan. Saat ini terdapat 60 penerima manfaat, dengan 24 orang yang akan segera lulus.

Selain pelatihan, orang tua juga dibekali motivasi agar bisa mendampingi anak-anak mereka. UPT RSBRW Pasuruan telah bekerjasama dengan tiga perusahaan untuk magang serta UPT BLK Pasuruan Disnakertrans Jatim, guna menyiapkan keterampilan lebih matang. Produk hasil pelatihan juga akan dipamerkan melalui showroom dan kegiatan pameran Dinsos Jatim.
""",
    },
    {
      "judul":
          "Korban Kecelakaan Menjadi Penyumbang Besar Disabilitas di Indonesia",
      "logo berita": "assets/Icon/logoTempo.png",
      "nama berita": "Tempo.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B6.png",
      "deskripsi":
          "Korban kecelakaan masih menjadi penyumbang terbesar jumlah penyandang disabilitas di Indonesia.",
      "isi berita": """
Ketua Umum Perkumpulan Penyandang Disabilitas Indonesia (PPDI), Norman Yulian, menyampaikan bahwa korban kecelakaan, termasuk kecelakaan lalu lintas, menjadi salah satu penyumbang terbesar angka disabilitas di Indonesia. Saat ini, jumlah penyandang disabilitas di Indonesia mencapai lebih dari 10 juta orang.

Norman menekankan bahwa beban psikologis korban kecelakaan lebih berat dibanding penyandang disabilitas sejak lahir, karena mereka harus menyesuaikan diri dengan kondisi baru yang berbeda dari kehidupan sebelumnya.

Dalam kesempatan tersebut, para penyandang disabilitas korban kecelakaan menerima alat bantu dari Korps Lalu Lintas (Korlantas) Polri, yang bertujuan membantu mereka lebih mandiri dan meningkatkan kepercayaan diri saat kembali bermasyarakat.
Norman mendorong agar dukungan tidak berhenti pada alat bantu saja, tetapi juga disertai program lanjutan berupa pembinaan keterampilan dan pemberdayaan ekonomi, sehingga korban kecelakaan dapat memperoleh penghasilan tambahan dan kembali produktif.

""",
    },
    {
      "judul": "DPR Desak Pemerintah Perkuat Layanan Disabilitas",
      "logo berita": "assets/Icon/logoSB.png",
      "nama berita": "Sekitar Bandung.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B7.png",
      "deskripsi":
          "Pemerintah diminta memperkuat akses layanan pendidikan agar semua anak disabilitas dapat bersekolah tanpa diskriminasi.",
      "isi berita": """
Komisi X DPR RI mendesak pemerintah untuk memperkuat fungsi Unit Layanan Disabilitas (ULD) agar anak-anak penyandang disabilitas di Indonesia dapat mengakses pendidikan secara setara.
Ketua Komisi X DPR RI, Hetifah Sjaifudian, menegaskan bahwa pendidikan merupakan hak dasar seluruh warga negara, termasuk penyandang disabilitas.
"Pendidikan adalah hak dasar setiap warga negara, tanpa terkecuali bagi saudara-saudara kita penyandang disabilitas. Negara wajib menjamin akses pendidikan yang setara, bermutu, dan tanpa diskriminasi," ujar Hetifah dalam kegiatan Advokasi Optimalisasi Fungsi ULD Bidang Pendidikan yang digelar di Jakarta, Kamis (21/8/2025).

Selain itu, meskipun terdapat ribuan sekolah inklusif di Indonesia, baru sekitar 14,83 persen yang memiliki Guru Pembimbing Khusus (GPK) sebagai tenaga pendukung utama bagi siswa penyandang disabilitas.
"Keberadaan ULD sangat strategis sebagai jembatan yang memastikan peserta didik penyandang disabilitas memperoleh layanan pendidikan setara," jelas Hetifah.

Ia menegaskan, optimalisasi ULD tidak boleh sebatas formalitas. ULD harus benar-benar responsif, memiliki SDM terlatih, sarana prasarana yang ramah disabilitas, serta dukungan regulasi yang kuat.
"Unit ini harus berkelanjutan dan mampu menghapus hambatan yang dihadapi peserta didik disabilitas. Dengan begitu, ULD dapat menjadi motor penggerak inklusi, kesetaraan, dan keadilan dalam pendidikan," tambahnya.

Komisi X DPR RI berkomitmen mendorong pemerintah memperkuat peran ULD di seluruh daerah. Hetifah juga mengajak lembaga pendidikan dan masyarakat turut serta membangun ekosistem pendidikan inklusif.
"Semoga ikhtiar ini menjadi langkah nyata dalam menghadirkan layanan pendidikan yang lebih adil, inklusif, dan berkualitas bagi seluruh anak bangsa," pungkasnya.

""",
    },
    {
      "judul": "Komitmen Pemenuhan Hak Disabilitas dalam RKP 2025",
      "logo berita": "assets/Icon/logoTempo.png",
      "nama berita": "Tempo.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B8.png",
      "deskripsi": "Komitmen Pemenuhan Hak Disabilitas dalam RKP 2025",
      "isi berita": """
Deputi Bidang Koordinasi Peningkatan Kualitas Keluarga dan Kependudukan Kementerian Koordinator Bidang Pembangunan Manusia dan Kebudayaan (Kemenko PMK) Woro Srihastuti Sulistyaningrum menegaskan, isu penyandang disabilitas adalah isu lintas sektor yang memerlukan perhatian komprehensif.

Hal tersebut disampaikannya dalam Rapat Koordinasi Monitoring dan Sinkronisasi Capaian Program RKP 2025 dan RENJA K/L Bidang Penyandang Disabilitas yang diselenggarakan secara daring, pada Kamis (13/3/2025).

"Pemerintah Indonesia terus berupaya memperkuat pemenuhan hak penyandang disabilitas melalui serangkaian kebijakan inklusif yang melibatkan berbagai sektor," ujar Deputi yang akrab disapa Lisa itu.

Deputi Lisa memaparkan, berdasarkan data REGSOSEK 2023, terdapat 4,3 juta penyandang disabilitas sedang hingga berat di Indonesia, dengan mayoritas berada pada kelompok usia dewasa dan lanjut usia. Ia menyampaikan, penyandang disabilitas dan keluarganya masih menghadapi keterbatasan akses terhadap layanan dasar, seperti pendidikan, kesehatan, dan ketenagakerjaan.

Salah satu tantangan utama dalam sektor pendidikan adalah rendahnya tingkat partisipasi penyandang disabilitas. Data Susenas Maret 2024 menunjukkan bahwa 17,2% penyandang disabilitas berusia 15 tahun ke atas tidak pernah bersekolah, dan hanya 4,24% yang berhasil mencapai pendidikan tinggi. 

Dari sisi kesehatan, Deputi Lisa mengungkapkan bahwa penyandang disabilitas cenderung memiliki akses yang lebih rendah terhadap jaminan kesehatan, baik dari pemerintah maupun swasta. Oleh karena itu, pemerintah akan terus mendorong penguatan layanan kesehatan yang ramah disabilitas.

Deputi Lisa menyampaikan, pemerintah telah menetapkan berbagai instrumen hukum untuk memastikan hak penyandang disabilitas terlindungi. Beberapa di antaranya adalah UU Nomor 8 Tahun 2016 tentang Penyandang Disabilitas, PP Nomor 70 Tahun 2019 tentang Perencanaan, Penyelenggaraan, dan Evaluasi terhadap Penghormatan, Pelindungan, dan Pemenuhan Hak Penyandang Disabilitas. Selain itu, terdapat Perpres Nomor 12 Tahun 2025 tentang RPJMN 2025-2029 juga menegaskan pentingnya koordinasi lintas kementerian dalam memastikan keberpihakan terhadap penyandang disabilitas.

Sebagai bagian dari Rencana Pembangunan Jangka Menengah Nasional (RPJMN) 2025-2029, Kemenko PMK diamanatkan untuk mendukung pencapaian sasaran pembangunan Prioritas Nasional IV, dengan fokus pada peningkatan mobilitas penyandang disabilitas. Targetnya adalah meningkatkan mobilitas dari 68,42% pada 2023 menjadi 69% pada 2025, dan mencapai 71% pada 2029.

Deputi Lisa juga menyoroti pentingnya sinergi antara pemerintah pusat dan daerah dalam menerapkan kebijakan inklusif. Pendekatan ini mencakup penyelarasan anggaran, integrasi program, serta peningkatan partisipasi penyandang disabilitas dalam proses perencanaan pembangunan.

"Kita perlu mendorong kemitraan dengan pemerintah daerah untuk memastikan kebijakan yang diterapkan sesuai dengan konteks lokal dan kebutuhan nyata penyandang disabilitas," tuturnya. 

Dalam Rencana Kerja Pemerintah (RKP) Tahun 2025, program peningkatan kesetaraan dan pemenuhan hak penyandang disabilitas akan difokuskan pada berbagai aspek, termasuk peningkatan akses terhadap pekerjaan, penguatan kapasitas penyandang disabilitas melalui pelatihan keterampilan, serta penyediaan infrastruktur yang ramah disabilitas. 

"Kolaborasi antar-kementerian harus terus diperkuat untuk memastikan bahwa alokasi dana dan program-program yang ada dapat saling melengkapi," kata Deputi Lisa.

Sebagai langkah konkret, pemerintah juga tengah menyusun Indeks Inklusivitas Penyandang Disabilitas sebagai alat ukur dalam mengevaluasi efektivitas kebijakan yang telah diterapkan. Indeks ini akan memastikan bahwa setiap kebijakan didasarkan pada data yang valid dan dapat dipertanggungjawabkan, sehingga intervensi yang dilakukan lebih tepat sasaran.

Deputi Lisa menutup paparannya dengan menegaskan bahwa inklusi penyandang disabilitas harus menjadi bagian integral dari pembangunan nasional. "Kita tidak bisa membangun bangsa ini dengan meninggalkan kelompok rentan. Oleh karena itu, kebijakan yang inklusif dan berkelanjutan harus terus diupayakan untuk mewujudkan kesejahteraan bagi seluruh warga negara," pungkasnya.

Rapat ini dihadiri oleh 14 K/L, antara lain Sesditjen Kemendiktisaintek, Direktur Pendidikan Khusus dan Pendidikan Layanan Khusus Kemendikdasmen, Kasub Direktorat Sosial dan Budaya Kemendagri, perwakilan dari Bappenas, Kemenkes, Kemensos, BKKBN, Kemenpora, KPPPA, Kemnaker, Kemendikdasmen, Kemenhub, Kemen PU, Kemenag, dan Komisi Nasional Disabilitas.

""",
    },
  ];

  final List<Map<String, String>> artikel = [
    {
      "judul": "Istilah Tuli dan Tunarungu, Mana yang Sebaiknya Digunakan?",
      "logo berita": "assets/Icon/logoLiputan6.png",
      "nama berita": "Liputan6.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/Berita1.png",
      "deskripsi":
          "Masyarakat kerap bingung tentang penyandang disabilitas, salah satunya soal penggunaan istilah...",
      "isi berita": """
Definisi dalam KBBI
Menurut Kamus Besar Bahasa Indonesia (KBBI), tunarungu berarti rusak pendengaran, sedangkan tuli berarti tidak dapat mendengar.

Perspektif Medis vs. Budaya
Istilah tunarungu sering digunakan dalam konteks medis untuk merujuk pada individu yang mengalami gangguan pendengaran dan dianggap sebagai kondisi yang memerlukan intervensi atau perbaikan. 
Di sisi lain, Tuli dengan huruf kapital T digunakan oleh komunitas sebagai identitas budaya yang menekankan bahasa isyarat sebagai bahasa ibu dan menolak pandangan bahwa mereka memiliki kekurangan yang perlu diperbaiki.

Preferensi Komunitas
Banyak anggota komunitas lebih memilih istilah Tuli karena dianggap lebih mewakili identitas sosial dan budaya mereka, serta menolak stigma yang mungkin terkait dengan istilah medis seperti tunarungu.

Kesimpulan
Memahami perbedaan antara Tuli dan Tunarungu penting untuk menghormati preferensi individu dan komunitas terkait. Penggunaan istilah yang tepat dapat membantu mengurangi stigma dan meningkatkan pemahaman serta inklusi dalam masyarakat.
""",
    },
    {
      "judul":
          "Perempuan Tunarungu Wicara di Bandung jadi Korban Kekerasan Seksual",
      "logo berita": "assets/Icon/logoSB.png",
      "nama berita": "Sekitar Bandung.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/Berita2.png",
      "deskripsi":
          "Para pelaku diduga merupakan debt collector yang biasa berkumpul di sekitar tempat kerja korban...",
      "isi berita": """
Seorang perempuan tunarungu wicara berusia 24 tahun di Kota Bandung menjadi korban kekerasan seksual yang diduga dilakukan oleh sembilan pelaku. Akibat kejadian tersebut, korban kini hamil enam bulan dan menerima pendampingan dari Dinas Pemberdayaan Perempuan dan Perlindungan Anak (DP3A) Kota Bandung.

Para pelaku diduga merupakan debt collector yang biasa berkumpul di sekitar tempat kerja korban, dengan salah satu pelaku berpura-pura menjalin hubungan pacaran untuk memanfaatkan kondisi korban. Kasus ini telah dilaporkan ke Polda Jawa Barat dan proses visum telah dilakukan untuk mendukung penyelidikan.

DP3A Kota Bandung memastikan bahwa korban mendapatkan dukungan mental dan materi, khususnya menjelang proses persalinan. Mereka juga berkoordinasi dengan Dinas Pemberdayaan Perempuan Perlindungan Anak dan Keluarga Berencana Jawa Barat untuk memberikan pendampingan hukum dan psikologis secara intensif.

Pemerintah Kota Bandung menegaskan komitmennya untuk melindungi dan mendukung korban kekerasan serta mendorong penegakan hukum yang tegas terhadap para pelaku.

Kasus ini menyoroti pentingnya perlindungan terhadap perempuan dan anak dari segala bentuk kekerasan, terutama bagi mereka yang memiliki disabilitas. Dukungan dari berbagai pihak diperlukan untuk memastikan keadilan bagi korban dan mencegah kejadian serupa di masa mendatang.
""",
    },
    {
      "judul":
          "Siswa Tuna Rungu-Tuna Wicara di Tasikmalaya Belajar Bahasa Isyarat Lewat I-Chat",
      "logo berita": "assets/Icon/logoTempo.png",
      "nama berita": "Tempo.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B1.png",
      "deskripsi":
          "Teknologi digital, termasuk aplikasi dan inovasi berbasis AI, membantu penyandang tunarungu dalam komunikasi dan aktivitas sehari-hari",
      "isi berita": """
Inklusivitas di dunia pendidikan mempunyai peran penting dalam mewujudkan lingkungan yang ramah dan aman bagi setiap anak, khususnya bagi penyandang disabilitas. Pendidikan inklusif merupakan pendekatan dalam sistem pendidikan yang berupaya memberikan akses pendidikan yang setara bagi semua anak, termasuk anak-anak dengan disabilitas.

Salah satu bentuk pendidikan inklusif diterapkan oleh Sekolah Luar Biasa Negeri (SLB) Tamansari Kota Tasikmalaya bagi siswa-siswi penyandang tuna rungu dan tuna wicara melalui pemanfaatan teknologi digital. Teknologi digital memungkinkan penyediaan akses yang lebih luas, fleksibel, dan adaptif bagi semua siswa, termasuk mereka yang memiliki kebutuhan khusus.

Dengan memanfaatkan sebuah aplikasi bernama I-Chat (I Can Hear and Talk) yang terpasang di perangkat komputer, proses pembelajaran bahasa isyarat bagi para siswa tuna rungu dan tuna wicara menjadi lebih mudah. I-Chat merupakan karya inovasi PT Telkom Indonesia berupa aplikasi pembelajaran bahasa isyarat melalui kamus audio-visual.

Sebelumnya, pembelajaran masih mengandalkan buku kamus Sistem Isyarat Bahasa Indonesia (SIBI). Proses itu cukup menghambat karena siswa membutuhkan waktu lama untuk mencari kosakata, dan sering kesulitan fokus karena media pembelajaran kurang menarik.

Aplikasi I-Chat dilengkapi dengan fitur video tutorial bahasa isyarat mulai dari huruf abjad hingga susunan kosakata kalimat. Fitur ini membantu guru membangun suasana kelas yang lebih interaktif dan menyenangkan.

Pemanfaatan teknologi digital ini merupakan salah satu bentuk inklusivitas, memberi kesempatan yang sama bagi penyandang disabilitas untuk berkembang secara optimal. Harapannya, ke depan semakin banyak inovasi teknologi yang mampu membantu penyandang disabilitas untuk mandiri dan berkarya.
""",
    },
    {
      "judul":
          "Pantang Menyerah! Penyandang Tuna Rungu Wicara Asal Jombang Ini Berhasil Raih Medali Perak di Ajang Peparpeda 2024",
      "logo berita": "assets/Icon/logoSB.png",
      "nama berita": "Sekitar Bandung.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B2.png",
      "deskripsi": "Atlet Tunarungu Raih Medali Perak di Peparpeda 2024",
      "isi berita": """
Hambatan dalam pendengaran bukan menjadi penghalang untuk tetap berprestasi.
Seperti dibuktikan Muhammad Abid Zakariya, yang jago berenang dan sudah meraih prestasi tingkat provinsi sebagai peraih medali perak pada Pekan Paralympic Pelajar Daerah (Peparpeda) di Bangkalan 2024.

"Itu kejuaraan pertama, langsung menang, alhamdulillah anaknya semakin semangat," kata Ahmad Suhadi, ayah Zaka.
Zakariya lahir di Jombang pada 22 Juli 2011. Terlahir prematur, Zaka memiliki hambatan tunawicara dan tunarungu. Sekolahnya juga terhambat.

Ia harusnya sudah duduk di bangku kelas 6 SD, kini masih duduk di bangku kelas 3 SDLB di SLBN Jombang.
Orang tuanya, Ahmad Suhadi dan istrinya, Betty Nuraini, ingin sang buah hati tumbuh menjadi anak yang berprestasi. Mereka kemudian menggali bakat Zaka melalui olahraga.

"Setahu saya, anak hambatan tunarungu dan wicara, paling baik diarahkan ke olahraga," kata warga Desa Ngudirejo, Kecamatan Diwek. Berenang menjadi olahraga yang dipilih.
Beruntungnya, Zaka yang baru pertama kali belajar berenang langsung mau dan enjoy menjalani latihan privat yang dilakukan dua kali seminggu di Kolam Renang Aquatic UPJB Jombang.

Pelatih yang melatih Zaka memiliki kesabaran dan ketelatenan tinggi. Zaka tidak hanya dibimbing dengan menggunakan bahasa isyarat, tapi juga dibimbing secara langsung, dituntun dengan sabar hingga Zaka bisa berenang.
""",
    },
    {
      "judul": "Bahasa Isyarat Bantu Pendidikan Anak Tuna Rungu Wicara",
      "logo berita": "assets/Icon/logoTempo.png",
      "nama berita": "Tempo.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B3.png",
      "deskripsi":
          "Bahasa isyarat berperan penting dalam mendukung pendidikan anak-anak tunarungu-wicara agar mereka tidak tertinggal dalam pembelajaran.",
      "isi berita": """
Bahasa isyarat membantu dalam memberikan pendidikan anak dengan tuna rungu wicara atau gangguan pendengaran dan berbicara di Sekolah Luar Biasa (SLB).
Siti Afifah, guru SLB B Dharma Wanita Pare, Kabupaten Kediri, menyampaikan bahwa karena SLB berada di daerah, siswa diajarkan bahasa oral (gerak bibir) dan bahasa isyarat.

 “Bahasa isyarat untuk anak-anak terutama di SLB memang membantu sekali, tapi kita tetap mengusahakan anak-anak bisa komunikasi total. Diusahakan anak-anak bisa pakai bahasa gerak bibir dan bahasa isyarat karena rata-rata anak-anak dari daerah, keluarga di rumah kurang menguasai bahasa isyarat,” ujar Siti Afifah.

Hari Bahasa Isyarat Internasional diperingati setiap tanggal 23 September untuk meningkatkan kesadaran pentingnya bahasa isyarat bagi jutaan orang tuli dan tunarungu serta mendorong hak mereka untuk mengakses komunikasi yang setara.

Wiwin, salah satu wali murid SLB B Dharma Wanita Pare, mengatakan bahwa di rumah lebih banyak menggunakan bahasa isyarat dan gerak bibir.

“Bahasa isyarat penting karena setiap anak berbeda-beda. Kalau di rumah memakai bahasa ibu, di sekolah bahasanya berbeda. Selama ini pakai bahasa isyarat, sementara bahasa gerak bibir masih belajar. Harapannya anak bisa diterima di masyarakat umum dengan baik,” kata Wiwin.
Tanggal 23 September dipilih karena bertepatan dengan berdirinya Federasi Tuli Sedunia pada tahun 1951, yang memperjuangkan hak-hak komunitas tuli secara internasional.

""",
    },
    {
      "judul":
          "Pemkab Jember Siap Tingkatkan Aksesibilitas Layanan Publik untuk Disabilitas Tuna Rungu dan Wicara?",
      "logo berita": "assets/Icon/logoLiputan6.png",
      "nama berita": "Liputan6.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B4.png",
      "deskripsi":
          "Pemerintah Kabupaten Jember berkomitmen memperbaiki layanan publik agar lebih ramah bagi penyandang tunarungu dan tunawicara",
      "isi berita": """
Perwakilan komunitas penyandang disabilitas rungu dan wicara yang tergabung dalam Gerakan untuk Kesejahteraan Tuna Rungu Indonesia (Gergatin) menyampaikan aspirasi mereka terkait keterbatasan akses terhadap layanan publik di Jember. Mereka berharap Pemerintah Kabupaten Jember memberikan perhatian agar pelayanan publik bisa diakses secara setara.

Perwakilan komunitas penyandang disabilitas rungu dan wicara yang tergabung dalam Gerakan untuk Kesejahteraan Tuna Rungu Indonesia (Gergatin) menyampaikan aspirasi mereka terkait keterbatasan akses terhadap layanan publik di Jember. Mereka berharap Pemerintah Kabupaten Jember memberikan perhatian agar pelayanan publik bisa diakses secara setara.

“Prinsip kami jelas, tidak boleh ada diskriminasi. Saudara-saudara kita penyandang disabilitas juga berhak mendapatkan pelayanan kesehatan yang optimal,” ujar Bupati Fawait.
Ia menambahkan bahwa aspirasi ini akan diteruskan ke seluruh fasilitas kesehatan di bawah kewenangan pemerintah daerah, termasuk 3 rumah sakit daerah dan 50 puskesmas di Jember. Tenaga kesehatan akan dibekali pengetahuan dan pelatihan untuk menghadirkan pelayanan yang inklusif.

Bupati Fawait menekankan seluruh fasilitas kesehatan harus ramah terhadap penyandang disabilitas. Aksesibilitas menjadi kunci agar semua masyarakat memperoleh layanan kesehatan secara adil.

Ia juga mengajak masyarakat menyampaikan keluhan dan saran melalui kanal Wadul Gus'e, terutama terkait kebutuhan layanan publik bagi kelompok difabel. Penyediaan juru bahasa isyarat (JBI) di fasilitas kesehatan diharapkan membantu penyandang disabilitas rungu dan wicara mengakses layanan secara mandiri dan nyaman.

""",
    },
    {
      "judul": "Bekali Disabilitas Rungu Wicara agar Bangun Kemandirian Sosial",
      "logo berita": "assets/Icon/logoSB.png",
      "nama berita": "Sekitar Bandung.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B5.png",
      "deskripsi":
          "Program pelatihan diberikan untuk mendukung kemandirian sosial dan ekonomi penyandang disabilitas rungu-wicara di Jawa Timur.",
      "isi berita": """
Dinas Sosial Provinsi Jawa Timur memiliki UPT Rehabilitasi Sosial Bina Rungu Wicara (RSBRW) Pasuruan, yang memberikan pembekalan keterampilan bagi penerima manfaat berusia 15-35 tahun untuk meraih kemandirian sosial.

Tersedia empat keterampilan utama: bordir, jahit putri, jahit putra, dan las, dilaksanakan Senin–Kamis. Pada hari Jumat, penerima manfaat juga mendapatkan keterampilan tambahan: tata boga, handycraft, dan desain grafis. Selain itu, ada kegiatan mengaji dengan metode oral dan bahasa isyarat, bekerjasama dengan Gerkatin (Gerakan untuk Kesejahteraan Tuna Rungu Indonesia).

Beberapa penerima manfaat merasa senang dan berkembang dalam keterampilan yang dipelajari, seperti Hilma (bordir), Alvia (jahit putri), dan Kiki (jahit putra). Mereka berharap setelah lulus, bisa membuka usaha sendiri atau bekerja di bidang keterampilan yang dimiliki, sehingga memiliki kemandirian sosial.

Kepala UPT RSBRW Pasuruan, Sri Mariyani, menambahkan bahwa penerima manfaat direkrut melalui Dinas Sosial kabupaten/kota masing-masing, dan lama pelatihan adalah dua tahun, dengan kemungkinan perpanjangan satu tahun jika masih membutuhkan. Saat ini terdapat 60 penerima manfaat, dengan 24 orang yang akan segera lulus.

Selain pelatihan, orang tua juga dibekali motivasi agar bisa mendampingi anak-anak mereka. UPT RSBRW Pasuruan telah bekerjasama dengan tiga perusahaan untuk magang serta UPT BLK Pasuruan Disnakertrans Jatim, guna menyiapkan keterampilan lebih matang. Produk hasil pelatihan juga akan dipamerkan melalui showroom dan kegiatan pameran Dinsos Jatim.
""",
    },
    {
      "judul":
          "Korban Kecelakaan Menjadi Penyumbang Besar Disabilitas di Indonesia",
      "logo berita": "assets/Icon/logoTempo.png",
      "nama berita": "Tempo.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B6.png",
      "deskripsi":
          "Korban kecelakaan masih menjadi penyumbang terbesar jumlah penyandang disabilitas di Indonesia.",
      "isi berita": """
Ketua Umum Perkumpulan Penyandang Disabilitas Indonesia (PPDI), Norman Yulian, menyampaikan bahwa korban kecelakaan, termasuk kecelakaan lalu lintas, menjadi salah satu penyumbang terbesar angka disabilitas di Indonesia. Saat ini, jumlah penyandang disabilitas di Indonesia mencapai lebih dari 10 juta orang.

Norman menekankan bahwa beban psikologis korban kecelakaan lebih berat dibanding penyandang disabilitas sejak lahir, karena mereka harus menyesuaikan diri dengan kondisi baru yang berbeda dari kehidupan sebelumnya.

Dalam kesempatan tersebut, para penyandang disabilitas korban kecelakaan menerima alat bantu dari Korps Lalu Lintas (Korlantas) Polri, yang bertujuan membantu mereka lebih mandiri dan meningkatkan kepercayaan diri saat kembali bermasyarakat.
Norman mendorong agar dukungan tidak berhenti pada alat bantu saja, tetapi juga disertai program lanjutan berupa pembinaan keterampilan dan pemberdayaan ekonomi, sehingga korban kecelakaan dapat memperoleh penghasilan tambahan dan kembali produktif.

""",
    },
    {
      "judul": "DPR Desak Pemerintah Perkuat Layanan Disabilitas",
      "logo berita": "assets/Icon/logoSB.png",
      "nama berita": "Sekitar Bandung.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B7.png",
      "deskripsi":
          "Pemerintah diminta memperkuat akses layanan pendidikan agar semua anak disabilitas dapat bersekolah tanpa diskriminasi.",
      "isi berita": """
Komisi X DPR RI mendesak pemerintah untuk memperkuat fungsi Unit Layanan Disabilitas (ULD) agar anak-anak penyandang disabilitas di Indonesia dapat mengakses pendidikan secara setara.
Ketua Komisi X DPR RI, Hetifah Sjaifudian, menegaskan bahwa pendidikan merupakan hak dasar seluruh warga negara, termasuk penyandang disabilitas.
"Pendidikan adalah hak dasar setiap warga negara, tanpa terkecuali bagi saudara-saudara kita penyandang disabilitas. Negara wajib menjamin akses pendidikan yang setara, bermutu, dan tanpa diskriminasi," ujar Hetifah dalam kegiatan Advokasi Optimalisasi Fungsi ULD Bidang Pendidikan yang digelar di Jakarta, Kamis (21/8/2025).

Selain itu, meskipun terdapat ribuan sekolah inklusif di Indonesia, baru sekitar 14,83 persen yang memiliki Guru Pembimbing Khusus (GPK) sebagai tenaga pendukung utama bagi siswa penyandang disabilitas.
"Keberadaan ULD sangat strategis sebagai jembatan yang memastikan peserta didik penyandang disabilitas memperoleh layanan pendidikan setara," jelas Hetifah.

Ia menegaskan, optimalisasi ULD tidak boleh sebatas formalitas. ULD harus benar-benar responsif, memiliki SDM terlatih, sarana prasarana yang ramah disabilitas, serta dukungan regulasi yang kuat.
"Unit ini harus berkelanjutan dan mampu menghapus hambatan yang dihadapi peserta didik disabilitas. Dengan begitu, ULD dapat menjadi motor penggerak inklusi, kesetaraan, dan keadilan dalam pendidikan," tambahnya.

Komisi X DPR RI berkomitmen mendorong pemerintah memperkuat peran ULD di seluruh daerah. Hetifah juga mengajak lembaga pendidikan dan masyarakat turut serta membangun ekosistem pendidikan inklusif.
"Semoga ikhtiar ini menjadi langkah nyata dalam menghadirkan layanan pendidikan yang lebih adil, inklusif, dan berkualitas bagi seluruh anak bangsa," pungkasnya.

""",
    },
    {
      "judul": "Komitmen Pemenuhan Hak Disabilitas dalam RKP 2025",
      "logo berita": "assets/Icon/logoTempo.png",
      "nama berita": "Tempo.com",
      "waktu": "2 Jam yang lalu",
      "gambar": "assets/images/B8.png",
      "deskripsi": "Komitmen Pemenuhan Hak Disabilitas dalam RKP 2025",
      "isi berita": """
Deputi Bidang Koordinasi Peningkatan Kualitas Keluarga dan Kependudukan Kementerian Koordinator Bidang Pembangunan Manusia dan Kebudayaan (Kemenko PMK) Woro Srihastuti Sulistyaningrum menegaskan, isu penyandang disabilitas adalah isu lintas sektor yang memerlukan perhatian komprehensif.

Hal tersebut disampaikannya dalam Rapat Koordinasi Monitoring dan Sinkronisasi Capaian Program RKP 2025 dan RENJA K/L Bidang Penyandang Disabilitas yang diselenggarakan secara daring, pada Kamis (13/3/2025).

"Pemerintah Indonesia terus berupaya memperkuat pemenuhan hak penyandang disabilitas melalui serangkaian kebijakan inklusif yang melibatkan berbagai sektor," ujar Deputi yang akrab disapa Lisa itu.

Deputi Lisa memaparkan, berdasarkan data REGSOSEK 2023, terdapat 4,3 juta penyandang disabilitas sedang hingga berat di Indonesia, dengan mayoritas berada pada kelompok usia dewasa dan lanjut usia. Ia menyampaikan, penyandang disabilitas dan keluarganya masih menghadapi keterbatasan akses terhadap layanan dasar, seperti pendidikan, kesehatan, dan ketenagakerjaan.

Salah satu tantangan utama dalam sektor pendidikan adalah rendahnya tingkat partisipasi penyandang disabilitas. Data Susenas Maret 2024 menunjukkan bahwa 17,2% penyandang disabilitas berusia 15 tahun ke atas tidak pernah bersekolah, dan hanya 4,24% yang berhasil mencapai pendidikan tinggi. 

Dari sisi kesehatan, Deputi Lisa mengungkapkan bahwa penyandang disabilitas cenderung memiliki akses yang lebih rendah terhadap jaminan kesehatan, baik dari pemerintah maupun swasta. Oleh karena itu, pemerintah akan terus mendorong penguatan layanan kesehatan yang ramah disabilitas.

Deputi Lisa menyampaikan, pemerintah telah menetapkan berbagai instrumen hukum untuk memastikan hak penyandang disabilitas terlindungi. Beberapa di antaranya adalah UU Nomor 8 Tahun 2016 tentang Penyandang Disabilitas, PP Nomor 70 Tahun 2019 tentang Perencanaan, Penyelenggaraan, dan Evaluasi terhadap Penghormatan, Pelindungan, dan Pemenuhan Hak Penyandang Disabilitas. Selain itu, terdapat Perpres Nomor 12 Tahun 2025 tentang RPJMN 2025-2029 juga menegaskan pentingnya koordinasi lintas kementerian dalam memastikan keberpihakan terhadap penyandang disabilitas.

Sebagai bagian dari Rencana Pembangunan Jangka Menengah Nasional (RPJMN) 2025-2029, Kemenko PMK diamanatkan untuk mendukung pencapaian sasaran pembangunan Prioritas Nasional IV, dengan fokus pada peningkatan mobilitas penyandang disabilitas. Targetnya adalah meningkatkan mobilitas dari 68,42% pada 2023 menjadi 69% pada 2025, dan mencapai 71% pada 2029.

Deputi Lisa juga menyoroti pentingnya sinergi antara pemerintah pusat dan daerah dalam menerapkan kebijakan inklusif. Pendekatan ini mencakup penyelarasan anggaran, integrasi program, serta peningkatan partisipasi penyandang disabilitas dalam proses perencanaan pembangunan.

"Kita perlu mendorong kemitraan dengan pemerintah daerah untuk memastikan kebijakan yang diterapkan sesuai dengan konteks lokal dan kebutuhan nyata penyandang disabilitas," tuturnya. 

Dalam Rencana Kerja Pemerintah (RKP) Tahun 2025, program peningkatan kesetaraan dan pemenuhan hak penyandang disabilitas akan difokuskan pada berbagai aspek, termasuk peningkatan akses terhadap pekerjaan, penguatan kapasitas penyandang disabilitas melalui pelatihan keterampilan, serta penyediaan infrastruktur yang ramah disabilitas. 

"Kolaborasi antar-kementerian harus terus diperkuat untuk memastikan bahwa alokasi dana dan program-program yang ada dapat saling melengkapi," kata Deputi Lisa.

Sebagai langkah konkret, pemerintah juga tengah menyusun Indeks Inklusivitas Penyandang Disabilitas sebagai alat ukur dalam mengevaluasi efektivitas kebijakan yang telah diterapkan. Indeks ini akan memastikan bahwa setiap kebijakan didasarkan pada data yang valid dan dapat dipertanggungjawabkan, sehingga intervensi yang dilakukan lebih tepat sasaran.

Deputi Lisa menutup paparannya dengan menegaskan bahwa inklusi penyandang disabilitas harus menjadi bagian integral dari pembangunan nasional. "Kita tidak bisa membangun bangsa ini dengan meninggalkan kelompok rentan. Oleh karena itu, kebijakan yang inklusif dan berkelanjutan harus terus diupayakan untuk mewujudkan kesejahteraan bagi seluruh warga negara," pungkasnya.

Rapat ini dihadiri oleh 14 K/L, antara lain Sesditjen Kemendiktisaintek, Direktur Pendidikan Khusus dan Pendidikan Layanan Khusus Kemendikdasmen, Kasub Direktorat Sosial dan Budaya Kemendagri, perwakilan dari Bappenas, Kemenkes, Kemensos, BKKBN, Kemenpora, KPPPA, Kemnaker, Kemendikdasmen, Kemenhub, Kemen PU, Kemenag, dan Komisi Nasional Disabilitas.

""",
    },
  ];

  @override
  void initState() {
    super.initState();

    // Ganti foto setiap 3 detik
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      setState(() {
        currentIndex = (currentIndex + 1) % images.length;
      });
    });
  }

  void nextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % images.length;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double buttonWidth = screenWidth * 0.3; // Semua kotak sama lebar
    double buttonHeight = screenHeight * 0.04; // Tinggi kotak sama

    List<Map<String, String>> filteredBerita = berita
        .where(
          (item) =>
              item["judul"]!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) &&
              item["deskripsi"]!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
        )
        .toList();
    List<Map<String, String>> filteredBerita1 = berita2
        .where(
          (item) =>
              item["judul"]!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) &&
              item["deskripsi"]!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
        )
        .toList();
    List<Map<String, String>> filteredArtikel = artikel
        .where(
          (item) =>
              item["judul"]!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              item["deskripsi"]!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.08,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFF1F4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText: "Cari sesuatu disini...",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      vertical:
                          MediaQuery.of(context).size.height *
                          (10 / MediaQuery.of(context).size.height),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            SizedBox(
              height: buttonHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.01,
                    ),
                    child: SizedBox(
                      width: buttonWidth,
                      height: buttonHeight,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.shade300,
                            width: screenWidth * 0.003,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                          ),
                        ),
                        child: Text(
                          items[index],
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: isSelected ? Colors.blue : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: nextImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Gambar background
                      Image.asset(
                        images[currentIndex],
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.5,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.62,
              ),
              child: Text(
                "Berita Isyarat",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              height: 200,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredBerita.length,
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02,
                ),
                itemBuilder: (context, index) {
                  final item = filteredBerita[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailBeritaPage(
                                judul: item["judul"]!,
                                logoBerita: item["logo berita"]!,
                                namaBerita: item["nama berita"]!,
                                waktu: item["waktu"]!,
                                gambar: item["gambar"]!,
                                deskripsi: item["isi berita"]!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.height * 0.28,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            item["gambar"]!,
                            width: MediaQuery.of(context).size.height * 0.28,
                            height: MediaQuery.of(context).size.height * 0.156,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        width:
                            MediaQuery.of(context).size.width *
                            0.6, // lebar sama dengan gambar
                        child: Text(
                          item["judul"]!,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 9,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign:
                              TextAlign.left, // atau center sesuai kebutuhan
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        width:
                            MediaQuery.of(context).size.width *
                            0.6, // lebar sama dengan gambar
                        child: Text(
                          item["deskripsi"]!,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 7,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign:
                              TextAlign.left, // atau center sesuai kebutuhan
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.62,
              ),
              child: Text(
                "Berita Terbaru",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              height: 200,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredBerita1.length,
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02,
                ),
                itemBuilder: (context, index) {
                  final item = filteredBerita1[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailBeritaPage(
                                judul: item["judul"]!,
                                logoBerita: item["logo berita"]!,
                                namaBerita: item["nama berita"]!,
                                waktu: item["waktu"]!,
                                gambar: item["gambar"]!,
                                deskripsi: item["isi berita"]!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.height * 0.28,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.asset(
                            item["gambar"]!,
                            width: MediaQuery.of(context).size.height * 0.28,
                            height: MediaQuery.of(context).size.height * 0.156,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        width:
                            MediaQuery.of(context).size.width *
                            0.6, // lebar sama dengan gambar
                        child: Text(
                          item["judul"]!,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 9,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign:
                              TextAlign.left, // atau center sesuai kebutuhan
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        width:
                            MediaQuery.of(context).size.width *
                            0.6, // lebar sama dengan gambar
                        child: Text(
                          item["deskripsi"]!,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 7,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign:
                              TextAlign.left, // atau center sesuai kebutuhan
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.62,
              ),
              child: Text(
                "Artikel Terbaru",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredArtikel.length,
              itemBuilder: (context, index) {
                final item = filteredArtikel[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: MediaQuery.of(context).size.width * 0.045,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded supaya teks fleksibel
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailBeritaPage(
                                  judul: item["judul"]!,
                                  logoBerita: item["logo berita"]!,
                                  namaBerita: item["nama berita"]!,
                                  waktu: item["waktu"]!,
                                  gambar: item["gambar"]!,
                                  deskripsi: item["isi berita"]!,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["judul"]!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item["deskripsi"]!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  color: const Color(0xFF878787),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),

                      // Gambar Artikel
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          item["gambar"]!,
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.width * 0.18,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
