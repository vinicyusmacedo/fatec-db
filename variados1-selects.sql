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
ON ProfTurma.CodProf = Professor.CodProf
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
        WHERE NomePred = "Informática - aulas"
    )
);

-- 5. Obter os códigos dos professores com título denominado 'Doutor' que não ministraram aulas em 2002/1.
SELECT CodProf FROM ProfTurma
WHERE AnoSem <> 20021
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

-- 7. Obter o dia da semana, a hora de início e o número de horas 
-- de cada horário de cada turma ministrada por um professor de nome `Antunes', 
-- em 2002/1, na sala número 101 do prédio de código 43423.
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

SELECT ProfTurma.CodProf, Professor.NomeProf, 
(SELECT NomeDepto FROM Depto WHERE CodDepto = Professor.CodDepto) NomeDepto,
(SELECT NomeDepto FROM Depto WHERE CodDepto = ProfTurma.CodDepto) DiscDepto
FROM ProfTurma, Professor
WHERE ProfTurma.CodProf = Professor.CodProf
AND ProfTurma.CodDepto <> Professor.CodDepto;

-- 9. Obter o nome dos professores que possuem horários conflitantes 
-- (possuem turmas que tenham a mesma hora inicial, no mesmo dia da semana e no mesmo semestre). 
-- Além dos nomes, mostrar as chaves primárias das turmas em conflito.
-- Expected: null as DiaSem and HoraInicio are PKs

SELECT NomeProf, SiglaTur
FROM Professor, ProfTurma, (
    SELECT CodProf, AnoSem, DiaSem, HoraInicio, COUNT(*) Conflito
    FROM ProfTurma
    NATURAL JOIN Horario
    GROUP BY CodProf, AnoSem, DiaSem, HoraInicio
    HAVING Conflito > 1
) AS Conflito
WHERE Professor.CodProf = ProfTurma.CodProf
AND ProfTurma.CodProf = Conflito.CodProf;

-- 10. Para cada disciplina que possui pré-requisito, obter o nome da disciplina seguido do nome da disciplina que é seu pré-requisito.

SELECT NomeDisc, 
(SELECT NomeDisc FROM Disciplina WHERE PreReq.NumDiscPreReq = Disciplina.NumDisc) AS NomePreReq
FROM Disciplina
NATURAL JOIN PreReq;

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

-- 2. Obter os nomes dos departamentos que têm turmas que, em 2002/1, 
-- têm aulas na sala 101 do prédio denominado 'Informática - aulas'. Resolver usando theta-join e junção natural.

-- theta join

SELECT NomeDepto FROM Depto, Horario, Predio
WHERE Depto.CodDepto = Horario.CodDepto
AND Horario.CodPred = Predio.CodPred
AND Horario.AnoSem = 20021 AND Horario.NumSala = 101
AND Predio.NomePred = "Informática - aulas"
GROUP BY NomeDepto;

-- natural join

SELECT NomeDepto FROM Depto
NATURAL JOIN Horario
NATURAL JOIN Predio
WHERE AnoSem = 20021 AND NumSala = 101
AND NomePred = "Informática - aulas"
GROUP BY NomeDepto;

-- 3. Obter o nome de cada departamento seguido do nome de cada uma de suas disciplinas que possui mais que três créditos 
-- (caso o departamento não tenha disciplinas ou caso o departamento não tenha disciplinas com mais que três créditos, 
-- seu nome deve aparecer seguido de vazio). 
-- Expected - Informática - Banco de Dados
-- Expected - Logística deve aparecer

SELECT NomeDepto, IF (CreditoDisc > 3, NomeDisc, NULL) AS PossuiCred FROM Depto
NATURAL LEFT JOIN Disciplina;

-- 4. Obter o nome dos professores que possuem horários conflitantes 
-- (possuem turmas que tenham a mesma hora inicial, no mesmo dia da semana e no mesmo semestre).

SELECT NomeProf, SiglaTur
FROM Professor, ProfTurma, (
    SELECT CodProf, AnoSem, DiaSem, HoraInicio, COUNT(*) Conflito
    FROM ProfTurma
    NATURAL JOIN Horario
    GROUP BY CodProf, AnoSem, DiaSem, HoraInicio
    HAVING Conflito > 1
) AS Conflito
WHERE Professor.CodProf = ProfTurma.CodProf
AND ProfTurma.CodProf = Conflito.CodProf;



-- 5. Para cada disciplina que possui pré-requisito, obter o nome da disciplina 
-- seguido do nome da disciplina que é seu pré-requisito (usar junções explícitas - quando possível usar junção natural).

SELECT NomeDisc, 
(SELECT NomeDisc FROM Disciplina WHERE PreReq.NumDiscPreReq = Disciplina.NumDisc) AS NomePreReq
FROM Disciplina
NATURAL JOIN PreReq;

-- 6. Para cada disciplina, mesmo para aquelas que não possuem pré-requisito, 
-- obter o nome da disciplina seguido do nome da disciplina que é seu pré-requisito 
-- (usar junções explícitas - quando possível usar junção natural).

SELECT NomeDisc, 
(SELECT NomeDisc FROM Disciplina WHERE PreReq.NumDiscPreReq = Disciplina.NumDisc) AS NomePreReq
FROM Disciplina
NATURAL LEFT JOIN PreReq;

-- 7. Para cada disciplina que tem um pré-requisito que a sua vez também tem um pré-requisito, 
-- obter o nome da disciplina seguido do nome do pré-requisito de seu pré-requisito.

-- TODO

-- 8. Obter uma tabela que contém três colunas. 
-- Na primeira coluna aparece o nome de cada disciplina que possui pré-requisito, 
-- na segunda coluna aparece o nome de cada um de seus pré-requisitos 
-- e a terceira contém o nível de pré-requisito. 
-- Nível 1 significa que trata-se de um pré-requisito imediato da disciplina, 
-- nível 2 significa que trata-se de um pré-requisito de um pré-requisito da disciplina, e assim por diante. 
-- Limitar a consulta para três níveis. (DICA USAR UNION ALL)

WITH RECURSIVE PreReqPaths AS (
    SELECT NumDisc, NumDiscPreReq, 1 Nível
    FROM PreReq
        UNION ALL
        SELECT PreReq.NumDisc, PreReq.NumDiscPreReq, Nível+1
        FROM PreReq
        INNER JOIN PreReqPaths
        ON PreReqPaths.NumDiscPreReq = PreReq.NumDisc
)
SELECT 
    (SELECT NomeDisc FROM Disciplina WHERE PreReqPaths.NumDisc = Disciplina.NumDisc) AS NomeDisc,
    (SELECT NomeDisc FROM Disciplina WHERE PreReqPaths.NumDiscPreReq = Disciplina.NumDisc) AS NomePreReq, Nível
FROM PreReqPaths
WHERE Nível <= 3;


-- 9. Obter os códigos dos professores com código de título vazio que não ministraram aulas em 2001/2 (resolver com junção natural).
-- Expected: 67

SELECT CodProf FROM Professor
NATURAL LEFT OUTER JOIN Titulacao
NATURAL JOIN ProfTurma
WHERE AnoSem <> 20012
AND CodTit IS NULL;

-- Parte 3

--1. Obter o os nomes dos professores que são do departamento denominado 'Informática', 
-- sejam doutores, e que, em 20022, ministraram alguma turma de disciplina do departamento 'Informática' 
-- que tenha mais que três créditos. Resolver a questão da seguinte forma:
--1.1. sem consultas aninhadas e sem sintaxe explícita para junções,
--1.2. usando SQL, em estilo de cálculo relacional, com consultas aninhadas
--(quando possível usar IN, caso contrário usar EXISTS).

--2. Obter os nomes das disciplinas do departamento denominado 'Informática' que não foram oferecidas no semestre 20021. 
-- Resolver a questão da seguinte forma:
--2.1. no estilo de álgebra relacional, isto é, sem consultas aninhadas (subselects),
--2.2. no estilo cálculo relacional, isto é, com consultas aninhadas (subselects).

--3. Obter uma tabela com as seguintes colunas: 
-- código de departamento, nome do departamento, número de disciplina, créditos da disciplina, 
-- sigla da turma e capacidade da turma. 
-- A tabela deve conter cada departamento associado com cada uma de suas disciplinas e, 
-- para cada disciplina as respectivas turmas no ano semestre 20022. 
-- Caso um departamento não tenha disciplinas, as demais colunas devem aparecer vazias. 
-- Caso uma disciplina não tenha turmas, as demais colunas deve aparecer vazias.

SELECT CodDepto, NomeDepto, NumDisc, CreditoDisc, 
IF(AnoSem = 20022, SiglaTur, NULL) AS SiglaTur,
IF(AnoSem = 20022, CapacTur, NULL) AS CapacTur
FROM Depto
NATURAL LEFT JOIN Disciplina
NATURAL LEFT JOIN Turma;

--4. Obter uma tabela com duas colunas, contendo o nome de cada disciplina 
-- seguido do nome de cada um de seus pré-requisitos. 
-- Disciplinas sem pré- requisito têm a segunda coluna vazia.

SELECT NomeDisc, 
(SELECT NomeDisc FROM Disciplina WHERE PreReq.NumDiscPreReq = Disciplina.NumDisc) AS NomePreReq
FROM Disciplina
NATURAL LEFT JOIN PreReq;

--5. Obter os identificadores de todas turmas de disciplinas do departamento denominado `Informática' 
-- que não têm aula na sala de número 102 do prédio de código 43421.

