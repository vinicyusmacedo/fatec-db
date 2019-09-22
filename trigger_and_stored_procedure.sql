drop table if exists PreReqList;
drop table if exists PreReqNomeList;
drop procedure if exists PreReqProc;
drop procedure if exists GetNomeDisc;
drop trigger if exists SaveAsNomeDisc;

CREATE TABLE IF NOT EXISTS PreReqList (
    NumDisc INT,
    NumDiscPreReq INT,
    Nivel INT
);

CREATE TABLE IF NOT EXISTS PreReqNomeList (
    NomeDisc VARCHAR(25),
    NomeDiscPreReq VARCHAR(25),
    Nivel INT
);

-- Essa procedure recebe um NumDisc e retorna o NomeDisc dela

-- Exemplo de chamada
-- CALL GetNomeDisc(25, @a);
-- SELECT @a;
DELIMITER //
CREATE PROCEDURE GetNomeDisc(NumDiscProvided INT, OUT NomeDiscOut VARCHAR(25))
BEGIN
    SELECT NomeDisc INTO NomeDiscOut FROM Disciplina
    WHERE NumDisc = NumDiscProvided
    LIMIT 1;
END//
DELIMITER ;

-- Essa trigger guarda na tabela PreReqNomeList o NomeDisc das disciplinas
-- que estão sendo inseridas na tabela PreReqList
DELIMITER //
CREATE TRIGGER SaveAsNomeDisc AFTER INSERT ON PreReqList
FOR EACH ROW
BEGIN
    CALL GetNomeDisc(NEW.NumDisc, @NomeDisc);
    CALL GetNomeDisc(NEW.NumDiscPreReq, @NomeDiscPreReq);
    INSERT INTO PreReqNomeList VALUES (@NomeDisc, @NomeDiscPreReq, NEW.Nivel);
END//
DELIMITER ;

-- Essa procedure obtem uma lista de disciplinas com sua pré-req a partir de uma disciplina inicial
-- Ela também mantém um contador de nível
DELIMITER //
CREATE PROCEDURE PreReqProc(NumDiscSupplied INT, Nivel INT, NivelMax INT)
BEGIN
    DECLARE Done BOOLEAN DEFAULT FALSE;
    DECLARE NumDiscPreReqVar INT;
    DECLARE cur CURSOR FOR 
        SELECT NumDiscPreReq FROM PreReq
        WHERE PreReq.NumDisc = NumDiscSupplied;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Done = TRUE;

    OPEN cur;

    nivel_loop: LOOP
        fetch_loop: LOOP
            FETCH cur INTO NumDiscPreReqVar;
            IF Done THEN
                LEAVE fetch_loop;
            END IF;
            INSERT INTO PreReqList VALUES (NumDiscSupplied, NumDiscPreReqVar, Nivel);
        END LOOP;
    SET Nivel = Nivel + 1;
    IF Nivel > NivelMax THEN
        LEAVE nivel_loop;
    END IF;
    CALL PreReqProc(NumDiscPreReqVar, Nivel, NivelMax);
    END LOOP;
    CLOSE cur;
END//
DELIMITER ;

-- Chamadas

SET @@session.max_sp_recursion_depth = 255; 
CALL PreReqProc(25, 1, 3);

SELECT * FROM PreReqList
ORDER BY Nivel;

SELECT * FROM PreReqNomeList
ORDER BY Nivel;