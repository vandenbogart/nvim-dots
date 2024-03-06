local lush = require "lush"
local hsluv = require "lush".hsluv
local base = require "zenbones"
local hsl = lush.hsl

local spec = lush.extends({ base }).with(function()
    return {
        -- Constant { fg = hsluv(225, 65, 75) },
        -- Directory { fg = hsl(200, 80, 45) },

        -- Statement { gui="bold,italic" },
        -- WinSeparator { fg = hsl(1, 20, 82) },
        -- Number { fg = hsluv(130, 65, 75), gui = "italic" },
        -- Normal { fg=base.Normal.fg, bg=hsluv(0, 5, 5) },
        -- DiagnosticVirtualTextError { fg=base.DiagnosticVirtualTextError.fg.da(25) },
        -- DiagnosticVirtualTextWarn { fg=base.DiagnosticVirtualTextWarn.fg.da(15) },
        -- DiagnosticVirtualTextOk { fg=base.DiagnosticVirtualTextOk.fg.da(15) },
        -- DiagnosticVirtualTextInfo { fg=base.DiagnosticVirtualTextInfo.fg.da(15) },
    }
end)
return spec