SELECT SiglaTur
FROM Horario
NATURAL JOIN Depto
WHERE NomeDepto = "Informática"
AND NumSala <> 102
AND CodPred = 43421;

--6. Obter o número de disciplinas do departamento denominado `Informática'.

SELECT NomeDepto, COUNT(NumDisc)
FROM Disciplina
NATURAL JOIN Depto
WHERE NomeDepto = "Informática"
GROUP BY NomeDepto;

--7. Obter o número de salas que foram usadas no ano-semestre 20021 por turmas do departamento denominado `Informática'.

SELECT COUNT(DISTINCT NumSala, CodPred)
FROM Horario
NATURAL JOIN Depto
WHERE NomeDepto = "Informática"
AND AnoSem = 20021
GROUP BY NomeDepto;

--8. Obter os nomes das disciplinas do departamento denominado `Informática' 
-- que têm o maior número de créditos dentre as disciplinas deste departamento.

SELECT NomeDisc, CreditoDisc
FROM Disciplina
NATURAL JOIN Depto
WHERE NomeDepto = "Informática"
ORDER BY CreditoDisc DESC;

--9. Para cada departamento, obter seu nome e o número de disciplinas do departamento. 
-- Obter o resultado em ordem descendente de número de disciplinas.

SELECT NomeDepto, COUNT(NumDisc) AS CountDisc
FROM Disciplina
NATURAL RIGHT JOIN Depto
GROUP BY NomeDepto
ORDER BY CountDisc DESC;

--10. Para cada departamento, obter seu nome e os créditos totais oferecidos no ano-semestre 20022. 
-- O número de créditos oferecidos é calculado através do produto de número de créditos da disciplina 
-- pelo número de turmas oferecidas no semestre.

SELECT NomeDepto, IF(AnoSem = 20022, SUM(CreditoDisc), 0) AS CreditosTotais
FROM Depto
NATURAL JOIN Disciplina
NATURAL JOIN Turma
GROUP BY NomeDepto, AnoSem;

--11. Resolver a consulta da questão anterior, mas incluindo somente os departamentos que têm mais que 5 disciplinas.

SELECT NomeDepto, IF(AnoSem = 20022, SUM(CreditoDisc), 0) AS CreditosTotais
FROM Depto
NATURAL JOIN Disciplina
NATURAL JOIN Turma
GROUP BY NomeDepto, AnoSem
HAVING COUNT(NumDisc) > 5;

--12. Obter os nomes dos departamentos que possuem a maior soma de créditos.

SELECT NomeDepto, SUM(CreditoDisc)
FROM Depto
NATURAL JOIN Disciplina
NATURAL LEFT JOIN Turma
GROUP BY NomeDepto;

--13. Obter os nomes das disciplinas que em 20022, têm pelo menos uma turma cuja total de horas 
-- seja diferente do número de créditos da disciplina.
--Resolver a questão da seguinte forma:
--13.1. sem usar GROUP BY, com consultas aninhadas (subselects),
--13.2. usando GROUP BY, sem consultas aninhadas.

--14. Obter os nomes dos professores que, em 20022, deram aula em mais de uma turma.
--Resolver a questão da seguinte forma:
--14.1. sem funções de agregação (tipo COUNT, MIN,MAX,AVG,SUM),
--14.2. ou ainda, com funções de agregação.
