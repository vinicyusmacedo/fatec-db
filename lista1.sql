-- TODO change INT to INT4
-- Tables
CREATE TABLE Peca (
	CodPeca CHAR(2),
	NomePeca VARCHAR(25),
	CorPeca VARCHAR(25),
	PesoPeca INT,
	CidadePeca VARCHAR(25)
);
CREATE TABLE Embarq (
	CodPeca CHAR(2),
	CodFornec CHAR(2),
	QtdeEmbarc INT
);
CREATE TABLE Fornec (
	CodFornec CHAR(2),
	NomeFornec VARCHAR(25),
	StatusFornec INT,
	CidadeFornec VARCHAR(25)
);

-- Constraints
-- Primary Keys
ALTER TABLE Peca
ADD CONSTRAINT PkPeca PRIMARY KEY (CodPeca);

ALTER TABLE Fornec
ADD CONSTRAINT PkFornec PRIMARY KEY (CodFornec);

-- Foreign Keys
ALTER TABLE Embarq
ADD CONSTRAINT FkEmbarqPeca FOREIGN KEY (CodPeca) REFERENCES Peca(CodPeca);

ALTER TABLE Embarq
ADD CONSTRAINT FkEmbarqFornec FOREIGN KEY (CodFornec) REFERENCES Fornec(CodFornec);

-- Inserts
INSERT INTO Peca VALUES ('P1', 'Eixo', 'Cinza', 10, 'Poa');
INSERT INTO Peca VALUES ('P2', 'Rolamento', 'Preto', 16, 'Rio');
INSERT INTO Peca VALUES ('P3', 'Mancal', 'Verde', 30, 'São Paulo');

INSERT INTO Fornec VALUES ('F1', 'Silva', 5, 'São Paulo');
INSERT INTO Fornec VALUES ('F2', 'Souza', 10, 'Rio');
INSERT INTO Fornec VALUES ('F3', 'Alvares', 5, 'São Paulo');
INSERT INTO Fornec VALUES ('F4', 'Tavares', 8, 'Rio');

INSERT INTO Embarq VALUES ('P1', 'F1', 300);
INSERT INTO Embarq VALUES ('P1', 'F2', 400);
INSERT INTO Embarq VALUES ('P1', 'F3', 200);
INSERT INTO Embarq VALUES ('P2', 'F1', 300);
INSERT INTO Embarq VALUES ('P2', 'F4', 350);