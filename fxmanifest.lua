fx_version 'cerulean'
game 'gta5'

description 'npwd_qbx_mail'
repository 'https://github.com/Qbox-project/npwd_qbx_mail'
version '0.1.0'

client_script 'client/client.lua'

shared_script '@ox_lib/init.lua'

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
}

ui_page 'web/dist/index.html'

files {
    'web/dist/**/*',
    'locales/*.json'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
