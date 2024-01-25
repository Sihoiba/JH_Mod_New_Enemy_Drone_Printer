function drone_print(self, print_max, print_delay)
    nova.log(tostring(self).." drone is printing")
    local max_print = print_max
    if self.data.disabled then
        return
    end
    if self:child("disabled" ) then
        return
    end
    if world:get_level():is_visible( world:get_position( self ) ) then
        max_print = self.data.print_max
    end
    if self.flags.data[ EF_IFF ] == true then
        max_print = 3
    end
    if self.data.print_count < max_print then
        if self.data.print_delay < print_delay then
            self.data.print_delay = self.data.print_delay + 1
            return
        end
        self.data.print_delay = 0
        world:play_sound( "armor_shard", self )
        local c = world:get_level():drop_coord(world:get_position( self ))
        if c then
            nova.log(tostring(self).." got spawn coord x:"..tostring(c.x)..", y:"..tostring(c.y))
            local s = world:get_level():add_entity( self.data.print_id, c, nil )
            s.data.parent = self
            if self.flags.data[ EF_IFF ] == true then
                aitk.convert( s, world:get_player() )
            end
            self.data.print_count = self.data.print_count + 1
        else
            nova.log(tostring(self).." no where safe to spawn")
        end
    end
end

register_blueprint "drone_bump"
{
    weapon = {
        group       = "melee",
        type        = "melee",
        natural     = true,
        damage_type = "impact",
        fire_sound  = "blunt_swing",
        hit_sound   = "blunt",
    },
    attributes = {
        damage   = 10,
        accuracy = 0,
    },
}

register_blueprint "buff_targeted"
{
    flags = { EF_NOPICKUP },
    text = {
        name    = "Target Painted",
        desc    = "Reduces dodge by 10%",
    },
    callbacks = {
        on_die = [[
            function ( self )
                world:mark_destroy( self )
            end
        ]],
    },
    attributes = {
        dodge_value = -10,
    },
    ui_buff = {
        color = LIGHTRED,
    },
}

register_blueprint "buff_targeted2"
{
    flags = { EF_NOPICKUP },
    text = {
        name    = "Target Painted",
        desc    = "Reduces dodge by 15%",
    },
    callbacks = {
        on_die = [[
            function ( self )
                world:mark_destroy( self )
            end
        ]],
    },
    attributes = {
        dodge_value = -15,
    },
    ui_buff = {
        color = LIGHTRED,
    },
}

register_blueprint "buff_targeted3"
{
    flags = { EF_NOPICKUP },
    text = {
        name    = "Target Painted",
        desc    = "Reduces dodge by 20%",
    },
    callbacks = {
        on_die = [[
            function ( self )
                world:mark_destroy( self )
            end
        ]],
    },
    attributes = {
        dodge_value = -20,
    },
    ui_buff = {
        color = LIGHTRED,
    },
}

register_blueprint "drone_target_laser"
{
    attributes = {
        damage = 10,
        shots = 1,
        min_distance = 4,
        opt_distance = 6,
        max_distance = 8,
    },
    weapon = {
        natural = true,
        type = "rail",
        group = "semi",
        damage_type = "emp",
        fire_sound = "energy2_shot",
    },
    callbacks = {
        on_damage = [[
            function ( weapon, who, amount, source )
                if who and who.data and who.data.is_player then
                    world:add_buff( who, "buff_targeted", 200 )
                end
            end
        ]],
    },
}

register_blueprint "drone_target_laser2"
{
    attributes = {
        damage = 10,
        shots = 1,
        min_distance = 4,
        opt_distance = 6,
        max_distance = 8,
    },
    weapon = {
        natural = true,
        type = "rail",
        group = "semi",
        damage_type = "emp",
        fire_sound = "energy2_shot",
    },
    callbacks = {
        on_damage = [[
            function ( weapon, who, amount, source )
                if who and who.data and who.data.is_player then
                    world:add_buff( who, "buff_targeted2", 200 )
                end
            end
        ]],
    },
}

register_blueprint "drone_target_laser3"
{
    attributes = {
        damage = 10,
        shots = 1,
        min_distance = 4,
        opt_distance = 6,
        max_distance = 8,
    },
    weapon = {
        natural = true,
        type = "rail",
        group = "semi",
        damage_type = "emp",
        fire_sound = "energy2_shot",
    },
    callbacks = {
        on_damage = [[
            function ( weapon, who, amount, source )
                if who and who.data and who.data.is_player then
                    world:add_buff( who, "buff_targeted3", 200 )
                end
            end
        ]],
    },
}

