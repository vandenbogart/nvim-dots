local wezterm = require 'wezterm'
local act = wezterm.action
local agent_workspaces = require 'agent_workspaces'
local git_status = require 'git_status'

local config_dir = os.getenv('XDG_CONFIG_HOME')
  and (os.getenv('XDG_CONFIG_HOME') .. '/wezterm')
  or (wezterm.home_dir .. '/.config/wezterm')

local kitty_config_dir = os.getenv('XDG_CONFIG_HOME')
  and (os.getenv('XDG_CONFIG_HOME') .. '/kitty')
  or (wezterm.home_dir .. '/.config/kitty')

local penumbra_state_file = config_dir .. '/.current-penumbra'
local kitty_penumbra_state_file = kitty_config_dir .. '/.current-penumbra'

-- Audited against:
--   https://github.com/nealmckee/penumbra/blob/main/penumbra.tsv
-- and your kitty ports in ~/.config/kitty/themes/penumbra_{dark,light}.conf
--
-- Note: the terminal palette intentionally uses orange in the magenta slot,
-- matching your kitty theme and its "we replace with orange" choice.
local penumbra = {
  base = {
    sun_plus = '#FFFDFB',
    sun = '#FFF7ED',
    sun_minus = '#F2E6D4',
    sky_plus = '#BEBEBE',
    sky = '#8F8F8F',
    sky_minus = '#636363',
    shade_plus = '#3E4044',
    shade = '#303338',
    shade_minus = '#24272B',
    shade_contrast_plus = '#181B1F',
    shade_contrast_plus_plus = '#0D0F13',
  },

  balanced = {
    six = {
      yellow = '#A38F2D',
      blue = '#7E87D6',
      cyan = '#00A0BE',
    },
    seven = {
      red = '#CA7081',
      orange = '#C27D40',
      yellow = '#92963A',
      green = '#3EA57B',
      cyan = '#00A0BA',
      blue = '#6E8DD5',
    },
    eight = {
      red = '#CA736C',
      orange = '#BA823A',
      green = '#47A477',
    },
  },

  contrast_pp = {
    seven = {
      red = '#F18AA1',
      orange = '#EA9856',
      yellow = '#B4B44A',
      green = '#58C792',
      cyan = '#16C3DD',
      blue = '#83ADFF',
    },
  },
}

local function read_file(path)
  local file = io.open(path, 'r')
  if not file then
    return nil
  end

  local contents = file:read('*a')
  file:close()

  if not contents then
    return nil
  end

  return contents:gsub('%s+$', '')
end

local function write_file(path, value)
  local file = io.open(path, 'w')
  if not file then
    return false
  end

  file:write(value)
  file:write('\n')
  file:close()
  return true
end

local function write_penumbra_mode(mode)
  write_file(penumbra_state_file, mode)
  write_file(kitty_penumbra_state_file, mode)
end

local function read_penumbra_mode()
  local mode = read_file(penumbra_state_file)
  if mode == 'light' or mode == 'dark' then
    return mode
  end

  mode = read_file(kitty_penumbra_state_file)
  if mode == 'light' or mode == 'dark' then
    return mode
  end

  return 'dark'
end

local function penumbra_scheme_name(mode)
  return mode == 'light' and 'Penumbra Light' or 'Penumbra Dark'
end

local function penumbra_dark_scheme()
  local b = penumbra.base
  local seven = penumbra.balanced.seven
  local bright = penumbra.contrast_pp.seven

  return {
    foreground = b.sky,
    background = b.shade,
    cursor_bg = b.sun,
    cursor_fg = b.shade,
    cursor_border = b.sun,
    selection_fg = b.shade,
    selection_bg = b.sun,
    scrollbar_thumb = b.shade_minus,
    split = b.shade_minus,
    visual_bell = b.sun_minus,
    compose_cursor = seven.orange,
    copy_mode_active_highlight_bg = { Color = b.sun },
    copy_mode_active_highlight_fg = { Color = b.shade },
    copy_mode_inactive_highlight_bg = { Color = b.shade_minus },
    copy_mode_inactive_highlight_fg = { Color = b.sun },
    quick_select_label_bg = { Color = b.sun },
    quick_select_label_fg = { Color = b.shade },
    quick_select_match_bg = { Color = seven.blue },
    quick_select_match_fg = { Color = b.sun_plus },
    ansi = {
      b.shade_minus,
      penumbra.balanced.eight.red,
      seven.green,
      seven.yellow,
      seven.blue,
      seven.orange,
      seven.cyan,
      b.sun,
    },
    brights = {
      b.shade_contrast_plus_plus,
      bright.red,
      bright.green,
      bright.yellow,
      bright.blue,
      bright.orange,
      bright.cyan,
      b.sun_plus,
    },
    tab_bar = {
      background = b.shade_minus,
      active_tab = {
        bg_color = b.sun,
        fg_color = b.shade,
        intensity = 'Bold',
      },
      inactive_tab = {
        bg_color = b.shade_minus,
        fg_color = b.sky,
      },
      inactive_tab_hover = {
        bg_color = b.shade,
        fg_color = b.sky_plus,
      },
      new_tab = {
        bg_color = b.shade_minus,
        fg_color = b.sky,
      },
      new_tab_hover = {
        bg_color = b.shade,
        fg_color = b.sky_plus,
      },
    },
  }
