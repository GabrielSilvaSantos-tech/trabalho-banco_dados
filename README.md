# Trabalho de Banco de Dados - Plena Visão Vistoria

## Integrantes

| Nome completo do aluno | RGM | Usuário do GitHub |
| :--- | :--- | :--- |
| Gabriel da Silva Santos | 47256818 | GabrielSilvaSantos-tech |
| Gustavo Francisco dos Santos | [RGM] | [usuario] |
| Henrique Constantino | 47219190 | RiqueCosta27 |
| João Victor Rodrigues de Araujo | 4758565 | joaoaraujo2023-crypto |

---

## 1. Relatório Técnico / Modelagem de Dados

### 1.1 Revisão do Modelo Conceitual (Caso A)

* **Nome e natureza da organização:** Plena Visão Vistoria, empresa atuante no segmento de inspeção e verificação veicular (vistorias ECV e Cautelar).
* **Contexto e porte:** Empresa com fins lucrativos, contando com aproximadamente 6 funcionários e um volume operacional de 50 a 60 vistorias realizadas por dia.
* **Localização:** Av. Direitos Humanos, 38 - Imirim, São Paulo - SP.
* **Problemas e necessidades identificados:**
  * **P1:** Utilização de caderno e WhatsApp para anotações e registros das vistorias, gerando dispersão de dados.
  * **P2:** Dificuldade no controle estruturado do histórico de vistorias dos veículos.

#### Tabela de Correções da Entrega 1 (Caso A)
| Apontamento da correção da E1 | O que mudou no trabalho | Por quê |
| :--- | :--- | :--- |
| *Ajustes de modelagem e padronização* | *Remoção total de chaves estrangeiras (FK) do DER conceitual e ajustes nas cardinalidades.* | *Chaves estrangeiras pertencem exclusivamente ao modelo lógico e relacional, garantindo a conformidade teórica do modelo conceitual.* |

---

### 1.2 Conversão do Modelo Conceitual para o Modelo Lógico

* **Entidades -> Tabelas:** Cada entidade do modelo conceitual (`CLIENTE`, `VEICULO`, `VISTORIADOR`, `LOJA_PARCEIRA`, `TIPO_VISTORIA` e `VISTORIA`) foi convertida diretamente em uma tabela relacional própria.
* **Atributos -> Colunas:** Os atributos conceituais foram mapeados com seus respectivos tipos de dados (ex: `INT`, `VARCHAR`, `DECIMAL`, `DATETIME`) mantendo a integridade semântica.
* **Relacionamentos -> Chaves:** Os relacionamentos 1:N entre as entidades fortes (`CLIENTE`, `VEICULO`, `VISTORIADOR`, `TIPO_VISTORIA`) e a entidade central (`VISTORIA`) foram traduzidos via propagação de Chaves Primárias (PKs) como Chaves Estrangeiras (FKs) na tabela de relacionamento.
* **Cardinalidades:** As cardinalidades (1,N) do lado forte propagaram suas chaves primárias para a tabela `VISTORIA` (lado 0,N ou 1,N do serviço prestado).

---

### 1.3 Definição de Chaves Primárias e Estrangeiras

* **Tabela `CLIENTE`:**
  * **PK:** `id_cliente`
* **Tabela `VEICULO`:**
  * **PK:** `id_veiculo`
* **Tabela `VISTORIADOR`:**
  * **PK:** `id_vistoriador`
* **Tabela `LOJA_PARCEIRA`:**
  * **PK:** `id_loja`
* **Tabela `TIPO_VISTORIA`:**
  * **PK:** `id_tipo_vistoria`
* **Tabela `VISTORIA`:**
  * **PK:** `ordem_servico`
  * **FK:** `id_cliente` (referencia `CLIENTE(id_cliente)`)
  * **FK:** `id_veiculo` (referencia `VEICULO(id_veiculo)`)
  * **FK:** `id_vistoriador` (referencia `VISTORIADOR(id_vistoriador)`)
  * **FK:** `id_tipo_vistoria` (referencia `TIPO_VISTORIA(id_tipo_vistoria)`)
  * **FK:** `id_loja` (referencia `LOJA_PARCEIRA(id_loja)`)

