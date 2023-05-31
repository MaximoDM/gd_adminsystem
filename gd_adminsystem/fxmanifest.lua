fx_version 'bodacious'

game 'gta5'

author 'Victor Berbegal | Gladiator RolePlay'
description 'gd_adminsystem'
version '0.9'


ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.js',
	'html/index.css',
	'server/actividad.json'
}


server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/commands.lua',
	'server/main.lua',
	'config.lua'
}

client_script {
	'@menuv/menuv.lua',
	-- 'client/*.lua'
	'client/antidump.lua'
}

shared_scripts {
	'@gd_core/imports.lua', -- This is the only line that is different from the original
}