end

local function penumbra_light_scheme()
  local b = penumbra.base
  local seven = penumbra.balanced.seven

  return {
    foreground = b.shade_plus,
    background = b.sun,
    cursor_bg = b.shade,
    cursor_fg = b.sun,
    cursor_border = b.shade,
    selection_fg = b.sun,
    selection_bg = b.shade,
    scrollbar_thumb = b.sun_minus,
    split = b.sun_minus,
    visual_bell = b.shade_plus,
    compose_cursor = seven.orange,
    copy_mode_active_highlight_bg = { Color = b.shade },
    copy_mode_active_highlight_fg = { Color = b.sun },
    copy_mode_inactive_highlight_bg = { Color = b.sun_minus },
    copy_mode_inactive_highlight_fg = { Color = b.shade_plus },
    quick_select_label_bg = { Color = b.shade },
    quick_select_label_fg = { Color = b.sun },
    quick_select_match_bg = { Color = seven.blue },
    quick_select_match_fg = { Color = b.sun_plus },
    ansi = {
      b.shade,
      penumbra.balanced.eight.red,
      seven.green,
      seven.yellow,
      seven.blue,
      seven.orange,
      seven.cyan,
      b.sun_minus,
    },
    brights = {
      b.shade_minus,
      seven.red,
      penumbra.balanced.eight.green,
      penumbra.balanced.six.yellow,
      penumbra.balanced.six.blue,
      penumbra.balanced.eight.orange,
      penumbra.balanced.six.cyan,
      b.sun_plus,
    },
    tab_bar = {
      background = b.sun_minus,
      active_tab = {
        bg_color = b.shade,
        fg_color = b.sun,
        intensity = 'Bold',
      },
      inactive_tab = {
        bg_color = b.sun_minus,
        fg_color = b.shade_plus,
      },
      inactive_tab_hover = {
        bg_color = b.sun,
        fg_color = b.shade,
      },
      new_tab = {
        bg_color = b.sun_minus,
        fg_color = b.shade_plus,
      },
      new_tab_hover = {
        bg_color = b.sun,
        fg_color = b.shade,
      },
    },
  }
end

local function penumbra_window_frame(mode)
  local b = penumbra.base

  if mode == 'light' then
    return {
      active_titlebar_bg = b.sun_minus,
      active_titlebar_fg = b.shade_plus,
      active_titlebar_border_bottom = b.sun_minus,
      inactive_titlebar_bg = b.sun,
      inactive_titlebar_fg = b.sky_minus,
      inactive_titlebar_border_bottom = b.sun_minus,
      button_fg = b.shade_plus,
      button_bg = b.sun_minus,
      button_hover_fg = b.sun,
      button_hover_bg = b.shade,
    }
  end

  return {
    active_titlebar_bg = b.shade_minus,
    active_titlebar_fg = b.sky,
    active_titlebar_border_bottom = b.shade_minus,
    inactive_titlebar_bg = b.shade,
    inactive_titlebar_fg = b.sky_minus,
    inactive_titlebar_border_bottom = b.shade_minus,
    button_fg = b.sky,
    button_bg = b.shade_minus,
    button_hover_fg = b.shade,
    button_hover_bg = b.sun,
  }
end

local function penumbra_overlay_colors(mode)
  local b = penumbra.base
  local seven = penumbra.balanced.seven

  if mode == 'light' then
    return {
      command_palette_bg_color = b.sun,
      command_palette_fg_color = b.shade_plus,
      char_select_bg_color = b.sun,
      char_select_fg_color = b.shade_plus,
      pane_select_bg_color = seven.blue,
      pane_select_fg_color = b.sun_plus,
    }
  end

  return {
    command_palette_bg_color = b.shade,
    command_palette_fg_color = b.sky,
    char_select_bg_color = b.shade,
    char_select_fg_color = b.sun,
    pane_select_bg_color = seven.blue,
    pane_select_fg_color = b.sun_plus,
  }
end

local function pane_cwd(pane)
  local cwd = pane:get_current_working_dir()
  if cwd == nil then
    return wezterm.home_dir
  end

  if type(cwd) == 'string' then
    return cwd:gsub('^file://[^/]*', '')
  end

  if type(cwd) == 'table' then
    return cwd.file_path or cwd.path or wezterm.home_dir
  end

  return wezterm.home_dir
end

wezterm.on('spawn-tab-in-pane-cwd', function(window, pane)
  window:perform_action(
    act.SpawnCommandInNewTab {
      cwd = pane_cwd(pane),
      domain = 'CurrentPaneDomain',
    },
    pane
  )
end)

wezterm.on('split-pane-in-pane-cwd', function(window, pane)
  window:perform_action(
    act.SplitHorizontal {
      cwd = pane_cwd(pane),
      domain = 'CurrentPaneDomain',
    },
    pane
  )
end)

