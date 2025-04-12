register_gfx_blueprint "drone_bump"
{
    weapon_fx = {
        advance   = 0.5,
    },
    equip = {},
}

register_gfx_blueprint "fx_on_shot_drone_printer_lazer"
{
    fx = {
        tag  = "muzzle",
    },
    lifetime = {
        duration = 2.0,
    },
    sprite = {
        material = "data/texture/fx/beam_test/beam_railgun",
        size     = vec2( 0.1, 0.1 ),
        beam     = "segmented",
    },
    target = {
        offset   = vec3( 0.0, 1.0, 0.0 ),
    },
    fade = {
        fade_in  = 0.2,
        fade_out = 0.1,
        easing   = EASING_SINE,
    },
}

register_gfx_blueprint "drone_target_laser"
{
    weapon_fx = {
        on_fire    = "fx_on_fire_railgun",
        on_shot    = "fx_on_shot_drone_printer_lazer",
        velocity   = 50.0,
    },
}

register_gfx_blueprint "drone_target_laser2"
{
    weapon_fx = {
        on_fire    = "fx_on_fire_railgun",
        on_shot    = "fx_on_shot_drone_printer_lazer",
        velocity   = 50.0,
    },
}

register_gfx_blueprint "drone_target_laser3"
{
    weapon_fx = {
        on_fire    = "fx_on_fire_railgun",
        on_shot    = "fx_on_shot_drone_printer_lazer",
        velocity   = 50.0,
    },
}

register_gfx_blueprint "printed_drone"
{
    blueprint = "drone_base",
    scale = {
        scale = 0.5,
    },
    style = {
        materials = {
            drone = "data/texture/drone_01/A/drone_01_A",
        },
    },
}

register_gfx_blueprint "printed_combat_drone"
{
    blueprint = "drone_base",
    scale = {
        scale = 0.7,
    },
    style = {
        materials = {
            drone = "data/texture/drone_01/B/drone_01_B",
        },
    },
}

register_gfx_blueprint "printed_military_drone"
{
    blueprint = "drone_base",
    scale = {
        scale = 0.8,
    },
    style = {
        materials = {
            drone = "data/texture/drone_01/C/drone_01_C",
        },
    },
}


register_gfx_blueprint "drone_printer"
{
    ragdoll  = "ragdoll_tank_mech",
    animator = "animator_tank_mech",
    skeleton = "data/model/tank_mech_01.nmd",
    rotation = {
        pivot = "RigHead1",
        range = 100,
        keep  = true,
    },
    movement = {
        no_rotate = true,
    },
    scale = {
        scale = 0.4
    },
    {
        scene = {},
        scale = {
            scale = 0.4
        },
        render = {
            mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01",
            material    = "data/texture/tank_mech_01/A/tank_mech_body_01",
        },
        {
            scene = {},
            scale = {
                scale = 0.4
            },
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#01",
                material    = "data/texture/tank_mech_01/A/tank_mech_head_01",
            },
        },
        {
            scene = {},
            scale = {
                scale = 0.4
            },
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#02",
                material    = "data/texture/tank_mech_01/A/tank_mech_legs_01",
            },
        },
    }
}

register_gfx_blueprint "combat_drone_printer"
{
    ragdoll  = "ragdoll_tank_mech",
    animator = "animator_tank_mech",
    skeleton = "data/model/tank_mech_01.nmd",
    rotation = {
        pivot = "RigHead1",
        range = 100,
        keep  = true,
    },
    movement = {
        no_rotate = true,
    },
    scale = {
        scale = 0.5
    },
    {
        scene = {},
        scale = {
            scale = 0.5
        },
        render = {
            mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01",
            material    = "data/texture/tank_mech_01/A/tank_mech_body_01",
        },
        {
            scene = {},
            scale = {
                scale = 0.5
            },
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#01",
                material    = "data/texture/tank_mech_01/A/tank_mech_head_01",
            },
        },
        {
            scene = {},
            scale = {
                scale = 0.5
            },
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#02",
                material    = "data/texture/tank_mech_01/A/tank_mech_legs_01",
            },
        },
    }
}

register_gfx_blueprint "military_drone_printer"
{
    ragdoll  = "ragdoll_tank_mech",
    animator = "animator_tank_mech",
    skeleton = "data/model/tank_mech_01.nmd",
    rotation = {
        pivot = "RigHead1",
        range = 100,
        keep  = true,
    },
    movement = {
        no_rotate = true,
    },
    scale = {
        scale = 0.7
    },
    {
        scene = {},
        scale = {
            scale = 0.7
        },
        render = {
            mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01",
            material    = "data/texture/tank_mech_01/A/tank_mech_body_01",
        },
        {
            scene = {},
            scale = {
                scale = 0.7
            },
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#01",
                material    = "data/texture/tank_mech_01/A/tank_mech_head_01",
            },
        },
        {
            scene = {},
            scale = {
                scale = 0.7
            },
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#02",
                material    = "data/texture/tank_mech_01/A/tank_mech_legs_01",
            },
        },
    }
}