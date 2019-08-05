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
    NomeDisc VARCHAR(10),
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
ADD CONSTRAINT PkTurmaAno PRIMARY KEY (AnoSem);

ALTER TABLE Turma
ADD CONSTRAINT PkTurmaSigla PRIMARY KEY (SiglaTur);

ALTER TABLE Turma
ADD CONSTRAINT FkTurmaDepto FOREIGN KEY (CodDepto) REFERENCES Disciplina(CodDepto);

ALTER TABLE Turma
ADD CONSTRAINT FkTurmaDisciplina FOREIGN KEY (NumDisc) REFERENCES Disciplina(NumDisc);

ALTER TABLE Sala
ADD CONSTRAINT PkSala PRIMARY KEY (NumSala);

ALTER TABLE Sala
ADD CONSTRAINT FkSalaPredio FOREIGN KEY (CodPred) REFERENCES Predio(CodPred);

ALTER TABLE Horario
ADD CONSTRAINT PkHorarioDia PRIMARY KEY (DiaSem);

ALTER TABLE Horario
ADD CONSTRAINT PkHorarioHora PRIMARY KEY (HoraInicio);

ALTER TABLE Horario
ADD CONSTRAINT FkHorarioSala FOREIGN KEY (NumSala) REFERENCES Sala(NumSala);

ALTER TABLE Horario
ADD CONSTRAINT FkHorarioTurmaAno FOREIGN KEY (AnoSem) REFERENCES Turma(AnoSem);

ALTER TABLE Horario
ADD CONSTRAINT FkHorarioTurmaCodDepto FOREIGN KEY (CodDepto) REFERENCES Turma(CodDepto);

ALTER TABLE Horario
ADD CONSTRAINT FkHorarioTurmaDisc FOREIGN KEY (NumDisc) REFERENCES Turma(NumDisc);

ALTER TABLE Horario
ADD CONSTRAINT FkHorarioTurmaSigla FOREIGN KEY (SiglaTur) REFERENCES Turma(SiglaTur);

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

ALTER TABLE ProfTurma
ADD CONSTRAINT FkProfTurmaSigla FOREIGN KEY (SiglaTur) REFERENCES Turma(SiglaTur);

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
INSERT INTO Disciplina VALUES ('INF01', 42, 'Banco de Dados', 40);
INSERT INTO Disciplina VALUES ('INF01', 43, 'Sistemas Operacionais', 40);
INSERT INTO Disciplina VALUES ('ADM01', 24, 'Recursos Humanos', 40);
INSERT INTO Turma VALUES (20021, 'INF01', 42, 'INF', 40);
INSERT INTO Turma VALUES (20021, 'ADM01', 24, 'ADM', 40);
INSERT INTO Turma VALUES (20031, 'ADM01', 24, 'ADM', 40);
INSERT INTO Titulacao VALUES (66, 'Doutor');
INSERT INTO Professor VALUES (64, 'INF01', 66, 'Antunes');
INSERT INTO Professor VALUES (65, 'ADM01', 66, 'Arnaldo');
INSERT INTO ProfTurma VALUES (20021, 'INF01', 42, 'INF', 64);
INSERT INTO ProfTurma VALUES (20021, 'ADM01', 24, 'ADM', 64);
INSERT INTO ProfTurma VALUES (20031, 'ADM01', 24, 'ADM', 66);
INSERT INTO Predio VALUES (43423, 'Informática - aulas');
INSERT INTO Sala VALUES (43423, 101, 'Laboratório de Informática', 40);
INSERT INTO Horario VALUES (20021, 'INF01', 42, 'INF', 2, 7, 101, 4);
INSERT INTO Horario VALUES (20021, 'INF01', 43, 'INF', 2, 7, 101, 4);
INSERT INTO Horario VALUES (20031, 'ADM01', 24, 'ADM', 4, 7, 102, 4);

-- Exercícios
-- 1. Obter os códigos dos diferentes departamentos que tem turmas no ano-semestre 2002/1
SELECT CodDepto FROM Turma
WHERE AnoSem = 20021;

-- 2. Obter os códigos dos professores que são do departamento de código 'INF01' e que ministraram ao menos uma turma em 2002/1.
SELECT CodProf FROM ProfTurma
WHERE CodDepto = 'INF01'
AND SiglaTur IN (SELECT SiglaTur FROM Turma WHERE AnoSem = 20021);

