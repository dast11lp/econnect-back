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

CREATE TABLE stories (
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

-- inserts


USE alumini;

INSERT IGNORE INTO administrators (name, email, password_hash, role, active) VALUES
('Camila Torres',     'camila.torres@generation.org',     '$2a$10$N9qo8uLOickgx2ZMRZoMy.example1hash', 'admin',  1),
('Andrés Gómez',      'andres.gomez@generation.org',      '$2a$10$N9qo8uLOickgx2ZMRZoMy.example2hash', 'editor', 1),
('Laura Jiménez',     'laura.jimenez@generation.org',     '$2a$10$N9qo8uLOickgx2ZMRZoMy.example3hash', 'editor', 1),
('Sebastián Rojas',   'sebastian.rojas@generation.org',   '$2a$10$N9qo8uLOickgx2ZMRZoMy.example4hash', 'editor', 1),
('Valentina Cruz',    'valentina.cruz@generation.org',    '$2a$10$N9qo8uLOickgx2ZMRZoMy.example5hash', 'editor', 0);

INSERT IGNORE INTO categories (name, description, active) VALUES
('Resume and CV',              'Plantillas y buenas prácticas para hojas de vida',        1),
('LinkedIn and Personal Brand','Cómo construir una marca profesional en LinkedIn',        1),
('Interview Preparation',      'Simulacros y guías para entrevistas técnicas y de valores',1),
('Networking',                 'Estrategias para construir red profesional',              1),
('English for Employability',  'Inglés enfocado en entrevistas y ambiente laboral',       1);

INSERT IGNORE INTO resource_types (name) VALUES
('PDF'), ('Video'), ('Template'), ('Link'), ('Guide');

INSERT IGNORE INTO learning_paths (name, description, active) VALUES
('Fullstack Java Development', 'Ruta de crecimiento para graduados bootcamp en Java',            1),
('Unity Developer',            'Ruta de crecimiento para graduados bootcamp en Unity',           1),
('IT Support',                 'Ruta de crecimiento para graduados bootcamp en IT Support',      1),
('Data Analysis',              'Ruta en Power BI, Python y estadística aplicada',                1),
('Frontend Development',       'Ruta de crecimiento para graduados enfocados en frontend web',   1);

INSERT IGNORE INTO job_boards (name, url, description, logo_url, active) VALUES
('LinkedIn',      'https://www.linkedin.com',      'Red profesional y bolsa de empleo global',            'https://cdn.example.com/logos/linkedin.png',   1),
('Computrabajo',  'https://www.computrabajo.com',  'Bolsa de empleo líder en Colombia',                   'https://cdn.example.com/logos/computrabajo.png',1),
('Magneto',       'https://www.magneto365.com',    'Bolsa de empleo y talento colombiano',                'https://cdn.example.com/logos/magneto.png',    1),
('elempleo',      'https://www.elempleo.com',      'Portal de empleo colombiano',                         'https://cdn.example.com/logos/elempleo.png',   1),
('Get on Board',  'https://www.getonbrd.com',      'Empleos tech y remotos en Latinoamérica',             'https://cdn.example.com/logos/getonbrd.png',   1);

INSERT INTO resources
    (title, description, category_id, type_id, section, url, duration_minutes, publication_date, featured, active, views, downloads, created_by)
VALUES
('Plantilla de hoja de vida ATS',
 'Plantilla editable optimizada para sistemas de selección automática (ATS).',
 (SELECT id FROM categories WHERE name = 'Resume and CV'),
 (SELECT id FROM resource_types WHERE name = 'Template'),
 'library', 'https://cdn.example.com/resources/plantilla-cv-ats.docx', NULL, '2024-02-10', 1, 1, 245, 132,
 (SELECT id FROM administrators WHERE email = 'camila.torres@generation.org')),

('Guía de optimización de perfil de LinkedIn',
 'Cómo estructurar el titular, extracto y experiencia para reclutadores.',
 (SELECT id FROM categories WHERE name = 'LinkedIn and Personal Brand'),
 (SELECT id FROM resource_types WHERE name = 'Guide'),
 'library', 'https://cdn.example.com/resources/guia-linkedin.pdf', NULL, '2024-03-05', 0, 1, 189, 98,
 (SELECT id FROM administrators WHERE email = 'andres.gomez@generation.org')),

('Simulación de entrevista técnica: Java',
 'Preguntas frecuentes y ejercicios de código para entrevistas junior.',
 (SELECT id FROM categories WHERE name = 'Interview Preparation'),
 (SELECT id FROM resource_types WHERE name = 'PDF'),
 'library', 'https://cdn.example.com/resources/entrevista-tecnica-java.pdf', NULL, '2024-04-01', 1, 1, 310, 201,
 (SELECT id FROM administrators WHERE email = 'laura.jimenez@generation.org')),

('Guest Talk: Cómo conseguí trabajo en una startup siendo junior',
 'Charla grabada con una graduada sobre su proceso de búsqueda de empleo.',
 (SELECT id FROM categories WHERE name = 'Networking'),
 (SELECT id FROM resource_types WHERE name = 'Video'),
 'recording', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 48, '2024-05-12', 1, 1, 421, 0,
 (SELECT id FROM administrators WHERE email = 'sebastian.rojas@generation.org')),

('Webinar: LinkedIn para graduados',
 'Sesión grabada sobre cómo construir perfil, red y búsqueda activa.',
 (SELECT id FROM categories WHERE name = 'LinkedIn and Personal Brand'),
 (SELECT id FROM resource_types WHERE name = 'Video'),
 'recording', 'https://www.linkedin.com/learning/webinar-graduados', 72, '2024-04-20', 0, 1, 156, 0,
 (SELECT id FROM administrators WHERE email = 'camila.torres@generation.org'));

INSERT INTO path_skills (path_id, skill_name, description, resource_id) VALUES
((SELECT id FROM learning_paths WHERE name = 'Fullstack Java Development'),
 'Fundamentos de Java y POO', 'Sintaxis, clases, herencia y polimorfismo', NULL),

((SELECT id FROM learning_paths WHERE name = 'Fullstack Java Development'),
 'Spring Boot y APIs REST', 'Construcción de servicios web con Spring Boot',
 (SELECT id FROM resources WHERE title = 'Simulación de entrevista técnica: Java')),

((SELECT id FROM learning_paths WHERE name = 'Unity Developer'),
 'C# y programación orientada a eventos', 'Scripting básico en Unity con C#', NULL),

((SELECT id FROM learning_paths WHERE name = 'Data Analysis'),
 'Power BI para reportes', 'Modelado de datos y dashboards en Power BI', NULL),

((SELECT id FROM learning_paths WHERE name = 'IT Support'),
 'Redes y soporte de infraestructura', 'Fundamentos de redes, hardware y mesa de ayuda', NULL);

INSERT INTO stories
    (alumni_name, program, photo_url, testimonial, trajectory, video_url, featured, active, publication_date, published_by)
VALUES
('Juan Rodríguez', 'IT Support',
 'https://randomuser.me/api/portraits/men/32.jpg',
 'La sección de Networking fue clave. Conecté con un reclutador y a las dos semanas tenía trabajo.',
 'Teleperformance · IT Support · 2 meses para conseguir empleo · 2023', NULL, 1, 1, '2023-11-15',
 (SELECT id FROM administrators WHERE email = 'camila.torres@generation.org')),

('María López', 'Fullstack Java Development',
 'https://randomuser.me/api/portraits/women/44.jpg',
 'Gracias a las simulaciones de entrevista conseguí mi primer empleo.',
 'Mercado Libre · Frontend Developer · 4 meses para conseguir empleo · 2024', NULL, 1, 1, '2024-02-20',
 (SELECT id FROM administrators WHERE email = 'andres.gomez@generation.org')),

('Diego Fernández', 'Data Analysis',
 'https://randomuser.me/api/portraits/men/51.jpg',
 'Pasé de no saber programar a trabajar como analista de datos en menos de un año.',
 'Rappi · Data Analyst · 6 meses para conseguir empleo · 2023', NULL, 0, 1, '2023-09-08',
 (SELECT id FROM administrators WHERE email = 'laura.jimenez@generation.org')),

('Andrea Salazar', 'Unity Developer',
 'https://randomuser.me/api/portraits/women/68.jpg',
 'El acompañamiento de mentores me ayudó a armar un portafolio que sí llamó la atención.',
 'Globant · Game Developer Jr. · 3 meses para conseguir empleo · 2024', 'https://www.youtube.com/watch?v=exampleAndrea', 1, 1, '2024-01-30',
 (SELECT id FROM administrators WHERE email = 'sebastian.rojas@generation.org')),

('Camilo Ortiz', 'IT Support',
 'https://randomuser.me/api/portraits/men/77.jpg',
 'Empecé sin experiencia previa en tecnología y hoy trabajo en soporte para una multinacional.',
 'Teleperformance · IT Support · 5 meses para conseguir empleo · 2022', NULL, 0, 1, '2022-12-01',
 (SELECT id FROM administrators WHERE email = 'valentina.cruz@generation.org'));

INSERT INTO interactions (resource_id, event_type, session_id, created_at) VALUES
((SELECT id FROM resources WHERE title = 'Plantilla de hoja de vida ATS'), 'view',     'sess-a1b2c3', '2024-05-01 09:15:00'),
((SELECT id FROM resources WHERE title = 'Plantilla de hoja de vida ATS'), 'download', 'sess-a1b2c3', '2024-05-01 09:16:20'),
((SELECT id FROM resources WHERE title = 'Guía de optimización de perfil de LinkedIn'), 'view', 'sess-d4e5f6', '2024-05-02 14:02:00'),
((SELECT id FROM resources WHERE title = 'Guest Talk: Cómo conseguí trabajo en una startup siendo junior'), 'view', 'sess-a1b2c3', '2024-05-03 20:45:10'),
((SELECT id FROM resources WHERE title = 'Simulación de entrevista técnica: Java'), 'download', 'sess-g7h8i9', '2024-05-04 11:30:00');

INSERT INTO uploaded_files (administrator_id, filename, storage_url, mime_type, size_bytes) VALUES
((SELECT id FROM administrators WHERE email = 'camila.torres@generation.org'),
 'plantilla-cv-ats.docx', 'https://cdn.example.com/uploads/plantilla-cv-ats.docx',
 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 84213),

((SELECT id FROM administrators WHERE email = 'andres.gomez@generation.org'),
 'guia-linkedin.pdf', 'https://cdn.example.com/uploads/guia-linkedin.pdf', 'application/pdf', 512400),

((SELECT id FROM administrators WHERE email = 'laura.jimenez@generation.org'),
 'entrevista-tecnica-java.pdf', 'https://cdn.example.com/uploads/entrevista-tecnica-java.pdf', 'application/pdf', 298110),

((SELECT id FROM administrators WHERE email = 'sebastian.rojas@generation.org'),
 'guest-talk-startup.mp4', 'https://res.cloudinary.com/dd9iztlrv/video/upload/guest-talk-startup.mp4', 'video/mp4', 154890342),

((SELECT id FROM administrators WHERE email = 'valentina.cruz@generation.org'),
 'foto-perfil-camilo.jpg', 'https://cdn.example.com/uploads/foto-perfil-camilo.jpg', 'image/jpeg', 204871);