wezterm.on('toggle-penumbra', function(window, pane)
  local next_mode = read_penumbra_mode() == 'dark' and 'light' or 'dark'
  write_penumbra_mode(next_mode)

  pcall(function()
    window:toast_notification('WezTerm', 'Switched to ' .. penumbra_scheme_name(next_mode), nil, 2000)
  end)

  window:perform_action(act.ReloadConfiguration, pane)
end)

local active_penumbra_mode = read_penumbra_mode()
local overlay_colors = penumbra_overlay_colors(active_penumbra_mode)

local config = {
  color_schemes = {
    ['Penumbra Dark'] = penumbra_dark_scheme(),
    ['Penumbra Light'] = penumbra_light_scheme(),
  },

  color_scheme = penumbra_scheme_name(active_penumbra_mode),
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = false,
  switch_to_last_active_tab_when_closing_tab = true,
  window_padding = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 0,
  },
  inactive_pane_hsb = {
    saturation = 0.95,
    brightness = 0.85,
  },
  window_frame = penumbra_window_frame(active_penumbra_mode),
  visual_bell = {
    fade_in_duration_ms = 60,
    fade_out_duration_ms = 90,
  },
  command_palette_bg_color = overlay_colors.command_palette_bg_color,
  command_palette_fg_color = overlay_colors.command_palette_fg_color,
  char_select_bg_color = overlay_colors.char_select_bg_color,
  char_select_fg_color = overlay_colors.char_select_fg_color,
  pane_select_bg_color = overlay_colors.pane_select_bg_color,
  pane_select_fg_color = overlay_colors.pane_select_fg_color,

  keys = {
    -- Match kitty: avoid accidental close on Ctrl+Shift+W.
    { key = 'w', mods = 'CTRL|SHIFT', action = act.DisableDefaultAssignment },

    -- Closest WezTerm-native equivalent to kitty scrollback browsing.
    { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },

    -- Toggle Penumbra dark/light like your kitty setup.
    { key = 'r', mods = 'CTRL|SHIFT|ALT', action = act.EmitEvent 'toggle-penumbra' },

    -- Pane navigation like kitty's Cmd+[ / Cmd+].
    { key = '[', mods = 'SUPER', action = act.ActivatePaneDirection 'Prev' },
    { key = ']', mods = 'SUPER', action = act.ActivatePaneDirection 'Next' },

    -- Previous active tab.
    { key = 'p', mods = 'SUPER|SHIFT', action = act.ActivateLastTab },

    -- Direct tab navigation, including a real Cmd+9.
    { key = '1', mods = 'SUPER', action = act.ActivateTab(0) },
    { key = '2', mods = 'SUPER', action = act.ActivateTab(1) },
    { key = '3', mods = 'SUPER', action = act.ActivateTab(2) },
    { key = '4', mods = 'SUPER', action = act.ActivateTab(3) },
    { key = '5', mods = 'SUPER', action = act.ActivateTab(4) },
    { key = '6', mods = 'SUPER', action = act.ActivateTab(5) },
    { key = '7', mods = 'SUPER', action = act.ActivateTab(6) },
    { key = '8', mods = 'SUPER', action = act.ActivateTab(7) },
    { key = '9', mods = 'SUPER', action = act.ActivateTab(8) },

    -- Pane resizing like kitty's Cmd+Shift+arrows.
    { key = 'LeftArrow', mods = 'SUPER|SHIFT', action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'RightArrow', mods = 'SUPER|SHIFT', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'UpArrow', mods = 'SUPER|SHIFT', action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'DownArrow', mods = 'SUPER|SHIFT', action = act.AdjustPaneSize { 'Down', 1 } },

    -- Clear/reset terminal: approximate kitty behavior with WezTerm-native actions.
    { key = 'k', mods = 'SUPER', action = act.SendKey { key = 'L', mods = 'CTRL' } },
    { key = 'k', mods = 'SUPER|SHIFT', action = act.ResetTerminal },

    -- Zoom current pane like kitty's Cmd+Z stack toggle.
    { key = 'z', mods = 'SUPER', action = act.TogglePaneZoomState },

    -- New pane/tab with the current pane's working directory.
    { key = 'Enter', mods = 'SUPER|SHIFT', action = act.EmitEvent 'split-pane-in-pane-cwd' },
    { key = 't', mods = 'SUPER|SHIFT', action = act.EmitEvent 'spawn-tab-in-pane-cwd' },

    -- Rough equivalents for kitty hint pickers.
    { key = 'e', mods = 'SUPER|SHIFT', action = act.QuickSelect },
    { key = 'f', mods = 'SUPER|SHIFT', action = act.QuickSelect },
    { key = 'h', mods = 'SUPER|SHIFT', action = act.QuickSelect },

    -- Keep kitty-style font controls explicit.
    { key = '=', mods = 'SUPER', action = act.IncreaseFontSize },
    { key = '-', mods = 'SUPER', action = act.DecreaseFontSize },
    { key = '0', mods = 'SUPER', action = act.ResetFontSize },
  },
}

for _, key in ipairs(agent_workspaces.keys()) do
  table.insert(config.keys, key)
end

git_status.apply_to_config(config)

return config
