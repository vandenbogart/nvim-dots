local lush = require "lush"
local base = require "zenbones"
local hsl = lush.hsl

local spec = lush.extends({base}).with(function()
    local a = 1
  return {
    Constant { fg=hsl(200,80,40) },
    Directory { fg=hsl(200,80,40) },
    Statement { gui="bold,italic" },
    WinSeparator { fg=hsl(1,20,82) },
    Number { fg=hsl(25,80,40) },
  }
end)
return spec
