lib.versionCheck('Qbox-project/npwd_qbx_mail')

local mailRateLimits = {}

local function generateMailId()
    return math.random(100000000, 999999999)
end

local function isValidMailId(mailId)
    return type(mailId) == 'number' and mailId % 1 == 0 and mailId > 0
end

local function sanitizeMailData(mailData)
    if type(mailData) ~= 'table' or type(mailData.sender) ~= 'string'
        or type(mailData.subject) ~= 'string' or type(mailData.message) ~= 'string' then return end
    if #mailData.sender == 0 or #mailData.sender > 128 or #mailData.subject == 0
        or #mailData.subject > 255 or #mailData.message > 10000 then return end

    local button
    local buttonJson
    if mailData.button ~= nil then
        if type(mailData.button) ~= 'table' then return end
        if next(mailData.button) then
            local encoded, result = pcall(json.encode, mailData.button)
            if not encoded or type(result) ~= 'string' or #result > 4096 then return end
            button = mailData.button
            buttonJson = result
        end
    end

    return {
        sender = mailData.sender,
        subject = mailData.subject,
        message = mailData.message,
        button = button,
        buttonJson = buttonJson
    }
end

local function insertMail(citizenid, playerSource, mailData)
    local mailId = generateMailId()
    if mailData.buttonJson then
        MySQL.insert.await('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            citizenid, mailData.sender, mailData.subject, mailData.message, mailId, 0, mailData.buttonJson
        })
    else
        MySQL.insert.await('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {
            citizenid, mailData.sender, mailData.subject, mailData.message, mailId, 0
        })
    end

    if not playerSource then return end
    TriggerClientEvent('npwd:qbx_mail:newMail', playerSource, {
        sender = mailData.sender,
        subject = mailData.subject,
        message = mailData.message,
        mailid = mailId,
        button = mailData.button,
        read = 0,
        date = os.time() * 1000
    })
end

local function isMailRateLimited(source)
    local time = os.time()
    local rate = mailRateLimits[source]
    if not rate or time - rate.startedAt >= 60 then
        mailRateLimits[source] = { startedAt = time, count = 1 }
        return false
    end
    if rate.count >= 10 then return true end

    rate.count = rate.count + 1
    return false
end

lib.callback.register('npwd:qbx_mail:getMail', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return {} end

    local mailResults = MySQL.query.await('SELECT `citizenid`, `sender`, `subject`, `message`, `read`, `mailid`, `date`, `button` FROM player_mails WHERE citizenid = ? ORDER BY date DESC', { player.PlayerData.citizenid })

    for i = 1, #mailResults do
        if mailResults[i].button then -- qb-phone used replace button with '' when its used, so checking if thats the length then setting to nil for ui
            local decoded, button = pcall(json.decode, mailResults[i].button)
            mailResults[i].button = decoded and button or nil
        end
    end

    return mailResults
end)

lib.callback.register('npwd:qbx_mail:updateRead', function(source, data)
    local player = exports.qbx_core:GetPlayer(source)
    if not player or not isValidMailId(data) then return false end
    MySQL.update.await('UPDATE player_mails SET `read` = 1 WHERE mailid = ? AND citizenid = ?', { data, player.PlayerData.citizenid })
    return true
end)

lib.callback.register('npwd:qbx_mail:deleteMail', function(source, data)
    local player = exports.qbx_core:GetPlayer(source)
    if not player or not isValidMailId(data) then return false end
    return MySQL.query.await('DELETE FROM player_mails WHERE mailid = ? AND citizenid = ?', { data, player.PlayerData.citizenid })
end)

lib.callback.register('npwd:qbx_mail:updateButton', function(source, id)
    local player = exports.qbx_core:GetPlayer(source)
    if not player or not isValidMailId(id) then return 0 end
    return MySQL.update.await('UPDATE player_mails SET `button` = NULL WHERE mailid = ? AND citizenid = ?', { id, player.PlayerData.citizenid })
end)

RegisterNetEvent('qb-phone:server:sendNewMail', function(mailData)
    local player = exports.qbx_core:GetPlayer(source)
    local sanitized = sanitizeMailData(mailData)
    if not player or not sanitized or isMailRateLimited(source) then return end

    insertMail(player.PlayerData.citizenid, player.PlayerData.source, sanitized)
end)

AddEventHandler('qb-phone:server:sendNewMailToOffline', function(citizenid, mailData)
    if type(citizenid) ~= 'string' or #citizenid == 0 or #citizenid > 64 then return end

    local sanitized = sanitizeMailData(mailData)
    if not sanitized then return end

    local player = exports.qbx_core:GetPlayerByCitizenId(citizenid)
    insertMail(citizenid, player and player.PlayerData.source, sanitized)
end)

AddEventHandler('playerDropped', function()
    mailRateLimits[source] = nil
end)

lib.addCommand('testemail', {help = 'Sends a test email to your phone', restricted = 'group.admin'}, function(source)
    TriggerClientEvent('npwd_qbx_mail:testMail', source)
end)
