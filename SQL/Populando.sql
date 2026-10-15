INSERT INTO categoria (nome, descricao) VALUES
('Periféricos', 'Teclados, mouses e acessórios'),
('Monitores', 'Monitores gamer e para escritório'),
('Hardware', 'Componentes internos de computadores'),
('Áudio', 'Headsets, fones e caixas de som'),
('Armazenamento', 'SSDs, HDs e Pendrives');

INSERT INTO cliente (nome, cpf, email, data_cadastro) VALUES
('Ana Silva', '111.222.333-44', 'ana.silva@email.com', '2025-01-10'),
('Bruno Costa', '222.333.444-55', 'bruno.costa@email.com', '2025-01-15'),
('Carla Souza', '333.444.555-66', 'carla.souza@email.com', '2025-02-01'),
('Daniel Alves', '444.555.666-77', 'daniel.alves@email.com', '2025-02-10'),
('Eduarda Lima', '555.666.777-88', 'eduarda.lima@email.com', '2025-03-01');

INSERT INTO telefone_cliente (id_cliente, numero) VALUES
(1, '(11) 98888-1111'),
(1, '(11) 3333-1111'),
(2, '(21) 97777-2222'),
(3, '(31) 96666-3333'),
(4, '(41) 95555-4444'),
(5, '(51) 94444-5555');

INSERT INTO endereco_cliente (id_cliente, logradouro, cidade, estado, cep) VALUES
(1, 'Rua das Flores, 123', 'São Paulo', 'SP', '01001-000'),
(2, 'Av. Copacabana, 456', 'Rio de Janeiro', 'RJ', '22020-001'),
(3, 'Rua da Bahia, 789', 'Belo Horizonte', 'MG', '30160-011'),
(4, 'Rua das Palmeiras, 101', 'Curitiba', 'PR', '80010-000'),
(5, 'Av. Ipiranga, 202', 'Porto Alegre', 'RS', '90160-091');

INSERT INTO produto (id_categoria, nome, preco_atual, quantidade_estoque) VALUES
(1, 'Teclado Mecânico RGB', 250.00, 30),
(1, 'Mouse Gamer 16000 DPI', 150.00, 50),
(2, 'Monitor 27 Polegadas 144Hz', 1200.00, 12),
(3, 'Placa de Vídeo RTX 4060', 2300.00, 5),
(4, 'Headset 7.1 Surround', 350.00, 20),
(5, 'SSD NVMe 1TB', 450.00, 40);

INSERT INTO pedido (id_cliente, data_pedido, status_pedido) VALUES
(1, '2025-03-01 10:30:00', 'Entregue'),
(2, '2025-03-02 14:15:00', 'Entregue'),
(3, '2025-03-05 09:00:00', 'Processando'),
(1, '2025-03-10 16:45:00', 'Enviado'),
(4, '2025-03-12 11:20:00', 'Cancelado');

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 250.00),
(1, 2, 2, 150.00),
(2, 3, 1, 1200.00),
(3, 5, 2, 350.00),
(4, 6, 1, 450.00),
(4, 2, 1, 150.00),
(5, 4, 1, 2300.00);