
-- ---------------------------------------------------------------------
-- 1. REQUÊTES DE BASE - CONSULTATION DES TABLES
-- ---------------------------------------------------------------------
USE bibliotheque_universitaire;
-- 1.1 Liste complète des étudiants
SELECT e_ID AS "ID", 
       e_nom AS "Nom", 
       e_prénom_ AS "Prénom", 
       e_mail AS "Email", 
       téléphone_ AS "Téléphone", 
       date_inscription AS "Inscription", 
       filière_ AS "Filière"
FROM étudiant_
ORDER BY e_nom, e_prénom_;

-- 1.2 Liste complète des livres avec leurs auteurs
SELECT l.l_ID AS "ID Livre",
       l.l_Titre AS "Titre",
       l.editeur AS "Éditeur",
       l.année_sortie AS "Année",
       GROUP_CONCAT(CONCAT(a.prénom_aut, ' ', a.nom_aut) SEPARATOR ', ') AS "Auteur(s)"
FROM Livres_ l
LEFT JOIN écrire_ e ON l.l_ID = e.l_ID
LEFT JOIN auteur a ON e.ID_auteur = a.ID_auteur
GROUP BY l.l_ID, l.l_Titre, l.editeur, l.année_sortie
ORDER BY l.l_Titre;

-- 1.3 Liste des exemplaires avec état et livre associé
SELECT e.exe_ID AS "ID Exemplaire",
       e.code_barre_ AS "Code barre",
       e.état_ AS "État",
       l.l_Titre AS "Titre du livre"
FROM exemplaire_ e
JOIN Livres_ l ON e.l_ID = l.l_ID
ORDER BY l.l_Titre, e.exe_ID;

-- ---------------------------------------------------------------------
-- 2. REQUÊTES AVANCÉES - FONCTIONNALITÉS DU SYSTÈME
-- ---------------------------------------------------------------------

-- 2.1 Livres actuellement disponibles (non empruntés)
-- Note: Un livre est disponible si aucun de ses exemplaires n'est actuellement emprunté (statut 'En cours' ou 'En retard')
SELECT DISTINCT l.l_ID AS "ID Livre",
       l.l_Titre AS "Titre",
       l.editeur AS "Éditeur",
       COUNT(DISTINCT ex.exe_ID) AS "Nombre d'exemplaires",
       SUM(CASE WHEN ex.exe_ID NOT IN (
           SELECT exe_ID 
           FROM emprunts_ 
           WHERE statut IN ('En cours', 'En retard')
       ) THEN 1 ELSE 0 END) AS "Exemplaires disponibles"
FROM Livres_ l
JOIN exemplaire_ ex ON l.l_ID = ex.l_ID
GROUP BY l.l_ID, l.l_Titre, l.editeur
HAVING SUM(CASE WHEN ex.exe_ID NOT IN (
    SELECT exe_ID 
    FROM emprunts_ 
    WHERE statut IN ('En cours', 'En retard')
) THEN 1 ELSE 0 END) > 0
ORDER BY l.l_Titre;

-- 2.2 Étudiants ayant emprunté le plus d'ouvrages (top 5)
SELECT e.e_ID AS "ID Étudiant",
       CONCAT(e.e_nom, ' ', e.e_prénom_) AS "Étudiant",
       e.filière_ AS "Filière",
       COUNT(emp.ID_emprunt) AS "Nombre d'emprunts",
       COUNT(DISTINCT emp.exe_ID) AS "Livres différents empruntés"
FROM étudiant_ e
LEFT JOIN emprunts_ emp ON e.e_ID = emp.e_ID
GROUP BY e.e_ID, e.e_nom, e.e_prénom_, e.filière_
ORDER BY COUNT(emp.ID_emprunt) DESC
LIMIT 5;

-- 2.3 Titres les plus populaires (les plus empruntés)
SELECT l.l_ID AS "ID Livre",
       l.l_Titre AS "Titre",
       COUNT(emp.ID_emprunt) AS "Nombre d'emprunts",
       COUNT(DISTINCT emp.e_ID) AS "Nombre d'emprunteurs différents"
FROM Livres_ l
JOIN exemplaire_ ex ON l.l_ID = ex.l_ID
LEFT JOIN emprunts_ emp ON ex.exe_ID = emp.exe_ID
GROUP BY l.l_ID, l.l_Titre
ORDER BY COUNT(emp.ID_emprunt) DESC
LIMIT 10;