register_blueprint "printed_drone"
{
    blueprint = "drone_base",
    lists = {
        group = "being",
        { keywords = { "drone", "robotic", "civilian" } },
    },
    text = {
        name      = "printed security drone",
        namep     = "printed security drones",
        entry     = "Drone",
    },
    data = {
        parent = nil,
    },
    callbacks = {
        on_create = [=[
        function( self )
            self:attach( "drone_weapon_1" )
            self:attach( "ammo_9mm", { stack = { amount = 1 + math.random(3) } } )
            local hack    = self:attach( "terminal_bot_hack" )
            hack.attributes.tool_cost = 3
            local disable = self:attach( "terminal_bot_disable" )
            disable.attributes.tool_cost = 1
            self:attach( "terminal_return" )
        end
        ]=],
        on_die = [=[
            function( self, killer, current, weapon )
                if weapon and weapon.weapon and weapon.weapon.type == world:hash("melee") then return end
                world:play_sound( "explosion", self, 0.3 )
                ui:spawn_fx( nil, "fx_drone_explode", nil, world:get_position( self ) )
                self.data.parent.data.print_count = self.data.parent.data.print_count - 1
            end
        ]=],
        on_activate = [=[
            function( self, who, level, param )
                if who == world:get_player() then
                    world:play_sound( "ui_terminal_accept", self )
                    ui:activate_terminal( who, self, uitk.hack_activate_params( self ) )
                    return 0
                else
                    return 0
                end
            end
        ]=],
    },
    attributes = {
        experience_value = 0,
        accuracy = -10,
        health   = 10,
    },
}

register_blueprint "printed_combat_drone"
{
    blueprint = "drone_base",
    lists = {
        group = "being",
        { keywords = { "drone", "robotic", "civilian" } },
    },
    text = {
        name      = "printed combat drone",
        namep     = "printed combat drones",
        entry     = "Drone",
    },
    data = {
        parent = nil,
    },
    ascii     = {
        glyph     = "^",
        color     = YELLOW,
    },
    callbacks = {
        on_create = [=[
        function( self )
            self:attach( "drone_weapon_2" )
            self:attach( "ammo_9mm", { stack = { amount = 3 + math.random(2) } } )
            local hack    = self:attach( "terminal_bot_hack" )
            hack.attributes.tool_cost = 4
            local disable = self:attach( "terminal_bot_disable" )
            disable.attributes.tool_cost = 2
            self:attach( "terminal_return" )
        end
        ]=],
        on_die = [=[
            function( self, killer, current, weapon )
                if weapon and weapon.weapon and weapon.weapon.type == world:hash("melee") then return end
                world:play_sound( "explosion", self, 0.3 )
                ui:spawn_fx( nil, "fx_drone_explode", nil, world:get_position( self ) )
                self.data.parent.data.print_count = self.data.parent.data.print_count - 1
            end
        ]=],
    },
    attributes = {
        experience_value = 0,
        accuracy = 0,
        health   = 20,
    },
}

register_blueprint "printed_military_drone"
{
    blueprint = "drone_base",
    lists = {
        group = "being",
        { keywords = { "drone", "robotic", "civilian" } },
    },
    text = {
        name      = "printed military drone",
        namep     = "printed military drones",
        entry     = "Drone",
    },
    ascii     = {
        glyph     = "^",
        color     = WHITE,
    },
    data = {
        parent = nil,
    },
    callbacks = {
        on_create = [=[
        function( self )
            self:attach( "drone_weapon_3" )
            self:attach( "ammo_762", { stack = { amount = 3 + math.random(2) } } )
            local hack    = self:attach( "terminal_bot_hack" )
            hack.attributes.tool_cost = 5
            local disable = self:attach( "terminal_bot_disable" )
            disable.attributes.tool_cost = 3
            self:attach( "terminal_return" )
        end
        ]=],
        on_die = [=[
            function( self, killer, current, weapon )
                if weapon and weapon.weapon and weapon.weapon.type == world:hash("melee") then return end
                world:play_sound( "explosion", self, 0.3 )
                ui:spawn_fx( nil, "fx_drone_explode", nil, world:get_position( self ) )
                self.data.parent.data.print_count = self.data.parent.data.print_count - 1
            end
        ]=],
    },
    attributes = {
        experience_value = 0,
        accuracy = 10,
        health   = 30,
    },
}

