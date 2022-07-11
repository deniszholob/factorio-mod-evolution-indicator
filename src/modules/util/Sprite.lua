--- Sprite Module - Sprite functions
--- @usage local Sprite = require('util/Sprite')
--- @author Denis Zholob (DDDGamer)
--- @see github: https://github.com/deniszholob/factorio-softmod-pack
--- ======================================================================== ---

Sprite = {}

--- Returns Factorio rich text string
--- @param name string Sprite name
function Sprite.getSpriteRichText(name)
  return "[" .. string.gsub(name, "/", "=") .. "]"
end

return Sprite
