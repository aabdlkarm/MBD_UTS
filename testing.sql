-- 1. Membuat Schema
CREATE SCHEMA SALAM;

-- 2. Membuat Tabel dengan berbagai constraint
CREATE TABLE SALAM.mahasiswas (
    id_mahasiswa SERIAL,
    nim VARCHAR(15) PRIMARY KEY,                  -- PRIMARY KEY CONSTRAINT
    email VARCHAR(100) UNIQUE NOT NULL,           -- UNIQUE CONSTRAINT
    nama_lengkap VARCHAR(100) NOT NULL,
    ipk NUMERIC(3,2) CHECK (ipk >= 0.00 AND ipk <= 4.00), -- CHECK CONSTRAINT
    konsentrasi_studi VARCHAR(50) DEFAULT 'Umum'  -- FITUR PEMBEDA (Custom)
);

-- SKENARIO BERHASIL
INSERT INTO SALAM.mahasiswas (nim, email, nama_lengkap, ipk, konsentrasi_studi) 
VALUES ('123456', 'budi@kampus.com', 'Budi Santoso', 3.85, 'Data Science');

-- BUKTI GAGAL UNIQUE (Jalankan ini, akan muncul error duplicate key value pada email)
INSERT INTO SALAM.mahasiswas (nim, email, nama_lengkap, ipk) 
VALUES ('654321', 'budi@kampus.com', 'Budi Clone', 3.00); 

-- BUKTI GAGAL CHECK (Jalankan ini, akan muncul error check constraint karena IPK > 4)
INSERT INTO SALAM.mahasiswas (nim, email, nama_lengkap, ipk) 
VALUES ('111222', 'andi@kampus.com', 'Andi', 4.50);

-- Membuat User
CREATE USER backend_dev WITH PASSWORD 'backend123';
CREATE USER bi_dev WITH PASSWORD 'bi123';
CREATE USER data_engineer WITH PASSWORD 'de123';

-- Memberikan akses ke DB dan Schema
GRANT CONNECT ON DATABASE postgres TO backend_dev, bi_dev, data_engineer;
GRANT USAGE ON SCHEMA SALAM TO backend_dev, bi_dev, data_engineer;

-- 1. Role: backend_dev (CRUD Semua Table)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA SALAM TO backend_dev;

-- 2. Role: bi_dev (Hanya Read/Select)
GRANT SELECT ON ALL TABLES IN SCHEMA SALAM TO bi_dev;

-- 3. Role: data_engineer (CREATE, MODIFY, DROP Object & CRUD)
-- Memberikan hak owner pada schema agar bisa DDL (Create/Alter/Drop)
GRANT ALL PRIVILEGES ON SCHEMA SALAM TO data_engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA SALAM TO data_engineer;
ALTER SCHEMA SALAM OWNER TO data_engineer;