-- G1GPP persistent diagnostic logger.
-- Kept outside main.lua so the mod entry point does not accumulate Lua locals.
-- External mirrors are deliberately outside the mod sandbox. This module owns
-- only the log inside Gen1Recomp's per-mod storage area.

local Logger = {}
Logger.__index = Logger

local function safeField(value)
  if value == nil then return "nil" end
  local ok, result = pcall(tostring, value)
  return ok and result or "<tostring failed>"
end

local function timestamp()
  local ok, stamp = pcall(os.date, "%Y-%m-%d %H:%M:%S")
  if ok and stamp then return stamp end
  local t = love and love.timer and love.timer.getTime and love.timer.getTime() or 0
  return ("runtime+%.3f"):format(tonumber(t) or 0)
end

local function detectGameVersion()
  local loaded, GameVersion = pcall(require, "src.core.GameVersion")
  if not loaded or type(GameVersion) ~= "table" then
    return "unknown", "Unknown", loaded and "invalid_module" or GameVersion
  end

  local gotId, id = pcall(GameVersion.get)
  local gotInfo, info = pcall(GameVersion.info)
  if not gotId or type(id) ~= "string" then
    return "unknown", "Unknown", gotId and "invalid_id" or id
  end

  local label = gotInfo and type(info) == "table"
    and (info.label or info.displayName) or nil
  if not gotInfo then return id, label or id, info end
  return id, label or id, nil
end

function Logger.new(config)
  config = config or {}
  local self = setmetatable({}, Logger)
  self.logDir = config.logDir or "g1gpp"
  self.logFile = self.logDir .. "/g1gpp_debug.log"
  self.sessionMarker = self.logDir .. "/g1gpp_session_open.txt"
  self.maxBytes = tonumber(config.maxBytes) or (1024 * 1024)
  self.buildVersion = tostring(config.buildVersion or "unknown")
  self.sequence = 0
  self.sessionId = nil
  self.gameVersionId = "unknown"
  self.gameVersionLabel = "Unknown"
  self.gameVersionError = nil
  self.sessionEnded = false
  return self
end

function Logger:safeField(value)
  return safeField(value)
end

function Logger:timestamp()
  return timestamp()
end

function Logger:gameVersionSummary()
  return "gameVersion=" .. safeField(self.gameVersionId)
    .. " gameLabel=" .. safeField(self.gameVersionLabel)
    .. " gameVersionError=" .. safeField(self.gameVersionError)
end

function Logger:_rotateIfNeeded()
  local info = love.filesystem.getInfo(self.logFile)
  if info and tonumber(info.size) and info.size >= self.maxBytes then
    local old = self.logDir .. "/g1gpp_debug_previous.log"
    pcall(love.filesystem.remove, old)
    local ok, data = pcall(love.filesystem.read, self.logFile)
    if ok and data then pcall(love.filesystem.write, old, data) end
    pcall(love.filesystem.write, self.logFile,
      "=== G1GPP DEBUG LOG ROTATED ===\n")
  end
end

function Logger:log(event, details)
  pcall(function()
    love.filesystem.createDirectory(self.logDir)
    self:_rotateIfNeeded()
    self.sequence = self.sequence + 1
    local line = ("[%s] #%06d %-30s %s\n"):format(
      timestamp(), self.sequence, safeField(event), safeField(details or ""))
    love.filesystem.append(self.logFile, line)
  end)
end

function Logger:_makeSessionId()
  local epoch = os and os.time and os.time() or 0
  local runtime = love and love.timer and love.timer.getTime and love.timer.getTime() or 0
  return ("%s-%s-%06d"):format(timestamp():gsub("[^%d]", ""),
    safeField(epoch), math.floor((tonumber(runtime) or 0) * 1000) % 1000000)
end

function Logger:beginSession()
  love.filesystem.createDirectory(self.logDir)
  local previous = love.filesystem.getInfo(self.sessionMarker)
  if previous then
    local ok, prior = pcall(love.filesystem.read, self.sessionMarker)
    self:log("PREVIOUS SESSION UNCLEAN END",
      "previousSession=" .. safeField(ok and prior or "unknown"))
  end

  self.sessionEnded = false
  self.sessionId = self:_makeSessionId()
  self.gameVersionId, self.gameVersionLabel, self.gameVersionError = detectGameVersion()
  pcall(love.filesystem.write, self.sessionMarker, self.sessionId)
  self:log("SESSION START", "session=" .. safeField(self.sessionId)
    .. " version=" .. self.buildVersion .. " " .. self:gameVersionSummary())
  self:log("DEBUG LOG LOCAL", "path=" .. safeField(self.logFile)
    .. " externalMirror=separate_helper")

  local rbTmhmActive = self.gameVersionId == "red" or self.gameVersionId == "blue"
  self:log("MISSINGNO TMHM COMPATIBILITY",
    "installed=" .. safeField(rbTmhmActive)
      .. " gameVersion=" .. safeField(self.gameVersionId)
      .. " normalForms=" .. safeField(rbTmhmActive and 36 or 0)
      .. " moveCount=" .. safeField(rbTmhmActive and 24 or 0)
      .. " tm12WaterGun=false tm43SkyAttack=" .. safeField(rbTmhmActive)
      .. " specialFormsExcluded=true yellowExcluded=true")
end

function Logger:endSession(reason, stateSummary)
  if self.sessionEnded then return end
  self.sessionEnded = true
  self:log("SESSION END", "session=" .. safeField(self.sessionId)
    .. " reason=" .. safeField(reason) .. " " .. safeField(stateSummary or ""))
  pcall(love.filesystem.remove, self.sessionMarker)
end

function Logger:clear(details)
  pcall(love.filesystem.remove, self.logFile)
  self.sequence = 0
  self:log("LOG CLEARED", details)
end

-- Return a factory instead of relying on package.path/require for mod-local files.
return function(config)
  return Logger.new(config)
end
