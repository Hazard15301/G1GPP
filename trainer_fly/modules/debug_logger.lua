-- G1GPP persistent diagnostic logger.
-- Kept outside main.lua so the mod entry point does not accumulate Lua locals.
-- The Google Drive mirror is development-only and must be disabled/removed for public builds.

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
  self.logDir = config.logDir or "trainer_fly"
  self.logFile = self.logDir .. "/g1gpp_debug.log"
  self.sessionMarker = self.logDir .. "/g1gpp_session_open.txt"
  self.maxBytes = tonumber(config.maxBytes) or (1024 * 1024)
  self.driveMirrorEnabled = config.driveMirrorEnabled == true
  self.driveMirrorFile = config.driveMirrorFile
  self.buildVersion = tostring(config.buildVersion or "unknown")
  self.sequence = 0
  self.sessionId = nil
  self.gameVersionId = "unknown"
  self.gameVersionLabel = "Unknown"
  self.gameVersionError = nil
  self.sessionEnded = false
  self.driveMirrorAvailable = false
  self.driveMirrorError = nil
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

function Logger:_writeDriveMirror(data, mode)
  if not self.driveMirrorEnabled then return false, "disabled" end
  if type(self.driveMirrorFile) ~= "string" or self.driveMirrorFile == "" then
    return false, "no mirror path"
  end
  local ok, err = pcall(function()
    local f, openErr = io.open(self.driveMirrorFile, mode or "ab")
    if not f then error(openErr or "io.open failed") end
    local writeOk, writeErr = f:write(data or "")
    if not writeOk then
      pcall(f.close, f)
      error(writeErr or "write failed")
    end
    f:flush()
    f:close()
  end)
  if ok then
    self.driveMirrorAvailable = true
    self.driveMirrorError = nil
    return true, nil
  end
  self.driveMirrorAvailable = false
  self.driveMirrorError = err
  return false, err
end

function Logger:_syncDriveMirrorFromPrimary()
  if not self.driveMirrorEnabled then return false, "disabled" end
  if not love.filesystem.getInfo(self.logFile) then
    return self:_writeDriveMirror("", "wb")
  end
  local okRead, data = pcall(love.filesystem.read, self.logFile)
  if not okRead then
    self.driveMirrorAvailable = false
    self.driveMirrorError = data
    return false, data
  end
  return self:_writeDriveMirror(data or "", "wb")
end

function Logger:_clearDriveMirror()
  if not self.driveMirrorEnabled then return false, "disabled" end
  return self:_writeDriveMirror("", "wb")
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
    self:_syncDriveMirrorFromPrimary()
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
    self:_writeDriveMirror(line, "ab")
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
  local mirrorSyncOk, mirrorSyncErr = self:_syncDriveMirrorFromPrimary()
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
  self:log(mirrorSyncOk and "DEBUG DRIVE MIRROR ACTIVE"
      or "DEBUG DRIVE MIRROR UNAVAILABLE",
    "devOnly=true path=" .. safeField(self.driveMirrorFile)
      .. " startupSync=" .. safeField(mirrorSyncOk)
      .. " error=" .. safeField(mirrorSyncErr))

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
  self:_clearDriveMirror()
  self.sequence = 0
  self:log("LOG CLEARED", details)
end

-- Return a factory instead of relying on package.path/require for mod-local files.
return function(config)
  return Logger.new(config)
end
