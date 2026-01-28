-- Environment detection module for cross-platform Neovim configuration
-- Detects iSH shell (iPad) and exports configuration flags

local M = {}

-- Detection methods for iSH environment
function M.is_ish()
  -- Method 1: Check for /proc/ish directory (iSH-specific)
  if vim.fn.isdirectory('/proc/ish') == 1 then
    return true
  end

  -- Method 2: Check uname for iSH signature
  local handle = io.popen('uname -a 2>/dev/null')
  if handle then
    local result = handle:read('*a')
    handle:close()
    if result and result:match('iSH') then
      return true
    end
  end

  -- Method 3: Check for Alpine + limited /proc (iSH characteristic)
  if vim.fn.filereadable('/etc/alpine-release') == 1 then
    -- iSH has a limited /proc filesystem
    if vim.fn.isdirectory('/proc/self/fd') == 0 then
      return true
    end
  end

  -- Method 4: Environment variable override (user can set ISH_ENV=1)
  if vim.env.ISH_ENV == '1' then
    return true
  end

  return false
end

-- Cache the result for performance (checked once at startup)
M.ish_mode = M.is_ish()

-- Performance profile based on environment
M.profile = M.ish_mode and 'minimal' or 'full'

return M