register_blueprint "drone_printer_self_destruct"
{
    attributes = {
        damage    = 30,
        explosion = 2,
    },
    weapon = {
        group = "env",
        damage_type = "slash",
        natural = true,
        fire_sound = "explosion",
    },
    noise = {
        use = 15,
    },
}

register_blueprint "drone_printer"
{
    blueprint = "bot",
    lists = {
        group = "being",
        { keywords = { "test2" }, weight = 150 },
        {  keywords = { "callisto", "bot", "robotic", "civilian" }, weight = 50, dmin = 5, dmax = 19, },
    },
    flags = { EF_NOMOVE, EF_NOFLY, EF_TARGETABLE, EF_ALIVE, EF_ACTION, EF_BUMPACTION, },
    text = {
        name      = "drone printer",
        namep     = "drone printers",
    },
    sound = {
        idle = "drone_printer_idle",
        step = "drone_printer_step",
        die  = "drone_printer_die",
    },
    ascii     = {
        glyph     = "P",
        color     = WHITE,
    },
    data = {
        ai = {
            aware     = false,
            alert     = 1,
            group     = "security",
            state     = "idle",
            melee     = 1,
            range     = 6,
            cover     = true,
        },
        print_id = "printed_drone",
        print_count = 0,
        print_max = 6,
        print_delay = 0;
    },
    attributes = {
        evasion = -20,
        accuracy         = 0,
        speed            = 0.9,
        damage_mult      = 0.5,
        health           = 90,
        experience_value = 50,
        resist = {
            emp = 10,
        },
    },
    state = "open",
    inventory = {},
    callbacks = {
        on_create = [=[
            function( self )
                self:attach( "drone_bump" )
                self:attach( "drone_target_laser" )
                local hack    = self:attach( "terminal_bot_hack" )
                hack.attributes.tool_cost = 7
                local disable = self:attach( "terminal_bot_disable" )
                disable.attributes.tool_cost = 5
                self:attach( "terminal_return" )
                self:attach( "ammo_9mm", { stack = { amount = 30 } } )
            end
            ]=],
        on_load = [=[
            function ( self )
                world:get_level():rotate_towards( self, world:get_player() )
            end
        ]=],
        on_action   = [=[
            function( self )
                aitk.standard_ai( self )
                nova.log( tostring(self).."is trying to print drone "..tostring(self.data.print_count).." of "..tostring(self.data.print_max) )
                drone_print( self, 3, 3 )
            end
        ]=],
        on_noise    = "aitk.on_noise",
        on_die = [=[
            function( self, killer, current, weapon )
                if weapon and weapon.weapon and weapon.weapon.type == world:hash("melee") then return end
                local w = world:create_entity( "drone_printer_self_destruct" )
                world:attach( self, w )
                world:get_level():fire( self, world:get_position( self ), w )
            end
            ]=],
        on_activate = [=[
            function( self, who, level, param )
                if who == world:get_player() then
                    world:play_sound( "ui_terminal_accept", self )
                    ui:activate_terminal( who, self, uitk.hack_activate_params( self ) )
                    return 0
                else
                    return 0
                end
            end
        ]=],
    },
}

