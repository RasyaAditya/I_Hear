import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:i_hear/Pages/Detail/DetailTempat.dart';
import 'package:i_hear/Pages/Home/IsyaratPintar.dart';
import 'package:i_hear/Pages/Home/Notifikasi.dart';
import 'package:i_hear/Pages/Home/OnBoardingAi.dart';
import 'package:i_hear/Pages/Home/SuaraTulis.dart';
import 'package:i_hear/Pages/Home/TerjemahKata.dart';
import '../Pages/Home/LensaIsyarat.dart';
import '../Pages/Detail/DetailBerita.dart';
import 'package:i_hear/Widgets/WidgetProfil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

// Import halaman artikel untuk navigasi
import 'WidgetArtikel.dart';

class WidgetHome extends StatefulWidget {
  final VoidCallback? onProfileTap;
  const WidgetHome({this.onProfileTap, super.key});

  @override
  State<WidgetHome> createState() => _WidgetHomeState();
}

class _WidgetHomeState extends State<WidgetHome> {
  int selectedIndex = 0;
  int currentIndex = 0;

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

  final List<Map<String, String>> tempat = [
    {
      "judul": "Sunyi Coffee - Taman Ayodia Barito",
      "instagram":
          "https://www.instagram.com/sunyicoffee?igsh=MXRodzc5NGxjNmp0NQ==",
      "maps": "https://maps.app.goo.gl/di4GaeVPdP8U4MmN9",
      "nama tempat": "Toko Kopi",
      "gambar": "assets/images/tmpt1.png",
      "deskripsi":
          "Sunyi Coffee, dipimpin oleh CEO Mario, memiliki visi yang kuat untuk memberdayakan penyandang disabilitas di Indonesia. Dalam wawancaranya baru-baru ini, Mario membahas konsep unik Sunyi Coffee yang bertujuan untuk menyetarakan penyandang disabilitas dan mengubah stigma terhadap mereka.\n\nKonsep bisnis sosial Sunyi Coffee bukan sekedar mencari keuntungan namun lebih pada pemberian kesempatan, edukasi, dan mengubah persepsi masyarakat terhadap disabilitas. Sunyi Coffee menunjukkan bahwa ukuran kesuksesan bisnis sebenarnya bukan hanya keuntungan, namun juga dampak sosialnya.",
    },
    {
      "judul": "Kopi Kamu Wijaya Jakarta Selatan",
      "instagram":
          "https://www.instagram.com/kopikamu_official?igsh=MXh6NjR5YW85YThidA==",
      "maps": "https://maps.app.goo.gl/7m4ybrYXCFwcins78",
      "nama tempat": "Toko Kopi",
      "gambar": "assets/images/tmpt2.png",
      "deskripsi":
          "Kafe di Jakarta Selatan ini punya program unik. Tidak hanya menyajikan minuman segar dan makanan enak, tetapi penyandang down syndrome juga dikaryakan di sini.Ketika datang ke kafe, banyak pelanggan yang berharap dilayani dengan cepat dan maksimal. Tetapi jika kamu memilih untuk datang ke kafe yang satu ini, harus menyiapkan kesabaran yang berbeda dari biasanya.\n\nKopi Kamu, yang salah satunya berada di Jakarta Selatan, memiliki konsep yang unik. Layaknya kafe yang memperkerjakan penyandang disabilitas lainnya. Bedanya di sini para penyandang down syndrome diajak berkarya bersama.",
    },
    {
      "judul": "Difabis Coffee And Tea",
      "instagram":
          "https://www.instagram.com/difabis?igsh=MW1uN3ZoZzdqbHZpcw==",
      "maps": "https://maps.app.goo.gl/1oCjLiLGezdVrmH29",
      "nama tempat": "Toko Kopi",
      "gambar": "assets/images/tmpt3.png",
      "deskripsi":
          "DIFABIS atau “Difabel Bisa” merupakan program pemberdayaan yang dilakukan oleh BAZNAS (BAZIS) Provinsi DKI Jakarta sebagai wadah inklusi bagi difabel untuk menciptakan kemandirian, kesejahteraan, dan mengembangkan diri dalam kesempatan dunia kerja.",
    },
    {
      "judul": "DignityKu",
      "instagram": "https://www.instagram.com/dignityku?igsh=dDhmZWk0cDQwYWp1",
      "maps": "https://maps.app.goo.gl/sJVVLArGPXNPNfWP9",
      "nama tempat": "Restoran",
      "gambar": "assets/images/tmpt4.png",
      "deskripsi":
          "DignityKu adalah restoran pertama di Indonesia yang semua pelayannya adalah penyandang disabilitas dan dilengkapi dengan kelas pelatihan. Restoran ini berada di Jalan Sepat No. 22, Jakarta Selatan.\n\nMenurut pendiri DignityKu, Hendra Warsita, socio enterprise ini menyediakan pelatihan barista dan memasak secara profesional bagi para penyandang disabilitas. Instruktur atau guru masaknya sendiri merupakan chef atau juru masak berpengalaman yang sudah bekerja di dunia food and beverage (F&B) selama 10 tahun.",
    },
    {
      "judul": "Difabis Coffee and Book",
      "instagram":
          "https://www.instagram.com/difabiscoffee?igsh=MTVwODR1MDc0dDQ5Zw==",
      "maps": "https://maps.app.goo.gl/Zr8SVN6HiJM61oCYA",
      "nama tempat": "Toko Kopi",
      "gambar": "assets/images/tmpt5.png",
      "deskripsi":
          "Kedai yang berada area Utara Pintu Barat Lobby Kantor Wali Kota Jakut ini, cocok untuk bersantai sejenak sambil menyeruput kopi atau teh dan menikmati cemilan ringan.\n\nSekilas, sajian dan suasana kedai ini memang tak jauh beda dengan kedai kopi kekinian lain. Yang membedakannya, juru saji dan barista di kedai ini adalah penyandang difabel.\n\nHaniyah, person in charge (PIC) atau penanggungjawab kedai Coffe dan Book Difabis mengatakan, empat barista di kedai ini merupakan tuna rungu dan tuna daksa yang sudah terlatih meracik kopi.",
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
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  final List<List<String>> texts = [
    [
      "Sulit berkomunikasi dengan orang lain?",
      "Sekarang lebih mudah dengan terjemahan instan!",
    ],
    [
      "Komunikasi lancar untuk semua!",
      "Pesan Sekarang, Nikmati Diskon Awal Tahun!",
    ],
    [
      "Bicara tanpa batas!",
      "Terjemahkan bahasa isyarat dan teks dengan mudah.",
    ],
  ];

  final List<String> iklanImages = [
    "assets/images/Iklan1.png",
    "assets/images/Iklan2.png",
    "assets/images/Iklan3.png",
  ];

  final User? user = FirebaseAuth.instance.currentUser;
  String? displayName;
  String? imageUrl;
  String? phoneNumber;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    final uid = user?.uid;
    if (uid == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          displayName = data["username"] ?? "Pengguna"; // ambil dari Firestore
          phoneNumber = data["phone"] ?? "-";
          imageUrl = data["imageUrl"] ?? null;

          // kalau ada imageUrl, simpan URL
          if (data["imageUrl"] != null &&
              data["imageUrl"].toString().isNotEmpty) {
            // simpan URL untuk ditampilkan via NetworkImage
            // kalau lokal
            // atau lebih aman: simpan ke variabel String urlImage
          }
        });
      } else {
        setState(() {
          displayName = user?.email ?? "Pengguna";
        });
      }
    } catch (e) {
      print("Error load profile: $e");
    }
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
    List<Map<String, String>> filteredBerita1 = tempat
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
      backgroundColor: const Color(0xFF5BC8FF),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                    left: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WidgetProfil()),
                      );
                      if (updated == true) {
                        _loadProfileData(); // refresh setelah edit
                      }
                    },
                    child: GestureDetector(
                      onTap: widget.onProfileTap,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            (imageUrl != null && imageUrl!.isNotEmpty)
                            ? NetworkImage(imageUrl!)
                            : AssetImage("assets/images/fotoProfil.png")
                                  as ImageProvider,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: Text(
                        "Selamat Datang",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      displayName ?? user?.email ?? " Pengguna",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                        left: MediaQuery.of(context).size.width * 0.05,
                      ),
                      onPressed: () {
                        Get.to(NotifikasiScreen());
                      },
                      icon: Image.asset(
                        "assets/Icon/NotifIcon.png",
                        height:
                            MediaQuery.of(context).size.height *
                            (20 / MediaQuery.of(context).size.height),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                      ),
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/Icon/Settings.png",
                        height:
                            MediaQuery.of(context).size.height *
                            (20 / MediaQuery.of(context).size.height),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height:
                          MediaQuery.of(context).size.height *
                          (100 / MediaQuery.of(context).size.height),
                      autoPlay: true,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.vertical,
                      autoPlayInterval: Duration(seconds: 3), // ganti jeda
                    ),
                    items: texts.map((text) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text[0],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              text[1],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.14,
                                  height:
                                      MediaQuery.of(context).size.width * 0.14,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffA1EEBD),
                                        Color(0xff48B570),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(50, 0, 0, 0),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Image.asset(
                                      "assets/Icon/translate.png",
                                      height:
                                          MediaQuery.of(context).size.width *
                                          0.13,
                                    ),
                                    onPressed: () {
                                      Get.to(VideoScreen());
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: Text(
                                    "Terjemah Kata",
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: Color(0xFF767676),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.14,
                                  height:
                                      MediaQuery.of(context).size.width * 0.14,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff7BD3EA),
                                        Color(0xff008FD8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(50, 0, 0, 0),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Image.asset(
                                      "assets/Icon/voice.png",
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.1,
                                    ),
                                    onPressed: () {
                                      Get.to(BasicBA());
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,
                                  child: Text(
                                    "Suara Tulis",
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: Color(0xFF767676),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.14,
                                  height:
                                      MediaQuery.of(context).size.width * 0.14,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffA1EEBD),
                                        Color(0xff48B570),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(50, 0, 0, 0),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Get.to(IsyaratPintar());
                                    },
                                    icon: Image.asset(
                                      "assets/Icon/abcd.png",
                                      height:
                                          MediaQuery.of(context).size.height *
                                          (70 /
                                              MediaQuery.of(
                                                context,
                                              ).size.height),
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,
                                  child: Text(
                                    "Isyarat Pintar",
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: Color(0xFF767676),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.14,
                                  height:
                                      MediaQuery.of(context).size.width * 0.14,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff7BD3EA),
                                        Color(0xff008FD8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(50, 0, 0, 0),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Get.to(QRScannerPage());
                                    },
                                    icon: Image.asset(
                                      "assets/Icon/bot.png",
                                      height:
                                          MediaQuery.of(context).size.height *
                                          (45 /
                                              MediaQuery.of(
                                                context,
                                              ).size.height),
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,
                                  child: Text(
                                    "Lensa Isyarat",
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      color: Color(0xFF767676),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.08,
                          decoration: BoxDecoration(
                            color: Color(0xff2F80ED),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.03,
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/Icon/botHome.png",
                                  height:
                                      MediaQuery.of(context).size.height *
                                      0.055,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.015,
                                    ),
                                    Text(
                                      "Halo, Aku Sapa ! ",
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.006,
                                    ),
                                    Text(
                                      "Jalani Hari-harimu bersama Sapa Bot.\nJadikan Sapa Bot teman bermainmu!",
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 7,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height *
                                      0.030,
                                  width:
                                      MediaQuery.of(context).size.width * 0.16,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Get.to(OnboardingScreen());
                                    },
                                    child: Text(
                                      "Coba",
                                      style: GoogleFonts.poppins(
                                        color: Colors.blue,
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      SizedBox(
                        height: 220,
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
                                    width:
                                        MediaQuery.of(context).size.height *
                                        0.28,
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      item["gambar"]!,
                                      width:
                                          MediaQuery.of(context).size.height *
                                          0.28,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.156,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    item["judul"]!,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 9,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
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

                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      CarouselSlider(
                        items: iklanImages.map((imgPath) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(imgPath, fit: BoxFit.cover),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.2,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          autoPlayInterval: Duration(seconds: 3),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Text(
                          "Rekomendasi Tempat Ramah Disabilitas",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
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
                                        builder: (context) => DetailTempatPage(
                                          namaTempat: item["judul"]!,
                                          kategori: item["nama tempat"]!,
                                          gambar: item["gambar"]!,
                                          deskripsi: item["deskripsi"]!,
                                          instagram: item["instagram"]!,
                                          maps: item["maps"]!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.height *
                                        0.28,
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      item["gambar"]!,
                                      width:
                                          MediaQuery.of(context).size.height *
                                          0.28,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.156,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    item["judul"]!,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Text(
                          "Jelajahi Tujuan Impian Anda dengan Aplikasi Kami",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                        ),
                        child: Text(
                          "Raih Tujuan Impian Anda dengan Aplikasi yang Mendukung Komunikasi\nuntuk Pengguna Tuli dan Bisu",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 8,
                              color: Color(0xFF878787),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      // --- AWAL BAGIAN YANG DIUBAH ---
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Artikel Terbaru",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // TextButton(
                            //   onPressed: () {
                            //     Get.to(() => WidgetArtikel());
                            //   },
                            //   child: Text(
                            //     "Lihat Semua",
                            //     style: GoogleFonts.poppins(
                            //       textStyle: const TextStyle(
                            //         fontSize: 12,
                            //         color: Colors.blue,
                            //         fontWeight: FontWeight.w600,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                      // --- AKHIR BAGIAN YANG DIUBAH ---
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredArtikel.length,
                        itemBuilder: (context, index) {
                          final item = filteredArtikel[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.045,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailBeritaPage(
                                                judul: item["judul"]!,
                                                logoBerita:
                                                    item["logo berita"]!,
                                                namaBerita:
                                                    item["nama berita"]!,
                                                waktu: item["waktu"]!,
                                                gambar: item["gambar"]!,
                                                deskripsi: item["isi berita"]!,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.height *
                                            0.01,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    item["gambar"]!,
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.25,
                                    height:
                                        MediaQuery.of(context).size.width *
                                        0.18,
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
                Positioned(
                  top: -20,
                  left: 8,
                  right: 8,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.08,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey, width: 0.5),
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Cari layanan, berita, komunitas...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
