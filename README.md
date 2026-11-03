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
