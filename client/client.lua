RegisterNUICallback("npwd:qb-mail:getMail", function(_, cb)
	local mail = lib.callback.await("npwd:qb-mail:getMail")
	cb({ status = "ok", data = mail })
end)

RegisterNUICallback("npwd:qb-mail:updateRead", function(data, cb)
	lib.callback.await("npwd:qb-mail:updateRead", data)
	cb({})
end)

RegisterNUICallback("npwd:qb-mail:deleteMail", function(data, cb)
	local mailDeleted = lib.callback.await("npwd:qb-mail:deleteMail", data)
	cb({ status = mailDeleted and "ok" or "error" })
end)

RegisterNUICallback("npwd:qb-mail:updateButton", function(data, cb)
	TriggerEvent(data.button.buttonEvent, data.button.buttonData)
	local buttonUpdated = lib.callback.await("npwd:qb-mail:updateButton", data.mailid)
	cb({ status = buttonUpdated and "ok" or "error" })
end)

RegisterNetEvent('npwd:qb-mail:newMail', function(data)
	exports.npwd:sendUIMessage({type = "npwd:qb-mail:newMail", payload = {data}})
	SetTimeout(3500, function ()
		exports["npwd"]:createNotification({
			notisId = "npwd:newmail",
			appId = "mail",
			content = Lang:t('newmail'),
			keepOpen = false,
			duration = 5000,
			path = "/mail",
		})
	end)
end)