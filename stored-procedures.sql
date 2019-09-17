-- 8. Obter uma tabela que contém três colunas. 
-- Na primeira coluna aparece o nome de cada disciplina que possui pré-requisito, 
-- na segunda coluna aparece o nome de cada um de seus pré-requisitos 
-- e a terceira contém o nível de pré-requisito. 
-- Nível 1 significa que trata-se de um pré-requisito imediato da disciplina, 
-- nível 2 significa que trata-se de um pré-requisito de um pré-requisito da disciplina, e assim por diante. 
-- Limitar a consulta para três níveis. (DICA USAR UNION ALL)

drop table PreReqList;
drop procedure PreReqProc;

CREATE TABLE IF NOT EXISTS PreReqList (
    NomeDisc VARCHAR(25),
    NomeDiscPreReq VARCHAR(25),
    Nivel INT
);

DELIMITER //

CREATE PROCEDURE PreReqProc(Nivel INT, NivelMax INT)
BEGIN
    DECLARE Done BOOLEAN DEFAULT FALSE;
    DECLARE NomeDisc, NomeDiscPreReq VARCHAR(25);
    DECLARE cur CURSOR FOR 
        SELECT Disciplina.NomeDisc, DiscPre.NomeDisc, Nivel FROM PreReq
        NATURAL JOIN Disciplina
        JOIN Disciplina AS DiscPre
        WHERE PreReq.NumDiscPreReq = DiscPre.NumDisc
        AND PreReq.CodDeptoPreReq = DiscPre.CodDepto;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Done = TRUE;

    OPEN cur;

    fetch_loop: LOOP
        FETCH cur INTO NomeDisc, NomeDiscPreReq, Nivel;
        IF Done THEN
            LEAVE fetch_loop;
        END IF;
        INSERT INTO PreReqList VALUES (NomeDisc, NomeDiscPreReq, Nivel);
        SET Nivel = Nivel + 1;
        IF Nivel <= NivelMax THEN
            CALL PreReqProc(Nivel, NivelMax);
            LEAVE fetch_loop;
        END IF;
    END LOOP;
    CLOSE cur;
END//

DELIMITER ;

CALL PreReqProc(1, 3);

SELECT * FROM PreReqList;