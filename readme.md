# Amedspor Mobil Uygulaması

Amedspor taraftarları için maç sonuçları, fikstür, kadro, istatistikler ve haberleri tek bir yerde sunan Flutter tabanlı mobil uygulama. Proje Riverpod durum yönetimi, Firebase altyapısı ve çeşitli futbol API'leri ile entegre olacak şekilde yapılandırılmıştır.

## Başlangıç

1. Gerekli Flutter SDK ve Firebase CLI kurulumlarını tamamlayın.
2. Bağımlılıkları yüklemek için `flutter pub get` komutunu çalıştırın.
3. `.env.example` dosyasını kopyalayarak `.env` oluşturun ve API anahtarlarını tanımlayın.
4. Firebase projelerini yapılandırın ve `google-services.json` / `GoogleService-Info.plist` dosyalarını ilgili platform dizinlerine ekleyin.

## Mimarİ

- `lib/core`: Sabitler, servisler, modeller ve yardımcı sınıflar.
- `lib/features`: Ekranlar, widget'lar ve sağlayıcılar gibi özellik tabanlı katman.
- `lib/shared`: Tema, ortak widget'lar gibi tekrar kullanılabilir bileşenler.

## Geliştirme

- Durum yönetimi için Riverpod kullanılmaktadır.
- API çağrıları `ApiService` üzerinden yapılır ve retry mekanizması ile sarılmıştır.
- Cache yapısı Hive ve SharedPreferences ile desteklenir.
- Bildirimler için Firebase Cloud Messaging, reklamlar için Google AdMob entegre edilmeye hazırdır.

## Test

Testleri çalıştırmak için:

```bash
flutter test
```

## Güvenlik

- Tüm API anahtarları `.env` dosyasında saklanır.
- `.env` dosyası `.gitignore` ile versiyon kontrolünün dışında tutulur.
