CREATE DATABASE IF NOT EXISTS Verdurão_Silva CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE Verdurão_Silva;

DROP TABLE IF EXISTS Promocoes;
DROP TABLE IF EXISTS Contas_Pagar;
DROP TABLE IF EXISTS Contas_Receber;
DROP TABLE IF EXISTS Perdas_Descartes;
DROP TABLE IF EXISTS Itens_Venda;
DROP TABLE IF EXISTS Vendas;
DROP TABLE IF EXISTS Funcionarios;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Itens_Compra;
DROP TABLE IF EXISTS Compras_Entrada;
DROP TABLE IF EXISTS Produtos;
DROP TABLE IF EXISTS Categorias;
DROP TABLE IF EXISTS Fornecedores;

CREATE TABLE IF NOT EXISTS Fornecedores (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome_empresa_produtor VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    cidade VARCHAR(50),
    estado CHAR(2) DEFAULT 'PR',
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS Categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT,
    nome VARCHAR(100) NOT NULL UNIQUE,
    preco_venda DECIMAL(10,2) NOT NULL,
    unidade_medida VARCHAR(10) NOT NULL,
    quantidade_estoque DECIMAL(10,3) DEFAULT 0.000,
    estoque_minimo DECIMAL(10,3) DEFAULT 5.000,
    organico BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);

CREATE TABLE IF NOT EXISTS Compras_Entrada (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor INT NOT NULL,
    data_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedores(id_fornecedor)
);

CREATE TABLE IF NOT EXISTS Itens_Compra (
    id_item_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade DECIMAL(10,3) NOT NULL,
    preco_custo_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES Compras_Entrada(id_compra),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

CREATE TABLE IF NOT EXISTS Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco VARCHAR(200),
    data_cadastro DATE,
    limite_credito DECIMAL(10,2) DEFAULT 0.00
);

CREATE TABLE IF NOT EXISTS Funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    telefone VARCHAR(20),
    data_admissao DATE NOT NULL,
    salario DECIMAL(10,2),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS Vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NULL,
    id_funcionario INT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    forma_pagamento VARCHAR(30) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0.00,
    valor_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionarios(id_funcionario)
);

CREATE TABLE IF NOT EXISTS Itens_Venda (
    id_item_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade DECIMAL(10,3) NOT NULL,
    preco_aplicado DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venda) REFERENCES Vendas(id_venda),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

CREATE TABLE IF NOT EXISTS Perdas_Descartes (
    id_perda INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    quantidade_perdida DECIMAL(10,3) NOT NULL,
    motivo VARCHAR(100) NOT NULL,
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

CREATE TABLE IF NOT EXISTS Contas_Receber (
    id_conta_receber INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_venda INT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE NULL,
    status VARCHAR(20) DEFAULT 'Pendente',
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_venda) REFERENCES Vendas(id_venda)
);

CREATE TABLE IF NOT EXISTS Contas_Pagar (
    id_conta_pagar INT AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor INT NOT NULL,
    id_compra INT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE NULL,
    status VARCHAR(20) DEFAULT 'Pendente',
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedores(id_fornecedor),
    FOREIGN KEY (id_compra) REFERENCES Compras_Entrada(id_compra)
);

