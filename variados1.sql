drop database fatec;
create database fatec;
alter database fatec default character set utf8;
alter database fatec default collate utf8_general_ci;
use fatec;
-- Only Primary Keys
-- TODO change INT to INT4
CREATE TABLE Depto (
    CodDepto CHAR(5),
    NomeDepto VARCHAR(40)
);
CREATE TABLE Titulacao (
    CodTit INT,
    NomeTit VARCHAR(40)
);
CREATE TABLE Predio (
    CodPred INT,
    NomePred VARCHAR(40)
);
-- Primary Keys and Foreign Keys
CREATE TABLE Disciplina (
    CodDepto CHAR(5),
    NumDisc INT,
    NomeDisc VARCHAR(25),
    CreditoDisc INT
);
CREATE TABLE Turma (
    AnoSem INT,
    CodDepto CHAR(5),
    NumDisc INT,
    SiglaTur CHAR(2),
    CapacTur INT
);
CREATE TABLE Sala (
    CodPred INT,
    NumSala INT,
    DescricaoSala VARCHAR(40),
    CapacSala INT
);
CREATE TABLE Horario (
    AnoSem INT,
    CodDepto CHAR(5),
    NumDisc INT,
    SiglaTur CHAR(2),
    DiaSem INT,
    HoraInicio INT,
    NumSala INT,
    CodPred INT,
    NumHoras INT
);
CREATE TABLE Professor (
    CodProf INT,
    CodDepto CHAR(5),
    CodTit INT,
    NomeProf VARCHAR(40)
);
-- Only Foreign Keys
CREATE TABLE ProfTurma (
    AnoSem INT,
    CodDepto CHAR(5),
    NumDisc INT,
    SiglaTur CHAR(2),
    CodProf INT
);
CREATE TABLE PreReq (
    CodDeptoPreReq CHAR(5),
    NumDiscPreReq INT,
    CodDepto CHAR(5),
    NumDisc INT
);

-- Constraints
-- Only Primary Keys
ALTER TABLE Depto
ADD CONSTRAINT PkDepto PRIMARY KEY (CodDepto);

ALTER TABLE Titulacao
ADD CONSTRAINT PkTitulacao PRIMARY KEY (CodTit);

ALTER TABLE Predio
ADD CONSTRAINT PkPredio PRIMARY KEY (CodPred);

-- Primary Keys and Foreign Keys
ALTER TABLE Disciplina 
ADD CONSTRAINT PkDisciplina PRIMARY KEY (NumDisc);

ALTER TABLE Disciplina
ADD CONSTRAINT FkDisciplinaDepto FOREIGN KEY (CodDepto) REFERENCES Depto(CodDepto);

ALTER TABLE Turma 
ADD CONSTRAINT PkTurmaAnoSigla PRIMARY KEY (AnoSem, SiglaTur);

ALTER TABLE Turma
ADD CONSTRAINT FkTurmaDepto FOREIGN KEY (CodDepto) REFERENCES Disciplina(CodDepto);

ALTER TABLE Turma
ADD CONSTRAINT FkTurmaDisciplina FOREIGN KEY (NumDisc) REFERENCES Disciplina(NumDisc);

ALTER TABLE Sala
ADD CONSTRAINT PkSala PRIMARY KEY (NumSala);

ALTER TABLE Sala
ADD CONSTRAINT FkSalaPredio FOREIGN KEY (CodPred) REFERENCES Predio(CodPred);

ALTER TABLE Horario
ADD CONSTRAINT PkHorarioDiaHora PRIMARY KEY (DiaSem, HoraInicio);

ALTER TABLE Horario
ADD CONSTRAINT FkHorarioSala FOREIGN KEY (NumSala) REFERENCES Sala(NumSala);

ALTER TABLE Horario
ADD CONSTRAINT FkHorarioTurmaAno FOREIGN KEY (AnoSem) REFERENCES Turma(AnoSem);

ALTER TABLE Horario
ADD CONSTRAINT FkHorarioTurmaCodDepto FOREIGN KEY (CodDepto) REFERENCES Turma(CodDepto);

ALTER TABLE Horario
ADD CONSTRAINT FkHorarioTurmaDisc FOREIGN KEY (NumDisc) REFERENCES Turma(NumDisc);

-- ALTER TABLE Horario
-- ADD CONSTRAINT FkHorarioTurmaSigla FOREIGN KEY (SiglaTur) REFERENCES Turma(SiglaTur);

ALTER TABLE Professor
ADD CONSTRAINT PkProfessor PRIMARY KEY (CodProf);

ALTER TABLE Professor
ADD CONSTRAINT FkProfessorTitulacao FOREIGN KEY (CodTit) REFERENCES Titulacao(CodTit);

-- Only Foreign Keys
ALTER TABLE ProfTurma
ADD CONSTRAINT FkProfTurmaAno FOREIGN KEY (AnoSem) REFERENCES Turma(AnoSem);

ALTER TABLE ProfTurma
ADD CONSTRAINT FkProfTurmaCodDepto FOREIGN KEY (CodDepto) REFERENCES Turma(CodDepto);

ALTER TABLE ProfTurma
ADD CONSTRAINT FkProfTurmaNumDisc FOREIGN KEY (NumDisc) REFERENCES Turma(NumDisc);

-- ALTER TABLE ProfTurma
-- ADD CONSTRAINT FkProfTurmaSigla FOREIGN KEY (SiglaTur) REFERENCES Turma(SiglaTur);

ALTER TABLE ProfTurma
ADD CONSTRAINT FkProfTurmaProfessor FOREIGN KEY (CodProf) REFERENCES Professor(CodProf);

