fx_version 'cerulean'

game 'gta5'

lua54 'yes'

author 'RISK Scripts'

description 'risk-scripts.tebex.io'

version '1.0.WH'

ui_page 'html/index.html'

files {

  'html/index.html',

  'html/assets/**/*'

}

shared_scripts {

  'config.lua',

  'locals.lua'

}

client_scripts {

  'main/client.lua'

}

server_scripts {

  '@mysql-async/lib/MySQL.lua',

  'dcconfig.lua',

  'main/server.lua'

}

escrow_ignore {

    'config.lua',

	'dcconfig.lua',

	'main/server.lua',

	'main/client.lua',

	'locals.lua'

}

dependency '/assetpacks'