# Amedspor Mobil Uygulaması

Bu depo, Amedspor taraftarları için maç sonuçları, fikstür, kadro, istatistikler ve haberleri tek noktada toplayan Flutter tabanlı mobil uygulamanın başlangıç iskeletini içerir. Uygulama; Riverpod durum yönetimi, Supabase destekli Premium+ veri akışları, Firebase servisleri, Firebase Cloud Messaging bildirimleri ve Google AdMob reklamları ile entegre olacak şekilde kurgulanmıştır.

## Mimarinin Özeti

- **Framework:** Flutter (Dart 3)
- **Durum Yönetimi:** Riverpod
- **Ağ İstekleri:** Dio
- **Backend:** Firebase (Firestore, Functions, Realtime Database) + Supabase (Premium+ üyelikleri ve canlı veri yayınları)
- **Cache & Offline:** Hive + SharedPreferences
- **Bildirimler:** Firebase Cloud Messaging
- **Reklamlar:** Google AdMob
- **Görsel Önbellekleme:** CachedNetworkImage

`lib/` klasöründe temel olarak `core`, `features` ve `shared` katmanları bulunur:

- `core`: Sabitler, modeller, servisler ve yardımcı sınıflar
- `features`: Her modül (maçlar, kadro, istatistikler, haberler, fikstür vb.) için ekranlar, sağlayıcılar ve widget'lar
- `shared`: Uygulama genelinde kullanılan temalar ve ortak widget'lar

## Kurulum

1. [Flutter](https://docs.flutter.dev/get-started/install) SDK'sını kurun.
2. Depodaki bağımlılıkları yükleyin:

   ```bash
   flutter pub get
   ```

3. Firebase, Supabase ve ilgili API anahtarlarını `.env` dosyasında tanımlayın. Örnek dosya: `.env.example`.
4. Gerekli Firebase projelerini ve Google AdMob kimliklerini yapılandırın.

## Çalıştırma

```bash
flutter run
```

## Katmanlar

- **Maçlar:** Yaklaşan, geçmiş ve canlı maçlar sekmeli yapı ile listelenir. Canlı maç ekranı 30 saniyede bir otomatik güncellenir.
- **Kadro:** Oyuncular pozisyon bazlı gruplandırılır; oyuncu detay ekranında performans istatistikleri sunulur.
- **Haberler:** NewsAPI ve YouTube özet videolarını listeler, bağlantılar tarayıcıda açılır.
- **İstatistikler:** Form grafiği, gol krallığı ve kart dökümleri görüntülenir.
- **Fikstür:** İç saha/deplasman filtrelemesi yapılabilen sezon listesi yer alır.

## Premium+ Deneyimi

- Supabase tabanlı üyelik kontrolü ile canlı taktik analizleri, xG metrikleri ve özel video içerikleri sunulur.
- Uygulama içi Premium ekranı modern cam efektiyle tasarlanmıştır ve kullanıcılar 3 günlük deneme ile kilit açabilir.
- Maç detay ekranlarında Premium kullanıcılar için ek veri panelleri gösterilir; üyelik olmayanlara modern paywall bileşeni sunulur.

## Kod Kalitesi

- `analysis_options.yaml` ile `very_good_analysis` kuralları uygulanır.
- Tüm API çağrıları için hata yakalama ve tekrar deneme mekanizması bulunan `ApiService` kullanılır.

## Lisans

Bu proje yalnızca örnek amaçlıdır.
