DROP DATABASE IF EXISTS alumini;
CREATE DATABASE alumini;
USE alumini;

CREATE TABLE administrators (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'editor',
    active TINYINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    active TINYINT NOT NULL DEFAULT 1
);

CREATE TABLE resource_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE resources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    category_id INT,
    type_id INT,
    section ENUM('library','recording') NOT NULL DEFAULT 'library',
    url VARCHAR(1000) NOT NULL,
    duration_minutes INT,
    publication_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    featured TINYINT NOT NULL DEFAULT 0,
    active TINYINT NOT NULL DEFAULT 1,
    views INT NOT NULL DEFAULT 0,
    downloads INT NOT NULL DEFAULT 0,
    created_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (type_id) REFERENCES resource_types(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES administrators(id) ON DELETE SET NULL
);

CREATE TABLE learning_paths (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    active TINYINT NOT NULL DEFAULT 1
);

CREATE TABLE path_skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    path_id INT NOT NULL,
    skill_name VARCHAR(150) NOT NULL,
    description TEXT,
    resource_id INT,
    FOREIGN KEY (path_id) REFERENCES learning_paths(id) ON DELETE CASCADE,
    FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE SET NULL
);

CREATE TABLE job_boards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    url VARCHAR(1000) NOT NULL,
    description TEXT,
    logo_url VARCHAR(1000),
    active TINYINT NOT NULL DEFAULT 1
);

CREATE TABLE success_stories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    alumni_name VARCHAR(150) NOT NULL,
    program VARCHAR(150),
    photo_url VARCHAR(1000),
    testimonial TEXT NOT NULL,
    trajectory TEXT,
    video_url VARCHAR(1000),
    featured TINYINT NOT NULL DEFAULT 0,
    active TINYINT NOT NULL DEFAULT 1,
    publication_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    published_by INT,
    FOREIGN KEY (published_by) REFERENCES administrators(id) ON DELETE SET NULL
);

CREATE TABLE interactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    resource_id INT,
    event_type ENUM('view','download') NOT NULL,
    session_id VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resource_id) REFERENCES resources(id) ON DELETE CASCADE
);

CREATE TABLE uploaded_files (
    id INT AUTO_INCREMENT PRIMARY KEY,
    administrator_id INT,
    filename VARCHAR(300),
    storage_url VARCHAR(2000) NOT NULL,
    mime_type VARCHAR(100),
    size_bytes BIGINT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (administrator_id) REFERENCES administrators(id) ON DELETE SET NULL
);