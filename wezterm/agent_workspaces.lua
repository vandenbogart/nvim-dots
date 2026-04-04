local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

local profiles = require 'agent_profiles'

local M = {}

local function notify(window, title, message)
  pcall(function()
    window:toast_notification(title, message, nil, 4000)
  end)
end

local function focus_existing_workspace(workspace_name)
  for _, mux_window in ipairs(mux.all_windows()) do
    if mux_window:get_workspace() == workspace_name then
      local gui_window = mux_window:gui_window()
      if gui_window then
        gui_window:focus()
        return true
      end
    end
  end

  return false
end

local function spawn_workspace(profile)
  local tab, _, mux_window = mux.spawn_window {
    workspace = profile.workspace,
    cwd = profile.root,
  }

  if tab then
    tab:set_title('control')
  end

  for _, repo in ipairs(profile.repos) do
    local repo_tab = mux_window:spawn_tab {
      cwd = repo.path,
    }

    if repo_tab then
      repo_tab:set_title(repo.name)
    end
  end

  local gui_window = mux_window:gui_window()
  if gui_window then
    gui_window:maximize()
    gui_window:focus()
  end
end

local function open_profile(profile)
  if focus_existing_workspace(profile.workspace) then
    return
  end

  spawn_workspace(profile)
end

local function kill_workspace(workspace_name)
  local ok, stdout = wezterm.run_child_process {
    'wezterm',
    'cli',
    'list',
    '--format',
    'json',
  }

  if not ok then
    return false, 'Unable to query the running WezTerm mux server'
  end

  local success, entries = pcall(wezterm.json_parse, stdout)
  if not success then
    return false, 'Unable to parse `wezterm cli list` output'
  end

  local pane_ids = {}
  for _, entry in ipairs(entries) do
    if entry.workspace == workspace_name and entry.pane_id then
      table.insert(pane_ids, tonumber(entry.pane_id))
    end
  end

  table.sort(pane_ids, function(left, right)
    return left > right
  end)

  for _, pane_id in ipairs(pane_ids) do
    wezterm.run_child_process {
      'wezterm',
      'cli',
      'kill-pane',
      '--pane-id',
      tostring(pane_id),
    }
  end

  return true
end

local function open_agent(window, agent_id)
  local profile = profiles.find(agent_id)
  if not profile then
    notify(window, 'WezTerm', 'Agent profile not found: ' .. agent_id)
    return
  end

  open_profile(profile)
end

local function rebuild_agent(window, pane, agent_id)
  local profile = profiles.find(agent_id)
  if not profile then
    notify(window, 'WezTerm', 'Agent profile not found: ' .. agent_id)
    return
  end

  if window:active_workspace() == profile.workspace then
    window:perform_action(act.SwitchToWorkspace { name = 'default' }, pane)
  end

  local ok, message = kill_workspace(profile.workspace)
  if not ok then
    notify(window, 'WezTerm', message)
    return
  end

  spawn_workspace(profile)
  notify(window, 'WezTerm', 'Rebuilt ' .. profile.workspace)
end

wezterm.on('show-agent-selector', function(window, pane)
  local choices = profiles.selector_choices()

  if #choices == 0 then
    notify(window, 'WezTerm', 'No agent workspaces found under ' .. profiles.root())
    return
  end

  window:perform_action(
    act.InputSelector {
      title = 'Launch agent workspace',
      fuzzy = true,
      choices = choices,
      action = wezterm.action_callback(function(inner_window, _, id)
        if id then
          open_agent(inner_window, id)
        end
      end),
    },
    pane
  )
end)

wezterm.on('rebuild-current-agent-workspace', function(window, pane)
  local agent_id = profiles.agent_id_from_workspace(window:active_workspace())
  if not agent_id then
    notify(window, 'WezTerm', 'Current workspace is not an agent workspace')
    return
  end

  rebuild_agent(window, pane, agent_id)
end)

function M.keys()
  return {
    {
      key = 'a',
      mods = 'SUPER|SHIFT',
      action = act.EmitEvent 'show-agent-selector',
    },
    {
      key = 'r',
      mods = 'SUPER|SHIFT',
      action = act.EmitEvent 'rebuild-current-agent-workspace',
    },
  }
end

return M