register_blueprint "combat_drone_printer"
{
    blueprint = "bot",
    lists = {
        group = "being",
        { keywords = { "test2" }, weight = 150 },
        {  keywords = { "europa", "bot", "robotic", "civilian" }, weight = 50, dmin = 12, dmax = 38, },
    },
    flags = { EF_NOMOVE, EF_NOFLY, EF_TARGETABLE, EF_ALIVE, EF_ACTION, EF_BUMPACTION, },
    text = {
        name      = "combat drone printer",
        namep     = "combat drone printers",
    },
    sound = {
        idle = "drone_printer_idle",
        step = "drone_printer_step",
        die  = "drone_printer_die",
    },
    ascii     = {
        glyph     = "P",
        color     = WHITE,
    },
    data = {
        ai = {
            aware     = false,
            alert     = 1,
            group     = "security",
            state     = "idle",
            melee     = 1,
            range     = 6,
            cover     = true,
        },
        print_id = "printed_combat_drone",
        print_count = 0,
        print_max = 8,
        print_delay = 0;
    },
    attributes = {
        evasion = -20,
        accuracy         = 0,
        speed            = 0.9,
        health           = 120,
        experience_value = 75,
        resist = {
            emp = 20,
        },
    },
    state = "open",
    inventory = {},
    callbacks = {
        on_create = [=[
            function( self )
                self:attach( "drone_bump" )
                self:attach( "drone_target_laser2" )
                local hack    = self:attach( "terminal_bot_hack" )
                hack.attributes.tool_cost = 7
                local disable = self:attach( "terminal_bot_disable" )
                disable.attributes.tool_cost = 5
                self:attach( "terminal_return" )
                self:attach( "ammo_762", { stack = { amount = 20 + math.random(5) } } )
            end
            ]=],
        on_load = [=[
            function ( self )
                world:get_level():rotate_towards( self, world:get_player() )
            end
        ]=],
        on_action   = [=[
            function( self )
                aitk.standard_ai( self )
                nova.log( tostring(self).."is printing drone "..tostring(self.data.print_count).." of "..tostring(self.data.print_max) )
                drone_print(self, 3, 2)
            end
        ]=],
        on_noise    = "aitk.on_noise",
        on_die = [=[
        function( self, killer, current, weapon )
            if weapon and weapon.weapon and weapon.weapon.type == world:hash("melee") then return end
            local w = world:create_entity( "drone_printer_self_destruct" )
            world:attach( self, w )
            world:get_level():fire( self, world:get_position( self ), w )
        end
        ]=],
        on_activate = [=[
            function( self, who, level, param )
                if who == world:get_player() then
                    world:play_sound( "ui_terminal_accept", self )
                    ui:activate_terminal( who, self, uitk.hack_activate_params( self ) )
                    return 0
                else
                    return 0
                end
            end
        ]=],
    },
}

register_blueprint "military_drone_printer"
{
    blueprint = "bot",
    lists = {
        group = "being",
        -- { keywords = { "test" }, weight = 150 },
        {  keywords = { "io", "beyond", "bot", "robotic", "civilian" }, weight = 50, dmin = 16, dmax = 57, },
    },
    flags = { EF_NOMOVE, EF_NOFLY, EF_TARGETABLE, EF_ALIVE, EF_ACTION, EF_BUMPACTION, },
    text = {
        name      = "military drone printer",
        namep     = "military drone printers",
    },
    sound = {
        idle = "drone_printer_idle",
        step = "drone_printer_step",
        die  = "drone_printer_die",
    },
    ascii     = {
        glyph     = "P",
        color     = WHITE,
    },
    data = {
        ai = {
            aware     = false,
            alert     = 1,
            group     = "security",
            state     = "idle",
            melee     = 1,
            range     = 6,
            cover     = true,
        },
        print_id = "printed_military_drone",
        print_count = 0,
        print_max = 10,
        print_delay = 0;
    },
    attributes = {
        evasion          = -20,
        accuracy         = 0,
        speed            = 0.9,
        health           = 180,
        experience_value = 100,
        damage_mult      = 1.2,
        resist = {
            emp = 30,
        },
    },
    state = "open",
    inventory = {},
    callbacks = {
        on_create = [=[
            function( self )
                self:attach( "drone_bump" )
                self:attach( "drone_target_laser3" )
                local hack    = self:attach( "terminal_bot_hack" )
                hack.attributes.tool_cost = 8
                local disable = self:attach( "terminal_bot_disable" )
                disable.attributes.tool_cost = 6
                self:attach( "terminal_return" )
                self:attach( "ammo_762", { stack = { amount = 30 + math.random(5) } } )
            end
            ]=],
        on_load = [=[
            function ( self )
                world:get_level():rotate_towards( self, world:get_player() )
            end
        ]=],
        on_action   = [=[
            function( self )
                aitk.standard_ai( self )
                nova.log( tostring(self).."is printing drone "..tostring(self.data.print_count).." of "..tostring(self.data.print_max) )
                drone_print(self, 4, 2)
            end
        ]=],
        on_noise    = "aitk.on_noise",
        on_die = [=[
        function( self, killer, current, weapon )
            if weapon and weapon.weapon and weapon.weapon.type == world:hash("melee") then return end
            local w = world:create_entity( "drone_printer_self_destruct" )
            world:attach( self, w )
            world:get_level():fire( self, world:get_position( self ), w )
        end
        ]=],
        on_activate = [=[
            function( self, who, level, param )
                if who == world:get_player() then
                    world:play_sound( "ui_terminal_accept", self )
                    ui:activate_terminal( who, self, uitk.hack_activate_params( self ) )
                    return 0
                else
                    return 0
                end
            end
        ]=],
    },
}