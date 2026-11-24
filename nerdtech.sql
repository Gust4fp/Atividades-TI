-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 24/11/2026 às 19:19
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `nerdtech`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `categorias`
--

INSERT INTO `categorias` (`id`, `nome`, `descricao`) VALUES
(1, 'Teclados', 'Teclados mecânicos e gamer'),
(2, 'Mouses', 'Mouses gamer e acessórios'),
(3, 'Headsets', 'Headsets e áudio'),
(4, 'Monitores', 'Monitores para jogos');

-- --------------------------------------------------------

--
-- Estrutura para tabela `itens_pedido`
--

CREATE TABLE `itens_pedido` (
  `id` int(11) NOT NULL,
  `pedido_id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `preco_unitario` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `itens_pedido`
--

INSERT INTO `itens_pedido` (`id`, `pedido_id`, `produto_id`, `quantidade`, `preco_unitario`) VALUES
(1, 1, 8, 1, 599.90),
(2, 1, 11, 1, 299.90),
(3, 1, 16, 1, 279.90),
(4, 1, 23, 1, 1099.90);

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedidos`
--

CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `data_pedido` timestamp NOT NULL DEFAULT current_timestamp(),
  `forma_pagamento` enum('PIX','Boleto','Cartao') NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `status` varchar(30) DEFAULT 'Confirmado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `pedidos`
--

INSERT INTO `pedidos` (`id`, `usuario_id`, `data_pedido`, `forma_pagamento`, `total`, `status`) VALUES
(1, 1, '2026-11-24 18:09:34', 'PIX', 2279.60, 'Confirmado');

-- --------------------------------------------------------

--
-- Estrutura para tabela `produtos`
--

CREATE TABLE `produtos` (
  `id` int(11) NOT NULL,
  `categoria_id` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `descricao` text DEFAULT NULL,
  `preco` decimal(10,2) NOT NULL,
  `estoque` int(11) NOT NULL DEFAULT 0,
  `imagem` varchar(255) DEFAULT NULL,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  `ativo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `produtos`
--

INSERT INTO `produtos` (`id`, `categoria_id`, `nome`, `descricao`, `preco`, `estoque`, `imagem`, `criado_em`, `ativo`) VALUES
(1, 1, 'Teclado Mecânico Redragon Kumara', 'Teclado mecânico gamer compacto, com estrutura resistente, conexão USB e iluminação LED ou RGB conforme a versão. Possui switches mecânicos, teclas com resposta tátil e recursos anti-ghosting. Ideal para jogos e digitação.', 199.90, 15, 'https://placehold.co/600x400?text=Teclado', '2026-11-24 18:02:04', 1),
(2, 2, 'Mouse Logitech G203', 'Mouse gamer com sensor óptico de até 8.000 DPI, seis botões programáveis e iluminação LIGHTSYNC RGB. Possui conexão USB com fio e formato ambidestro, indicado para diferentes estilos de jogo.', 129.90, 20, 'https://placehold.co/600x400?text=Mouse', '2026-11-24 18:02:04', 1),
(3, 3, 'Headset HyperX Cloud Stinger', 'Headset gamer com drivers direcionais de 50 mm, resposta de frequência de 18 Hz a 23 kHz e conexão P2 de 3,5 mm. Possui microfone com cancelamento de ruído, controles de áudio e estrutura confortável.', 249.90, 10, 'https://placehold.co/600x400?text=Headset', '2026-11-24 18:02:04', 1),
(4, 4, 'Monitor Gamer LG 24', 'Monitor gamer LG de 24 polegadas. A resolução, frequência de atualização, tipo de painel e tempo de resposta dependem do código exato do modelo. Consulte a versão do produto para confirmar essas especificações antes da compra.', 699.90, 8, 'https://placehold.co/600x400?text=Monitor', '2026-11-24 18:02:04', 1),
(5, 1, 'Redragon Mitra K551', 'Teclado mecânico gamer de tamanho completo, com teclado numérico, conexão USB e iluminação conforme a versão. Conta com switches mecânicos e recursos anti-ghosting para registrar múltiplas teclas simultaneamente.', 229.90, 12, 'https://placehold.co/600x400?text=Redragon+Mitra', '2026-11-24 18:03:30', 1),
(6, 1, 'Logitech G213 Prodigy', 'Teclado gamer de tamanho completo com teclas Mech-Dome, iluminação RGB LIGHTSYNC personalizável e apoio para as mãos integrado. Possui conexão USB, resistência a respingos e teclas multimídia dedicadas.', 299.90, 10, 'https://placehold.co/600x400?text=Logitech+G213', '2026-11-24 18:03:30', 1),
(7, 1, 'HyperX Alloy Origins Core', 'Teclado mecânico gamer compacto no formato TKL, sem teclado numérico. Possui estrutura de alumínio, switches mecânicos HyperX, iluminação RGB personalizável e conexão USB-C removível.', 449.90, 8, 'https://placehold.co/600x400?text=HyperX+Alloy', '2026-11-24 18:03:30', 1),
(8, 1, 'Razer BlackWidow V3', 'Teclado mecânico gamer com switches Razer, iluminação RGB Razer Chroma, estrutura resistente e teclas multimídia. Oferece opções de switches diferentes conforme a versão adquirida.', 599.90, 5, 'https://placehold.co/600x400?text=Razer+BlackWidow', '2026-11-24 18:03:30', 1),
(9, 1, 'Fortrek Gamer Cruiser', 'Teclado gamer com conexão USB, design voltado para jogos, teclas de tamanho completo e iluminação conforme a versão. Uma opção para uso cotidiano, jogos e digitação.', 159.90, 15, 'https://placehold.co/600x400?text=Fortrek+Cruiser', '2026-11-24 18:03:30', 1),
(10, 2, 'Razer DeathAdder Essential', 'Mouse gamer ergonômico com sensor óptico de até 6.400 DPI, cinco botões programáveis e conexão USB com fio. Desenvolvido para oferecer controle e conforto durante longas sessões de jogo.', 149.90, 15, 'https://placehold.co/600x400?text=DeathAdder', '2026-11-24 18:03:30', 1),
(11, 2, 'Logitech G502 Hero', 'Mouse gamer com sensor HERO de até 25.600 DPI, 11 botões programáveis, iluminação RGB LIGHTSYNC e sistema de pesos ajustáveis. Possui conexão USB e alta precisão para jogos competitivos.', 299.90, 9, 'https://placehold.co/600x400?text=Logitech+G502', '2026-11-24 18:03:30', 1),
(12, 2, 'Redragon Cobra M711', 'Mouse gamer com sensor óptico de até 10.000 DPI, iluminação RGB, botões programáveis e conexão USB. Permite personalizar configurações para diferentes estilos de jogo.', 119.90, 18, 'https://placehold.co/600x400?text=Redragon+Cobra', '2026-11-24 18:03:30', 1),
(13, 2, 'HyperX Pulsefire Core', 'Mouse gamer com sensor óptico Pixart 3327 de até 6.200 DPI, sete botões programáveis e iluminação RGB. Possui conexão USB e formato ergonômico.', 139.90, 12, 'https://placehold.co/600x400?text=HyperX+Pulsefire', '2026-11-24 18:03:30', 1),
(14, 2, 'Razer Viper Mini', 'Mouse gamer compacto e leve, com sensor óptico de até 8.500 DPI, seis botões programáveis e conexão USB. Conta com iluminação Razer Chroma RGB e formato ambidestro.', 199.90, 9, 'https://placehold.co/600x400?text=Razer+Viper', '2026-11-24 18:03:30', 1),
(15, 3, 'Logitech G435', 'Headset gamer sem fio com conexão LIGHTSPEED 2,4 GHz e Bluetooth. Possui drivers de 40 mm, microfones duplos integrados e compatibilidade com dispositivos selecionados. Leve e indicado para jogos e uso cotidiano.', 399.90, 10, 'https://placehold.co/600x400?text=Logitech+G435', '2026-11-24 18:03:30', 1),
(16, 3, 'Redragon Zeus X', 'Headset gamer com drivers de 53 mm, conexão USB, iluminação RGB e microfone integrado. Oferece áudio estéreo e controles de volume para facilitar o uso durante as partidas.', 279.90, 11, 'https://placehold.co/600x400?text=Redragon+Zeus', '2026-11-24 18:03:30', 1),
(17, 3, 'Razer Kraken X', 'Headset gamer leve com drivers de 40 mm, conexão P2 de 3,5 mm e microfone flexível. Possui áudio estéreo e estrutura confortável para longas sessões de uso.', 299.90, 8, 'https://placehold.co/600x400?text=Razer+Kraken', '2026-11-24 18:03:30', 1),
(18, 3, 'Havit H2002D', 'Headset gamer com drivers de 53 mm, conexão P2 de 3,5 mm e microfone removível. Possui estrutura confortável, controles de áudio e compatibilidade com diferentes dispositivos.', 189.90, 15, 'https://placehold.co/600x400?text=Havit+H2002D', '2026-11-24 18:03:30', 1),
(19, 3, 'JBL Quantum 100', 'Headset gamer com drivers de 40 mm, conexão P2 de 3,5 mm e microfone removível com foco na comunicação durante partidas. Possui áudio JBL QuantumSOUND e compatibilidade com diversas plataformas.', 229.90, 10, 'https://placehold.co/600x400?text=JBL+Quantum', '2026-11-24 18:03:30', 1),
(20, 4, 'Samsung Odyssey G3 24', 'Monitor gamer Samsung Odyssey G3 de 24 polegadas, com resolução Full HD e painel voltado para jogos. A frequência de atualização pode variar conforme a geração e o código do modelo, incluindo versões de 144 Hz e 165 Hz. Consulte a versão específica.', 899.90, 7, 'https://placehold.co/600x400?text=Odyssey+G3', '2026-11-24 18:03:30', 1),
(21, 4, 'AOC Hero 24G2', 'Monitor gamer AOC Hero de aproximadamente 24 polegadas, com resolução Full HD (1920 x 1080), painel IPS e alta taxa de atualização. Algumas versões oferecem 144 Hz ou 165 Hz. Possui recursos voltados para jogos e sincronização adaptativa.', 999.90, 6, 'https://placehold.co/600x400?text=AOC+Hero', '2026-11-24 18:03:30', 1),
(22, 4, 'LG UltraGear 27', 'Monitor gamer de 27 polegadas Full HD.', 1199.90, 5, 'https://placehold.co/600x400?text=LG+UltraGear', '2026-11-24 18:03:30', 1),
(23, 4, 'ASUS TUF Gaming VG249Q', 'Monitor gamer ASUS TUF de 23,8 polegadas, resolução Full HD (1920 x 1080), painel IPS, frequência de 144 Hz e tempo de resposta de 1 ms MPRT. Possui Adaptive-Sync e conexões HDMI, DisplayPort e VGA.', 1099.90, 4, 'https://placehold.co/600x400?text=ASUS+TUF', '2026-11-24 18:03:30', 1),
(24, 4, 'Acer Nitro KG241Y', 'Monitor gamer Acer Nitro de 23,8 polegadas, com resolução Full HD e painel voltado para jogos. A taxa de atualização pode variar conforme a versão, com modelos de diferentes frequências. Consulte o código completo para confirmar os dados técnicos.', 849.90, 8, 'https://placehold.co/600x400?text=Acer+Nitro', '2026-11-24 18:03:30', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `tipo` enum('cliente','admin') DEFAULT 'cliente',
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `usuarios`
--

INSERT INTO `usuarios` (`id`, `nome`, `email`, `senha`, `tipo`, `criado_em`) VALUES
(1, 'Gust4_fp', 'gutao623@gmail.com', '$2y$10$gPv5We5coJChcGFm54X8xuPrRRFhi42zqcf62aSPESUk5T9TJFzhK', 'admin', '2026-11-24 17:58:33');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `itens_pedido`
--
ALTER TABLE `itens_pedido`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pedido_id` (`pedido_id`),
  ADD KEY `produto_id` (`produto_id`);

--
-- Índices de tabela `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Índices de tabela `produtos`
--
ALTER TABLE `produtos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_id` (`categoria_id`);

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `itens_pedido`
--
ALTER TABLE `itens_pedido`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `produtos`
--
ALTER TABLE `produtos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `itens_pedido`
--
ALTER TABLE `itens_pedido`
  ADD CONSTRAINT `itens_pedido_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`),
  ADD CONSTRAINT `itens_pedido_ibfk_2` FOREIGN KEY (`produto_id`) REFERENCES `produtos` (`id`);

--
-- Restrições para tabelas `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Restrições para tabelas `produtos`
--
ALTER TABLE `produtos`
  ADD CONSTRAINT `produtos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