---

### 1.4 Processo de Normalização (1FN, 2FN e 3FN)

* **1FN (Primeira Forma Normal):** Atributos multivalorados ou compostos foram eliminados. Endereços e dados de contato foram atomizados, e cada coluna possui apenas valores atômicos por tupla.
* **2FN (Segunda Forma Normal):** Garantido que todos os atributos não-chave dependam totalmente de toda a chave primária. Como todas as tabelas possuem chaves primárias simples, não há dependência parcial.
* **3FN (Terceira Forma Normal):** Eliminadas dependências transitivas entre atributos não-chave. Atributos derivados foram removidos do armazenamento bruto.
* **Justificativa do processo:** A normalização garante a eliminação de redundâncias, prevenindo anomalias de inserção, atualização e deleção no sistema da Plena Visão Vistoria.

---

### 1.5 Justificativas Técnicas das Decisões

* **Chaves Primárias:** Escolha de identificadores numéricos inteiros auto-incrementais (`INT AUTO_INCREMENT`) para garantir desempenho em junções (`JOINs`) e unicidade.
* **Chaves Estrangeiras:** Aplicação rigorosa das restrições de integridade referencial com `FOREIGN KEY`, garantindo que nenhuma vistoria seja registrada sem um cliente, veículo ou vistoriador válidos.
* **Restrições Aplicadas:** Uso de `NOT NULL` para campos obrigatórios (ex: `cpf`, `placa`), `UNIQUE` para evitar cadastros duplicados de veículos e CPFs, e `CHECK` para validar status e valores.

---

### 1.6 Proposta de Arquitetura Analítica para BI e IA

#### Informações Estratégicas e KPIs Propagados
1. **Faturamento Total por Período:** Cálculo do valor acumulado das vistorias realizadas para acompanhamento de metas financeiras.
2. **Volume de Vistorias por Vistoriador:** Métrica operacional para mensurar produtividade e eficiência da equipe técnica.
3. **Distribuição por Tipo de Vistoria (ECV vs Cautelar):** Acompanhamento da demanda por modalidade de serviço.

#### Tabela de Rastreabilidade
| Problema ou KPI | Tabelas Envolvidas | Consulta no Script |
| :--- | :--- | :--- |
| **P1 / KPI 1:** Desempenho e volume diário de vistorias | `VISTORIA`, `VISTORIADOR` | `G01` |
| **P2 / KPI 2:** Histórico completo de vistorias por veículo | `VEICULO`, `VISTORIA`, `TIPO_VISTORIA` | `G02` |
| **KPI 3:** Faturamento bruto mensal e por tipo de serviço | `VISTORIA`, `TIPO_VISTORIA` | `G03` |

