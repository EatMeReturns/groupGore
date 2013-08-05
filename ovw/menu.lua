Menu = {}

function Menu:load()
  print('Loading menu')
  self.bg = love.graphics.newImage('media/graphics/menu/background.png')
end

function Menu:unload()
  self.bg = nil
end

function Menu:draw()
  love.graphics.draw(self.bg, 0, 0)
  love.graphics.printf('groupGore: They have taken the hobbits to Isengard', 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), 'center')
  love.timer.sleep(.1)
end

function Menu:update()
  if love.keyboard.isDown('s') then
    -- Start server.
  elseif love.keyboard.isDown('c') then
    serverIp = '127.0.0.1'
    serverPort = 6061
    username = 'tie372' .. math.floor(love.timer.getMicroTime())
    
    Overwatch:unload()
    Overwatch = Game
    Overwatch:load()
  end
end