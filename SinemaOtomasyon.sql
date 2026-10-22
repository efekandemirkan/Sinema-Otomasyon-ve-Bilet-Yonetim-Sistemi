CREATE DATABASE SinemaOtomasyonDB;
GO

USE SinemaOtomasyonDB;
GO

CREATE TABLE Turler (
    TurID       INT IDENTITY(1,1) NOT NULL,
    TurAdi      NVARCHAR(50) NOT NULL,
    Aciklama    NVARCHAR(200) NULL,
    AktifMi     BIT NOT NULL DEFAULT (1),
    PRIMARY KEY (TurID),
    UNIQUE (TurAdi)
);
GO

CREATE TABLE Filmler (
    FilmID       INT IDENTITY(1,1) NOT NULL,
    FilmAdi      NVARCHAR(200) NOT NULL,
    OrijinalAdi  NVARCHAR(200) NULL,
    Aciklama     NVARCHAR(MAX) NULL,
    Sure         INT NOT NULL, 
    VizyonTarihi DATE NOT NULL,
    YasSiniri    NVARCHAR(10) NOT NULL, 
    Dil          NVARCHAR(50) NOT NULL,
    PosterURL    NVARCHAR(500) NULL,
    AktifMi      BIT NOT NULL DEFAULT (1),
    PRIMARY KEY (FilmID),
    CHECK (Sure > 0)
);
GO

CREATE TABLE FilmTurleri (
    FilmID INT NOT NULL,
    TurID  INT NOT NULL,
    PRIMARY KEY (FilmID, TurID),
    FOREIGN KEY (FilmID) REFERENCES Filmler (FilmID) ON DELETE CASCADE,
    FOREIGN KEY (TurID)  REFERENCES Turler (TurID) ON DELETE CASCADE
);
GO

CREATE TABLE Oyuncular (
    OyuncuID    INT IDENTITY(1,1) NOT NULL,
    Ad          NVARCHAR(100) NOT NULL,
    Soyad       NVARCHAR(100) NOT NULL,
    DogumTarihi DATE NULL,
    Uyruk       NVARCHAR(50) NULL,
    AktifMi     BIT NOT NULL DEFAULT (1),
    PRIMARY KEY (OyuncuID)
);
GO

CREATE TABLE FilmOyuncular (
    FilmID      INT NOT NULL,
    OyuncuID    INT NOT NULL,
    KarakterAdi NVARCHAR(100) NULL,
    PRIMARY KEY (FilmID, OyuncuID),
    FOREIGN KEY (FilmID) REFERENCES Filmler (FilmID) ON DELETE CASCADE,
    FOREIGN KEY (OyuncuID) REFERENCES Oyuncular (OyuncuID) ON DELETE CASCADE
);
GO

CREATE TABLE Yonetmenler (
    YonetmenID  INT IDENTITY(1,1) NOT NULL,
    Ad          NVARCHAR(100) NOT NULL,
    Soyad       NVARCHAR(100) NOT NULL,
    DogumTarihi DATE NULL,
    Uyruk       NVARCHAR(50) NULL,
    AktifMi     BIT NOT NULL DEFAULT (1),
    PRIMARY KEY (YonetmenID)
);
GO

CREATE TABLE FilmYonetmenler (
    FilmID     INT NOT NULL,
    YonetmenID INT NOT NULL,
    PRIMARY KEY (FilmID, YonetmenID),
    FOREIGN KEY (FilmID) REFERENCES Filmler (FilmID) ON DELETE CASCADE,
    FOREIGN KEY (YonetmenID) REFERENCES Yonetmenler (YonetmenID) ON DELETE CASCADE
);
GO

CREATE TABLE Sinemalar (
    SinemaID  INT IDENTITY(1,1) NOT NULL,
    SinemaAdi NVARCHAR(200) NOT NULL,
    Adres     NVARCHAR(300) NOT NULL,
    Il        NVARCHAR(50) NOT NULL,
    Ilce      NVARCHAR(50) NOT NULL,
    Sirket    NVARCHAR(100) NOT NULL,
    AktifMi   BIT NOT NULL DEFAULT (1),
    PRIMARY KEY (SinemaID)
);
GO

