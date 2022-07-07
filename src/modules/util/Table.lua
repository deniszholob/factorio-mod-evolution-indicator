--- Table/array functions module
--- @usage require('modules/util/Table')
--- ------------------------------------------------------- ---
--- @author Denis Zholob (DDDGamer)
--- @see github: https://github.com/deniszholob/factorio-softmod-pack
--- ======================================================= ---

Table = {}

--- Standard array filter function
--- @param t table - table to filter
--- @param func function(k,v) the function to filter values
function Table.filter(t, func)
  local newtbl = {}
  local insert = #t > 0
  for k, v in pairs(t) do
      if func(v, k) then
          if insert then table.insert(newtbl, v)
          else newtbl[k] = v end
      end
  end
  return newtbl
end

return Table
