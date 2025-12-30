-- fichier_insertion.sql
-- Insertion de données pour le système de gestion de bibliothèque

-- 1. Insertion des étudiants
INSERT INTO étudiant_ (e_ID, e_nom, e_prénom_, e_mail, téléphone_, date_inscription, filière_) VALUES
(1, 'Martin', 'Pierre', 'pierre.martin@email.com', '0612345678', '2023-09-15', 'Informatique'),
(2, 'Dubois', 'Marie', 'marie.dubois@email.com', '0623456789', '2023-09-20', 'Mathématiques'),
(3, 'Bernard', 'Jean', 'jean.bernard@email.com', '0634567890', '2023-10-05', 'Physique'),
(4, 'Thomas', 'Sophie', 'sophie.thomas@email.com', '0645678901', '2023-10-10', 'Chimie'),
(5, 'Petit', 'Lucas', 'lucas.petit@email.com', '0656789012', '2023-11-01', 'Biologie'),
(6, 'Robert', 'Emma', 'emma.robert@email.com', '0667890123', '2023-11-15', 'Informatique'),
(7, 'Richard', 'Hugo', 'hugo.richard@email.com', '0678901234', '2023-12-01', 'Mathématiques'),
(8, 'Durand', 'Alice', 'alice.durand@email.com', '0689012345', '2024-01-10', 'Physique');

-- 2. Insertion des catégories
INSERT INTO catégorie_ (ID_ca, libellé_) VALUES
('CAT001', 'Roman'),
('CAT002', 'Science-fiction'),
('CAT003', 'Fantasy'),
('CAT004', 'Policier'),
('CAT005', 'Biographie'),
('CAT006', 'Science'),
('CAT007', 'Histoire'),
('CAT008', 'Philosophie');

-- 3. Insertion des auteurs
INSERT INTO auteur (ID_auteur, nom_aut, prénom_aut, ville_aut) VALUES
('AUT001', 'Hugo', 'Victor', 'Paris'),
('AUT002', 'Zola', 'Émile', 'Paris'),
('AUT003', 'Verne', 'Jules', 'Nantes'),
('AUT004', 'Orwell', 'George', 'Londres'),
('AUT005', 'Tolkien', 'John', 'Oxford'),
('AUT006', 'Rowling', 'Joanne', 'Yate'),
('AUT007', 'Asimov', 'Isaac', 'New York'),
('AUT008', 'Hawking', 'Stephen', 'Oxford'),
('AUT009', 'de Saint-Exupéry', 'Antoine', 'Lyon'),
('AUT010', 'Camus', 'Albert', 'Alger');

-- 4. Insertion des livres
INSERT INTO Livres_ (l_ID, editeur, l_Titre, année_sortie, ISBN) VALUES
(1, 'Gallimard', 'Les Misérables', 1862, '978-2070109220'),
(2, 'Flammarion', 'Vingt mille lieues sous les mers', 1870, '978-2080700142'),
(3, 'Penguin Books', '1984', 1949, '978-0451524935'),
(4, 'Allen & Unwin', 'Le Seigneur des Anneaux', 1954, '978-2267025172'),
(5, 'Bloomsbury', 'Harry Potter à l école des sorciers', 1997, '978-2070584628'),
(6, 'Doubleday', 'Fondation', 1951, '978-0553293357'),
(7, 'Bantam Books', 'Une brève histoire du temps', 1988, '978-0553109535'),
(8, 'Gallimard', 'L Étranger', 1942, '978-2070360024'),
(9, 'Gallimard', 'Le Petit Prince', 1943, '978-2070612758'),
(10, 'Flammarion', 'Germinal', 1885, '978-2080701255');

-- 5. Insertion des exemplaires
INSERT INTO exemplaire_ (exe_ID, code_barre_, état_, l_ID) VALUES
(1, 'EX001001', 'Neuf', 1),
(2, 'EX001002', 'Bon', 1),
(3, 'EX002001', 'Bon', 2),
(4, 'EX002002', 'Moyen', 2),
(5, 'EX003001', 'Neuf', 3),
(6, 'EX004001', 'Bon', 4),
(7, 'EX005001', 'Neuf', 5),
(8, 'EX005002', 'Bon', 5),
(9, 'EX005003', 'Moyen', 5),
(10, 'EX006001', 'Bon', 6),
(11, 'EX007001', 'Neuf', 7),
(12, 'EX008001', 'Bon', 8),
(13, 'EX009001', 'Neuf', 9),
(14, 'EX010001', 'Bon', 10),
(15, 'EX010002', 'Moyen', 10);