ALTER TABLE PreReq
ADD CONSTRAINT FkPreReqCodDeptoPreReq FOREIGN KEY (CodDeptoPreReq) REFERENCES Disciplina(CodDepto);

ALTER TABLE PreReq
ADD CONSTRAINT FkPreReqNumDiscPreReq FOREIGN KEY (NumDiscPreReq) REFERENCES Disciplina(NumDisc);

ALTER TABLE PreReq
ADD CONSTRAINT FkPreReqCodDepto FOREIGN KEY (CodDepto) REFERENCES Disciplina(CodDepto);

ALTER TABLE PreReq
ADD CONSTRAINT FkPreReqNumDisc FOREIGN KEY (NumDisc) REFERENCES Disciplina(NumDisc);

-- Inserts
INSERT INTO Depto VALUES ('INF01', 'Informática');
INSERT INTO Depto VALUES ('ADM01', 'Administração');
INSERT INTO Depto VALUES ('LGT01', 'Logística');
INSERT INTO Depto VALUES ('POL01', 'Polímeros');
INSERT INTO Disciplina VALUES ('INF01', 42, 'Banco de Dados', 4);
INSERT INTO Disciplina VALUES ('INF01', 43, 'Sistemas Operacionais', 2);
INSERT INTO Disciplina VALUES ('INF01', 44, 'Programação p/ mainframe', 9000);
INSERT INTO Disciplina VALUES ('INF01', 45, 'AOC', 9000);
INSERT INTO Disciplina VALUES ('INF01', 46, 'IA', 9000);
INSERT INTO Disciplina VALUES ('INF01', 47, 'IAC', 9000);
INSERT INTO Disciplina VALUES ('ADM01', 24, 'Recursos Humanos', 2);
INSERT INTO Disciplina VALUES ('ADM01', 26, 'Empreendedorismo', 2);
INSERT INTO Disciplina VALUES ('ADM01', 25, 'Gestão de equipes', 1);
INSERT INTO Disciplina VALUES ('ADM01', 27, 'Administração', 1);
INSERT INTO Disciplina VALUES ('ADM01', 28, 'Administração Geral', 1);
INSERT INTO PreReq VALUES ('ADM01', 24, 'ADM01', 25);
INSERT INTO PreReq VALUES ('ADM01', 26, 'ADM01', 25);
INSERT INTO PreReq VALUES ('ADM01', 27, 'ADM01', 26);
INSERT INTO PreReq VALUES ('ADM01', 27, 'ADM01', 24);
INSERT INTO PreReq VALUES ('ADM01', 28, 'ADM01', 27);
INSERT INTO Turma VALUES (20012, 'INF01', 42, 'IN', 40);
INSERT INTO Turma VALUES (20021, 'INF01', 42, 'IN', 40);
INSERT INTO Turma VALUES (20021, 'ADM01', 24, 'AD', 40);
INSERT INTO Turma VALUES (20031, 'ADM01', 24, 'AD', 40);
INSERT INTO Turma VALUES (20022, 'ADM01', 24, 'AD', 40);
INSERT INTO Turma VALUES (20022, 'INF01', 44, 'IN', 40);
INSERT INTO Turma VALUES (20022, 'INF01', 44, 'CO', 40);
INSERT INTO Turma VALUES (20022, 'INF01', 45, 'AO', 40);
INSERT INTO Turma VALUES (20022, 'INF01', 46, 'IS', 40);
INSERT INTO Turma VALUES (20022, 'INF01', 47, 'IC', 40);
INSERT INTO Titulacao VALUES (66, 'Doutor');
INSERT INTO Titulacao VALUES (3, 'Ator');
INSERT INTO Professor VALUES (64, 'INF01', 66, 'Antunes');
INSERT INTO Professor VALUES (65, 'ADM01', 66, 'Arnaldo');
INSERT INTO Professor VALUES (66, 'ADM01', 3, 'Gumball');
INSERT INTO Professor VALUES (67, 'ADM01', NULL, 'Zé Ninguém');
INSERT INTO ProfTurma VALUES (20021, 'INF01', 42, 'IN', 64);
INSERT INTO ProfTurma VALUES (20021, 'INF01', 44, 'IN', 65);
INSERT INTO ProfTurma VALUES (20021, 'ADM01', 24, 'AD', 64);
INSERT INTO ProfTurma VALUES (20021, 'ADM01', 24, 'AD', 67);
INSERT INTO ProfTurma VALUES (20012, 'ADM01', 24, 'AD', 66);
INSERT INTO ProfTurma VALUES (20031, 'ADM01', 24, 'AD', 64);
INSERT INTO Predio VALUES (43423, 'Informática - aulas');
INSERT INTO Sala VALUES (43423, 101, 'Laboratório de Informática', 40);
INSERT INTO Horario VALUES (20021, 'INF01', 42, 'IN', 2, 7, 101, 43423, 4);
INSERT INTO Horario VALUES (20021, 'INF01', 24, 'IN', 2, 8, 101, 43423, 4);
INSERT INTO Horario VALUES (20031, 'ADM01', 24, 'AD', 4, 7, 101, 43423, 4);

INSERT INTO Horario VALUES (20022, 'INF01', 44, 'IN', 4, 7, 101, 43423, 4);
INSERT INTO Horario VALUES (20022, 'INF01', 45, 'AO', 4, 7, 101, 43423, 4);
INSERT INTO Horario VALUES (20022, 'INF01', 46, 'IS', 4, 9, 101, 43423, 4);