CREATE TABLE Salonlar (
    SalonID   INT IDENTITY(1,1) NOT NULL,
    SinemaID  INT NOT NULL,
    SalonAdi  NVARCHAR(50) NOT NULL,
    SalonTipi NVARCHAR(50) NOT NULL, -- Örn: Standart, Gold Class
    Kapasite  INT NOT NULL,
    AktifMi   BIT NOT NULL DEFAULT (1),
    PRIMARY KEY (SalonID),
    FOREIGN KEY (SinemaID) REFERENCES Sinemalar (SinemaID),
    CHECK (Kapasite > 0)
);
GO

CREATE TABLE Koltuklar (
    KoltukID   INT IDENTITY(1,1) NOT NULL,
    SalonID    INT NOT NULL,
    SiraNo     NVARCHAR(5) NOT NULL, -- Örn: A, B, C
    KoltukNo   NVARCHAR(5) NOT NULL, -- Örn: 1, 2, 3
    KoltukTipi NVARCHAR(20) NOT NULL DEFAULT (N'Normal'),
    AktifMi    BIT NOT NULL DEFAULT (1),
    PRIMARY KEY (KoltukID),
    FOREIGN KEY (SalonID) REFERENCES Salonlar (SalonID) ON DELETE CASCADE,
    UNIQUE (SalonID, SiraNo, KoltukNo),
    CHECK (KoltukTipi IN (N'Normal', N'İkili', N'Ikili', N'Engelli'))
);
GO

CREATE TABLE BiletFiyatlari (
    FiyatID         INT IDENTITY(1,1) NOT NULL,
    SinemaID        INT NOT NULL,
    BiletTipi       NVARCHAR(20) NOT NULL, -- Tam, Öğrenci, Herkes
    Format          NVARCHAR(20) NOT NULL, -- 2D, 3D, Gold Class
    GunTipi         NVARCHAR(20) NOT NULL, -- Normal, Çarşamba
    Fiyat           DECIMAL(10,2) NOT NULL,
    BaslangicTarihi DATE NOT NULL,
    BitisTarihi     DATE NULL,
    AktifMi         BIT NOT NULL DEFAULT (1),
    PRIMARY KEY (FiyatID),
    FOREIGN KEY (SinemaID) REFERENCES Sinemalar (SinemaID),
    CHECK (Fiyat >= 0),
    CHECK (BiletTipi IN (N'Tam', N'Öğrenci', N'Ogrenci', N'Herkes')),
    CHECK (Format IN (N'2D', N'3D', N'Gold Class')),
    CHECK (GunTipi IN (N'Normal', N'Çarşamba', N'Carsamba')),
    CHECK (BitisTarihi IS NULL OR BitisTarihi >= BaslangicTarihi)
);
GO

CREATE TABLE Seanslar (
    SeansID INT IDENTITY(1,1) NOT NULL,
    FilmID  INT NOT NULL,
    SalonID INT NOT NULL,
    Tarih   DATE NOT NULL,
    Saat    TIME(0) NOT NULL,
    Format  NVARCHAR(20) NOT NULL, -- 2D, 3D, Gold ClasS
    Dil     NVARCHAR(20) NOT NULL, -- Türkçe Dublaj, Altyazılı
    AktifMi BIT NOT NULL DEFAULT (1),
    PRIMARY KEY (SeansID),
    FOREIGN KEY (FilmID) REFERENCES Filmler (FilmID),
    FOREIGN KEY (SalonID) REFERENCES Salonlar (SalonID),
    CHECK (Format IN (N'2D', N'3D', N'Gold Class'))
);
GO

CREATE TABLE Musteriler (
    MusteriID   INT IDENTITY(1,1) NOT NULL,
    Ad          NVARCHAR(100) NOT NULL,
    Soyad       NVARCHAR(100) NOT NULL,
    Email       NVARCHAR(100) NOT NULL,
    Telefon     NVARCHAR(20) NULL,
    SifreHash   NVARCHAR(255) NOT NULL,
    KayitTarihi DATETIME NOT NULL DEFAULT (GETDATE()),
    AktifMi     BIT NOT NULL DEFAULT (1),
    PRIMARY KEY (MusteriID),
    UNIQUE (Email)
);
GO

