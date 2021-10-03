local death_pos = {}

minetest.register_on_dieplayer(function(player, reason)
    local send_tip = minetest.settings:get("death_pos.send_tip_on_die") or true -- Sends tip to use 'death_pos' command when player dies (if true)
    death_pos[player:get_player_name()] = player:get_pos()
    if player and send_tip == true then
        minetest.chat_send_player(player:get_player_name(), minetest.colorize("#60e645", "You died. You can return back to your last death position by using /death_pos command"))
    end
end)

minetest.register_chatcommand("death_pos", {
    description = "Go to your last death position",
    privs = {interact = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local pos = death_pos[player:get_player_name()]
        local clear_pos = minetest.settings:get("death_pos.clear_pos") or true -- Clears the death position when 'death_pos' command is used (if true)
        if pos then
            player:set_pos(pos)
            if clear_pos == true then
                death_pos[player:get_player_name()] = nil
            end
            return false, minetest.colorize("#60e645", "Teleported you back to your death position!")
        else
            return false, "You don't have a death position right now"
        end
    end
})