-- 2.4 Calcul automatique des pénalités de retard
-- Montant forfaitaire de 0.50€ par jour de retard
SELECT emp.ID_emprunt AS "ID Emprunt",
       emp.date_emprunt AS "Date emprunt",
       emp.date_retour_prévu_ AS "Retour prévu",
       CURDATE() AS "Date du jour",
       DATEDIFF(CURDATE(), emp.date_retour_prévu_) AS "Jours de retard",
       (DATEDIFF(CURDATE(), emp.date_retour_prévu_) * 0.50) AS "Amende calculée",
       CONCAT(et.e_nom, ' ', et.e_prénom_) AS "Étudiant",
       l.l_Titre AS "Livre emprunté"
FROM emprunts_ emp
JOIN étudiant_ et ON emp.e_ID = et.e_ID
JOIN exemplaire_ ex ON emp.exe_ID = ex.exe_ID
JOIN Livres_ l ON ex.l_ID = l.l_ID
WHERE emp.statut = 'En retard'
  AND emp.date_retour_effect IS NULL
  AND DATEDIFF(CURDATE(), emp.date_retour_prévu_) > 0;

-- 2.5 Détail des amendes avec informations étudiant et emprunt
SELECT a.ID_am AS "ID Amende",
       a.montant AS "Montant",
       a.statut AS "Statut paiement",
       a.date_amende AS "Date amende",
       CONCAT(e.e_nom, ' ', e.e_prénom_) AS "Étudiant",
       emp.ID_emprunt AS "ID Emprunt",
       l.l_Titre AS "Livre",
       emp.date_emprunt AS "Date emprunt",
       emp.date_retour_prévu_ AS "Retour prévu"
FROM amende a
JOIN emprunts_ emp ON a.ID_emprunt = emp.ID_emprunt
JOIN étudiant_ e ON emp.e_ID = e.e_ID
JOIN exemplaire_ ex ON emp.exe_ID = ex.exe_ID
JOIN Livres_ l ON ex.l_ID = l.l_ID
ORDER BY a.date_amende DESC;

-- 2.6 Recherche de livres par catégorie
SELECT c.libellé_ AS "Catégorie",
       l.l_Titre AS "Titre",
       GROUP_CONCAT(CONCAT(a.prénom_aut, ' ', a.nom_aut) SEPARATOR ', ') AS "Auteur(s)",
       l.editeur AS "Éditeur",
       l.année_sortie AS "Année"
FROM catégorie_ c
JOIN classer cl ON c.ID_ca = cl.ID_ca
JOIN Livres_ l ON cl.l_ID = l.l_ID
LEFT JOIN écrire_ ec ON l.l_ID = ec.l_ID
LEFT JOIN auteur a ON ec.ID_auteur = a.ID_auteur
WHERE c.libellé_ = 'Science-fiction'  -- Changer la catégorie selon besoin
GROUP BY c.libellé_, l.l_ID, l.l_Titre, l.editeur, l.année_sortie
ORDER BY l.l_Titre;

-- 2.7 Statistiques par filière
SELECT e.filière_ AS "Filière",
       COUNT(DISTINCT e.e_ID) AS "Nombre d'étudiants",
       COUNT(DISTINCT emp.ID_emprunt) AS "Nombre total d'emprunts",
       ROUND(AVG(DATEDIFF(emp.date_retour_effect, emp.date_emprunt)), 1) AS "Durée moyenne emprunt (jours)",
       COUNT(DISTINCT a.ID_am) AS "Nombre d'amendes"
FROM étudiant_ e
LEFT JOIN emprunts_ emp ON e.e_ID = emp.e_ID
LEFT JOIN amende a ON emp.ID_emprunt = a.ID_emprunt
GROUP BY e.filière_
ORDER BY COUNT(DISTINCT emp.ID_emprunt) DESC;

-- 2.8 Liste des emprunts en cours avec date de retour prévue
SELECT emp.ID_emprunt AS "ID Emprunt",
       CONCAT(e.e_nom, ' ', e.e_prénom_) AS "Étudiant",
       e.filière_ AS "Filière",
       l.l_Titre AS "Livre",
       emp.date_emprunt AS "Date emprunt",
       emp.date_retour_prévu_ AS "Retour prévu",
       DATEDIFF(emp.date_retour_prévu_, CURDATE()) AS "Jours restants",
       emp.statut AS "Statut"
