-- =====================================================================
-- SISTEMA DE GESTÃO: PLENA VISÃO VISTORIA
-- SGBD: MySQL
-- ARQUIVO: docs/script.sql
-- =====================================================================

CREATE DATABASE IF NOT EXISTS plena_visao_vistoria;
USE plena_visao_vistoria;

-- 1. CRIAÇÃO DAS TABELAS (DDL)

CREATE TABLE LOJA (
    Codigo_Loja INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Loja VARCHAR(100) NOT NULL,
    CNPJ_Loja VARCHAR(20) UNIQUE NOT NULL,
    Descrição_Acordo VARCHAR(255)
);

CREATE TABLE CLIENTE (
    Codigo_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    CPF_ou_CNPJ VARCHAR(20) UNIQUE NOT NULL,
    Nome_Completo VARCHAR(150) NOT NULL,
    Tipo_Cliente VARCHAR(50) NOT NULL,
    idLOJA INT,
    CONSTRAINT fk_cliente_loja FOREIGN KEY (idLOJA) REFERENCES LOJA(Codigo_Loja)
);

CREATE TABLE VEICULO (
    Codigo_Veiculo INT AUTO_INCREMENT PRIMARY KEY,
    Placa VARCHAR(10) UNIQUE NOT NULL,
    Chassi VARCHAR(30) UNIQUE NOT NULL,
    Renavam VARCHAR(20) UNIQUE NOT NULL,
    Modelo_Marca VARCHAR(100) NOT NULL
);

