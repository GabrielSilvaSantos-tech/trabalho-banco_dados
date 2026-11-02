# Trabalho de Banco de Dados - Plena Visão Vistoria

## Integrantes do Grupo
* **Nome completo do aluno:** Gabriel da Silva Santos | **RGM:** [Seu RGM] | **Usuário do GitHub:** `GabrielSilvaSantos-tech`
* Henrique Constantino
* Gustavo Francisco dos Santos
* João Victor Rodrigues de Araujo

---

## 1. Relatório Técnico / Modelagem de Dados

### 1.1 Revisão do Modelo Conceitual (Caso A)

* **Nome e natureza da organização:** Plena Visão Vistoria, empresa atuante no segmento de inspeção e verificação veicular (vistorias ECV e Cautelar).
* **Contexto e porte:** Empresa com fins lucrativos, contando com aproximadamente 6 funcionários e um volume operacional de 50 a 60 vistorias realizadas por dia.
* **Localização:** Av. Direitos Humanos, 38 - Imirim, São Paulo - SP
* **Problemas e necessidades identificados:**
  * **P1:** Utilização de caderno e WhatsApp para anotações e registros das vistorias, gerando dispersão de dados.
  * **P2:** Dificuldade no controle estruturado do histórico de vistorias dos veículos.
#### Tabela de Correções da Entrega 1 (Caso A)
| Apontamento da correção da E1 | O que mudou no trabalho | Por quê |
| :--- | :--- | :--- |
| *Ajustes de modelagem e padronização* | *Remoção total de chaves estrangeiras (FK) do DER conceitual e ajustes nas cardinalidades*. | *Chaves estrangeiras pertencem exclusivamente ao modelo lógico e relacional, garantindo a conformidade teórica do modelo conceitual*. |
