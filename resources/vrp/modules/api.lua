function vRP.httpRequest(method, url, data, callback)
    if method ~= 'GET' and method ~= 'POST' then
        return
    end

    if method == 'POST' then
        data = json.encode(data)
    end

    PerformHttpRequest(url, function(statusCode, responseText, headers)
        if statusCode == 200 then
            callback(true, responseText)
        else
            callback(false, "Erro na requisição: " .. statusCode)
        end
    end, method, data, { ['Content-Type'] = 'application/json' })
end