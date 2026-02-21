playerTables = {}
playerIdentities = {}
local loadingIdentities = false 

debugMode = true

local debugFunction = function(...)
    if debugMode then
        print("^4[tz_main]^0",...)
    end
    return
end

local playerTablesMT = {}
local newPlayerMt = {}
playerTables = function(source)
    if not source then
        return {}
    end
    if not playerTablesMT[source] then
        playerTablesMT[source] = {}
    end
    if not newPlayerMt[source] then
        newPlayerMt[source] = {}
        newPlayerMt[source] = setmetatable(newPlayerMt[source],{
            __index = function(self,index,value)
                if not playerTablesMT[source] then
                    playerTablesMT[source] = {}
                end
                return playerTablesMT[source][index]
            end,
            __newindex = function(self,index,value)
                TriggerClientEvent("tz/setTables",source,index,value)
                playerTablesMT[source][index] = value
            end,
        })
    end
    return newPlayerMt[source]
end

SQL = {}
setmetatable(SQL, SQL)
local loadSQL = false
local blockedLoad = {

}

for dir in io.popen('dir "'..GetResourcePath(GetCurrentResourceName())..'/scripts/" /b'):lines() do 
    if not blockedLoad[dir] then
        loadSQL = true
    end
end

if loadSQL then
    SQL.drivers = {
        {'oxmysql', function(promise, sql, params)
            promise:resolve(exports.oxmysql:query_async(sql, params))
        end},
        {'ghmattimysql', function(promise, sql, params)
            exports.ghmattimysql:execute(sql, params, function(result)
                promise:resolve(result)
            end)
        end},
        {'GHMattiMySQL', function(promise, sql, params)
            exports.GHMattiMySQL:QueryResultAsync(sql, params, function(result)
                promise:resolve(result)
            end)
        end},
        {'mysql-async', function(promise, sql, params)
            exports['mysql-async']:mysql_fetch_all(sql, params, function(result)
                promise:resolve(result)
            end)
        end}
    }
    
    SQL.tables = {}
    
    function SQL.has_table(name)
        return SQL.tables[name] ~= nil
    end
    SQL.hasTable = SQL.has_table
    function SQL.first_table(...)
        for table in ipairs({ ... }) do
            if SQL.has_table(table) then
                return table
            end
        end
    end
    SQL.firstTable = SQL.first_table
    function SQL.has_column(table, column)
        return SQL.tables[table] and SQL.tables[table][column]
    end
    SQL.hasColumn = SQL.has_column
    function SQL.first_column(table, ...)
        for column in ipairs({ ... }) do
            if SQL.has_column(table, column) then
                return column
            end
        end
    end

    local handlers = {}
    
    for driver in ipairs(SQL.drivers) do
        if GetResourceState(SQL.drivers[driver][1]) == 'started' then
            SQL.driver = SQL.drivers[driver][2]
            debugFunction('Usando driver', SQL.drivers[driver][1])
            break
        end
    end
    
    function SQL.__call(self, sql, params)
        return SQL.silent(sql, params)
    end
    
    function SQL.silent(sql, params)
        if SQL.driver then
            local p = promise.new()
            SQL.driver(p, sql, params or {})
            return Citizen.Await(p) or error('Unexpected sql result from db driver')
        end
        error('Missing compatible SQL driver')
    end
    
    function SQL.escape(seq)
        local safe = seq:gsub('`', '')
        return string.format('`%s`', safe)
    end
    
    function SQL.scalar(sql, params)
        local row = SQL(sql, params)[1] or {}
        return ({next(row)})[2]
    end
    
    function SQL.select(table_name, columns, condition)

        local column_list = "*"
        if columns and type(columns) == "table" then
            column_list = table.concat(columns, ", ")
        end
    
        local code = string.format("SELECT %s FROM %s", column_list, SQL.escape(table_name))
    
        if condition then
            code = code .. " WHERE " .. condition
        end
    
        
        return SQL(code)
    end
    
    function SQL.update(table_name, data, condition)
        local sets = {}
    
        local context = { table = table_name, data = data }
        if handlers[table_name] then
            handlers[table_name](context)
        end
    
        for k, v in pairs(context.data) do
            if SQL.has_column(table_name, k) then
                if type(v) == "table" then
                    sets[#sets + 1] = SQL.escape(k) .. " = '" .. json.encode(v) .. "'"
                else
                    sets[#sets + 1] = SQL.escape(k) .. " = '" .. v .. "'"
                end
            end
        end
    
        local code = string.format("UPDATE %s SET %s", SQL.escape(context.table), table.concat(sets, ','))
        if condition then
            code = code .. " WHERE " .. condition
        end
    
        return SQL(code)
    end
    

    function SQL.insert(table_name, data, operation)
        local columns = {}
        local values = {}
    
        local context = { table = table_name, data = data }
        if handlers[table_name] then
            handlers[table_name](context)
        end
    
        for k,v in pairs(context.data) do
            if SQL.has_column(table_name, k) then
                table.insert(columns, SQL.escape(k))
                if type(v) == "table" then
                    table.insert(values, "'" .. json.encode(v) .. "'")
                else
                    table.insert(values, "'"..v.."'")
                end
            end
        end
    
        local code = string.format('%s INTO %s (%s) VALUES (%s)', operation or 'INSERT', SQL.escape(context.table), table.concat(columns, ','), table.concat(values, ','))
        return SQL(code)
    end


    function SQL.replace(table_name, data)
        return SQL.insert(table_name, data, 'REPLACE')
    end
    
    SQL.columnsTable = function(table_name,columns)
        for _,column in pairs(columns) do
            if SQL.hasColumn(table_name,column) then
                return column
            end
        end
        return nil
    end
    
  
    
    CreateThread(function()
        local tables = SQL.silent([[
            SELECT table_name as t, column_name as c FROM information_schema.columns WHERE 
            table_schema = DATABASE()
        ]])
    
        for row in ipairs(tables) do
            local table, column = tables[row].t, tables[row].c
    
            if SQL.tables[table] then
                SQL.tables[table][column] = true
            else
                SQL.tables[table] = { [column] = true }
            end
        end
    
        if not Framework["version"] then
            
            if SQL.has_table('vrp_infos') and SQL.has_table('vrp_permissions') then
                Framework["version"] = "crv3"
            elseif GetResourceMetadata('vrp', 'creative_network') or vRP.Groups() then
                Framework["version"] = "crnetwork"
            elseif SQL.has_table('summerz_characters') or SQL.has_table('characters') then
                Framework["version"] = "crv5"
            elseif SQL.has_table('vrp_user_data') then
                Framework["version"] = "vrp"
            else
                debugFunction("Framework não encontrado.")
            end
        end
        
        SQL.loaded = true

        if not SQL.has_table('tz_modulo') then
            SQL("CREATE TABLE IF NOT EXISTS tz_modulo ( id INT AUTO_INCREMENT PRIMARY KEY,  user_id INT NOT NULL, dkey VARCHAR(255) NOT NULL COLLATE 'latin1_swedish_ci', dvalue TEXT NULL DEFAULT NULL COLLATE 'latin1_swedish_ci', status INT NOT NULL);")
            print("^4[tz_modulo]^2 Tabela criada com sucesso! ^1 --> REINICIE O MODULO <--^0")
        end
     
    end)
end
