RegisterNUICallback('npwd:qbx_mail:getMail', function(_, cb)
	local mail = lib.callback.await('npwd:qbx_mail:getMail', false)
	cb({ status = 'ok', data = mail })
end)

RegisterNUICallback('npwd:qbx_mail:updateRead', function(data, cb)
	lib.callback.await('npwd:qbx_mail:updateRead', false, data)
	cb({})
end)

RegisterNUICallback('npwd:qbx_mail:deleteMail', function(data, cb)
	local mailDeleted = lib.callback.await('npwd:qbx_mail:deleteMail', false, data)
	cb({ status = mailDeleted and 'ok' or 'error' })
end)

RegisterNUICallback('npwd:qbx_mail:updateButton', function(data, cb)
	TriggerEvent(data.button.buttonEvent, data.button.buttonData)
	local buttonUpdated = lib.callback.await('npwd:qbx_mail:updateButton', false, data.mailid)
	cb({ status = buttonUpdated and 'ok' or 'error' })
end)

RegisterNetEvent('npwd:qbx_mail:newMail', function(data)
	exports.npwd:sendNPWDMessage({type = 'npwd:qbx_mail:newMail', payload = {data}})
	SetTimeout(3500, function ()
		exports.npwd:createNotification({
			notisId = 'npwd:newmail',
			appId = 'mail',
			content = Lang:t('newmail'),
			keepOpen = false,
			duration = 5000,
			path = '/mail',
		})
	end)
end)

RegisterNetEvent('npwd_qbx_mail:testMail', function()
	local email = {
		sender = 'Mr. Attenborough',
		subject = 'Test Email',
		message = 'This is a test of our electronic mail system',
	}
    TriggerServerEvent('qb-phone:server:sendNewMail', email)
end)