CREATE TABLE IF NOT EXISTS Promocoes (
    id_promocao INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    preco_promocional DECIMAL(10,2) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

INSERT INTO Fornecedores (nome_empresa_produtor, cpf_cnpj, telefone, email, cidade, estado) VALUES
('Sítio Boa Colheita',          '12.345.678/0001-90', '(41) 99111-0001', 'contato@boacolheita.com.br',  'Colombo',              'PR'),
('Chácara Primavera',           '23.456.789/0001-01', '(41) 99111-0002', 'chacaraprimavera@email.com',  'São José dos Pinhais', 'PR'),
('CEASA Curitiba Distribuidora','34.567.890/0001-12', '(41) 3333-0003',  'vendas@ceasacwb.com.br',      'Curitiba',             'PR'),
('João Batista Produtor Rural', '123.456.789-09',     '(41) 99111-0004', NULL,                          'Mandirituba',          'PR'),
('Fazenda Frutas do Sul',       '45.678.901/0001-23', '(41) 99111-0005', 'comercial@frutasdosul.com.br','Araucária',            'PR'),
('Hortifruti Serra Verde',      '56.789.012/0001-34', '(42) 99111-0006', 'serraverde@email.com',        'Lapa',                 'PR');

INSERT INTO Categorias (nome_categoria, descricao) VALUES
('Frutas',            'Frutas frescas nacionais e da estação'),
('Verduras',          'Folhosas frescas, vendidas por unidade ou maço'),
('Legumes',           'Legumes e tubérculos'),
('Temperos e Ervas',  'Temperos frescos e condimentos'),
('Ovos e Outros',     'Ovos caipira e itens complementares');

INSERT INTO Produtos (id_categoria, nome, preco_venda, unidade_medida, quantidade_estoque, estoque_minimo, organico) VALUES
(1, 'Banana Prata',          6.99, 'KG',    41.500, 10.000, FALSE),
(1, 'Maçã Gala',             8.99, 'KG',    37.000, 10.000, FALSE),
(1, 'Laranja Pera',          4.99, 'KG',    68.000, 15.000, FALSE),
(1, 'Mamão Papaya',          5.99, 'KG',    26.500,  8.000, FALSE),
(2, 'Alface Crespa',         3.50, 'UN',    52.000, 15.000, TRUE),
(2, 'Couve Manteiga',        3.00, 'MACO',  34.000, 10.000, TRUE),
(2, 'Rúcula',                3.20, 'MACO',  28.000, 10.000, TRUE),
(3, 'Tomate',                7.99, 'KG',    35.000, 10.000, FALSE),
(3, 'Batata Inglesa',        5.49, 'KG',    95.000, 20.000, FALSE),
(3, 'Cenoura',               4.99, 'KG',    57.000, 15.000, FALSE),
(3, 'Cebola',                4.49, 'KG',    77.000, 20.000, FALSE),
(3, 'Abobrinha',             6.50, 'KG',    24.000,  8.000, FALSE),
(4, 'Cheiro-Verde',          2.50, 'MACO',  49.000, 15.000, FALSE),
(4, 'Alho',                 29.90, 'KG',      4.500,  2.000, FALSE),
(5, 'Ovos Caipira (dúzia)', 14.00, 'DZ',    27.000, 10.000, FALSE);

INSERT INTO Compras_Entrada (id_fornecedor, data_compra, valor_total) VALUES
(1, '2026-09-28 06:30:00', 465.00),
(2, '2026-09-29 06:45:00', 183.00),
(3, '2026-09-30 05:50:00', 704.00),
(5, '2026-10-01 07:00:00', 504.00),
(4, '2026-10-02 06:20:00', 420.00);

INSERT INTO Itens_Compra (id_compra, id_produto, quantidade, preco_custo_unitario) VALUES
(1, 1,  50.000, 3.80),
(1, 8,  40.000, 4.50),
(1, 12, 25.000, 3.80),
(2, 5,  60.000, 1.60),
(2, 6,  40.000, 1.20),
(2, 7,  30.000, 1.30),
(3, 9, 100.000, 3.20),
(3, 11, 80.000, 2.70),
(3, 10, 60.000, 2.80),
(4, 2,  40.000, 5.50),
(4, 3,  70.000, 2.60),
(4, 4,  30.000, 3.40),
(5, 15, 30.000, 9.00),
(5, 13, 50.000, 1.20),
(5, 14,  5.000, 18.00);

INSERT INTO Clientes (nome, cpf, telefone, email, endereco, data_cadastro, limite_credito) VALUES
('Ana Beatriz Ferreira', '111.222.333-44', '(41) 99888-1001', 'ana.ferreira@email.com',  'Rua das Flores, 120 - Água Verde, Curitiba',     '2026-01-15', 200.00),
('Roberto Almeida',      '222.333.444-55', '(41) 99888-1002', 'roberto.almeida@email.com','Av. Sete de Setembro, 3400 - Centro, Curitiba', '2026-02-03', 0.00),
('Fernanda Gomes',       '333.444.555-66', '(41) 99888-1003', NULL,                       'Rua XV de Novembro, 85 - Batel, Curitiba',       '2026-03-10', 150.00),
('Dona Lúcia Martins',   '444.555.666-77', '(41) 99888-1004', NULL,                       'Rua Pernambuco, 560 - Portão, Curitiba',         '2025-11-20', 300.00),
('Paulo Henrique Dias',  '555.666.777-88', '(41) 99888-1005', 'paulo.dias@email.com',     'Rua Mateus Leme, 900 - Bom Retiro, Curitiba',    '2026-05-22', 100.00),
('Restaurante Sabor Caseiro', '666.777.888-99', '(41) 3222-1006', 'contato@sabor-caseiro.com', 'Rua Marechal Deodoro, 210 - Centro, Curitiba', '2026-06-01', 800.00);

INSERT INTO Funcionarios (nome, cargo, telefone, data_admissao, salario) VALUES
('Carlos Silva',     'Gerente',     '(41) 99777-2001', '2020-03-01', 4500.00),
('Mariana Souza',    'Caixa',       '(41) 99777-2002', '2022-07-15', 2100.00),
('Pedro Lima',       'Atendente',   '(41) 99777-2003', '2023-01-10', 1850.00),
('Rafael Costa',     'Repositor',  '(41) 99777-2004', '2023-09-05', 1950.00),
('Juliana Alves',    'Caixa',       '(41) 99777-2005', '2024-02-19', 2100.00),
('Marcos Pereira',   'Auxiliar de Estoque',  '(41) 99777-2006', '2025-04-01', 1950.00);

INSERT INTO Vendas (id_cliente, id_funcionario, data_hora, forma_pagamento, desconto, valor_total) VALUES
(1,    2, '2026-10-01 09:15:00', 'Pix',               0.00, 21.97),
(NULL, 5, '2026-10-01 10:40:00', 'Dinheiro',          0.00, 11.99),
(2,    2, '2026-10-02 11:05:00', 'Cartão de Crédito', 0.95, 50.00),
(3,    5, '2026-10-02 16:20:00', 'Pix',               0.00, 51.38),
(4,    2, '2026-10-03 08:50:00', 'Fiado',             0.00, 30.98),
(5,    5, '2026-10-03 17:30:00', 'Cartão de Débito',  0.00, 32.95),
(6,    2, '2026-10-04 07:45:00', 'Pix',               0.00, 37.90),
(NULL, 5, '2026-10-04 12:10:00', 'Dinheiro',          0.00, 14.47);

INSERT INTO Itens_Venda (id_venda, id_produto, quantidade, preco_aplicado) VALUES
(1, 1,  2.000, 6.99),
(1, 8,  1.000, 7.99),
(2, 5,  2.000, 3.50),
(2, 10, 1.000, 4.99),
(3, 2,  3.000, 8.99),
(3, 3,  2.000, 4.99),
(3, 15, 1.000, 14.00),
(4, 9,  5.000, 5.49),
(4, 11, 2.000, 4.49),
(4, 14, 0.500, 29.90),
(5, 8,  2.000, 7.99),
(5, 12, 1.000, 6.50),
(5, 6,  2.000, 3.00),
(5, 13, 1.000, 2.50),
(6, 4,  2.000, 5.99),
(6, 1,  3.000, 6.99),
(7, 15, 2.000, 14.00),
(7, 7,  2.000, 3.20),
(7, 5,  1.000, 3.50),
(8, 10, 2.000, 4.99),
(8, 11, 1.000, 4.49);

INSERT INTO Perdas_Descartes (id_produto, quantidade_perdida, motivo, data_registro) VALUES
(1, 3.500, 'Maduras demais',          '2026-10-02 18:00:00'),
(5, 5.000, 'Folhas murchas',          '2026-10-02 18:10:00'),
(8, 2.000, 'Amassados no transporte', '2026-10-03 18:00:00'),
(4, 1.500, 'Apodrecimento',           '2026-10-03 18:15:00'),
(6, 4.000, 'Folhas amareladas',       '2026-10-04 18:00:00');

INSERT INTO Contas_Receber (id_cliente, id_venda, valor, data_vencimento, data_pagamento, status) VALUES
(4, 5,    30.98,  '2026-10-15', NULL,         'Pendente'),
(4, NULL, 45.00,  '2026-09-20', '2026-09-22', 'Pago'),
(6, NULL, 120.00, '2026-09-30', NULL,         'Atrasado');

INSERT INTO Contas_Pagar (id_fornecedor, id_compra, valor, data_vencimento, data_pagamento, status) VALUES
(1, 1, 465.00, '2026-10-12', NULL,         'Pendente'),
(2, 2, 183.00, '2026-10-06', NULL,         'Pendente'),
(3, 3, 704.00, '2026-10-05', '2026-10-05', 'Pago'),
(5, 4, 504.00, '2026-10-15', NULL,         'Pendente'),
(4, 5, 420.00, '2026-10-02', '2026-10-02', 'Pago');

INSERT INTO Promocoes (id_produto, descricao, preco_promocional, data_inicio, data_fim) VALUES
(5, 'Terça da Verdura - Alface',  2.99, '2026-10-06', '2026-10-06'),
(7, 'Terça da Verdura - Rúcula',  2.50, '2026-10-06', '2026-10-06'),
(1, 'Quarta da Fruta - Banana',   5.99, '2026-10-07', '2026-10-07'),
(9, 'Oferta da Semana - Batata',  4.79, '2026-10-05', '2026-10-11');

DELIMITER $$

CREATE PROCEDURE sp_categoria_inserir(
    IN p_nome_categoria VARCHAR(50),
    IN p_descricao TEXT
)
BEGIN
    IF p_nome_categoria IS NULL OR TRIM(p_nome_categoria) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da categoria não pode ser vazio.';
    END IF;
    IF p_descricao IS NULL OR TRIM(p_descricao) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A descrição da categoria não pode ser vazia.';
    END IF;

    INSERT INTO Categorias (nome_categoria, descricao)
    VALUES (TRIM(p_nome_categoria), TRIM(p_descricao));

    SELECT LAST_INSERT_ID() AS id_categoria_criada;
END$$

CREATE PROCEDURE sp_categoria_listar()
BEGIN
    SELECT id_categoria, nome_categoria, descricao
    FROM Categorias
    ORDER BY nome_categoria;
END$$

CREATE PROCEDURE sp_categoria_buscar(IN p_id_categoria INT)
BEGIN
    SELECT id_categoria, nome_categoria, descricao
    FROM Categorias
    WHERE id_categoria = p_id_categoria;
END$$

CREATE PROCEDURE sp_categoria_atualizar(
    IN p_id_categoria INT,
    IN p_nome_categoria VARCHAR(50),
    IN p_descricao TEXT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Categorias WHERE id_categoria = p_id_categoria) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Categoria não encontrada.';
    END IF;
    IF p_nome_categoria IS NULL OR TRIM(p_nome_categoria) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome da categoria não pode ser vazio.';
    END IF;
    IF p_descricao IS NULL OR TRIM(p_descricao) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A descrição da categoria não pode ser vazia.';
    END IF;

    UPDATE Categorias
    SET nome_categoria = TRIM(p_nome_categoria),
        descricao = TRIM(p_descricao)
    WHERE id_categoria = p_id_categoria;
END$$

CREATE PROCEDURE sp_categoria_excluir(IN p_id_categoria INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Categorias WHERE id_categoria = p_id_categoria) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Categoria não encontrada.';
    END IF;
    IF EXISTS (SELECT 1 FROM Produtos WHERE id_categoria = p_id_categoria) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível excluir: existem produtos nesta categoria.';
    END IF;

    DELETE FROM Categorias WHERE id_categoria = p_id_categoria;
END$$

CREATE PROCEDURE sp_produto_inserir(
    IN p_id_categoria INT,
    IN p_nome VARCHAR(100),
    IN p_preco_venda DECIMAL(10,2),
    IN p_unidade_medida VARCHAR(10),
    IN p_quantidade_estoque DECIMAL(10,3),
    IN p_estoque_minimo DECIMAL(10,3),
    IN p_organico BOOLEAN
)
BEGIN
    IF p_nome IS NULL OR TRIM(p_nome) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do produto não pode ser vazio.';
    END IF;
    IF p_preco_venda IS NULL OR p_preco_venda <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O preço de venda deve ser maior que zero.';
    END IF;
    IF p_unidade_medida IS NULL OR TRIM(p_unidade_medida) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A unidade de medida não pode ser vazia.';
    END IF;
    IF p_id_categoria IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM Categorias WHERE id_categoria = p_id_categoria) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Categoria informada não existe.';
    END IF;

    INSERT INTO Produtos (id_categoria, nome, preco_venda, unidade_medida,
                          quantidade_estoque, estoque_minimo, organico)
    VALUES (p_id_categoria, TRIM(p_nome), p_preco_venda, UPPER(TRIM(p_unidade_medida)),
            IFNULL(p_quantidade_estoque, 0), IFNULL(p_estoque_minimo, 5), IFNULL(p_organico, FALSE));

    SELECT LAST_INSERT_ID() AS id_produto_criado;