-- 6. Insertion des relations écrire_ (livres-auteurs)
INSERT INTO écrire_ (l_ID, ID_auteur, rôle_, ordre) VALUES
(1, 'AUT001', 'Auteur principal', 1),
(2, 'AUT003', 'Auteur principal', 1),
(3, 'AUT004', 'Auteur principal', 1),
(4, 'AUT005', 'Auteur principal', 1),
(5, 'AUT006', 'Auteur principal', 1),
(6, 'AUT007', 'Auteur principal', 1),
(7, 'AUT008', 'Auteur principal', 1),
(8, 'AUT010', 'Auteur principal', 1),
(9, 'AUT009', 'Auteur principal', 1),
(10, 'AUT002', 'Auteur principal', 1);

-- 7. Insertion des relations classer (livres-catégories)
INSERT INTO classer (l_ID, ID_ca) VALUES
(1, 'CAT001'), -- Les Misérables -> Roman
(1, 'CAT007'), -- Les Misérables -> Histoire
(2, 'CAT002'), -- Vingt mille lieues -> Science-fiction
(2, 'CAT006'), -- Vingt mille lieues -> Science
(3, 'CAT002'), -- 1984 -> Science-fiction
(4, 'CAT003'), -- Le Seigneur des Anneaux -> Fantasy
(5, 'CAT003'), -- Harry Potter -> Fantasy
(6, 'CAT002'), -- Fondation -> Science-fiction
(7, 'CAT006'), -- Une brève histoire du temps -> Science
(8, 'CAT001'), -- L Étranger -> Roman
(8, 'CAT008'), -- L Étranger -> Philosophie
(9, 'CAT001'), -- Le Petit Prince -> Roman
(10, 'CAT001'); -- Germinal -> Roman

-- 8. Insertion des emprunts
INSERT INTO emprunts_ (ID_emprunt, date_emprunt, date_retour_prévu_, e_ID, statut, exe_ID, date_retour_effect) VALUES
('EMP001', '2024-01-15', '2024-02-15', 1, 'Retourné', 1, '2024-02-10'),
('EMP002', '2024-01-20', '2024-02-20', 2, 'Retourné', 3, '2024-02-18'),
('EMP003', '2024-02-01', '2024-03-01', 3, 'En retard', 6, NULL),
('EMP004', '2024-02-05', '2024-03-05', 4, 'En cours', 7, NULL),
('EMP005', '2024-02-10', '2024-03-10', 5, 'Retourné', 10, '2024-03-05'),
('EMP006', '2024-02-15', '2024-03-15', 6, 'En cours', 11, NULL),
('EMP007', '2024-02-20', '2024-03-20', 7, 'Retourné', 13, '2024-03-15'),
('EMP008', '2024-03-01', '2024-03-31', 8, 'En cours', 14, NULL),
('EMP009', '2024-03-05', '2024-04-05', 1, 'En cours', 5, NULL),
('EMP010', '2024-03-10', '2024-04-10', 2, 'En cours', 8, NULL);

-- 9. Insertion des amendes
INSERT INTO amende (ID_am, ID_emprunt, montant, statut, date_amende) VALUES
('AM001', 'EMP003', 5.50, 'Impayée', '2024-03-05'),
('AM002', 'EMP001', 2.00, 'Payée', '2024-02-12'),
('AM003', 'EMP007', 3.00, 'Payée', '2024-03-20');

-- 10. Mise à jour des emprunts avec les IDs d'amende
UPDATE emprunts_ SET ID_am = 'AM001' WHERE ID_emprunt = 'EMP003';
UPDATE emprunts_ SET ID_am = 'AM002' WHERE ID_emprunt = 'EMP001';
UPDATE emprunts_ SET ID_am = 'AM003' WHERE ID_emprunt = 'EMP007';

-- Affichage des comptes
SELECT 'Insertion terminée.' AS Status;
SELECT 'Étudiants: ' || COUNT(*) FROM étudiant_ UNION ALL
SELECT 'Livres: ' || COUNT(*) FROM Livres_ UNION ALL
SELECT 'Exemplaires: ' || COUNT(*) FROM exemplaire_ UNION ALL
SELECT 'Emprunts: ' || COUNT(*) FROM emprunts_ UNION ALL
SELECT 'Amendes: ' || COUNT(*) FROM amende;