-- Création de la base de données
CREATE DATABASE bibliotheque_universitaire;
USE bibliotheque_universitaire;


CREATE TABLE étudiant_(
   e_ID INT,
   e_nom VARCHAR(50) NOT NULL,
   e_prénom_ VARCHAR(50) NOT NULL,
   e_mail VARCHAR(50),
   téléphone_ VARCHAR(20), 
   date_inscription DATE NOT NULL, 
   filière_ VARCHAR(50) NOT NULL,
   PRIMARY KEY(e_ID)
);

CREATE TABLE Livres_(
   l_ID INT,
   editeur VARCHAR(50) NOT NULL, 
   l_Titre VARCHAR(50) NOT NULL,
   année_sortie YEAR NOT NULL, 
   ISBN VARCHAR(50) NOT NULL,
   PRIMARY KEY(l_ID),
   UNIQUE(ISBN) 
);

CREATE TABLE auteur(
   ID_auteur VARCHAR(50),
   nom_aut VARCHAR(50) NOT NULL,
   prénom_aut VARCHAR(50) NOT NULL,
   ville_aut VARCHAR(50),
   PRIMARY KEY(ID_auteur)
);

CREATE TABLE catégorie_(
   ID_ca VARCHAR(50),
   libellé_ VARCHAR(50) NOT NULL, 
   PRIMARY KEY(ID_ca)
);

CREATE TABLE exemplaire_(
   exe_ID INT,
   code_barre_ VARCHAR(50) NOT NULL, 
   état_ VARCHAR(50),
   l_ID INT NOT NULL,
   PRIMARY KEY(exe_ID),
   FOREIGN KEY(l_ID) REFERENCES Livres_(l_ID)
);

CREATE TABLE emprunts_(
   ID_emprunt VARCHAR(50),
   date_emprunt DATE NOT NULL,
   date_retour_prévu_ DATE NOT NULL, 
   e_ID INT NOT NULL,
   statut VARCHAR(50) NOT NULL,
   exe_ID INT NOT NULL,
   date_retour_effect DATE,
   PRIMARY KEY(ID_emprunt),
   FOREIGN KEY(e_ID) REFERENCES étudiant_(e_ID),
   FOREIGN KEY(exe_ID) REFERENCES exemplaire_(exe_ID)
);

CREATE TABLE amende(
   ID_am VARCHAR(50),
   ID_emprunt VARCHAR(50) NOT NULL,
   montant DECIMAL(10,2) NOT NULL, 
   statut VARCHAR(50) NOT NULL,
   date_amende DATE NOT NULL,
   PRIMARY KEY(ID_am),
   FOREIGN KEY(ID_emprunt) REFERENCES emprunts_(ID_emprunt)
);

CREATE TABLE écrire_(
   l_ID INT,
   ID_auteur VARCHAR(50),
   rôle_ VARCHAR(50) NOT NULL,
   ordre INT NOT NULL, 
   PRIMARY KEY(l_ID, ID_auteur),
   FOREIGN KEY(l_ID) REFERENCES Livres_(l_ID),
   FOREIGN KEY(ID_auteur) REFERENCES auteur(ID_auteur)
);

CREATE TABLE classer(
   l_ID INT,
   ID_ca VARCHAR(50),
   PRIMARY KEY(l_ID, ID_ca),
   FOREIGN KEY(l_ID) REFERENCES Livres_(l_ID),
   FOREIGN KEY(ID_ca) REFERENCES catégorie_(ID_ca)
);


ALTER TABLE emprunts_ ADD COLUMN ID_am VARCHAR(50);
ALTER TABLE emprunts_ ADD FOREIGN KEY (ID_am) REFERENCES amende(ID_am);
ALTER TABLE Livres_ MODIFY année_sortie INT NOT NULL;