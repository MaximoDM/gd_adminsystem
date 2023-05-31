Grupo = {}
Config = {}
Permisos = {}

Grupo.GameMaster = "gamemaster"
Grupo.SuperAdmin = "superadmin"
Grupo.Admin      = "admin"
Grupo.Mod        = "mod"
Grupo.Helper     = "helper"
Grupo.User       = "user"


---------------
--  USERS T --
---------------

Permisos.ira   = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.traer = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.atras = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }

---------------
-- VEHICULOS --
---------------

Permisos.iracoche    = { Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.traercoche  = { Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.lockcoche   = { Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.unlockcoche = { Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.fix         = { Grupo.USer, Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.clean       = { Grupo.USer, Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.setfuel     = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.trunkveh    = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }


---------------
-- PERSONAJE --
---------------

Permisos.sethambre = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.setsed    = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.setescudo = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.setvida   = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.muerte    = { Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }

Permisos.congelar     = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.descongelar  = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.esposar      = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.desesposar   = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.pesposar     = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.visible      = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.invisible    = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.noinvencible = { Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.invencible   = { Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.cachear      = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }


---------------
-- ADMIN UTI --
---------------


Permisos.ir          = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.trabajo     = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.coordenadas = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.infov       = { Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.tpm         = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.dvbeta2     = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.seatcoche   = { Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }

Permisos.aduty = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }

Permisos.noclip = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.recon  = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.id     = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }

Permisos.panuncio = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.admin    = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.aonline  = { Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }

Permisos.chatstaff = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }

Permisos.reportes = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }

Permisos.ha = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }

Permisos.setiddistance = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.adminarea     = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.jtag          = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }

Permisos.jail           = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.unjail         = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.kick           = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.advertencias   = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.revive         = { Grupo.Helper, Grupo.Mod, Grupo.Admin, Grupo.SuperAdmin, Grupo.GameMaster }
Permisos.reviveall      = { Grupo.GameMaster }
Permisos.setgroup       = { Grupo.GameMaster }
Permisos.setpermissions = { Grupo.GameMaster }
Permisos.mafia          = { Grupo.GameMaster }



Config.Configs = {
    Carcel = {
        { x = 1641.64, y = 2571.08, z = 45.56 },
        { x = 1651.03, y = 2570.78, z = 45.56 }
    },
    Avante = 8755522,
    JailWarns = 2,
    JailWarnsMinutes = 20,
    ExitCarcel = vector3(1873.51, 2600.2, 45.67),
    JailMaxWarns = "Se ha aumentado tu condena 20 minutos por incumplimiento de la misma"
}


Config.Uniforme = {
    admin = {
        helper = {
            male = {
                ['tshirt_1'] = 0, ['tshirt_2'] = 0,
                ['torso_1'] = 0, ['torso_2'] = 1,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 23,
                ['pants_1'] = 152, ['pants_2'] = 0,
                ['ears_1'] = 1, ['ears_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['shoes_1'] = 93, ['shoes_2'] = 8,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            },
            female = {
                ['tshirt_1'] = 274, ['tshirt_2'] = 0,
                ['torso_1'] = 527, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 13,
                ['pants_1'] = 15, ['pants_2'] = 0,
                ['ears_1'] = 1, ['ears_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['shoes_1'] = 119, ['shoes_2'] = 0,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
        },
        mod = {
            male = {
                ['tshirt_1'] = 0, ['tshirt_2'] = 0,
                ['torso_1'] = 0, ['torso_2'] = 1,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 23,
                ['pants_1'] = 152, ['pants_2'] = 0,
                ['ears_1'] = 1, ['ears_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['shoes_1'] = 93, ['shoes_2'] = 8,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            },
            female = {
                ['tshirt_1'] = 274, ['tshirt_2'] = 0,
                ['torso_1'] = 527, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 13,
                ['pants_1'] = 15, ['pants_2'] = 0,
                ['ears_1'] = 1, ['ears_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['shoes_1'] = 119, ['shoes_2'] = 0,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
        },
        admin = {
            male = {
                ['tshirt_1'] = 0, ['tshirt_2'] = 0,
                ['torso_1'] = 0, ['torso_2'] = 1,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 23,
                ['pants_1'] = 152, ['pants_2'] = 0,
                ['ears_1'] = 1, ['ears_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['shoes_1'] = 93, ['shoes_2'] = 8,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            },
            female = {
                ['tshirt_1'] = 274, ['tshirt_2'] = 0,
                ['torso_1'] = 527, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 13,
                ['pants_1'] = 15, ['pants_2'] = 0,
                ['ears_1'] = 1, ['ears_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['shoes_1'] = 119, ['shoes_2'] = 0,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            },
            nath = {
                ['tshirt_1'] = 262, ['tshirt_2'] = 0,
                ['torso_1'] = 512, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 13,
                ['pants_1'] = 127, ['pants_2'] = 0,
                ['ears_1'] = 1, ['ears_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['shoes_1'] = 18, ['shoes_2'] = 1,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
        },
        superadmin = {
            male = {
                ['tshirt_1'] = 0, ['tshirt_2'] = 0,
                ['torso_1'] = 0, ['torso_2'] = 1,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 23,
                ['pants_1'] = 152, ['pants_2'] = 0,
                ['ears_1'] = 1, ['ears_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['shoes_1'] = 93, ['shoes_2'] = 8,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            },
            female = {
                ['tshirt_1'] = 274, ['tshirt_2'] = 0,
                ['torso_1'] = 527, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 13,
                ['pants_1'] = 15, ['pants_2'] = 0,
                ['ears_1'] = 1, ['ears_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['shoes_1'] = 119, ['shoes_2'] = 0,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
        },
        gamemaster = {
            male = {
                ['tshirt_1'] = 0, ['tshirt_2'] = 0,
                ['torso_1'] = 0, ['torso_2'] = 1,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 23,
                ['pants_1'] = 152, ['pants_2'] = 0,
                ['ears_1'] = 1, ['ears_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['shoes_1'] = 93, ['shoes_2'] = 8,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            },
            female = {
                ['tshirt_1'] = 274, ['tshirt_2'] = 0,
                ['torso_1'] = 527, ['torso_2'] = 0,
                ['decals_1'] = 0, ['decals_2'] = 0,
                ['arms'] = 13,
                ['pants_1'] = 15, ['pants_2'] = 0,
                ['ears_1'] = 1, ['ears_2'] = 1,
                ['helmet_1'] = -1, ['helmet_2'] = 0,
                ['bags_1'] = 0, ['bags_2'] = 0,
                ['shoes_1'] = 119, ['shoes_2'] = 0,
                ['chain_1'] = 0, ['chain_2'] = 0,
                ['mask_1'] = 0, ['mask_2'] = 0,
                ['glasses_1'] = 0, ['glasses_2'] = 0,
                ['bproof_1'] = 0, ['bproof_2'] = 0
            }
        }
    },
}
