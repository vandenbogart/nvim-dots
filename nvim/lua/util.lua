local M = {}

M.tprint = function(tbl, indent)
      if not indent then indent = 0 end
      for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
          print(formatting)
          M.tprint(v, indent+1)
        elseif type(v) == 'boolean' then
          print(formatting .. tostring(v))
        elseif type(v) == 'function' then
          print(formatting .. tostring(v))
        else
          print(formatting .. v)
        end
      end
    end

return M

