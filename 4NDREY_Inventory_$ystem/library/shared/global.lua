Config = {
	['Inventory'] = {
		['DxDraw'] = {
			['Ptarting_position'] = {x = 520, y = 302}; --// Pos inicial Inv.
			['Item_scale'] = {w = 40, h = 40}; --// Tamanha da imagem do item.
			['Column_X'] = 6; --// Número de coluna para o lado.
			['Column_Y'] = 5;  --// Número de coluna para baixo
			['Slot_Scale'] = 51; --// Tamanho do slot.
			['Square_Space'] = 1;  --// Ditancia dos slots.
			['Colors'] = {Cor_1 = {36, 36, 36}, Cor_2 = {26, 26, 26}, Cor_3 = {147,112,219}};
		};

		['General'] = {
			['Weight'] = 50;
		};

		['Itens'] = {
			[1] = {Name = 'Rosquinha', Weight_Item = 0.1, Lose_item = true, Together = false, Desc = ''};
			[2] = {Name = 'Hambúrgeuer', Weight_Item = 0.1, Lose_item = true, Together = true, Desc = ''};
			[3] = {Name = 'Batata Frita', Weight_Item = 0.1, Lose_item = true, Together = false, Desc = ''};
			[4] = {Name = 'Coca Cola', Weight_Item = 0.3, Lose_item = true, Together = true, Desc = ''};
			[5] = {Name = 'Leite', Weight_Item = 0.5, Lose_item = true, Together = true, Desc = ''};
			[6] = {Name = 'sanduíche', Weight_Item = 0.1, Lose_item = true, Together = true, Desc = ''};
			[7] = {Name = 'Nutella', Weight_Item = 0.4, Lose_item = true, Together = true, Desc = ''};
			[8] = {Name = 'Cerveja', Weight_Item = 0.1, Lose_item = true, Together = true, Desc = ''};
			[9] = {Name = 'Pepsi', Weight_Item = 0.1, Lose_item = true, Together = true, Desc = ''};
		};
	};
}