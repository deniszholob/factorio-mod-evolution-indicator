--- GUI Module - Common GUI functions
--- @usage local GUI = require('util/GUI')
--- @author Denis Zholob (DDDGamer)
--- @see github: https://github.com/deniszholob/factorio-softmod-pack
--- ======================================================================== ---

--- Dependencies ---
--- ======================================================================== ---
local mod_gui = require('mod-gui') -- From `Factorio\data\core\lualib`
local GUI_Events = require('__stdlib__/stdlib/event/gui')

--- Constants ---
--- ======================================================================== ---
GUI = {
  --- @see https://lua-api.factorio.com/latest/LuaGui.html
  MASTER_FRAME_LOCATIONS = {
    menu = 'menu', -- Button flow (top)
    left = 'left', -- Frame flow
    center = 'center', -- gui.center
    screen = 'screen', -- Draggable Windows
    goal = 'goal', -- Factorio goal section (left)
  },
  EVENTS = {
      on_gui_click = GUI_Events.on_click,
      on_gui_checked_state_changed = GUI_Events.on_checked_state_changed,
  }
}

--- Public Functions ---
--- ======================================================================== ---

--- Destroys the children of a GUI element
--- @param el LuaGuiElementement to destroy childen of
function GUI.clear_element(el)
  if el ~= nil then
    for i, child_el in pairs(el.children) do
      child_el.destroy()
    end
  end
end

--- Toggles element on off (visibility)
--- @param el LuaGuiElement Element to toggle visibility of
function GUI.toggle_element(el)
  if el ~= nil then
    if (el.visible == nil) then -- game treats nil as true
      el.visible = true
    end
    el.visible = not el.visible or false
  end
end

--- Destroys element if exists
--- @param el LuaGuiElement Element
function GUI.destroy_element(el)
  if (el ~= nil) then
    el.destroy()
  end
end

--- Applies a style to the passed in element
--- @param el LuaGuiElement Element
--- @param style LuaStyle
function GUI.element_apply_style(el, style)
  if style then
    for name, value in pairs(style) do
      if (el.style) then
        el.style[name] = value
      else
        error('Element doesnt have style ' .. name)
      end
    end
  end
end

--- Adds an element to the parent element and returns it
--- @see https://lua-api.factorio.com/latest/LuaGuiElement.html#LuaGuiElement.add
--- @param parent LuaGuiElement Element
--- @param el table element parameters
--- @return LuaGuiElement
function GUI.add_element(parent, el)
  if (parent and parent.el == nil) then
    return parent.add(el)
  else
    error("Parent Element is nil")
  end
end

--- Adds a button to the parent element
--- @param parent LuaGuiElement Element
--- @param el_definition table element parameters
--- @param callback function
--- Returns the added LuaGuiElement
function GUI.add_button(parent, el_definition, callback)
  GUI.fail_on_type_mismatch(el_definition, "button")

  -- Create element
  local el = GUI.add_element(parent, el_definition)

  GUI.register_if_callback(
    callback,
    el_definition.name,
    GUI.EVENTS.on_gui_click
  )

  return el
end

--- Adds a sprite-button to the parent element and returns the added LuaGuiElement
--- @param parent LuaGuiElement Element
--- @param el_definition table element parameters
--- @param callback function
--- @return LuaGuiElement
function GUI.add_sprite_button(parent, el_definition, callback)
  GUI.fail_on_type_mismatch(el_definition, "sprite-button")

  -- Create element
  local el = GUI.add_element(parent, el_definition)

  GUI.register_if_callback(
    callback,
    el_definition.name,
    GUI.EVENTS.on_gui_click
  )

  return el
end

--- Adds a checkbox to the parent element and returns the added LuaGuiElement
--- @param parent LuaGuiElement Element
--- @param el_definition table element parameters
--- @param callback function
--- @return LuaGuiElement
function GUI.add_checkbox(parent, el_definition, callback)
  GUI.fail_on_type_mismatch(el_definition, "checkbox")

  -- Create element
  local el = GUI.add_element(parent, el_definition)

  GUI.register_if_callback(
    callback,
    el_definition.name,
    GUI.EVENTS.on_gui_checked_state_changed
  )

  return el
end

--- Helper Functions --
--- ======================================================================== ---

--- Cant register call back without a name, fail if missing
--- @param callback function
--- @param name string
--- @param register_function function
function GUI.register_if_callback(callback, name, register_function)
  -- Callback provided
  if (callback) then
    if (not name) then
      -- cant register without a name
      error("Element name not defined, callback not registered")
      return
    elseif (not register_function or not (type(register_function) == "function")) then
      -- cant register without a registration function
      error(
        "Registration function " ..
        serpent.block(register_function) ..
        " not provided or not a function, its a " .. type(register_function)
      )
      return
    else
      -- Name exists, registration function ok -> register callback
      register_function(name, callback)
    end
  end
end

--- If types dont match, error out
--- @param el LuaGuiElement Element
--- @param type string
function GUI.fail_on_type_mismatch(el, type)
  if (not el.type == type) then
    error("Invalid element definition: element type" .. el.type .. " is not " .. type)
    return
  end
end

--- Returns sprite_name string if valid path if not a question mark sprite
--- @param player LuaPlayer player who owns a gui
--- @param sprite_name string name/path of the sprite
--- @return string
function GUI.get_safe_sprite_name(player, sprite_name)
  if not player.gui.is_valid_sprite_path(sprite_name) then
    sprite_name = "utility/questionmark"
  end
  return sprite_name
end

--- @param player LuaPlayer player who owns a gui
--- @return LuaGuiElement
function GUI.menu_bar_el(player)
  return mod_gui.get_button_flow(player)
end

--- @param player LuaPlayer player who owns a gui
--- @param location string GUI.MASTER_FRAME_LOCATIONS
--- @return LuaGuiElement|nil
function GUI.master_frame_location_el(player, location)
  if (location == GUI.MASTER_FRAME_LOCATIONS.left) then
    return mod_gui.get_frame_flow(player)
  elseif (location == GUI.MASTER_FRAME_LOCATIONS.center) then
    return player.gui.center
  elseif (location == GUI.MASTER_FRAME_LOCATIONS.menu) then
    return mod_gui.get_button_flow(player)
  elseif (location == GUI.MASTER_FRAME_LOCATIONS.screen) then
    return player.gui.screen
  elseif (location == GUI.MASTER_FRAME_LOCATIONS.goal) then
    return player.gui.goal
  else
    error('Invalid location ' .. location)
    return nil
  end
end

return GUI
