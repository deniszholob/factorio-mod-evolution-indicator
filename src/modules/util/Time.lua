--- Time Helper Module
--- Common Time functions
--- @usage local Time = require('util/Time')
--- ------------------------------------------------------- ---
--- @author Denis Zholob (DDDGamer)
--- github: https://github.com/deniszholob/factorio-softmod-pack
--- ======================================================= ---

Time = {}

-- Returns seconds converted from game ticks
-- @param t - Factorio game tick
function Time.tick_to_sec(t)
  -- return game.speed * (t / 60)
  return (t / 60)
end

return Time