CREATE TABLE Odemeler (
    OdemeID      INT IDENTITY(1,1) NOT NULL,
    OdemeTarihi  DATETIME NOT NULL DEFAULT (GETDATE()),
    Tutar        DECIMAL(10,2) NOT NULL,
    OdemeYontemi NVARCHAR(50) NOT NULL, -- Kredi Kartı, Banka Kartı, Nakit
    OdemeDurumu  NVARCHAR(20) NOT NULL DEFAULT (N'Basarili'),
    IslemNo      NVARCHAR(100) NULL,
    Aciklama     NVARCHAR(200) NULL,
    PRIMARY KEY (OdemeID),
    CHECK (Tutar >= 0),
    CHECK (OdemeDurumu IN (N'Basarili', N'Başarılı', N'Iptal', N'İptal', N'Iade', N'İade'))
);
GO

CREATE TABLE Biletler (
    BiletID            INT IDENTITY(1,1) NOT NULL,
    MusteriID          INT NOT NULL,
    SeansID            INT NOT NULL,
    KoltukID           INT NOT NULL,
    OdemeID            INT NULL, -- Ödeme tamamlanana kadar (geçici rezervasyon esnasında) NULL kalabilir
    BiletTipi          NVARCHAR(20) NOT NULL,
    UygulananFiyat     DECIMAL(10,2) NOT NULL,
    SatinAlmaTarihi    DATETIME NOT NULL DEFAULT (GETDATE()),
    RezerveBitisTarihi DATETIME NULL,
    BiletDurumu        NVARCHAR(20) NOT NULL DEFAULT (N'Aktif'),
    PRIMARY KEY (BiletID),
    FOREIGN KEY (MusteriID) REFERENCES Musteriler (MusteriID),
    FOREIGN KEY (SeansID) REFERENCES Seanslar (SeansID),
    FOREIGN KEY (KoltukID) REFERENCES Koltuklar (KoltukID),
    FOREIGN KEY (OdemeID) REFERENCES Odemeler (OdemeID),
    CHECK (UygulananFiyat >= 0),
    CHECK (BiletTipi IN (N'Tam', N'Öğrenci', N'Ogrenci', N'Herkes')),
    CHECK (BiletDurumu IN (N'Aktif', N'Rezerve', N'Iptal', N'İptal', N'Iade', N'İade'))
);
GO

-- INDEXES
CREATE UNIQUE NONCLUSTERED INDEX UQ_Biletler_Seans_Koltuk_Kilit
ON Biletler (SeansID, KoltukID)
WHERE BiletDurumu IN (N'Aktif', N'Rezerve');
GO

CREATE NONCLUSTERED INDEX IX_Seanslar_Tarih_FilmID ON Seanslar (Tarih, FilmID);
CREATE NONCLUSTERED INDEX IX_Biletler_MusteriID ON Biletler (MusteriID);
CREATE NONCLUSTERED INDEX IX_Biletler_OdemeID ON Biletler (OdemeID);
GO

