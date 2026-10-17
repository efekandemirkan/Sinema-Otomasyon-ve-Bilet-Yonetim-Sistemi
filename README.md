# 🎬 Sinema Otomasyonu ve Bilet Yönetim Sistemi

Modern sinema salonu işletmeciliği, vizyon takibi, seans yönetimi ve uçtan uca güvenli biletleme süreçlerini dijitalleştirmek amacıyla geliştirilmiş kapsamlı bir otomasyon sistemidir.

---

## 📌 Proje Genel Özeti

Bu sistem; sinema zincirleri, bağımsız salonlar ve izleyiciler arasındaki tüm operasyonel süreci tek bir platformda birleştirmektedir. Proje, sadece temel bir rezervasyon mekanizması sunmakla kalmayıp; 2D, 3D ve Gold Class gibi farklı gösterim formatlarını, dinamik bilet fiyatlandırmalarını, özel gün kampanyalarını ve çakışma önleyici akıllı koltuk seçim mekanizmasını bünyesinde barındırır.

---

## ✨ Temel Özellikler

- **Film & Sanatçı Yönetimi:** Filmlerin tür, oyuncu kadrosu, yönetmen, vizyon tarihi, yaş sınırı ve süre bazında kataloglanması.
- **Sinema & Salon Altyapısı:** Çoklu sinema şubesi yönetimi, salon tipleri (2D, 3D, Gold Class) ve salona özel dinamik koltuk konfigürasyonu (Normal, Engelli koltuklar).
- **Akıllı Seans & Dinamik Fiyatlandırma Motoru:**
  - Seans bazlı format (2D/3D/Gold Class) ve dublaj/altyazı dil seçimi.
  - Tarih, gün tipi (Normal, Çarşamba vb.) ve seyirci kategorisine (Tam, Öğrenci, Herkes) göre bilet fiyatlarının dinamik eşleştirilmesi.
  - Özel kampanya kural motoru desteği (Örn: Paribu Cineverse Çarşamba Sinema Günü sabit fiyat uygulaması).
- **Güvenli Koltuk Rezervasyonu ve Bilet Satışı (Double Booking Koruması):**
  - **5 Dakikalık Geçici Kilitleme (Seat Hold):** Kullanıcı koltuğu seçip ödeme adımına geçtiğinde koltuk 5 dakika boyunca o kullanıcı adına rezerve edilir; başka kullanıcıların aynı koltuğu seçmesi engellenir.
  - **Zaman Aşımı Yönetimi:** 5 dakika içinde ödemesi tamamlanmayan koltuklar otomatik olarak serbest bırakılır ve yeniden satışa açılır.
  - **Filtered Unique Index:** Veritabanı motoru düzeyinde `(SeansID, KoltukID)` benzersizlik kontrolü uygulanarak aynı koltuğun birden fazla kişiye satılması kesin olarak önlenir.
  - **Genişletilmiş Durum Takibi:** Biletler `Rezerve`, `Aktif`, `Iptal` ve `Iade` yaşam döngüsüyle izlenir.
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
