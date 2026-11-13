# Tugas Rutin 2 - Kasir Console

Nama    :   Angelina S. Saragih
NIM     :   4243250049
Kelas   :   PSIK 24C

Program kasir sederhana berbasis console. Pengguna mengetik pesanan dalam satu baris(contoh P01x2, P05x1), lalu program mencetak struk.
 
## Cara Menjalankan
dart run bin/kasir.dart
(Harus lewat terminal, bukan DartPad, karena memakai stdin.readLineSync().)

## Fitur
- Katalog berupa Map kode -> record (nama, harga, kategori), 7 produk.
- Pesanan diurai dengan split, trim, dan int.tryParse.
- Kode yang salah atau jumlah yang tidak valid tidak bikin crash, hanya dimasukkan ke daftar "Diabaikan".
- Struk memakai map + fold untuk total, diskon 10% kalau total >= Rp100.000, dan Set untuk menampilkan kategori yang dibeli (tanpa duplikat).

## Skenario 1 - Total di bawah Rp100.000 (tanpa diskon)

Input: P02x1, P03x2

=== STRUK ===
Sirup Markisa             1 x     35000
Keripik Ubi Balado        2 x     50000
---------------------------------------
Total                             85000
Bayar                             85000

Kategori dibeli: Minuman, Makanan


## Skenario 2 - Dapat diskon + ada kode yang salah

Input: P01x2, P05x1, P09x3

=== STRUK ===
Kopi Sidikalang 250 g     2 x     90000
Bolu Meranti              1 x     80000
---------------------------------------
Total                            170000
Diskon 10%                        17000
Bayar                            153000

Kategori dibeli: Minuman, Kue
Diabaikan: P09x3

P09 tidak ada di katalog, jadi dilewati dan program tetap jalan.

## Penjelasan var / final / const
- var : variabel yang nilainya boleh diganti, tipenya ditebak dari nilai awal. Di program ini hampir tidak dipakai karena tidak ada nilai yang perlu diubah.
- final : diisi sekali saja, nilainya ditentukan saat program berjalan. Ini pilihan default saya, contohnya input, total, diskon, bayar, karena nilainya baru ketahuan setelah pengguna mengetik.
- const : nilainya sudah pasti sejak kompilasi. Saya pakai untuk batasDiskon, persenDiskon, dan katalog, karena isinya tetap. Kalau saya tulis const waktu = DateTime.now(); akan error karena waktunya baru diketahui saat program jalan.
- late tidak dipakai di tugas ini karena semua variabel langsung terisi.


## Penjelasan null safety

Di Dart, tipe tanpa ? (misal String) tidak boleh null. Tipe dengan ? (misal String?) boleh null, jadi harus dicek dulu sebelum dipakai.

Yang saya pakai di program ini:

- stdin.readLineSync() ?? '' : hasil readLineSync() bertipe String?, jadi kalau null diganti string kosong.
- int.tryParse(...) : mengembalikan null kalau teksnya bukan angka (misal P01xabc), lalu dicek jumlah == null supaya tidak crash. Kalau pakai int.parse program akan berhenti dengan exception.
- katalog.containsKey(kode) : akses Map dengan [] hasilnya nullable, jadi kode dicek dulu sebelum diambil.

Penggunaan tanda ! (null check operator):

dart
final produk = katalog[p.kode]!;

Ini satu-satunya ! di program saya. Alasannya aman: sebelum masuk daftar pesanan, setiap kode sudah dicek katalog.containsKey(kode), dan kode yang tidak ada langsung dilewati dengan continue. Jadi saat baris ini jalan, katalog[p.kode] pasti ada isinya dan tidak mungkin null.