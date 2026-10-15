-- Insert: CLIENTE
INSERT INTO cliente (nome, cpf, telefone, email) VALUES
('Ana Silva', '11122233344', '11988881111', 'ana.silva@email.com'),
('Bruno Costa', '22233344455', '11988882222', 'bruno.costa@email.com'),
('Carla Dias', '33344455566', '11988883333', 'carla.dias@email.com'),
('Daniel Souza', '44455566677', '11988884444', 'daniel.souza@email.com'),
('Eduarda Rocha', '55566677788', '11988885555', 'eduarda.rocha@email.com');

-- Insert: PET
INSERT INTO pet (id_cliente, nome, especie, raca, data_nascimento) VALUES
(1, 'Thor', 'Cão', 'Golden Retriever', '2020-05-10'),
(1, 'Loki', 'Gato', 'Siamês', '2021-08-15'),
(2, 'Mel', 'Cão', 'Poodle', '2019-03-22'),
(3, 'Frajola', 'Gato', 'SRD', '2018-11-01'),
(4, 'Rex', 'Cão', 'Pastor Alemão', '2022-01-30');

-- Insert: VETERINARIO
INSERT INTO veterinario (nome, crmv, especialidade) VALUES
('Dr. Roberto Alves', 'CRMV-SP1234', 'Clinica Geral'),
('Dra. Maria Fernanda', 'CRMV-SP5678', 'Dermatologia'),
('Dr. Lucas Mendes', 'CRMV-SP9012', 'Ortopedia'),
('Dra. Juliana Lima', 'CRMV-SP3456', 'Felinos'),
('Dr. Gustavo Borges', 'CRMV-SP7890', 'Cirurgia');

-- Insert: CONSULTA
INSERT INTO consulta (id_pet, id_veterinario, data_consulta, diagnostico, valor) VALUES
(1, 1, '2026-01-10 10:00:00', 'Check-up anual. Animal saudável.', 150.00),
(2, 4, '2026-01-15 14:30:00', 'Otite dermatológica leve.', 200.00),
(3, 2, '2026-02-01 11:00:00', 'Alergia alimentar. Recomendada ração hipoalergênica.', 180.00),
(4, 4, '2026-02-20 16:00:00', 'Gengivite em estágio inicial.', 160.00),
(5, 3, '2026-03-05 09:15:00', 'Displasia coxofemoral confirmada por RX.', 250.00);

-- Insert: MEDICAMENTO
INSERT INTO medicamento (nome, dosagem_padrao) VALUES
('Amoxicilina', '250mg a cada 12h'),
('Anti-inflamatório Meloxicam', '0.5mg/kg 1x ao dia'),
('Pomada Otológica', 'Aplicar 2x ao dia'),
('Shampoo Terapêutico', 'Banho 2x por semana'),
('Suplemento Articular', '1 comprimido ao dia');

-- Insert: PRESCRICAO
INSERT INTO prescricao (id_consulta, id_medicamento, posologia) VALUES
(2, 3, 'Aplicar 3 gotas no ouvido afetado por 7 dias.'),
(3, 4, 'Utilizar durante o banho por 4 semanas.'),
(3, 1, 'Administrar 1 comprimido a cada 12 horas por 10 dias.'),
(5, 2, 'Tomar 1 comprimido por 5 dias após as refeições.'),
(5, 5, 'Uso contínuo por 60 dias.');

-- Insert: PRODUTO
INSERT INTO produto (nome, preco, estoque) VALUES
('Ração Premium Cães 15kg', 220.00, 30),
('Ração Gatos Castrados 3kg', 85.00, 50),
('Shampoo Neutro 500ml', 35.00, 40),
('Coleira Antipulgas', 110.00, 20),
('Brinquedo Osso de Borracha', 25.00, 100);

-- Insert: VENDA
INSERT INTO venda (id_cliente, data_venda, valor_total) VALUES
(1, '2026-01-10 11:00:00', 305.00),
(2, '2026-01-18 15:20:00', 85.00),
(3, '2026-02-01 12:00:00', 255.00),
(4, '2026-02-10 17:45:00', 60.00),
(5, '2026-03-01 10:30:00', 220.00);

-- Insert: ITEM_VENDA
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 220.00),
(1, 2, 1, 85.00),
(2, 2, 1, 85.00),
(3, 1, 1, 220.00),
(3, 3, 1, 35.00),
(4, 5, 2, 25.00),
(5, 1, 1, 220.00);