--- Evolution Module
--- Uses locale evolution.cfg
--- @usage require('modules/evolution')
--- @author Denis Zholob (DDDGamer)
--- @see github: https://github.com/deniszholob/factorio-mod-evolution-indicator
--- ======================================================================== ---

--- Dependencies --
--- ======================================================================== ---
-- stdlib
local Event = require('__stdlib__/stdlib/event/event')
local Math = require('__stdlib__/stdlib/utils/math') -- Math.round_to(x, pres)
-- util
local Colors = require('util/Colors')
local GUI = require('util/GUI')
local Sprite = require("util/Sprite")
local Sprites = require("util/Sprites")
local Styles = require('util/Styles')
local Time = require("util/Time")

--- Constants --
--- ======================================================================== ---
DDD_Evolution = {
  MAIN_FRAME_NAME = 'frame_main_Evolution',
  EVOLUTION_FLOW_NAME = 'flw_Evolution',
  EVOLUTION_SPRITE_NAME = 'sprite_Evolution',
  EVOLUTION_LABEL_NAME = 'lbl_Evolution',
  EVOLUTION_PROGRESS_NAME = 'bar_Evolution',
  EVOLUTION_SPRITES = {
    [0.00] = Sprites.small_biter,
    [0.21] = Sprites.medium_biter,
    [0.26] = Sprites.small_spitter,
    [0.41] = Sprites.medium_spitter,
    [0.50] = Sprites.big_biter,
    [0.51] = Sprites.big_spitter,
    [0.90] = Sprites.behemoth_biter,
    [0.91] = Sprites.behemoth_spitter,
  },
  EVOLUTION_COLORS = {
    [0.00] = Colors.orange,
    [0.21] = Colors.salmon,
    [0.50] = Colors.blue,
    [0.90] = Colors.darkgreen,
  },
  REFRESH_PERIOD = 5, -- seconds
  -- GUI element getters
  get_el_main_frame_container = function(player)
    return GUI.menu_bar_el(player);
  end,
  get_el_main_frame = function(player)
    return DDD_Evolution.get_el_main_frame_container(player)[DDD_Evolution.MAIN_FRAME_NAME];
  end,
  get_el_evo_progress = function(player)
    return DDD_Evolution.get_el_main_frame(player)[DDD_Evolution.EVOLUTION_PROGRESS_NAME]
  end,
  get_el_evo_sprite = function(player)
    return DDD_Evolution.get_el_main_frame(player)
        [DDD_Evolution.EVOLUTION_FLOW_NAME][DDD_Evolution.EVOLUTION_SPRITE_NAME]
  end,
  get_el_evo_label = function(player)
    return DDD_Evolution.get_el_main_frame(player)
        [DDD_Evolution.EVOLUTION_FLOW_NAME][DDD_Evolution.EVOLUTION_LABEL_NAME]
  end
}

--- Event Functions --
--- ======================================================================== ---

--- When new player is created, create mod GUI for player
--- @param event EventData.on_player_created defines.events.on_player_created event
function DDD_Evolution.on_player_created(event)
  local player = game.players[event.player_index]
  DDD_Evolution.gui_refresh(player)
end

--- When new player joins, create mod GUI for player
--- @param event EventData.on_player_joined_game defines.events.on_player_joined_game
function DDD_Evolution.on_player_joined_game(event)
  local player = game.players[event.player_index]
  DDD_Evolution.gui_refresh(player)
end

--- When a player leaves, clean up their GUI in case this mod gets removed or changed next time
--- @param event EventData.on_player_left_game defines.events.on_player_left_game
function DDD_Evolution.on_player_left_game(event)
  local player = game.players[event.player_index]
  DDD_Evolution.gui_destroy(player)
end

--- Refresh the GUI after REFRESH_PERIOD
--- @param event EventData.on_tick defines.events.on_tick
function DDD_Evolution.on_tick(event)
  local refresh_period = DDD_Evolution.REFRESH_PERIOD -- (sec)
  if (Time.tick_to_sec(game.tick) % refresh_period == 0) then
    for i, player in pairs(game.connected_players) do
      DDD_Evolution.gui_refresh(player)
      -- For Testing, artificially add pollution
      -- player.surface.pollute(player.position, 100000)
    end
  end
end

--- Event Registration --
--- ======================================================================== ---
Event.register(defines.events.on_player_created, DDD_Evolution.on_player_created)
Event.register(defines.events.on_player_joined_game, DDD_Evolution.on_player_joined_game)
Event.register(defines.events.on_player_left_game, DDD_Evolution.on_player_left_game)
Event.register(defines.events.on_tick, DDD_Evolution.on_tick)

--- GUI Functions --
--- ======================================================================== ---

