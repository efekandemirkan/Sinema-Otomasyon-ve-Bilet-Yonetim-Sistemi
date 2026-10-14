# 🎬 Sinema Otomasyonu ve Bilet Yönetim Sistemi

Modern sinema salonu işletmeciliği, vizyon takibi, seans yönetimi ve uçtan uca güvenli biletleme süreçlerini dijitalleştirmek amacıyla geliştirilmiş kapsamlı bir otomasyon sistemidir.

---

## 📌 Proje Genel Özeti

Bu sistem; sinema zincirleri, bağımsız salonlar ve izleyiciler arasındaki tüm operasyonel süreci tek bir platformda birleştirmektedir. Proje, sadece temel bir rezervasyon mekanizması sunmakla kalmayıp; 2D, 3D ve IMAX gibi farklı gösterim formatlarını, dinamik bilet fiyatlandırmalarını, özel gün kampanyalarını ve çakışma önleyici akıllı koltuk seçim mekanizmasını bünyesinde barındırır.

---

## ✨ Temel Özellikler

- **Film & Sanatçı Yönetimi:** Filmlerin tür, oyuncu kadrosu, yönetmen, vizyon tarihi, yaş sınırı ve süre bazında kataloglanması.
- **Sinema & Salon Altyapısı:** Çoklu sinema şubesi yönetimi, salon tipleri (VIP, Starium, IMAX vb.) ve salona özel dinamik koltuk konfigürasyonu (Normal, İkili, Engelli koltuklar).
- **Akıllı Seans & Fiyatlandırma Motoru:**
  - Seans bazlı format (2D/3D/IMAX), dublaj/altyazı dil seçimi.
  - Tarih, gün tipi (Hafta İçi, Çarşamba vb.) ve seyirci kategorisine (Tam, Öğrenci, Herkes) göre otomatik fiyat eşleştirme.
  - Özel kural motoru desteği (Örn: Paribu Cineverse Çarşamba Sinema Günü kampanyası).
- **Güvenli Bilet Satışı ve Koltuk Rezervasyonu:**
  - Aynı seanstaki aynı koltuğun birden fazla kişiye satılmasını engelleyen veri bütünlüğü koruması (`Filtered Unique Index`).
  - Bilet durum takibi (Aktif, İptal, İade).
- **Çoklu Sepet & Ödeme Entegrasyonu:** Tek bir ödeme işlemi üzerinden birden fazla bilet satın alabilme desteği (1-to-N ilişki).
- **Müşteri & Güvenlik:** Müşteri hesapları, güvenli parola hashleme ve işlem geçmişi takibi.

---

## 🗄️ Veritabanı Mimarisi

Sistem, 3. Normal Form (3NF) kurallarına ve yüksek veri tutarlılığı standartlarına uygun olarak tasarlanmış 15 ilişkisel tablodan oluşur:

| Modül | Tablolar |
| :--- | :--- |
| **Katalog & İçerik** | `FILMLER`, `TURLER`, `FILMTURLERI`, `OYUNCULAR`, `FILMOYUNCULAR`, `YONETMENLER`, `FILMYONETMENLER` |
| **Lokasyon & Kapasite** | `SINEMALAR`, `SALONLAR`, `KOLTUKLAR` |
| **Operasyon & Biletleme** | `SEANSLAR`, `BILETFIYATLARI`, `BILETLER` |
| **Kullanıcı & Finans** | `MUSTERILER`, `ODEMELER` |

### 🔑 Kritik İş Kuralları ve Mimarisi
- **Fiyat Tutarlılığı:** Seans tablosunda doğrudan fiyat tutulmaz; fiyatlar `BILETFIYATLARI` tablosundan dinamik olarak çekilir.
- **Filtered Unique Index:** `(SeansID, KoltukID)` benzersizlik kısıtı yalnızca `BiletDurumu = 'Aktif'` olan biletler için geçerlidir; böylece iptal veya iade edilen koltuklar tekrar satışa açılabilir.
- **Çarşamba Sinema Günü Kuralı:** Paribu Cineverse salonlarında her Çarşamba tüm izleyiciler için sabit kampanyalı fiyat uygulanır (resmi tatiller hariç).

---

## 🛠️ Kullanılan Teknolojiler (Tech Stack)

- **Veritabanı (DBMS):** Microsoft SQL Server
- **Backend:** Python
- **Frontend / Arayüz:** HTML5 / CSS / JavaScript
- **Versiyon Kontrolü:** Git & GitHub
