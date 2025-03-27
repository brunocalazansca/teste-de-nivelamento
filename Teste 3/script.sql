CREATE TABLE relatorio_cadop (
    registro_ans BIGINT PRIMARY KEY,
    cnpj VARCHAR(18),
    razao_social TEXT,
    nome_fantasia TEXT,
    modalidade TEXT,
    logradouro TEXT,
    numero TEXT,
    complemento TEXT,
    bairro VARCHAR(30),
    cidade VARCHAR(30),
    uf VARCHAR(2),
    cep VARCHAR(9),
    ddd INTEGER,
    telefone VARCHAR(30),
    fax VARCHAR(15),
    endereco_eletronico TEXT,
    representante TEXT,
    cargo_representante TEXT,
    regiao_comercializacao INTEGER,
    data_registro_ans DATE
);

COPY relatorio_cadop 
FROM 'C:\Teste 3\Relatorio_cadop.csv'
DELIMITER ';'
CSV HEADER;

CREATE TABLE relatorios_trimestrais(
	data DATE,
	reg_ans BIGINT,
	cd_conta_contabil BIGINT,
	descricao TEXT,
	vl_saldo_inicial NUMERIC,
	vl_saldo_final NUMERIC
);

CREATE TEMP TABLE relatorio_temporario (
    data TEXT,
    reg_ans TEXT,
    cd_conta_contabil TEXT,
    descricao TEXT,
    vl_saldo_inicial TEXT,
    vl_saldo_final TEXT
);

-- Relatórios 2024

COPY relatorio_temporario ("data", "reg_ans", "cd_conta_contabil", "descricao", "vl_saldo_inicial", "vl_saldo_final")
FROM 'C:\Teste 3\2024\1T2024\1T2024.csv'
DELIMITER ';'
CSV HEADER;

COPY relatorio_temporario ("data", "reg_ans", "cd_conta_contabil", "descricao", "vl_saldo_inicial", "vl_saldo_final")
FROM 'C:\Teste 3\2024\2T2024\2T2024.csv'
DELIMITER ';'
CSV HEADER;

COPY relatorio_temporario ("data", "reg_ans", "cd_conta_contabil", "descricao", "vl_saldo_inicial", "vl_saldo_final")
FROM 'C:\Teste 3\2024\3T2024\3T2024.csv'
DELIMITER ';'
CSV HEADER;

COPY relatorio_temporario ("data", "reg_ans", "cd_conta_contabil", "descricao", "vl_saldo_inicial", "vl_saldo_final")
FROM 'C:\Teste 3\2024\4T2024\4T2024.csv'
DELIMITER ';'
CSV HEADER;

-- Relatórios 2023

COPY relatorio_temporario ("data", "reg_ans", "cd_conta_contabil", "descricao", "vl_saldo_inicial", "vl_saldo_final")
FROM 'C:\Teste 3\2023\1T2023\1T2023.csv'
DELIMITER ';'
CSV HEADER;

COPY relatorio_temporario ("data", "reg_ans", "cd_conta_contabil", "descricao", "vl_saldo_inicial", "vl_saldo_final")
FROM 'C:\Teste 3\2023\2T2023\2T2023.csv'
DELIMITER ';'
CSV HEADER;

COPY relatorio_temporario ("data", "reg_ans", "cd_conta_contabil", "descricao", "vl_saldo_inicial", "vl_saldo_final")
FROM 'C:\Teste 3\2023\3T2023\3T2023.csv'
DELIMITER ';'
CSV HEADER;

COPY relatorio_temporario ("data", "reg_ans", "cd_conta_contabil", "descricao", "vl_saldo_inicial", "vl_saldo_final")
FROM 'C:\Teste 3\2023\4T2023\4T2023.csv'
DELIMITER ';'
CSV HEADER;

INSERT INTO relatorios_trimestrais (data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
SELECT 
    data::DATE,
    reg_ans::BIGINT,
    cd_conta_contabil::BIGINT,
    descricao,
    REPLACE(vl_saldo_inicial, ',', '.')::NUMERIC,
    REPLACE(vl_saldo_final, ',', '.')::NUMERIC
FROM relatorio_temporario;

SELECT 
    r.reg_ans,
    c.razao_social,
    SUM(r.vl_saldo_final) AS despesas_totais
FROM relatorios_trimestrais r
JOIN relatorio_cadop c ON r.reg_ans = c.registro_ans
WHERE r.descricao ILIKE 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS NA MODALIDADE DE PAGAMENTO POR PROCEDIMENTO'
AND r.data >= (
    SELECT DATE_TRUNC('quarter', MAX(data)) FROM relatorios_trimestrais
)
GROUP BY r.reg_ans, c.razao_social
ORDER BY despesas_totais DESC
LIMIT 10;

SELECT 
    r.reg_ans,
    c.razao_social,
    SUM(r.vl_saldo_final) AS despesas_totais
FROM relatorios_trimestrais r
JOIN relatorio_cadop c ON r.reg_ans = c.registro_ans
WHERE r.descricao ILIKE 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS NA MODALIDADE DE PAGAMENTO POR PROCEDIMENTO'
AND r.data >= (
    SELECT DATE_TRUNC('year', MAX(data)) FROM relatorios_trimestrais
) -- Obtém o primeiro dia do último ano disponível
GROUP BY r.reg_ans, c.razao_social
ORDER BY despesas_totais DESC
LIMIT 10;