-- 3. Obter os horários de aula (dia da semana,hora inicial e número de horas ministradas) do professor "Antunes" em 20021.
SELECT DiaSem, HoraInicio, NumHoras FROM Horario
INNER JOIN Turma
ON Horario.SiglaTur = Turma.SiglaTur
INNER JOIN ProfTurma
ON Turma.SiglaTur = ProfTurma.SiglaTur
INNER JOIN Professor
ON ProfTurma.CodProf = Professor.CodProfessor
WHERE NomeProf = 'Antunes'
AND Horario.AnoSem = 20021;

-- 4. Obter os nomes dos departamentos que têm turmas que, em 2002/1, têm aulas na sala 101 do prédio denominado 'Informática - aulas'.
SELECT NomeDepto FROM Depto
WHERE CodDepto IN (
    SELECT CodDepto FROM Horario
    WHERE AnoSem = 20021
    AND NumSala = 101
    AND CodPred IN (
        SELECT CodPred FROM Predio
        WHERE NomePred = 'Informática - aulas'
    )
);

-- 5. Obter os códigos dos professores com título denominado 'Doutor' que não ministraram aulas em 2002/1.
SELECT CodProf FROM ProfTurma
WHERE AnoSem NOT 20021
AND CodProf IN (
    SELECT CodProf FROM Professor
    INNER JOIN Titulacao
    ON Professor.CodTit = Titulacao.CodTit
    WHERE NomeTit = 'Doutor'
);

-- 6. Obter os identificadores das salas (código do prédio e número da sala) que, em 2002/1:
--    nas segundas-feiras (dia da semana = 2), tiveram ao menos uma turma do departamento 'Informática', e
--    nas quartas-feiras (dia da semana = 4), tiveram ao menos uma turma ministrada pelo professor denominado 'Antunes'.
SELECT CodPred, NumSala FROM Horario
WHERE AnoSem = 20021
AND (
    DiaSem = 2
    AND CodDepto IN (
        SELECT CodDepto FROM Depto
        WHERE NomeDepto = 'Informática'
    )
)
OR (
    DiaSem = 4
    AND SiglaTur IN (
        SELECT SiglaTur FROM ProfTurma
        INNER JOIN Professor
        ON ProfTurma.CodProf = Professor.CodProf
        WHERE NomeProf = 'Antunes'
    )
);