#### Dicionario de Dados 
| Tabela | Coluna (Campo) | Tipo de Dado | Restrição / Chave | Descrição do Campo |
| :--- | :--- | :--- | :--- | :--- |
| **LOJA** | Codigo_Loja | INT | PK (Auto Increment) | Identificador único da loja parceira. |
| **LOJA** | Nome_Loja | VARCHAR(100) | NOT NULL | Nome comercial da revenda parceira. |
| **LOJA** | CNPJ_Loja | VARCHAR(20) | UNIQUE, NOT NULL | CNPJ oficial da empresa parceira. |
| **LOJA** | Descrição_Acordo | VARCHAR(255) | - | Regras ou termos da parceria comercial. |
| **CLIENTE** | Codigo_Cliente | INT | PK (Auto Increment) | Identificador único do cliente. |
| **CLIENTE** | CPF_ou_CNPJ | VARCHAR(20) | UNIQUE, NOT NULL | Documento de identificação do cliente. |
| **CLIENTE** | Nome_Completo | VARCHAR(150) | NOT NULL | Nome ou razão social do cliente. |
| **CLIENTE** | Tipo_Cliente | VARCHAR(50) | NOT NULL | Classificação ('Particular' ou 'Lojista'). |
| **CLIENTE** | idLOJA | INT | FK (Ref: LOJA) | Chave estrangeira para clientes lojistas vinculados. |
| **VEICULO** | Codigo_Veiculo | INT | PK (Auto Increment) | Identificador único do veículo. |
| **VEICULO** | Placa | VARCHAR(10) | UNIQUE, NOT NULL | Placa oficial de identificação do veículo. |
| **VEICULO** | Chassi | VARCHAR(30) | UNIQUE, NOT NULL | Número do chassi do veículo. |
| **VEICULO** | Renavam | VARCHAR(20) | UNIQUE, NOT NULL | Registro Nacional de Veículos Automotores. |
| **VEICULO** | Modelo_Marca | VARCHAR(100) | NOT NULL | Descrição da marca e modelo do automóvel. |
| **VISTORIADOR** | Codigo_Vistoriador | INT | PK (Auto Increment) | Identificador único do vistoriador. |
| **VISTORIADOR** | Nome_Vistoriador | VARCHAR(150) | NOT NULL | Nome completo do profissional técnico. |
| **VISTORIADOR** | CPF_Vistoriador | VARCHAR(20) | UNIQUE, NOT NULL | CPF do vistoriador responsável. |
| **TIPO_VISTORIA** | Codigo_TipoVistoria | INT | PK (Auto Increment) | Identificador único do tipo de serviço. |
| **TIPO_VISTORIA** | Codigo_Tipo | VARCHAR(20) | NOT NULL | Sigla interna da modalidade. |
| **TIPO_VISTORIA** | Nome_Tipo | VARCHAR(100) | NOT NULL | Nome oficial (ex: ECV, Vistoria Cautelar). |
| **TIPO_VISTORIA** | Descrições_Procedimentos | VARCHAR(255) | - | Resumo dos procedimentos executados na inspeção. |
| **PRECOS_VISTORIAS** | Codigo_Preço | INT | PK (Auto Increment) | Identificador único da tabela de preço. |
| **PRECOS_VISTORIAS** | Tipo_Cliente_Aplicavel | VARCHAR(50) | NOT NULL | Público-alvo da regra de preço ('Particular' ou 'Lojista'). |
| **PRECOS_VISTORIAS** | Valor_Base | FLOAT | NOT NULL | Valor financeiro cobrado pelo serviço. |
| **PRECOS_VISTORIAS** | Descrições_Regra | VARCHAR(255) | - | Detalhes sobre a aplicação da tarifa. |
| **PRECOS_VISTORIAS** | idTIPO_VISTORIA | INT | FK (Ref: TIPO_VISTORIA) | Vinculação com o tipo de serviço cobrado. |
| **VISTORIA** | Codigo_Vistoria | INT | PK (Auto Increment) | Número de ordem do atendimento realizado. |
| **VISTORIA** | Data_Hora | DATETIME | NOT NULL | Data e horário exatos da execução da vistoria. |
| **VISTORIA** | Resultado_Vistoria | VARCHAR(50) | NOT NULL | Status final do laudo ('Aprovado' ou 'Reprovado'). |
| **VISTORIA** | Observações | VARCHAR(255) | - | Apontamentos técnicos ou motivos de reprovação. |
| **VISTORIA** | Valor | FLOAT | NOT NULL | Preço cobrado no ato do atendimento. |
| **VISTORIA** | idTIPO_VISTORIA | INT | NOT NULL, FK | Tipo de vistoria realizada. |
| **VISTORIA** | idCLIENTE | INT | NOT NULL, FK | Cliente que solicitou o serviço. |
| **VISTORIA** | idVEICULO | INT | NOT NULL, FK | Veículo inspecionado na pista. |
| **VISTORIA** | idVISTORIADOR | INT | NOT NULL, FK | Profissional técnico responsável pelo laudo. |

## 3. Implementação do Banco de Dados (SQL)

O script completo foi desenvolvido para o SGBD MySQL, contemplando a criação do banco, tabelas, restrições (chaves primárias e estrangeiras) e a massa de dados corporativa.

```sql
-- =====================================================================
-- SISTEMA DE GESTÃO: PLENA VISÃO VISTORIA
-- AUTOR: Equipe Técnica / Gabriel
-- =====================================================================

CREATE DATABASE IF NOT EXISTS plena_visao_vistoria;
USE plena_visao_vistoria;

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

-- Massa de Dados
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