CREATE TABLE VISTORIADOR (
    Codigo_Vistoriador INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Vistoriador VARCHAR(150) NOT NULL,
    CPF_Vistoriador VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE TIPO_VISTORIA (
    Codigo_TipoVistoria INT AUTO_INCREMENT PRIMARY KEY,
    Codigo_Tipo VARCHAR(20) NOT NULL,
    Nome_Tipo VARCHAR(100) NOT NULL,
    Descrições_Procedimentos VARCHAR(255)
);

CREATE TABLE PRECOS_VISTORIAS (
    Codigo_Preço INT AUTO_INCREMENT PRIMARY KEY,
    Tipo_Cliente_Aplicavel VARCHAR(50) NOT NULL,
    Valor_Base FLOAT NOT NULL,
    Descrições_Regra VARCHAR(255),
    idTIPO_VISTORIA INT,
    CONSTRAINT fk_preco_tipo FOREIGN KEY (idTIPO_VISTORIA) REFERENCES TIPO_VISTORIA(Codigo_TipoVistoria)
);

CREATE TABLE VISTORIA (
    Codigo_Vistoria INT AUTO_INCREMENT PRIMARY KEY,
    Data_Hora DATETIME NOT NULL,
    Resultado_Vistoria VARCHAR(50) NOT NULL,
    Observações VARCHAR(255),
    Valor FLOAT NOT NULL,
    idTIPO_VISTORIA INT NOT NULL,
    idCLIENTE INT NOT NULL,
    idVEICULO INT NOT NULL,
    idVISTORIADOR INT NOT NULL,
    CONSTRAINT fk_vistoria_tipo FOREIGN KEY (idTIPO_VISTORIA) REFERENCES TIPO_VISTORIA(Codigo_TipoVistoria),
    CONSTRAINT fk_vistoria_cliente FOREIGN KEY (idCLIENTE) REFERENCES CLIENTE(Codigo_Cliente),
    CONSTRAINT fk_vistoria_veiculo FOREIGN KEY (idVEICULO) REFERENCES VEICULO(Codigo_Veiculo),
    CONSTRAINT fk_vistoria_vistoriador FOREIGN KEY (idVISTORIADOR) REFERENCES VISTORIADOR(Codigo_Vistoriador)
);

-- 2. INSERÇÃO DA MASSA DE DADOS (DML)

INSERT INTO LOJA (Nome_Loja, CNPJ_Loja, Descrição_Acordo) VALUES 
('Auto nove', '11.264.870/0001-94', 'Parceria corporativa com benefícios em vistorias.'),
('Carangos Premium', '26.993.930/0001-87', 'Parceria ativa para lojistas parceiros.');

INSERT INTO CLIENTE (CPF_ou_CNPJ, Nome_Completo, Tipo_Cliente, idLOJA) VALUES 
('111.222.333-44', 'Carlos Alberto da Silva', 'Particular', NULL),
('555.666.777-88', 'Mariana Souza Lima', 'Particular', NULL),
('26.993.930/0001-87', 'Carangos Premium', 'Lojista', 2),
('11.264.870/0001-94', 'Auto nove', 'Lojista', 1);

INSERT INTO VEICULO (Placa, Chassi, Renavam, Modelo_Marca) VALUES 
('ABC1D23', '9BWZZZ377VT001234', '12345678901', 'Volkswagen Gol 1.6'),
('XYZ9W87', '8APZZZ277JY987654', '09876543210', 'Chevrolet Onix Plus'),
('TJG1F85', '4S3BR6BD9E3123456', '11223344556', 'Porsche 718 Cayman');

INSERT INTO VISTORIADOR (Nome_Vistoriador, CPF_Vistoriador) VALUES 
('Durval Aparecido Maffia', '333.444.555-66'),
('Danilo Sicko', '777.888.999-00'),
('Leandro Amaral', '222.333.444-55');

INSERT INTO TIPO_VISTORIA (Codigo_Tipo, Nome_Tipo, Descrições_Procedimentos) VALUES 
('ECV_TRANSF', 'ECV', 'Inspeção obrigatória de identificação veicular.'),
('CAUTELAR', 'Vistoria Cautelar', 'Análise completa de estrutura, pintura e histórico.');

INSERT INTO PRECOS_VISTORIAS (Tipo_Cliente_Aplicavel, Valor_Base, Descrições_Regra, idTIPO_VISTORIA) VALUES 
('Particular', 135.00, 'Preço padrão para ECV', 1),
('Lojista', 110.00, 'Preço especial lojista ECV', 1),
('Particular', 299.00, 'Preço padrão para Cautelar', 2),
('Lojista', 250.00, 'Preço corporativo Cautelar', 2);

INSERT INTO VISTORIA (Data_Hora, Resultado_Vistoria, Observações, Valor, idTIPO_VISTORIA, idCLIENTE, idVEICULO, idVISTORIADOR) VALUES 
('2026-10-10 09:30:00', 'Aprovado', 'Veículo em perfeito estado de conservação.', 135.00, 1, 1, 1, 1),
('2026-10-10 10:45:00', 'Aprovado', 'Pequeno detalhe de pintura na lateral direita.', 299.00, 2, 3, 3, 2),
('2026-10-11 14:15:00', 'Reprovado', 'Número do motor divergente', 135.00, 1, 2, 2, 3);

-- 3. CONSULTAS GERENCIAIS E DE AUDITORIA

-- G01 - Relatório Geral de Atendimentos Realizados
SELECT 
    v.Codigo_Vistoria AS ID,
    DATE_FORMAT(v.Data_Hora, '%d/%m/%Y %H:%i') AS Data_Atendimento,
    c.Nome_Completo AS Cliente,
    c.Tipo_Cliente,
    ve.Placa,
    ve.Modelo_Marca AS Veiculo,
    tv.Nome_Tipo AS Servico,
    vis.Nome_Vistoriador AS Vistoriador,
    v.Resultado_Vistoria AS Resultado,
    CONCAT('R$ ', FORMAT(v.Valor, 2, 'pt_BR')) AS Valor_Pago
FROM VISTORIA v
JOIN CLIENTE c ON v.idCLIENTE = c.Codigo_Cliente
JOIN VEICULO ve ON v.idVEICULO = ve.Codigo_Veiculo
JOIN TIPO_VISTORIA tv ON v.idTIPO_VISTORIA = tv.Codigo_TipoVistoria
JOIN VISTORIADOR vis ON v.idVISTORIADOR = vis.Codigo_Vistoriador
ORDER BY v.Codigo_Vistoria ASC;

-- A01 - Auditoria de Laudos Reprovados com Detalhamento de Motivo
SELECT 
    v.Codigo_Vistoria AS ID_Laudo,
    ve.Placa,
    c.Nome_Completo AS Proprietario,
    v.Resultado_Vistoria AS Status_Laudo,
    v.Observações AS Motivo_Reprovacao
FROM VISTORIA v
JOIN VEICULO ve ON v.idVEICULO = ve.Codigo_Veiculo
JOIN CLIENTE c ON v.idCLIENTE = c.Codigo_Cliente
WHERE v.Resultado_Vistoria = 'Reprovado';
