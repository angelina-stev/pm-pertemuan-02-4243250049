import 'dart:io';

// nilainya sudah pasti dari awal, jadi pakai const
const int batasDiskon = 100000;
const int persenDiskon = 10;

// katalog: kode -> record (nama, harga, kategori)
const Map<String, ({String nama, int harga, String kategori})> katalog = {
  'P01': (nama: 'Kopi Sidikalang 250 g', harga: 45000, kategori: 'Minuman'),
  'P02': (nama: 'Sirup Markisa', harga: 35000, kategori: 'Minuman'),
  'P03': (nama: 'Keripik Ubi Balado', harga: 25000, kategori: 'Makanan'),
  'P04': (nama: 'Teri Medan 250 g', harga: 40000, kategori: 'Makanan'),
  'P05': (nama: 'Bolu Meranti', harga: 80000, kategori: 'Kue'),
  'P06': (nama: 'Pancake Durian', harga: 60000, kategori: 'Kue'),
  'P07': (nama: 'Kain Ulos Mini', harga: 150000, kategori: 'Kerajinan'),
};

void tampilkanKatalog() {
  print('=== KATALOG OLEH-OLEH MEDAN ===');
  print(
    '${'Kode'.padRight(6)}${'Nama'.padRight(24)}'
    '${'Kategori'.padRight(12)}${'Harga'.padLeft(7)}',
  );
  print('-' * 49);
  for (final e in katalog.entries) {
    final p = e.value;
    print(
      '${e.key.padRight(6)}${p.nama.padRight(24)}'
      '${p.kategori.padRight(12)}${p.harga.toString().padLeft(7)}',
    );
  }
}

void main() {
  tampilkanKatalog();
  print('');
  print(
    'Format pesanan: kode x jumlah, pisahkan dengan koma. Contoh: P01x2, P05x1',
  );
  stdout.write('Pesanan: ');

  // readLineSync() hasilnya String?, jadi dikasih ?? supaya tidak null
  final input = stdin.readLineSync() ?? '';

  final pesanan = <({String kode, int jumlah})>[];
  final diabaikan = <String>[];

  // urai satu baris pesanan
  for (final potongan in input.split(',')) {
    final teks = potongan.trim();
    if (teks.isEmpty) continue;

    final posisiX = teks.toLowerCase().indexOf('x');
    if (posisiX <= 0) {
      // tidak ada x, atau kodenya kosong
      diabaikan.add(teks);
      continue;
    }

    final kode = teks.substring(0, posisiX).trim().toUpperCase();
    final jumlah = int.tryParse(teks.substring(posisiX + 1).trim());

    // kode tidak ada di katalog / jumlah bukan angka / jumlah <= 0 -> dilewati
    if (!katalog.containsKey(kode) || jumlah == null || jumlah <= 0) {
      diabaikan.add(teks);
      continue;
    }

    pesanan.add((kode: kode, jumlah: jumlah));
  }

  if (pesanan.isEmpty) {
    print('\nTidak ada pesanan yang valid.');
    if (diabaikan.isNotEmpty) print('Diabaikan: ${diabaikan.join(', ')}');
    return;
  }

  // ambil data produk dari katalog.
  // tanda ! di sini aman karena kode sudah dicek containsKey() di atas,
  // jadi katalog[p.kode] pasti tidak null
  final item = pesanan.map((p) {
    final produk = katalog[p.kode]!;
    return (produk: produk, jumlah: p.jumlah);
  }).toList();

  final total = item
      .map((i) => i.produk.harga * i.jumlah)
      .fold<int>(0, (a, b) => a + b);
  final diskon = total >= batasDiskon ? total * persenDiskon ~/ 100 : 0;
  final bayar = total - diskon;
  final kategori = item.map((i) => i.produk.kategori).toSet();

  print('\n=== STRUK ===');
  for (final i in item) {
    final subtotal = i.produk.harga * i.jumlah;
    print(
      '${i.produk.nama.padRight(24)}'
      '${'${i.jumlah} x'.padLeft(5)}'
      '${subtotal.toString().padLeft(10)}',
    );
  }
  print('-' * 39);
  print('${'Total'.padRight(29)}${total.toString().padLeft(10)}');
  if (diskon > 0) {
    print(
      '${'Diskon $persenDiskon%'.padRight(29)}${diskon.toString().padLeft(10)}',
    );
  }
  print('${'Bayar'.padRight(29)}${bayar.toString().padLeft(10)}');
  print('\nKategori dibeli: ${kategori.join(', ')}');

  if (diabaikan.isNotEmpty) {
    print('Diabaikan: ${diabaikan.join(', ')}');
  }
}