--- Main GUI Function to destroy the mod GUI
--- @param player LuaPlayer player calling the function
function DDD_Evolution.gui_destroy(player)
  GUI.destroy_element(DDD_Evolution.get_el_main_frame(player))
end

--- Main GUI Function to create and refresh the mod GUI
--- @param player LuaPlayer player calling the function
function DDD_Evolution.gui_refresh(player)
  local el_main_frame = DDD_Evolution.get_el_main_frame(player);

  if (not el_main_frame) then
    local container = DDD_Evolution.get_el_main_frame_container(player);
    el_main_frame = GUI.add_element(
      container,
      {
        type = 'frame',
        name = DDD_Evolution.MAIN_FRAME_NAME,
        direction = 'vertical',
        tooltip = { "Evolution.main_frame_caption" },
      }
    )
    DDD_Evolution.gui_fill_main_frame(el_main_frame)
  end
  DDD_Evolution.gui_update_evolution(player)
end

--- Fills frame with worst enemy icon and evolution percentage
--- @param container LuaGuiElement parent container to add GUI elements to
function DDD_Evolution.gui_fill_main_frame(container)
  local h_flow = GUI.add_element(container,
    {
      type = 'flow',
      name = DDD_Evolution.EVOLUTION_FLOW_NAME,
      direction = 'horizontal',
    }
  )
  h_flow.style.height = 10

  local sprite = GUI.add_element(h_flow,
    {
      type = 'sprite',
      name = DDD_Evolution.EVOLUTION_SPRITE_NAME,
      tooltip = { "Evolution.main_frame_caption" },
    }
  )

  local label = GUI.add_element(h_flow,
    {
      type = 'label',
      name = DDD_Evolution.EVOLUTION_LABEL_NAME,
      tooltip = { "Evolution.main_frame_caption" },
    }
  )

  local evo_progress_bar = GUI.add_element(container,
    {
      type = 'progressbar',
      name = DDD_Evolution.EVOLUTION_PROGRESS_NAME,
      tooltip = { "Evolution.main_frame_caption" },
      value = 0.2
    }
  )

  evo_progress_bar.style.width = 98
  evo_progress_bar.style.height = 3
  evo_progress_bar.style.top_margin = 14

  GUI.element_apply_style(container, Styles.btn_menu)
  GUI.element_apply_style(label, Styles.btn_menu_lbl)
end

--- Updates the enemy icon and evolution percentage, if its a new icon, send out alert
--- @param player LuaPlayer current player calling the function
function DDD_Evolution.gui_update_evolution(player)
  local el_evo_sprite = DDD_Evolution.get_el_evo_sprite(player)
  local el_evo_label = DDD_Evolution.get_el_evo_label(player)
  local el_evo_progress_bar = DDD_Evolution.get_el_evo_progress(player)
  local evo_stats = DDD_Evolution.get_evo_stats(player)

  if (el_evo_sprite.sprite ~= evo_stats.sprite) then
    el_evo_sprite.sprite = evo_stats.sprite
    player.print({ "Evolution.alert", Sprite.getSpriteRichText(evo_stats.sprite) })
  end
  -- sprite_evolution.tooltip = evolution_stats.evolution_percent
  el_evo_label.caption = evo_stats.evolution_percent
  el_evo_progress_bar.value = evo_stats.evolution
  el_evo_progress_bar.style.color = evo_stats.color
end

--- Logic Functions --
--- ======================================================================== ---

--- Figures out some evolution stats and returns them (Sprite and evo %)
--- @see https://wiki.factorio.com/Enemies#Spawn_chances_by_evolution_factor
--- @param player LuaPlayer current player calling the function
function DDD_Evolution.get_evo_stats(player)
  local evolution_factor = game.forces["enemy"].evolution_factor;
  local spriteIdx = 0;

  -- Figure out what evolution breakpoint we are at
  for evolution, sprite in pairs(DDD_Evolution.EVOLUTION_SPRITES) do
    if (evolution_factor < evolution) then
      break
    end
    spriteIdx = evolution
  end

  -- Figure out what evolution breakpoint we are at
  local colorIdx = 1
  for evo, color in pairs(DDD_Evolution.EVOLUTION_COLORS) do
    if (evolution_factor < evo) then
      break
    end
    colorIdx = evo
  end

  -- return the evolution data
  return {
    sprite = GUI.get_safe_sprite_name(player, DDD_Evolution.EVOLUTION_SPRITES[spriteIdx]),
    evolution = evolution_factor,
    evolution_percent = string.format('%6.2f', Math.round_to(evolution_factor * 100, 2)) .. "%",
    color = DDD_Evolution.EVOLUTION_COLORS[colorIdx]
  }
end
