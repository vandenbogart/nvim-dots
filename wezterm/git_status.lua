local wezterm = require 'wezterm'

local M = {}

local cache_ttl_seconds = 3
local status_cache = {}

local function trim(value)
  if not value then
    return ''
  end

  return value:gsub('^%s+', ''):gsub('%s+$', '')
end

local function basename(path)
  return path:match('([^/]+)$') or path
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

local function parse_git_status(root, output)
  local info = {
    root = root,
    repo_name = basename(root),
    branch = 'detached',
    dirty = false,
    ahead = 0,
    behind = 0,
  }

  for line in output:gmatch('[^\r\n]+') do
    local branch = line:match('^# branch%.head (.+)$')
    if branch then
      info.branch = branch == '(detached)' and 'detached' or branch
    end

    local ahead, behind = line:match('^# branch%.ab %+(%d+) %-(%d+)$')
    if ahead and behind then
      info.ahead = tonumber(ahead)
      info.behind = tonumber(behind)
    end

    if line:match('^[12u?] ') then
      info.dirty = true
    end
  end

  return info
end

local function git_status(path)
  local now = os.time()
  local cached = status_cache[path]
  if cached and (now - cached.updated_at) < cache_ttl_seconds then
    return cached.value
  end

  local ok, stdout = wezterm.run_child_process {
    'git',
    '-C',
    path,
    'rev-parse',
    '--show-toplevel',
  }

  if not ok then
    status_cache[path] = {
      updated_at = now,
      value = nil,
    }
    return nil
  end

  local root = trim(stdout)
  local status_ok, status_output = wezterm.run_child_process {
    'git',
    '-C',
    root,
    'status',
    '--porcelain=2',
    '--branch',
  }

  if not status_ok then
    status_cache[path] = {
      updated_at = now,
      value = nil,
    }
    return nil
  end

  local value = parse_git_status(root, status_output)
  status_cache[path] = {
    updated_at = now,
    value = value,
  }

  return value
end

wezterm.on('update-right-status', function(window, pane)
  local workspace = window:active_workspace()
  local agent_id = workspace and workspace:match('^agent:(.+)$') or nil
  local info = git_status(pane_cwd(pane))

  local parts = {}
  if agent_id then
    table.insert(parts, agent_id)
  elseif workspace and workspace ~= '' then
    table.insert(parts, workspace)
  end

  if info then
    table.insert(parts, info.repo_name)
    table.insert(parts, info.branch .. (info.dirty and '*' or ''))

    if info.ahead > 0 then
      table.insert(parts, '↑' .. info.ahead)
    end

    if info.behind > 0 then
      table.insert(parts, '↓' .. info.behind)
    end
  end

  window:set_right_status(table.concat(parts, ' • '))
end)

function M.apply_to_config(config)
  config.status_update_interval = config.status_update_interval or 2000
end

return M
