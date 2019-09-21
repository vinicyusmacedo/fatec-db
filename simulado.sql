-- Simulado 
-- Criar uma stored procedure usando cursor explícito

-- 8. Obter uma tabela que contém três colunas. 
-- Na primeira coluna aparece o nome de cada disciplina que possui pré-requisito, 
-- na segunda coluna aparece o nome de cada um de seus pré-requisitos 
-- e a terceira contém o nível de pré-requisito. 
-- Nível 1 significa que trata-se de um pré-requisito imediato da disciplina, 
-- nível 2 significa que trata-se de um pré-requisito de um pré-requisito da disciplina, e assim por diante. 
-- Limitar a consulta para três níveis. (DICA USAR UNION ALL)

SELECT Disciplina.NomeDisc, DiscPre.NomeDisc, 1 AS Nivel
FROM Disciplina NATURAL JOIN PreReq
JOIN Disciplina AS DiscPre
ON PreReq.CodDeptoPreReq = DiscPre.CodDepto
AND PreReq.NumDiscPreReq = DiscPre.NumDisc

UNION ALL

SELECT Disciplina.NomeDisc, DiscPre.NomeDisc, 2
FROM (
    (Disciplina NATURAL JOIN PreReq)
    JOIN PreReq AS PrePreReq
    ON PreReq.CodDeptoPreReq = PrePreReq.CodDepto
    AND PreReq.NumDiscPreReq = PrePreReq.NumDisc
)
JOIN Disciplina AS DiscPre
ON PrePreReq.CodDeptoPreReq = DiscPre.CodDepto
AND PrePreReq.NumDiscPreReq = DiscPre.NumDisc

UNION ALL

SELECT Disciplina.NomeDisc, DiscPre.NomeDisc, 3
FROM (
    (
        (Disciplina NATURAL JOIN PreReq)
        JOIN PreReq AS PrePreReq
        ON PreReq.CodDeptoPreReq = PrePreReq.CodDepto
        AND PreReq.NumDiscPreReq = PrePreReq.NumDisc
    )
    JOIN PreReq AS PrePrePreReq
    ON PrePreReq.CodDeptoPreReq = PrePrePreReq.CodDepto
    AND PrePreReq.NumDiscPreReq = PrePrePreReq.NumDisc
)
JOIN Disciplina AS DiscPre
ON PrePrePreReq.CodDeptoPreReq = DiscPre.CodDepto
AND PrePrePreReq.NumDiscPreReq = DiscPre.NumDisc;