-- 7. Obter o dia da semana, a hora de início e o número de horas de cada horário de cada turma ministrada por um professor de nome `Antunes', em 2002/1, na sala número 101 do prédio de código 43423.
SELECT DiaSem, HoraInicio, NumHoras FROM Horario
WHERE AnoSem = 20021
AND NumSala = 101
AND CodPred = 43423
AND SiglaTur IN (
    SELECT SiglaTur FROM ProfTurma
    INNER JOIN Professor
    ON ProfTurma.CodProf = Professor.CodProf
    WHERE NomeProf = 'Antunes'
);

-- 8. Um professor pode ministrar turmas de disciplinas pertencentes a outros departamentos. 
-- Para cada professor que já ministrou aulas em disciplinas de outros departamentos, 
-- obter o código do professor, seu nome, o nome de seu departamento e o nome do departamento no qual ministrou disciplina.

-- 9. Obter o nome dos professores que possuem horários conflitantes 
-- (possuem turmas que tenham a mesma hora inicial, no mesmo dia da semana e no mesmo semestre). 
-- Além dos nomes, mostrar as chaves primárias das turmas em conflito.

-- 10. Para cada disciplina que possui pré-requisito, obter o nome da disciplina seguido do nome da disciplina que é seu pré-requisito.

-- 11. Obter os nomes das disciplinas que não têm pré-requisito.
SELECT NomeDisc FROM Disciplina
WHERE NumDisc IN (
    SELECT NumDisc FROM PreReq
    WHERE NumDiscPreReq IS NULL
)
OR NumDisc NOT IN (
    SELECT NumDisc FROM PreReq
);

-- 12. Obter o nome de cada disciplina que possui ao menos dois pré-requisitos.
SELECT NomeDisc FROM Disciplina
WHERE NumDisc IN (
    SELECT NumDisc FROM PreReq
    GROUP BY NumDisc
    HAVING COUNT(NumDiscPreReq) >= 2
);

-- Parte 2

-- 1. Obter os nomes docentes cuja titulação tem código diferente de 3.
SELECT NomeProf FROM Professor WHERE CodTit <> 3;

-- 2. Obter os nomes dos departamentos que têm turmas que, em 2002/1, têm aulas na sala 101 do prédio denominado 'Informática - aulas'. Resolver usando theta-join e junção natural.

-- 3. Obter o nome de cada departamento seguido do nome de cada uma de suas disciplinas que possui mais que três créditos (caso o departamento não tenha disciplinas ou caso o departamento não tenha disciplinas com mais que três créditos, seu nome deve aparecer seguido de vazio). 

-- 4. Obter o nome dos professores que possuem horários conflitantes (possuem turmas que tenham a mesma hora inicial, no mesmo dia da semana e no mesmo semestre).

-- 5. Para cada disciplina que possui pré-requisito, obter o nome da disciplina seguido do nome da disciplina que é seu pré-requisito (usar junções explícitas - quando possível usar junção natural).

-- 6. Para cada disciplina, mesmo para aquelas que não possuem pré-requisito, obter o nome da disciplina seguido do nome da disciplina que é seu pré-requisito (usar junções explícitas - quando possível usar junção natural).

-- 7. Para cada disciplina que tem um pré-requisito que a sua vez também tem um pré-requisito, obter o nome da disciplina seguido do nome do pré-requisito de seu pré-requisito.

-- 8. Obter uma tabela que contém três colunas. Na primeira coluna aparece o nome de cada disciplina que possui pré-requisito, na segunda coluna aparece o nome de cada um de seus pré-requisitos e a terceira contém o nível de pré-requisito. Nível 1 significa que trata-se de um pré-requisito imediato da disciplina, nível 2 significa que trata-se de um pré-requisito de um pré-requisito da disciplina, e assim por diante. Limitar a consulta para três níveis. (DICA USAR UNION ALL)

-- 9. Obter os códigos dos professores com código de título vazio que não ministraram aulas em 2001/2 (resolver com junção natural).

-- Parte 3

--1. Obter o os nomes dos professores que são do departamento denominado 'Informática', sejam doutores, e que, em 20022, ministraram alguma turma de disciplina do departamento 'Informática' que tenha mais que três créditos. Resolver a questão da seguinte forma:
--1.1. sem consultas aninhadas e sem sintaxe explícita para junções,
--1.2. usando SQL, em estilo de cálculo relacional, com consultas aninhadas
--(quando possível usar IN, caso contrário usar EXISTS).

--2. Obter os nomes das disciplinas do departamento denominado 'Informática' que não foram oferecidas no semestre 20021. Resolver a questão da seguinte forma:
--2.1. no estilo de álgebra relacional, isto é, sem consultas aninhadas (subselects),
--2.2. no estilo cálculo relacional, isto é, com consultas aninhadas (subselects).

--3. Obter uma tabela com as seguintes colunas: código de departamento, nome do departamento, número de disciplina, créditos da disciplina, sigla da turma e capacidade da turma. A tabela deve conter cada departamento associado com cada uma de suas disciplinas e, para cada disciplina as respectivas turmas no ano semestre 20022. Caso um departamento não tenha disciplinas, as demais colunas devem aparecer vazias. Caso uma disciplina não tenha turmas, as demais colunas deve aparecer vazias.

--4. Obter uma tabela com duas colunas, contendo o nome de cada disciplina seguido do nome de cada um de seus pré-requisitos. Disciplinas sem pré- requisito têm a segunda coluna vazia.

--5. Obter os identificadores de todas turmas de disciplinas do departamento denominado `Informática' que não têm aula na sala de número 102 do prédio de código 43421.

--6. Obter o número de disciplinas do departamento denominado `Informática'.

--7. Obter o número de salas que foram usadas no ano-semestre 20021 por turmas do departamento denominado `Informática'.

--8. Obter os nomes das disciplinas do departamento denominado `Informática' que têm o maior número de créditos dentre as disciplinas deste departamento.

--9. Para cada departamento, obter seu nome e o número de disciplinas do departamento. Obter o resultado em ordem descendente de número de disciplinas.

--10. Para cada departamento, obter seu nome e os créditos totais oferecidos no ano-semestre 20022. O número de créditos oferecidos é calculado através do produto de número de créditos da disciplina pelo número de turmas oferecidas no semestre.

--11. Resolver a consulta da questão anterior, mas incluindo somente os departamentos que têm mais que 5 disciplinas.

--12. Obter os nomes dos departamentos que possuem a maior soma de créditos.

--13. Obter os nomes das disciplinas que em 20022, têm pelo menos uma turma cuja total de horas seja diferente do número de créditos da disciplina.
--Resolver a questão da seguinte forma:
--13.1. sem usar GROUP BY, com consultas aninhadas (subselects),
--13.2. usando GROUP BY, sem consultas aninhadas.

--14. Obter os nomes dos professores que, em 20022, deram aula em mais de uma turma.
--Resolver a questão da seguinte forma:
--14.1. sem funções de agregação (tipo COUNT, MIN,MAX,AVG,SUM),
--14.2. ou ainda, com funções de agregação.
