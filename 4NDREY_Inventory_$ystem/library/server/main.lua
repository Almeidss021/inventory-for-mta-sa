database = dbConnect ('sqlite', 'library/assets/database/dados.sql')


addEventHandler('onResourceStart', getRootElement(), function(res)
    if res == getThisResource() then
        if (database) then
            dbExec (database, 'CREATE TABLE IF NOT EXISTS Information (Account, Itens_Name, Itens, Amount, Slot, Weighing)')
            dbExec (database, 'CREATE TABLE IF NOT EXISTS Player (Account, Maximum_Weight, Current_weight, Weapons)')
            print('Banco de dados conectado com sucesso!')
            for i, v in ipairs(getElementsByType('player')) do
                local data = dbPoll(dbQuery(database, 'SELECT * FROM Player WHERE Account = ?', getAccountName(getPlayerAccount(v))), -1)
                if data and #data == 0 then 
                    dbExec(database, 'INSERT INTO Player (Account, Maximum_Weight, Current_weight) VALUES (?,?,?)', getAccountName(getPlayerAccount(v)), Config['Inventory']['General']['Weight'], 0)
                end
            end
        else
            error('Banco de dados não foi inicializado corretamente!', 1)
        end
    end
end)


addEvent('AN >> Information', true)
addEventHandler('AN >> Information', root, function (thePlayer)
    local account = getAccountName(getPlayerAccount(thePlayer))
    local totalSlot = Config['Inventory']['DxDraw']['Column_X'] * Config['Inventory']['DxDraw']['Column_Y'] 
    local result = dbPoll(dbQuery(database, 'SELECT * FROM Information'), -1)
    local Table_Inventory = { }
    for i = 1, totalSlot do
        Table_Inventory[i] = false 
    end
    if (#result > 0) then
        for i, v in ipairs(result) do
            if (v['Account'] == account and #v['Account'] > 0) then
                local info = {
                    Account = v['Account'];
                    Name = v['Itens_Name'];
                    Item = v['Itens'];
                    Amount = v['Amount'];
                    Slot = v['Slot'];
                    Weighing = v['Weighing']
                }
                Table_Inventory[tonumber(v['Slot'])] = info 
            end
        end
    end
    if (#Table_Inventory > 0) then
        triggerClientEvent(thePlayer, 'AN >> Dados', thePlayer, Table_Inventory)
    else
        return false
    end
end)



function getFreeIDSlot(acc)
    local result = dbPoll(dbQuery(database, "SELECT Slot FROM Information WHERE Account = '"..acc.."' ORDER BY Slot ASC"), -1)
    newID = false
    for i, id in ipairs(result) do
        if id['Slot'] ~= i then
            newID = i
            break
        end
    end
    if newID then
        return newID 
    else 
        return #result + 1 
    end
end








addEvent('AN >> Change_Slot', true)
addEventHandler('AN >> Change_Slot', root, function (thePlayer, item_slot, old_slot, new_slot)
    iprint(item)
    local account = getAccountName(getPlayerAccount(thePlayer))
    local result = dbPoll(dbQuery(database, 'SELECT * FROM Information WHERE Account = ? AND Slot = ?', account, old_slot), -1)
    if #result ~= 0 then
        print()
        dbExec(database, 'UPDATE Information SET Slot = ? WHERE Account = ? AND Itens = ? ', new_slot, account, item_slot['Item']) 
    end
end)















function giveItem(thePlayer, item, amount)
    local account = getAccountName(getPlayerAccount(thePlayer))
    local item = tonumber (item)
    local amount = tonumber (amount)
    if item and amount and amount > 0 then
        local item_slot = getFreeIDSlot(account)
        local result = dbPoll(dbQuery(database, 'SELECT * FROM Information WHERE Account = ? AND Itens = ?', account, item), -1)
        local data = dbPoll(dbQuery(database, 'SELECT * FROM Player WHERE Account = ?', account), -1)
        if Config['Inventory']['Itens'][item] then
            local Weight_Item = Config['Inventory']['Itens'][item]['Weight_Item'] * amount
            local Weight_free = data[1]['Maximum_Weight'] - data[1]['Current_weight']
            local totalSlot = Config['Inventory']['DxDraw']['Column_X'] * Config['Inventory']['DxDraw']['Column_Y'] 
            print(Weight_free, Weight_Item)
            if Weight_Item <= Weight_free then 
                if #result ~= 0 then
                    print('item update db + soma ')
                    dbExec(database, 'UPDATE Information SET Amount = ?, Weighing = ? WHERE Account = ? AND Itens = ?', result[1]['Amount'] + amount, result[1]['Weighing'] + Weight_Item, account, item)
                else
                    if item_slot == totalSlot then
                        print('Sua mochila não tem mais espaço 1')
                        return
                    end
                    print('item inserido na db')
                    dbExec(database, 'INSERT INTO Information (Account, Itens_Name, Itens, Amount, Slot, Weighing) VALUES (?,?,?,?,?,?)', account, Config['Inventory']['Itens'][item]['Name'], item, amount, item_slot, Config['Inventory']['Itens'][item]['Weight_Item'])
                end
            else
                print('Sua mochila não tem mais espaço 2 ')
            end
        end
    end
end


addCommandHandler('give', function(thePlayer, cmd, item, amount)
    local account = getAccountName(getPlayerAccount(thePlayer))
    local item = tonumber (item)
    local amount = tonumber (amount)
    if item and amount and amount > 0 then
        giveItem(thePlayer, item, amount)
        print('item givado', Config['Inventory']['Itens'][item]['Name'])
    end
end)
