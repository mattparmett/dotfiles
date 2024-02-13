-- Hammerspoon config
-- Matt Parmett

---------------------------------------------------------
-- Code for debugging; prints all keypresses to console
---------------------------------------------------------
-- hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.systemDefined}, function(event)
--     local type = event:getType()
--     if type == hs.eventtap.event.types.keyDown then
--         print(hs.keycodes.map[event:getKeyCode()])
--     elseif type == hs.eventtap.event.types.systemDefined then
--         local t = event:systemKey()
--         if t.down then
--             print("System key: " .. t.key)
--         end
--     end
-- end):start()

----------------------------------------------
-- Vim keybindings in all system text fields
----------------------------------------------
-- local VimMode = hs.loadSpoon('VimMode')
-- local vim = VimMode:new()
-- vim
--   :disableForApp('zoom.us')
--   :disableForApp('Terminal')
--   :disableForApp('iTerm')
--   :disableForApp('Eclipse')
--   :bindHotKeys({ enter = {{'ctrl'}, ';'} })
--   :shouldDimScreenInNormalMode(false)
--   :enterWithSequence(';;')


----------------------
-- Remap control (caps lock) to escape if tapped,
-- or control if held
----------------------
hs.loadSpoon("ControlEscape")
spoon.ControlEscape:start()

----------------------
-- Manage caffeinate (no sleep) on the menubar
----------------------

-- ampOnIcon = [[ASCII:
-- .....1a..........AC..........E
-- ..............................
-- ......4.......................
-- 1..........aA..........CE.....
-- e.2......4.3...........h......
-- ..............................
-- ..............................
-- .......................h......
-- e.2......6.3..........t..q....
-- 5..........c..........s.......
-- ......6..................q....
-- ......................s..t....
-- .....5c.......................
-- ]]

-- ampOffIcon = [[ASCII:
-- .....1a.....x....AC.y.......zE
-- ..............................
-- ......4.......................
-- 1..........aA..........CE.....
-- e.2......4.3...........h......
-- ..............................
-- ..............................
-- .......................h......
-- e.2......6.3..........t..q....
-- 5..........c..........s.......
-- ......6..................q....
-- ......................s..t....
-- ...x.5c....y.......z..........
-- ]]

-- -- caffeine replacement
-- local caffeine = hs.menubar.new()

-- function setCaffeineDisplay(state)
--     if state then
--         caffeine:setIcon(ampOnIcon)
--     else
--         caffeine:setIcon(ampOffIcon)
--     end
-- end

-- function caffeineClicked()
--     setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
-- end

-- if caffeine then
--     caffeine:setClickCallback(caffeineClicked)
--     setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
-- end

----------------------
-- Menubar button to go to sleep
----------------------
-- sleep = hs.menubar.new()
-- sleep:setTitle("Sleep")
-- function goToSleep()
--   os.execute("pmset sleepnow")
-- end

-- if sleep then
--   sleep:setClickCallback(goToSleep)
-- end

----------------------
-- Remap Keychron C1 lock key to trigger sleep
----------------------
hs.hotkey.bind({"cmd", "ctrl"}, "q", function()
  os.execute("pmset sleepnow")
end)

----------------------
-- Eject external disks on sleep
----------------------
hs.loadSpoon("EjectMenu")
spoon.EjectMenu.eject_on_sleep = true
spoon.EjectMenu.show_in_menubar = true
spoon.EjectMenu.notify = true
spoon.EjectMenu:start()

----------------------
-- Custom Window management
-- Replaces Magnet
-- https://github.com/waigx/hammerspoon-config/blob/master/init.lua
-- TODO: when resizing window to same side (e.g. ctrl-right when
-- window is already on right), cycle between 1/2, 1/3, etc of the
-- side of the screen.  Do this for easy snapping to top right corner,
-- etc.
----------------------
--
-- Set short animations
animationDuration = 0.025

-- Functions for getting max, left, and right window dimensions
function maxWinFrame()
  return hs.window.focusedWindow():screen():frame()
end

function leftWinFrame()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  return f
end

function rightWinFrame()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  return f
end

function topWinFrame()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h / 2
  return f
end

function bottomWinFrame()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y + (max.h / 2)
  f.w = max.w
  f.h = max.h / 2
  return f
end

function isSnappedTo(direction)
  local curWinFrame = hs.window.focusedWindow():frame()
  local geo = nil
  local epsilon = 100

  if direction == "left" then
    geo = leftWinFrame()
  elseif direction == "right" then
    geo = rightWinFrame()
  elseif direction == "up" then
    geo = maxWinFrame()
  end

  return (
    math.abs(curWinFrame.x - geo.x) < epsilon and
    math.abs(curWinFrame.y - geo.y) < epsilon and
    math.abs(curWinFrame.w - geo.w) < epsilon and
    math.abs(curWinFrame.h - geo.h) < epsilon
  )
end

-- Bind Ctrl+Up/Left/Right for max, left half, right half
directions = {"left", "right", "up"}
for _, direction in ipairs(directions) do
  hs.hotkey.bind({"ctrl"}, direction, function()
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    -- Disable accessibility AXEnhancedUserInterface
    -- Avoids sluggish window manipulation
    local axApp = hs.axuielement.applicationElement(win:application())
    local wasEnhanced = axApp.AXEnhancedUserInterface
    if wasEnhanced then
      axApp.AXEnhancedUserInterface = false
    end

    if direction == "left" then
      if isSnappedTo("left") then
        win:moveToScreen(screen:previous())
        win:moveToUnit(hs.layout.right50, animationDuration)
      else
        win:moveToUnit(hs.layout.left50, animationDuration)
      end
    elseif direction == "right" then
      if isSnappedTo("right") then
        win:moveToScreen(screen:next())
        win:moveToUnit(hs.layout.left50, animationDuration)
      else
        win:moveToUnit(hs.layout.right50, animationDuration)
      end
    elseif direction == "up" then
      if not isSnappedTo("up") then
        win:moveToUnit(hs.layout.maximized, animationDuration )
      end
    end

    if wasEnhanced then
      axApp.AXEnhancedUserInterface = true
    end
  end)