FROM emprunts_ emp
JOIN étudiant_ e ON emp.e_ID = e.e_ID
JOIN exemplaire_ ex ON emp.exe_ID = ex.exe_ID
JOIN Livres_ l ON ex.l_ID = l.l_ID
WHERE emp.statut IN ('En cours', 'En retard')
  AND emp.date_retour_effect IS NULL
ORDER BY emp.date_retour_prévu_ ASC;

-- 2.9 Livres écrits par un auteur spécifique
SELECT CONCAT(a.prénom_aut, ' ', a.nom_aut) AS "Auteur",
       a.ville_aut AS "Ville",
       l.l_Titre AS "Titre",
       l.editeur AS "Éditeur",
       l.année_sortie AS "Année",
       GROUP_CONCAT(DISTINCT c.libellé_ SEPARATOR ', ') AS "Catégories"
FROM auteur a
JOIN écrire_ ec ON a.ID_auteur = ec.ID_auteur
JOIN Livres_ l ON ec.l_ID = l.l_ID
LEFT JOIN classer cl ON l.l_ID = cl.l_ID
LEFT JOIN catégorie_ c ON cl.ID_ca = c.ID_ca
WHERE a.nom_aut = 'Hugo'  -- Changer l'auteur selon besoin
GROUP BY a.ID_auteur, a.prénom_aut, a.nom_aut, a.ville_aut, l.l_ID, l.l_Titre, l.editeur, l.année_sortie
ORDER BY l.année_sortie;

-- 2.10 Statistiques mensuelles des emprunts
SELECT DATE_FORMAT(date_emprunt, '%Y-%m') AS "Mois",
       COUNT(*) AS "Nombre d'emprunts",
       COUNT(DISTINCT e_ID) AS "Nombre d'emprunteurs différents",
       COUNT(DISTINCT exe_ID) AS "Nombre d'exemplaires différents"
FROM emprunts_
GROUP BY DATE_FORMAT(date_emprunt, '%Y-%m')
ORDER BY DATE_FORMAT(date_emprunt, '%Y-%m') DESC;

-- ---------------------------------------------------------------------
-- 3. REQUÊTES COMPLEXES - ANALYSES APPROFONDIES
-- ---------------------------------------------------------------------

-- 3.1 Étudiants avec retard de retour (plus de 30 jours)
SELECT CONCAT(e.e_nom, ' ', e.e_prénom_) AS "Étudiant",
       e.e_mail AS "Email",
       e.téléphone_ AS "Téléphone",
       COUNT(emp.ID_emprunt) AS "Nombre de retards",
       MAX(DATEDIFF(COALESCE(emp.date_retour_effect, CURDATE()), emp.date_retour_prévu_)) AS "Retard maximum (jours)",
       SUM(a.montant) AS "Total amendes dues"
FROM étudiant_ e
JOIN emprunts_ emp ON e.e_ID = emp.e_ID
LEFT JOIN amende a ON emp.ID_emprunt = a.ID_emprunt AND a.statut = 'Impayée'
WHERE emp.statut = 'En retard'
   OR (emp.date_retour_effect IS NOT NULL 
       AND emp.date_retour_effect > emp.date_retour_prévu_)
GROUP BY e.e_ID, e.e_nom, e.e_prénom_, e.e_mail, e.téléphone_
HAVING COUNT(emp.ID_emprunt) > 0
ORDER BY COUNT(emp.ID_emprunt) DESC;

-- 3.2 Livres jamais empruntés
SELECT l.l_ID AS "ID Livre",
       l.l_Titre AS "Titre",
       l.editeur AS "Éditeur",
       l.année_sortie AS "Année",
       COUNT(ex.exe_ID) AS "Nombre d'exemplaires",
       GROUP_CONCAT(DISTINCT c.libellé_ SEPARATOR ', ') AS "Catégories"
FROM Livres_ l
JOIN exemplaire_ ex ON l.l_ID = ex.l_ID
LEFT JOIN emprunts_ emp ON ex.exe_ID = emp.exe_ID
LEFT JOIN classer cl ON l.l_ID = cl.l_ID
LEFT JOIN catégorie_ c ON cl.ID_ca = c.ID_ca
WHERE emp.ID_emprunt IS NULL
GROUP BY l.l_ID, l.l_Titre, l.editeur, l.année_sortie
ORDER BY l.l_Titre;