-- TRIGGERS
CREATE OR ALTER TRIGGER TRG_Biletler_SalonKoltukKontrol
ON Biletler
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted I
        INNER JOIN Seanslar S  ON I.SeansID  = S.SeansID
        INNER JOIN Koltuklar K ON I.KoltukID = K.KoltukID
        WHERE S.SalonID <> K.SalonID
    )
    BEGIN
        RAISERROR (N'HATA: Seçilen koltuk bu seansın oynadığı salona ait değildir!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE OR ALTER TRIGGER TRG_Odemeler_DurumSenkron
ON Odemeler
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(OdemeDurumu)
    BEGIN
        UPDATE B
        SET 
            B.BiletDurumu        = I.OdemeDurumu,
            B.RezerveBitisTarihi = NULL
        FROM Biletler B
        INNER JOIN inserted I ON B.OdemeID = I.OdemeID
        WHERE I.OdemeDurumu IN (N'Iptal', N'İptal', N'Iade', N'İade');
    END
END;
GO

-- VIEWS
CREATE OR ALTER VIEW vw_SinemaSalonOzet
AS
SELECT 
    SN.SinemaID,
    SN.SinemaAdi,
    SN.Sirket,
    SN.Il,
    SN.Ilce,
    COUNT(SL.SalonID) AS SalonSayisi
FROM Sinemalar SN
LEFT JOIN Salonlar SL ON SN.SinemaID = SL.SinemaID AND SL.AktifMi = 1
WHERE SN.AktifMi = 1
GROUP BY SN.SinemaID, SN.SinemaAdi, SN.Sirket, SN.Il, SN.Ilce;
GO

-- ARAYÜZDE KOLTUKLARI BOŞ / REZERVE / DOLU GÖSTEREN VIEW
CREATE OR ALTER VIEW vw_SeansKoltukDurumu
AS
SELECT 
    SE.SeansID,
    K.KoltukID,
    K.SiraNo,
    K.KoltukNo,
    K.KoltukTipi,
    CASE 
        WHEN B.BiletDurumu = N'Aktif' THEN N'Dolu'
        WHEN B.BiletDurumu = N'Rezerve' AND B.RezerveBitisTarihi > GETDATE() THEN N'Rezerve'
        ELSE N'Bos' -- Kayıt yoksa, Iptal/Iade ise veya 5 dk süresi dolmuşsa KOLTUK BOŞTUR!
    END AS KoltukDurumu
FROM Seanslar SE
INNER JOIN Koltuklar K ON SE.SalonID = K.SalonID AND K.AktifMi = 1
LEFT JOIN Biletler B   ON SE.SeansID = B.SeansID 
                      AND K.KoltukID = B.KoltukID 
                      AND B.BiletDurumu IN (N'Aktif', N'Rezerve');
GO

-- 5 DAKİKA İÇİNDE ÖDEME YAPILINCA BİLETİ 'AKTİF' (SATILDI) YAPAN PROCEDURE
CREATE OR ALTER PROCEDURE sp_OdemeYapVeBiletOnayla
    @MusteriID    INT,
    @SeansID      INT,
    @OdemeYontemi NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Önce 5 dakikası dolmuş olanları iptal et (Boşa çıkar)
        UPDATE Biletler
        SET BiletDurumu = N'Iptal', RezerveBitisTarihi = NULL
        WHERE BiletDurumu = N'Rezerve' AND RezerveBitisTarihi <= GETDATE();

        -- 2. Müşterinin süresi geçmemiş Rezerve biletlerinin toplam tutarını bul
        DECLARE @ToplamTutar DECIMAL(10,2);
        SELECT @ToplamTutar = SUM(UygulananFiyat)
        FROM Biletler WITH (UPDLOCK)
        WHERE MusteriID = @MusteriID AND SeansID = @SeansID AND BiletDurumu = N'Rezerve';

        IF @ToplamTutar IS NULL
        BEGIN
            RAISERROR (N'HATA: 5 dakikalık rezervasyon süreniz dolmuş veya seçili koltuk bulunamadı!', 16, 1);
        END

        -- 3. Ödemeyi kaydet (1 Ödeme -> N Bilet)
        INSERT INTO Odemeler (Tutar, OdemeYontemi, OdemeDurumu)
        VALUES (@ToplamTutar, @OdemeYontemi, N'Basarili');

        DECLARE @YeniOdemeID INT = SCOPE_IDENTITY();

        -- 4. Biletleri 'Rezerve' durumundan 'Aktif' (Kesin Satış) durumuna geçir
        UPDATE Biletler
        SET 
            OdemeID            = @YeniOdemeID,
            BiletDurumu        = N'Aktif',
            SatinAlmaTarihi    = GETDATE(),
            RezerveBitisTarihi = NULL
        WHERE MusteriID = @MusteriID AND SeansID = @SeansID AND BiletDurumu = N'Rezerve';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- PROCEDURE (5 DK REZERVASYON VE ÇARŞAMBA KURALI)
CREATE OR ALTER PROCEDURE sp_KoltukRezerveEt
    @MusteriID INT,
    @SeansID   INT,
    @KoltukID  INT,
    @BiletTipi NVARCHAR(20) -- 'Tam' veya 'Öğrenci'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Süresi (5 dk) dolmuş geçici rezervasyonları temizle (Koltuklar boşa çıkar)
        UPDATE Biletler
        SET BiletDurumu = N'Iptal', RezerveBitisTarihi = NULL
        WHERE SeansID = @SeansID AND BiletDurumu = N'Rezerve' AND RezerveBitisTarihi <= GETDATE();

        -- 2. Koltuğun gerçekten boşta olup olmadığını eşzamanlı kilit (UPDLOCK) ile kontrol et
        IF EXISTS (
            SELECT 1 FROM Biletler WITH (UPDLOCK, HOLDLOCK)
            WHERE SeansID = @SeansID AND KoltukID = @KoltukID AND BiletDurumu IN (N'Aktif', N'Rezerve')
        )
        BEGIN
            RAISERROR (N'HATA: Seçilen koltuk şu anda dolu veya başka bir kullanıcı tarafından rezerve edilmiştir!', 16, 1);
        END

        -- 3. Seansın sinema, şirket, tarih ve format bilgilerini al
        DECLARE @SinemaID INT, @Sirket NVARCHAR(100), @Tarih DATE, @Format NVARCHAR(20), @Fiyat DECIMAL(10,2);

        SELECT 
            @SinemaID = SL.SinemaID,
            @Sirket   = SN.Sirket,
            @Tarih    = SE.Tarih,
            @Format   = SE.Format
        FROM Seanslar SE
        INNER JOIN Salonlar SL  ON SE.SalonID  = SL.SalonID
        INNER JOIN Sinemalar SN ON SL.SinemaID = SN.SinemaID
        WHERE SE.SeansID = @SeansID AND SE.AktifMi = 1;

        IF @SinemaID IS NULL
        BEGIN
            RAISERROR (N'HATA: Geçerli veya aktif bir seans bulunamadı!', 16, 1);
        END

        -- 4. Fiyatı belirle (1900-01-03 Çarşambadır; DATEDIFF % 7 = 0 ise gün Çarşambadır)
        IF (DATEDIFF(DAY, '19000103', @Tarih) % 7 = 0) AND (@Sirket = N'Paribu Cineverse')
        BEGIN
            -- Çarşamba Sinema Günü Kuralı (BiletTipi = 'Herkes', GunTipi = 'Çarşamba')
            SELECT TOP 1 @Fiyat = Fiyat 
            FROM BiletFiyatlari
            WHERE SinemaID = @SinemaID 
              AND Format = @Format 
              AND GunTipi IN (N'Çarşamba', N'Carsamba') 
              AND BiletTipi = N'Herkes' 
              AND AktifMi = 1
              AND @Tarih >= BaslangicTarihi 
              AND (BitisTarihi IS NULL OR @Tarih <= BitisTarihi)
            ORDER BY BaslangicTarihi DESC;
        END

        -- Çarşamba değilse veya kampanya fiyatı tanımlanmamışsa Normal tarifeyi al
        IF @Fiyat IS NULL
        BEGIN
            SELECT TOP 1 @Fiyat = Fiyat 
            FROM BiletFiyatlari
            WHERE SinemaID = @SinemaID 
              AND Format = @Format 
              AND GunTipi = N'Normal' 
              AND BiletTipi = @BiletTipi 
              AND AktifMi = 1
              AND @Tarih >= BaslangicTarihi 
              AND (BitisTarihi IS NULL OR @Tarih <= BitisTarihi)
            ORDER BY BaslangicTarihi DESC;
        END

        IF @Fiyat IS NULL
        BEGIN
            RAISERROR (N'HATA: Bu seans ve bilet tipi için tanımlı aktif bir fiyat tarifesi bulunamadı!', 16, 1);
        END

        -- 5. Koltuğu 5 dakikalığına kullanıcıya Rezerve et
        INSERT INTO Biletler (
            MusteriID, SeansID, KoltukID, OdemeID, 
            BiletTipi, UygulananFiyat, SatinAlmaTarihi, RezerveBitisTarihi, BiletDurumu
        )
        VALUES (
            @MusteriID, @SeansID, @KoltukID, NULL, 
            @BiletTipi, ISNULL(@Fiyat, 0), GETDATE(), DATEADD(MINUTE, 5, GETDATE()), N'Rezerve'
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO