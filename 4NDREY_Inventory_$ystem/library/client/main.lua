local screen = {guiGetScreenSize()}; 
local scale = math.min(math.max(screen[2] / 1360, 0.65), 2)
local parent = {Config['Inventory']['DxDraw']['Ptarting_position']['x'] * scale, Config['Inventory']['DxDraw']['Ptarting_position']['y'] * scale} -- W e H
local parent_c = {screen[1] / 2 - parent[1] / 2, screen[2] / 2 - parent[2] / 2} --x e y

local Global = {
    ['Moving_invetory'] = {
        ['keeping'] = false;
        ['off_x_y'] = { 0, 0 }; 
    };

    ['Slots'] = {
        ['rows'] = Config['Inventory']['DxDraw']['Column_X'];
        ['columns'] = Config['Inventory']['DxDraw']['Column_Y'];
        ['slotScale'] = Config['Inventory']['DxDraw']['Slot_Scale'];
        ['square_space'] = Config['Inventory']['DxDraw']['Square_Space'];
    };

    ['Panel'] = {
        ['Visible'] = false;
        ['Route'] = {0, 1};
        ['Tick'] = nil;
    };

    ['Informations'] = {
        ['Result_itens'] = { };
    };

    ['Font'] = {
        [1] = dxCreateFont('library/assets/font/font.ttf', 15 * scale);
        [2] = dxCreateFont('library/assets/font/font.ttf', 13 * scale)
    };
}
--_selected_item = antigo  slot
--selected_item = slot selecionado

local totalSlot = Global['Slots']['rows'] * Global['Slots']['columns']; 
local DoubleClick = nil  

function Inventory() 
    local alpha = interpolateBetween (Global['Panel']['Route'][1], 0, 0, Global['Panel']['Route'][2], 0, 0, (getTickCount ( ) - Global['Panel']['Tick'])/500, 'Linear')
    local offsetX, offsetY = 0, 0
    local mx, my = getCursorPosition ()
    local fullx, fully = guiGetScreenSize ()
    local cursorx, cursory = mx*fullx, my*fully

    dxDrawRectangle(parent_c[1] + 2, parent_c[2] + 12, 1 + ((Global['Slots']['slotScale'] + Global['Slots']['square_space']) * Global['Slots']['rows']), 31 + ((Global['Slots']['slotScale'] + Global['Slots']['square_space']) * Global['Slots']['columns']), tocolor(26, 26, 26, (alpha * 255)), false)
    dxDrawRectangle(parent_c[1] + 3, parent_c[2] + 13, ((Global['Slots']['slotScale'] + Global['Slots']['square_space']) * Global['Slots']['rows']) - 1, 28, tocolor(36, 36, 36, (alpha * 255)), false)
    dxDrawRectangle(parent_c[1] + 3, parent_c[2] + 13, ((Global['Slots']['slotScale'] + Global['Slots']['square_space']) * Global['Slots']['rows'] * getElementHealth(localPlayer) / 100) - 1, 28, tocolor(147,112,219, (alpha * 255)), false)
    dxDrawText('30KG / 50KG', parent_c[1] + 3, parent_c[2] + 13, ((Global['Slots']['slotScale'] + Global['Slots']['square_space']) * Global['Slots']['rows']) - 1, 28, tocolor(254, 254, 254, (alpha * 255)), 1.00, Global['Font'][1], 'center', 'center', false, false, false, true, false)
    
    selected_item = nil 

    for i = 1, totalSlot do

        dxDrawRectangle((1 + offsetX) + (parent_c[1] + 2), offsetY + (parent_c[2] + 43), Global['Slots']['slotScale'], Global['Slots']['slotScale'], isCursorOnElement ((1 + offsetX) + (parent_c[1] + 2), offsetY + (parent_c[2] + 43), Global['Slots']['slotScale'], Global['Slots']['slotScale']) and tocolor(147,112,219, (alpha * 255)) or tocolor(36, 36, 36, (alpha * 255)), false)
        
        if isCursorOnElement((1 + offsetX) + (parent_c[1] + 2), offsetY + (parent_c[2] + 43), Global['Slots']['slotScale'], Global['Slots']['slotScale']) then
            selected_item = i 
        end

        if Global['Informations']['Result_itens'][i] then 
            dxDrawImage((1 + offsetX) + (parent_c[1] + 2) + (Global['Slots']['slotScale'] / 2) - (Config['Inventory']['DxDraw']['Item_scale']['w']/ 2), offsetY + (parent_c[2] + 43) + (Global['Slots']['slotScale'] / 2) - (Config['Inventory']['DxDraw']['Item_scale']['h'] / 2), Config['Inventory']['DxDraw']['Item_scale']['w'], Config['Inventory']['DxDraw']['Item_scale']['h'], 'library/assets/img/items/'..Global['Informations']['Result_itens'][i]['Item']..'.png', 0, 0, 0, tocolor(255, 255, 255, (alpha * 255)), false)
        end

        offsetX = offsetX + Global['Slots']['slotScale'] + Global['Slots']['square_space']
        if (i % Global['Slots']['rows'] == 0) then
            offsetX = 0
            offsetY = offsetY + Global['Slots']['slotScale'] + Global['Slots']['square_space']
        end
    end

    if _selected_item and Global['Informations']['Result_itens'][_selected_item] then
        dxDrawImage(cursorx - 15, cursory - 15, 40, 40, 'library/assets/img/items/'..Global['Informations']['Result_itens'][_selected_item]['Item']..'.png', 0, 0, 0, tocolor(255, 255, 255, (alpha * 255)), false)   
        local slot, item, name, weight, amount = Global['Informations']['Result_itens'][_selected_item]['Slot'], Global['Informations']['Result_itens'][_selected_item]['Item'], Global['Informations']['Result_itens'][_selected_item]['Name'], Global['Informations']['Result_itens'][_selected_item]['Weighing'], Global['Informations']['Result_itens'][_selected_item]['Amount']
        local length = dxGetTextWidth(name, 1, Global['Font'][2], false)
        local Weighing_ = weight + amount
        dxDrawRectangle(cursorx + 3, cursory - 5, 152 + (length / 2) - (80 / 2), 61, tocolor(26, 26, 26, (alpha * 255)), true)
        dxDrawText('Item: '..name..'', cursorx + 3, cursory - 25, 152 + (length / 2) - (80 / 2), 61, tocolor(255, 255, 255, 255), 1.00, Global['Font'][2], 'center', 'center', false, false, true, false, false)
        dxDrawText('Quantidade: '..amount..'x', cursorx + 3, cursory - 8, 152 + (length / 2) - (80 / 2), 61, tocolor(255, 255, 255, 255), 1.00, Global['Font'][2], 'center', 'center', false, false, true, false, false)
        dxDrawText('Peso: '..string.format("%.1f",Weighing_)..'', cursorx + 3, cursory + 10, 152 + (length / 2) - (80 / 2), 61, tocolor(255, 255, 255, 255), 1.00, Global['Font'][2], 'center', 'center', false, false, true, false, false)
    end
end

function DividBy ()
    dxDrawRectangle(parent_c[1] + 3, parent_c[2] - 55, 310, 64, tocolor(26, 26, 26, 255), false)  
    dxDrawRectangle(parent_c[1] + 8, parent_c[2] - 48, 56, 51, tocolor(36, 36, 36, 255), false)
    dxDrawRectangle(parent_c[1] + 292, parent_c[2] - 55, 21, 19, tocolor(36, 36, 36, 255), false)
    dxDrawRectangle(parent_c[1] + 68, parent_c[2] - 48, 147, 51, tocolor(36, 36, 36, 255), false)
    dxDrawText('2x', parent_c[1] + 68, parent_c[2] - 48, 147, 51, tocolor(254, 254, 254, 100), 1.00, Global['Font'][1], 'center', 'center', false, false, false, false, false)
    dxDrawText('X', parent_c[1] + 292, parent_c[2] - 55, 21, 19, tocolor(254, 254, 254, 100), 1.00, Global['Font'][1], 'center', 'center', false, false, false, false, false)
    dxDrawImage(parent_c[1] + 15, parent_c[2] - 43, 40, 40, 'library/assets/img/items/2.png', 0, 0, 0, tocolor(255, 255, 255, 255), false)
end


    --// Open and Close\--

 bindKey('i', 'down', function()
    if not Global['Panel']['Visible'] and Global['Panel']['Tick'] == nil then

        Global['Panel']['Visible'] = true
        Global['Panel']['Route'] = {0, 1}
        Global['Panel']['Tick'] = getTickCount ()

        addEventHandler ('onClientRender', getRootElement ( ), Inventory)
        addEventHandler('onClientClick', getRootElement ( ), Click)
        addEventHandler('onClientCursorMove', getRootElement ( ), MoveDx)

        showCursor(true)
        triggerServerEvent('AN >> Information', localPlayer, localPlayer)

    else

        Global['Panel']['Visible'] = false
        Global['Panel']['Route'] = {1, 0}
        Global['Panel']['Tick'] = getTickCount()


        setTimer (function ( )
        removeEventHandler ('onClientRender', getRootElement ( ), Inventory)
        removeEventHandler ('onClientClick', getRootElement ( ), Click)
        removeEventHandler ('onClientCursorMove', getRootElement ( ), MoveDx)
        showCursor(false)

        Global['Panel']['Tick'] = nil
        end, 500, 1)
    end
end)