-- 3.3 Performance des exemplaires (les plus utilisés)
SELECT ex.exe_ID AS "ID Exemplaire",
       l.l_Titre AS "Titre",
       ex.état_ AS "État actuel",
       COUNT(emp.ID_emprunt) AS "Nombre d'emprunts",
       MIN(emp.date_emprunt) AS "Premier emprunt",
       MAX(emp.date_emprunt) AS "Dernier emprunt"
FROM exemplaire_ ex
JOIN Livres_ l ON ex.l_ID = l.l_ID
LEFT JOIN emprunts_ emp ON ex.exe_ID = emp.exe_ID
GROUP BY ex.exe_ID, l.l_Titre, ex.état_
ORDER BY COUNT(emp.ID_emprunt) DESC
LIMIT 10;

-- 3.4 Recommandations de livres basées sur les catégories populaires par filière
SELECT e.filière_ AS "Filière",
       c.libellé_ AS "Catégorie populaire",
       COUNT(DISTINCT emp.ID_emprunt) AS "Nombre d'emprunts",
       GROUP_CONCAT(DISTINCT l.l_Titre SEPARATOR '; ') AS "Livres empruntés"
FROM étudiant_ e
JOIN emprunts_ emp ON e.e_ID = emp.e_ID
JOIN exemplaire_ ex ON emp.exe_ID = ex.exe_ID
JOIN Livres_ l ON ex.l_ID = l.l_ID
JOIN classer cl ON l.l_ID = cl.l_ID
JOIN catégorie_ c ON cl.ID_ca = c.ID_ca
GROUP BY e.filière_, c.libellé_
HAVING COUNT(DISTINCT emp.ID_emprunt) >= 2
ORDER BY e.filière_, COUNT(DISTINCT emp.ID_emprunt) DESC;

-- ---------------------------------------------------------------------
-- 4. VUES POUR FACILITER LES REQUÊTES FRÉQUENTES
-- ---------------------------------------------------------------------

-- 4.1 Vue: Livres disponibles avec détails
CREATE OR REPLACE VIEW vue_livres_disponibles AS
SELECT l.l_ID,
       l.l_Titre,
       l.editeur,
       l.année_sortie,
       GROUP_CONCAT(DISTINCT CONCAT(a.prénom_aut, ' ', a.nom_aut) SEPARATOR ', ') AS auteurs,
       GROUP_CONCAT(DISTINCT c.libellé_ SEPARATOR ', ') AS categories,
       COUNT(DISTINCT ex.exe_ID) AS total_exemplaires,
       COUNT(DISTINCT CASE WHEN ex.exe_ID NOT IN (
           SELECT exe_ID 
           FROM emprunts_ 
           WHERE statut IN ('En cours', 'En retard')
       ) THEN ex.exe_ID END) AS exemplaires_disponibles
FROM Livres_ l
LEFT JOIN écrire_ ec ON l.l_ID = ec.l_ID
LEFT JOIN auteur a ON ec.ID_auteur = a.ID_auteur
LEFT JOIN classer cl ON l.l_ID = cl.l_ID
LEFT JOIN catégorie_ c ON cl.ID_ca = c.ID_ca
LEFT JOIN exemplaire_ ex ON l.l_ID = ex.l_ID
GROUP BY l.l_ID, l.l_Titre, l.editeur, l.année_sortie
HAVING exemplaires_disponibles > 0;

-- 4.2 Vue: Statistiques étudiantes
CREATE OR REPLACE VIEW vue_statistiques_etudiants AS
SELECT e.e_ID,
       CONCAT(e.e_nom, ' ', e.e_prénom_) AS nom_complet,
       e.filière_,
       e.date_inscription,
       COUNT(DISTINCT emp.ID_emprunt) AS total_emprunts,
       COUNT(DISTINCT CASE WHEN emp.statut = 'En retard' THEN emp.ID_emprunt END) AS emprunts_en_retard,
       COUNT(DISTINCT a.ID_am) AS total_amendes,
       SUM(CASE WHEN a.statut = 'Impayée' THEN a.montant ELSE 0 END) AS amendes_impayees