end

-- Bind Ctrl+Shift+Up/Down for top/bottom half
half_directions = {"up", "down"}
for _, direction in ipairs(half_directions) do
  hs.hotkey.bind({"ctrl", "shift"}, direction, function()
    local win = hs.window.focusedWindow()
    local frame = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    -- Disable accessibility AXEnhancedUserInterface
    -- Avoids sluggish window manipulation
    local axApp = hs.axuielement.applicationElement(win:application())
    local wasEnhanced = axApp.AXEnhancedUserInterface
    if wasEnhanced then
      axApp.AXEnhancedUserInterface = false
    end

    if direction == "up" then
      win:setFrame(topWinFrame())
    elseif direction == "down" then
      win:setFrame(bottomWinFrame())
    end

    if wasEnhanced then
      axApp.AXEnhancedUserInterface = true
    end
  end)
end


----------------------
-- Window management
-- Replaces Magnet
-- https://github.com/waigx/hammerspoon-config/blob/master/init.lua
----------------------

---- Set short animations
--hs.window.animationDuration = 0.025

---- Container to store original window positions (before resizing)
---- Used to restore window positions with CTRL-Down
--previousFrameSizes = {}

---- Checks if the window is already "snapped"
--function isPredefinedWinFrameSize()
--  if isAlmostEqualToCurWinFrame(getMaxWinFrame()) or
--     isAlmostEqualToCurWinFrame(getFillLeftWinFrame()) or
--     isAlmostEqualToCurWinFrame(getFillRightWinFrame()) then
--     return true
--  else
--    return false
--  end
--end

---- Checks if the window is very close to being "snapped"
--function isAlmostEqualToCurWinFrame(geo)
--  local epsilon = 5
--  local curWinFrame = hs.window.focusedWindow():frame()
  
--  if math.abs(curWinFrame.x - geo.x) < epsilon and
--     math.abs(curWinFrame.y - geo.y) < epsilon and
--     math.abs(curWinFrame.w - geo.w) < epsilon and
--     math.abs(curWinFrame.h - geo.h) < epsilon then
--     return true
--  else
--    return false
--  end
-- end

---- Functions for getting max, left, and right window dimensions
--function getMaxWinFrame()
--  return hs.window.focusedWindow():screen():frame()
--end

--function getFillLeftWinFrame()
--  local win = hs.window.focusedWindow()
--  local f = win:frame()
--  local max = win:screen():frame()

--  f.x = max.x
--  f.y = max.y
--  f.w = max.w / 2
--  f.h = max.h
--  return f
--end

--function getFillRightWinFrame()
--  local win = hs.window.focusedWindow()
--  local f = win:frame()
--  local max = win:screen():frame()

--  f.x = max.x + (max.w / 2)
--  f.y = max.y
--  f.w = max.w / 2
--  f.h = max.h
--  return f
--end

---- Factory for keymaps
--function bindWindowKeys(key, resize_fn)
--  hs.hotkey.bind("ctrl", key, function()
--    local win = hs.window.focusedWindow()
--    local f = win:frame()
--    local targetFrame = resize_fn()

--    -- Disable accessibility AXEnhancedUserInterface
--    -- Avoids sluggish window manipulation
--    -- From https://github.com/Hammerspoon/hammerspoon/issues/3224#issuecomment-1294359070
--    local axApp = hs.axuielement.applicationElement(win:application())
--    local wasEnhanced = axApp.AXEnhancedUserInterface
--    if wasEnhanced then
--      axApp.AXEnhancedUserInterface = false
--    end

--    if isPredefinedWinFrameSize() and
--       not isAlmostEqualToCurWinFrame(targetFrame) then
--       win:setFrame(targetFrame)
--    else
--       previousFrameSizes[win:id()] = f
--       win:setFrame(targetFrame)
--    end

--    -- Re-enable accessibility if needed
--    -- From https://github.com/Hammerspoon/hammerspoon/issues/3224#issuecomment-1294359070
--    if wasEnhanced then
--      axApp.AXEnhancedUserInterface = true
--    end

--  end)
--end

---- Restore window size
--hs.hotkey.bind("ctrl", "down", function()
--  local win = hs.window.focusedWindow()
--  local f = win:frame()

--  -- Disable accessibility AXEnhancedUserInterface
--  -- Avoids sluggish window manipulation
--  local axApp = hs.axuielement.applicationElement(win:application())
--  local wasEnhanced = axApp.AXEnhancedUserInterface
--  if wasEnhanced then
--    axApp.AXEnhancedUserInterface = false
--  end
  
--  if isPredefinedWinFrameSize() and
--     previousFrameSizes[win:id()] then
--     win:setFrame(previousFrameSizes[win:id()])
--     previousFrameSizes[win:id()] = nil
--  end

--  if wasEnhanced then
--    axApp.AXEnhancedUserInterface = true
--  end

--end)

---- Generate keymaps
--bindWindowKeys("up", getMaxWinFrame)
--bindWindowKeys("left", getFillLeftWinFrame)
--bindWindowKeys("right", getFillRightWinFrame)

------------------------
---- End window management
------------------------