addEvent('AN >> Dados', true)
addEventHandler('AN >> Dados', root, function(table)
    Global['Informations']['Result_itens'] = table
end)

function Click(button, state, abs_x, abs_y)
    if Global['Panel']['Visible'] then
        if button == 'left' and state == 'down' then
            if isCursorOnElement(parent_c[1] + 3, parent_c[2] + 2, ((Global['Slots']['slotScale'] + Global['Slots']['square_space']) * Global['Slots']['rows']) - 1, 38) then
                Global['Moving_invetory']['keeping'] = true 
                Global['Moving_invetory']['off_x_y'][1] = abs_x - parent_c[1]
                Global['Moving_invetory']['off_x_y'][2] = abs_y - parent_c[2]
            end
        else
            Global['Moving_invetory']['keeping'] = false
        end
        if button == 'right' and state == 'down' then
            if isCursorOnElement(parent_c[1] + 3, parent_c[2] + 2, ((Global['Slots']['slotScale'] + Global['Slots']['square_space']) * Global['Slots']['rows']) - 1, 38) then
                parent_c[1] = (screen[1] / 2) * scale
                parent_c[2] = (screen[2] / 2) * scale
            end        
        end
        if button == 'left' and state == 'down' then
            if selected_item then
                if Global['Informations']['Result_itens'][selected_item] then 
                    _selected_item = selected_item
                    --print(selected_item)
                end
            end
        elseif button == 'left' and state == 'up' then 
            if _selected_item then 
                if selected_item then
                    if _selected_item ~= selected_item then
                        if not Global['Informations']['Result_itens'][selected_item] then 
                            Global['Informations']['Result_itens'][selected_item] = Global['Informations']['Result_itens'][_selected_item]
                            Global['Informations']['Result_itens'][_selected_item] = nil
                            --triggerServerEvent('AN >> Change_Slot', localPlayer, localPlayer, Global['Informations']['Result_itens'][selected_item], _selected_item, selected_item) 
                            _selected_item = nil 
                        else
                            if Global['Informations']['Result_itens'][_selected_item]['Item'] == Global['Informations']['Result_itens'][selected_item]['Item'] then 
                                if Config['Inventory']['Itens'][Global['Informations']['Result_itens'][_selected_item]['Item']] then 
                                    local Together = Global['Informations']['Result_itens'][_selected_item]
                                    Together['Amount'] = Global['Informations']['Result_itens'][selected_item]['Amount'] + Together['Amount']
                                    Global['Informations']['Result_itens'][selected_item] = Together
                                    Global['Informations']['Result_itens'][_selected_item] = nil   
                                end
                                _selected_item = nil 
                                --print(1)
                            else
                                local substitui = Global['Informations']['Result_itens'][selected_item]

                                Global['Informations']['Result_itens'][selected_item] = Global['Informations']['Result_itens'][_selected_item]
                                Global['Informations']['Result_itens'][_selected_item] = substitui
                                _selected_item = nil 
                                --print(2)
                            end
                        end
                        local item = Global['Informations']['Result_itens'][selected_item]
                        local old_slot = Global['Informations']['Result_itens'][selected_item]['Slot']
                        local new_slot = selected_item
                        triggerServerEvent('AN >> Change_Slot', localPlayer, localPlayer, item, old_slot, new_slot) 
                    else 
                        if not isTimer(DoubleClick) then
                            DoubleClick = setTimer(function()
                            end, 1000, 1)
                            _selected_item = nil 
                        else
                            killTimer(DoubleClick) 
                            _selected_item = nil
                            print('usando item 123 testando ')
                        end
                    end 
                else
                    _selected_item = nil
                end
            end
        end
    end
end


function MoveDx(rel_x, rel_y, abs_x, abs_y)
    if Global['Panel']['Visible'] then
        if Global['Moving_invetory']['keeping'] == true then 
            parent_c[1] = abs_x - Global['Moving_invetory']['off_x_y'][1]
            parent_c[2] = abs_y - Global['Moving_invetory']['off_x_y'][2]
        end
    end
end
