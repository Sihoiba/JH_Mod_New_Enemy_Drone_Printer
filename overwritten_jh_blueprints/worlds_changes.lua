register_blueprint "valhalla_shutdown_runtime"
{
    flags = { EF_NOPICKUP }, 
    attributes = {
        tier = 1,
    },
    callbacks = {
        on_enter_level = [=[
            function ( self, entity )
                local current_id = world.data.current
                local current    = world.data.level[ current_id ]
                if current.episode > 1 then
                    world:mark_destroy( self )
                    return
                end
                local tier  = self.attributes.tier
                local level = world:get_level()
                local ids = { turret = true, rturret = true, security_bot_1 = true, security_bot_3 = true, sentry_bot_1 = true, sentry_bot_2 = true, sentry_bot_3 = true, drone1 = true, drone2 = true, drone3 = true, adv_security_bot = true, drone_printer = true, printed_drone = true, }
                for e in level:entities() do 
                    if e.minimap and e.flags and e.flags.data[ EF_TARGETABLE ] then
                        local id = world:get_id( e )
                        if ids[ id ] then
                            if tier > 1 then
                                aitk.convert( e, entity, not e:flag( EF_NOCORPSE ) )
                            else
                                aitk.disable( e, entity )
                            end
                        end
                        if tier == 3 and id == "boss_tank_mech" then
                            aitk.disable( e, entity )
                            world:lua_callback( e, "bulwark_close" )
                            level.ui_boss.boss = nil
                        end
                    end
                end
            end
        ]=],
    },
}

register_blueprint "mimir_shutdown_runtime"
{
    flags = { EF_NOPICKUP }, 
    attributes = {
        tier    = 1,
        counter = 0,
    },
    callbacks = {
        on_enter_level = [=[
            function ( self, entity )
                world:preload( "mimir_sentry_bot" )
                local current_id = world.data.current
                local current    = world.data.level[ current_id ]
                if current.episode > 1 then
                    world:mark_destroy( self )
                    return
                end
                local level = world:get_level()
                local tier  = self.attributes.tier
                local ids = { turret = true, rturret = true, security_bot_1 = true, security_bot_3 = true, sentry_bot_1 = true, sentry_bot_2 = true, sentry_bot_3 = true, drone1 = true, drone2 = true, drone3 = true, adv_security_bot = true, mimir_sentry_bot = true, drone_printer = true, printed_drone = true, }
                for e in level:entities() do 
                    if e.minimap and e.flags and e.flags.data[ EF_TARGETABLE ] then
                        if e.data and e.data.ai and e.data.ai.group ~= "player" then
                            local id = world:get_id( e )
                            if ids[ id ] then
                                if tier > 1 and id == "mimir_sentry_bot" then
                                    aitk.convert( e, entity, true )
                                else
                                    aitk.disable( e, entity )
                                end
                            end
                        end
                    end
                end
            end
        ]=],
        on_timer = [[
            function ( self, first )
                if first or world:current_transfer() > 0 then return 500 end
                local counter = self.attributes.counter
                if counter > 0 then
                    local level  = world:get_level()
                    if level.attributes.mdf then 
                        return 500
                    end

                    local mdf_count = 0
                    for e in level:entities() do 
                        if e.data and e.data.ai then
                            if e.attributes and e.attributes.mdf and e.attributes.mdf > 0 then
                                mdf_count = mdf_count + 1
                                if mdf_count >= counter then 
                                    return 500
                                end
                            end
                        end
                    end
                    local summon = level:add_entity( "mimir_sentry_bot", level.level_info.entry )
                    world:destroy( summon:child( "mimir_terminal_download" ) ) 
                    aitk.convert( summon, entity, true, true )
                    summon.attributes.mdf = 1
                    local ai = summon.data.ai
                    ai.state = "idle"
                    ai.idle = "active_hunt"
                    ai.seek = "seek"
                    summon.flags.data[ EF_FOLLOW ] = false
                end
                return 500
            end
        ]],
    },
}