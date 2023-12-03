local function GenerateMailId()
    return math.random(111111, 999999)
end

lib.callback.register("npwd:qbx_mail:getMail", function(source)
	local player  = exports.qbx_core:GetPlayer(source)
	local mailResults = MySQL.query.await('SELECT `citizenid`, `sender`, `subject`, `message`, `read`, `mailid`, `date`, `button` FROM player_mails WHERE citizenid = ? ORDER BY date DESC', {player.PlayerData.citizenid})

	for i = 1, #mailResults do
		if mailResults[i].button then -- qb-phone used replace button with "" when its used, so checking if thats the length then setting to nil for ui
			mailResults[i].button = #mailResults[i].button == 2 and nil or json.decode(mailResults[i].button)
		end
    end
	return mailResults
end)

lib.callback.register('npwd:qbx_mail:updateRead', function(source, data)
	local src = source
	local player = exports.qbx_core:GetPlayer(src)
	MySQL.update('UPDATE player_mails SET `read` = 1 WHERE mailid = ? AND citizenid = ?', {data, player.PlayerData.citizenid})
	return true
end)

lib.callback.register('npwd:qbx_mail:deleteMail', function(source, data)
    local player = exports.qbx_core:GetPlayer(source)
	return MySQL.query.await('DELETE FROM player_mails WHERE mailid = ? AND citizenid = ?', {data, player.PlayerData.citizenid})
end)

lib.callback.register('npwd:qbx_mail:updateButton', function(source, id)
    local player = exports.qbx_core:GetPlayer(source)
	return MySQL.update.await('UPDATE player_mails SET `button` = NULL WHERE mailid = ? AND citizenid = ?', {id, player.PlayerData.citizenid})
end)

RegisterNetEvent('qb-phone:server:sendNewMail', function(mailData)
    local player = exports.qbx_core:GetPlayer(source)
	local mailid = GenerateMailId()
    if mailData.button == nil then
        MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, mailid, 0})
    else
        MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, mailid, 0, json.encode(mailData.button)})
    end
	local newMail = {
		sender = mailData.sender,
		subject = mailData.subject,
		message = mailData.message,
		mailid = mailid,
		button = mailData.button,
		read = 0,
		date = os.time() * 1000
	}
	TriggerClientEvent('npwd:qbx_mail:newMail', player.PlayerData.source, newMail)
end)

RegisterNetEvent('qb-phone:server:sendNewMailToOffline', function(citizenid, mailData)
    local player = exports.qbx_core:GetPlayerByCitizenId(citizenid)
    if player then
        local src = player.PlayerData.source
		local mailid = GenerateMailId()
        if mailData.button == nil or not next(mailData.button) then
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, mailid, 0})
        else
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, mailid, 0, json.encode(mailData.button)})
        end
		local newMail = {
			sender = mailData.sender,
			subject = mailData.subject,
			message = mailData.message,
			mailid = mailid,
			button = mailData.button,
			read = 0,
			date = os.time() * 1000
		}
		TriggerClientEvent('npwd:qbx_mail:newMail', src, newMail)
    else
        if mailData.button == nil then
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
        else
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
        end
    end
end)
