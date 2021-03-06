require './lib/util'
require './lib/core'

require './lib/bitstream'
require './lib/linkedlist'
require './lib/message'
require './lib/net'
require './lib/view'

require './ovw/menu'
require './ovw/game'

require './mapovw'
require './collisionovw'
require './view'

require './player'
require './playerovw'

require './spell'
require './spellovw'

function love.load()
  Overwatch = Menu
  Overwatch:load()
  
  love.update = function() Overwatch:update() end
  love.draw = function() f.exe(Overwatch.draw, Overwatch) end
  love.sync = function() f.exe(Overwatch.sync, Overwatch) end
  
  love.handlers = {}
  setmetatable(love.handlers, {__index = function(t, k) return Overwatch[k] or f.empty end})
end

function love.run()
  math.randomseed(os.time()) math.random()

  tick = 0
  tickRate = .02
  tickDelta = 0
  syncRate = .05
  syncDelta = 0
  interp = .1

  love.load(arg)

  local delta = 0

  while true do
    love.timer.step()
    delta = love.timer.getDelta()

    love.event.pump()
    local releases = {}
    for e, a, b, c, d in love.event.poll() do
      if e == 'quit' then f.exe(love.quit) love.audio.stop() return
      elseif e == 'mousereleased' or e == 'keyreleased' then table.insert(releases, {e, a, b, c, d})
      else love.handlers[e](a, b, c, d) end
    end

    tickDelta = tickDelta + delta
    while tickDelta >= tickRate do
      tick = tick + 1
      tickDelta = tickDelta - tickRate
      love.update()
    end
    
    for _, e in pairs(releases) do
      love.handlers[e[1]](e[2], e[3], e[4], e[5])
    end

    syncDelta = syncDelta + delta
    if syncDelta >= syncRate then
      love.sync()
      syncDelta = 0
    end
    
    love.graphics.clear()
    love.draw()
    love.graphics.present()
    
    love.timer.sleep(math.max(math.min(tickRate - tickDelta, syncRate - syncDelta) - .001, 0))
  end
end

function love.keyboard.downs(...)
  local t = {}
  for _, key in pairs({...}) do
    t[#t + 1] = love.keyboard.isDown(key)
  end
  return unpack(t)
end