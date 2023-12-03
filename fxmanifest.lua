fx_version "cerulean"
game "gta5"

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
}

client_script 'client/client.lua'

server_script {
    'server/server.lua',
    '@oxmysql/lib/MySQL.lua',
}

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html',
    'web/dist/*.js',
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'