FROM étudiant_ e
LEFT JOIN emprunts_ emp ON e.e_ID = emp.e_ID
LEFT JOIN amende a ON emp.ID_emprunt = a.ID_emprunt
GROUP BY e.e_ID, e.e_nom, e.e_prénom_, e.filière_, e.date_inscription;

-- 4.3 Vue: Emprunts en cours détaillés
CREATE OR REPLACE VIEW vue_emprunts_en_cours AS
SELECT emp.ID_emprunt,
       CONCAT(e.e_nom, ' ', e.e_prénom_) AS etudiant,
       e.e_mail,
       e.téléphone_,
       l.l_Titre,
       ex.code_barre_,
       emp.date_emprunt,
       emp.date_retour_prévu_,
       emp.statut,
       DATEDIFF(CURDATE(), emp.date_retour_prévu_) AS jours_retard,
       (DATEDIFF(CURDATE(), emp.date_retour_prévu_) * 0.50) AS amende_calculee
FROM emprunts_ emp
JOIN étudiant_ e ON emp.e_ID = e.e_ID
JOIN exemplaire_ ex ON emp.exe_ID = ex.exe_ID
JOIN Livres_ l ON ex.l_ID = l.l_ID
WHERE emp.statut IN ('En cours', 'En retard')
  AND emp.date_retour_effect IS NULL;

-- ---------------------------------------------------------------------
-- 5. REQUÊTES DE TEST DES VUES
-- ---------------------------------------------------------------------

-- 5.1 Test vue livres disponibles
SELECT * FROM vue_livres_disponibles 
WHERE exemplaires_disponibles > 0
ORDER BY l_Titre;

-- 5.2 Test vue statistiques étudiants
SELECT nom_complet AS "Étudiant",
       filière_ AS "Filière",
       total_emprunts AS "Emprunts totaux",
       emprunts_en_retard AS "Emprunts en retard",
       amendes_impayees AS "Amendes impayées (€)"
FROM vue_statistiques_etudiants
ORDER BY total_emprunts DESC;

-- 5.3 Test vue emprunts en cours
SELECT etudiant AS "Étudiant",
       l_Titre AS "Livre",
       date_emprunt AS "Date emprunt",
       date_retour_prévu_ AS "Retour prévu",
       jours_retard AS "Jours de retard",
       amende_calculee AS "Amende calculée"
FROM vue_emprunts_en_cours
WHERE jours_retard > 0
ORDER BY jours_retard DESC;

-- ---------------------------------------------------------------------
-- 6. REQUÊTES DE MAINTENANCE ET AUDIT
-- ---------------------------------------------------------------------

-- 6.1 Vérification de l'intégrité des données
SELECT 'Étudiants sans email' AS vérification, COUNT(*) AS nombre
FROM étudiant_ 
WHERE e_mail IS NULL OR e_mail = ''
UNION ALL
SELECT 'Emprunts sans retour prévu', COUNT(*)
FROM emprunts_
WHERE date_retour_prévu_ IS NULL
UNION ALL
SELECT 'Exemplaires sans état', COUNT(*)
FROM exemplaire_
WHERE état_ IS NULL OR état_ = ''
UNION ALL
SELECT 'Amendes sans montant', COUNT(*)
FROM amende
WHERE montant IS NULL OR montant <= 0;

-- 6.2 Historique complet des activités d'un étudiant
SELECT emp.ID_emprunt AS "ID Opération",
       'Emprunt' AS "Type",
       l.l_Titre AS "Détail",
       emp.date_emprunt AS "Date",
       emp.statut AS "Statut",
       NULL AS "Montant"
FROM emprunts_ emp
JOIN exemplaire_ ex ON emp.exe_ID = ex.exe_ID
JOIN Livres_ l ON ex.l_ID = l.l_ID
WHERE emp.e_ID = 1  -- Changer l'ID étudiant
UNION ALL
SELECT a.ID_am,
       'Amende',
       CONCAT('Amende pour retard - ', l.l_Titre),
       a.date_amende,
       a.statut,
       a.montant
FROM amende a
JOIN emprunts_ emp ON a.ID_emprunt = emp.ID_emprunt
JOIN exemplaire_ ex ON emp.exe_ID = ex.exe_ID
JOIN Livres_ l ON ex.l_ID = l.l_ID
WHERE emp.e_ID = 1
ORDER BY "Date" DESC;

