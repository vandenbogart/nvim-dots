local wezterm = require 'wezterm'

local M = {}

local agent_root = wezterm.home_dir .. '/tm/agents'

local function trim(value)
  if not value then
    return ''
  end

  return value:gsub('^%s+', ''):gsub('%s+$', '')
end

local function basename(path)
  return path:match('([^/]+)$') or path
end

local function is_hidden_name(name)
  return name:sub(1, 1) == '.'
end

local function list_directories(path)
  local ok, stdout = wezterm.run_child_process {
    'find',
    path,
    '-mindepth',
    '1',
    '-maxdepth',
    '1',
    '-type',
    'd',
    '-print',
  }

  if not ok then
    return {}
  end

  local directories = {}
  for line in stdout:gmatch('[^\r\n]+') do
    table.insert(directories, line)
  end

  table.sort(directories)
  return directories
end

local function is_git_repo(path)
  local ok, stdout = wezterm.run_child_process {
    'git',
    '-C',
    path,
    'rev-parse',
    '--is-inside-work-tree',
  }

  return ok and trim(stdout) == 'true'
end

local function discover_repos(path)
  local repos = {}

  for _, directory in ipairs(list_directories(path)) do
    local name = basename(directory)
    if not is_hidden_name(name) and is_git_repo(directory) then
      table.insert(repos, {
        name = name,
        path = directory,
      })
    end
  end

  table.sort(repos, function(left, right)
    return left.name < right.name
  end)

  return repos
end

function M.root()
  return agent_root
end

function M.workspace_name(agent_id)
  return 'agent:' .. agent_id
end

function M.agent_id_from_workspace(workspace_name)
  return workspace_name and workspace_name:match('^agent:(.+)$') or nil
end

function M.discover()
  local agents = {}

  for _, directory in ipairs(list_directories(agent_root)) do
    local id = basename(directory)
    if not is_hidden_name(id) then
      local repos = discover_repos(directory)
      if #repos > 0 or is_git_repo(directory) then
        table.insert(agents, {
          id = id,
          root = directory,
          repos = repos,
          workspace = M.workspace_name(id),
        })
      end
    end
  end

  table.sort(agents, function(left, right)
    return left.id < right.id
  end)

  return agents
end

function M.find(agent_id)
  for _, profile in ipairs(M.discover()) do
    if profile.id == agent_id then
      return profile
    end
  end

  return nil
end

function M.selector_choices()
  local choices = {}

  for _, profile in ipairs(M.discover()) do
    table.insert(choices, {
      id = profile.id,
      label = string.format('%s · %d repos · %s', profile.id, #profile.repos, profile.root),
    })
  end

  return choices
end

return M
