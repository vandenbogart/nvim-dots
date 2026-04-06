local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

local function notify(window, message)
  pcall(function()
    window:toast_notification('WezTerm', message, nil, 3000)
  end)
end

wezterm.on('show-pane-layout-selector', function(window, pane)
  window:perform_action(
    act.InputSelector {
      title = 'Kitty-style pane actions',
      fuzzy = true,
      choices = {
        { id = 'stack', label = 'stack · zoom active pane' },
        { id = 'rotate-clockwise', label = 'rotate panes clockwise' },
        { id = 'rotate-counterclockwise', label = 'rotate panes counterclockwise' },
        { id = 'swap', label = 'swap active pane' },
        { id = 'resize', label = 'resize mode' },
      },
      action = wezterm.action_callback(function(inner_window, inner_pane, id)
        if id == 'stack' then
          inner_window:perform_action(act.TogglePaneZoomState, inner_pane)
        elseif id == 'rotate-clockwise' then
          inner_window:perform_action(act.RotatePanes 'Clockwise', inner_pane)
        elseif id == 'rotate-counterclockwise' then
          inner_window:perform_action(act.RotatePanes 'CounterClockwise', inner_pane)
        elseif id == 'swap' then
          inner_window:perform_action(
            act.PaneSelect {
              mode = 'SwapWithActive',
              show_pane_ids = true,
            },
            inner_pane
          )
        elseif id == 'resize' then
          inner_window:perform_action(
            act.ActivateKeyTable {
              name = 'resize_pane',
              one_shot = false,
              until_unknown = false,
            },
            inner_pane
          )
        elseif id then
          notify(inner_window, 'No WezTerm equivalent for kitty layout preset: ' .. id)
        end
      end),
    },
    pane
  )
end)

wezterm.on('kitty-last-used-layout', function(window, pane)
  local tab = window:active_tab()
  if tab and tab:get_size() then
    -- WezTerm has no kitty-style layout history. Use zoom-stack as the closest match.
    window:perform_action(act.TogglePaneZoomState, pane)
    return
  end

  notify(window, 'No active tab')
end)

function M.keys()
  return {
    -- Kitty defaults: move_window_forward / move_window_backward.
    { key = 'f', mods = 'CTRL|SHIFT', action = act.RotatePanes 'Clockwise' },
    { key = 'b', mods = 'CTRL|SHIFT', action = act.RotatePanes 'CounterClockwise' },

    -- Kitty default: move_window_to_top. Closest WezTerm equivalent is swap picker.
    {
      key = '`',
      mods = 'CTRL|SHIFT',
      action = act.PaneSelect {
        mode = 'SwapWithActive',
        show_pane_ids = true,
      },
    },

    -- Kitty default: start_resizing_window.
    {
      key = 'r',
      mods = 'CTRL|SHIFT',
      action = act.ActivateKeyTable {
        name = 'resize_pane',
        one_shot = false,
        until_unknown = false,
      },
    },

    -- Kitty default: next_layout. WezTerm doesn't have named layouts, so open a layout action picker.
    { key = 'l', mods = 'CTRL|SHIFT', action = act.EmitEvent 'show-pane-layout-selector' },

    -- Kitty examples: goto_layout tall / stack / last_used_layout / toggle_layout stack.
    { key = 't', mods = 'CTRL|ALT', action = act.EmitEvent 'show-pane-layout-selector' },
    { key = 's', mods = 'CTRL|ALT', action = act.TogglePaneZoomState },
    { key = 'p', mods = 'CTRL|ALT', action = act.EmitEvent 'kitty-last-used-layout' },
    { key = 'z', mods = 'CTRL|ALT', action = act.TogglePaneZoomState },
  }
end

function M.apply_to_config(config)
  config.key_tables = config.key_tables or {}
  config.key_tables.resize_pane = {
    { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 1 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'Enter', action = 'PopKeyTable' },
  }
end

return M
