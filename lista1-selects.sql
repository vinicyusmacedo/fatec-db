-- Selects
-- 1 - Obter o número de fornecedores na base de dados
-- Expected: 4
SELECT COUNT(*) FROM Fornec;

-- 2 - Obter o número de cidades em que há fornecedores
-- Expected: 2
SELECT COUNT(DISTINCT(CidadeFornec)) FROM Fornec;

-- 3 - Obter o número de fornecedores com cidade informada
-- Expected: 4
SELECT COUNT(CodFornec) FROM Fornec WHERE CidadeFornec IS NOT NULL;

-- 4 - Obter a quantidade máxima embarcada
-- Expected: 400

SELECT MAX(QtdeEmbarc) FROM Embarq; 

-- 5 - Obter o número de embarques de cada fornecedor
-- Expected: F1: 2, F2: 1, F3: 1, F4: 1

SELECT CodFornec, COUNT(*) FROM Embarq GROUP BY CodFornec;

-- 6 - Obter o número de embarques de quantidade maior que 300 de cada fornecedor
-- Expected: F2: 1, F4: 1

SELECT CodFornec, COUNT(*) FROM Embarq WHERE QtdeEmbarc > 300 GROUP BY CodFornec;

-- 7 - Obter a quantidade total embarcada de peças de cor cinza para cada fornecedor
-- Expected: F1: 300, F2: 400, F3: 200

SELECT CodFornec, SUM(QtdeEmbarc) FROM Embarq
WHERE CodPeca IN (
	SELECT CodPeca FROM Peca WHERE CorPeca = "cinza"
)
GROUP BY CodFornec;

-- 8 - Obter o quantidade total embarcada de peças para cada fornecedor. 
-- Exibir o resultado por ordem descendente de quantidade total embarcada.
-- Expected: F1: 600, F2: 400, F4: 350, F3: 200

SELECT CodFornec, SUM(QtdeEmbarc) AS SumEmbarc FROM Embarq
GROUP BY CodFornec, QtdeEmbarc
ORDER BY SumEmbarc DESC;


-- 9 - Obter os códigos de fornecedores que tenham embarques de mais de 500 unidades de peças cinzas,
-- junto com a quantidade de embarques de peças cinzas
-- Expected: none

SELECT CodFornec, SUM(QtdeEmbarc) AS SumEmbarc FROM Embarq
WHERE CodPeca IN (
	SELECT CodPeca FROM Peca WHERE CorPeca = "cinza"
)
GROUP BY CodFornec
HAVING SumEmbarc > 500;