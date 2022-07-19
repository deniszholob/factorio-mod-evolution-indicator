local mod_gui = require('mod-gui') -- From `Factorio\data\core\lualib`

local OLD_EVOLUTION_FRAME = 'frame_Evolution'

--- Apply migrations from previous versions
function migrations()
  for i, player in pairs(game.players) do
    destroy_old_gui(player)
  end
end

--- Destroys element if exists
--- @param el LuaGuiElement Element
function destroy_old_gui(player)
  local el_button_flow = mod_gui.get_button_flow(player)
  local el_main_frame = el_button_flow[OLD_EVOLUTION_FRAME]
  destroy_element(el_main_frame)
end

--- Destroys element if exists
--- @param el LuaGuiElement Element
function destroy_element(el)
  if (el ~= nil) then
    el.destroy()
  end
end

migrations()