END$$

CREATE PROCEDURE sp_produto_listar()
BEGIN
    SELECT p.id_produto,
           p.nome,
           c.nome_categoria,
           p.preco_venda,
           p.unidade_medida,
           p.quantidade_estoque,
           p.estoque_minimo,
           p.organico,
           p.ativo
    FROM Produtos p
    LEFT JOIN Categorias c ON c.id_categoria = p.id_categoria
    ORDER BY p.nome;
END$$

CREATE PROCEDURE sp_produto_buscar(IN p_id_produto INT)
BEGIN
    SELECT p.id_produto,
           p.nome,
           c.nome_categoria,
           p.preco_venda,
           p.unidade_medida,
           p.quantidade_estoque,
           p.estoque_minimo,
           p.organico,
           p.ativo
    FROM Produtos p
    LEFT JOIN Categorias c ON c.id_categoria = p.id_categoria
    WHERE p.id_produto = p_id_produto;
END$$

CREATE PROCEDURE sp_produto_atualizar(
    IN p_id_produto INT,
    IN p_id_categoria INT,
    IN p_nome VARCHAR(100),
    IN p_preco_venda DECIMAL(10,2),
    IN p_unidade_medida VARCHAR(10),
    IN p_quantidade_estoque DECIMAL(10,3),
    IN p_estoque_minimo DECIMAL(10,3),
    IN p_organico BOOLEAN,
    IN p_ativo BOOLEAN
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Produtos WHERE id_produto = p_id_produto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto não encontrado.';
    END IF;
    IF p_nome IS NULL OR TRIM(p_nome) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O nome do produto não pode ser vazio.';
    END IF;
    IF p_preco_venda IS NULL OR p_preco_venda <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O preço de venda deve ser maior que zero.';
    END IF;
    IF p_unidade_medida IS NULL OR TRIM(p_unidade_medida) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A unidade de medida não pode ser vazia.';
    END IF;
    IF p_id_categoria IS NOT NULL
       AND NOT EXISTS (SELECT 1 FROM Categorias WHERE id_categoria = p_id_categoria) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Categoria informada não existe.';
    END IF;

    UPDATE Produtos
    SET id_categoria = p_id_categoria,
        nome = TRIM(p_nome),
        preco_venda = p_preco_venda,
        unidade_medida = UPPER(TRIM(p_unidade_medida)),
        quantidade_estoque = IFNULL(p_quantidade_estoque, 0),
        estoque_minimo = IFNULL(p_estoque_minimo, 5),
        organico = IFNULL(p_organico, FALSE),
        ativo = IFNULL(p_ativo, TRUE)
    WHERE id_produto = p_id_produto;
END$$

CREATE PROCEDURE sp_produto_excluir(IN p_id_produto INT)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Produtos WHERE id_produto = p_id_produto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto não encontrado.';
    END IF;
    IF EXISTS (SELECT 1 FROM Itens_Compra WHERE id_produto = p_id_produto)
       OR EXISTS (SELECT 1 FROM Itens_Venda WHERE id_produto = p_id_produto)
       OR EXISTS (SELECT 1 FROM Perdas_Descartes WHERE id_produto = p_id_produto)
       OR EXISTS (SELECT 1 FROM Promocoes WHERE id_produto = p_id_produto) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Não é possível excluir: o produto possui compras, vendas, perdas ou promoções. Inative-o pela atualização.';
    END IF;

    DELETE FROM Produtos WHERE id_produto = p_id_produto;
END$$

DELIMITER ;

CALL sp_categoria_inserir('Grãos e Cereais', 'Feijão, arroz e outros grãos vendidos a granel');
SET @id_categoria_teste = LAST_INSERT_ID();
CALL sp_categoria_listar();
CALL sp_categoria_buscar(@id_categoria_teste);
CALL sp_categoria_atualizar(@id_categoria_teste, 'Grãos e Cereais', 'Feijão, arroz, lentilha e outros grãos vendidos a granel');

CALL sp_produto_inserir(@id_categoria_teste, 'Feijão Carioca', 8.90, 'KG', 20.000, 5.000, FALSE);
SET @id_produto_teste = LAST_INSERT_ID();
CALL sp_produto_buscar(@id_produto_teste);
CALL sp_produto_atualizar(@id_produto_teste, @id_categoria_teste, 'Feijão Carioca', 9.50, 'KG', 25.000, 5.000, FALSE, TRUE);
CALL sp_produto_listar();
CALL sp_produto_excluir(@id_produto_teste);
CALL sp_categoria_excluir(@id_categoria_teste);

SELECT p.nome AS produto,
       c.nome_categoria AS categoria,
       p.preco_venda,
       p.quantidade_estoque
FROM Produtos p
INNER JOIN Categorias c ON c.id_categoria = p.id_categoria
ORDER BY c.nome_categoria, p.nome;

SELECT v.id_venda,
       v.data_hora,
       f.nome AS funcionario,
       pr.nome AS produto,
       iv.quantidade,
       iv.preco_aplicado,
       (iv.quantidade * iv.preco_aplicado) AS subtotal
FROM Vendas v
INNER JOIN Funcionarios f ON f.id_funcionario = v.id_funcionario
INNER JOIN Itens_Venda iv ON iv.id_venda = v.id_venda
INNER JOIN Produtos pr ON pr.id_produto = iv.id_produto
ORDER BY v.id_venda, pr.nome;

SELECT p.nome AS produto,
       p.quantidade_estoque,
       pd.quantidade_perdida,
       pd.motivo,
       pd.data_registro
FROM Produtos p
LEFT JOIN Perdas_Descartes pd ON pd.id_produto = p.id_produto
ORDER BY p.nome;

SELECT fo.nome_empresa_produtor AS fornecedor,
       fo.cidade,
       ce.id_compra,
       ce.data_compra,
       ce.valor_total
FROM Fornecedores fo
LEFT JOIN Compras_Entrada ce ON ce.id_fornecedor = fo.id_fornecedor
ORDER BY fo.nome_empresa_produtor;

SELECT f.nome AS funcionario,
       f.cargo,
       v.id_venda,
       v.data_hora,
       v.valor_total
FROM Vendas v
RIGHT JOIN Funcionarios f ON f.id_funcionario = v.id_funcionario
ORDER BY f.nome, v.data_hora;

SELECT c.nome_categoria AS categoria,
       p.nome AS produto
FROM Produtos p
RIGHT JOIN Categorias c ON c.id_categoria = p.id_categoria
ORDER BY c.nome_categoria, p.nome;