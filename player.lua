local cpml = require 'cpml'
local player_sprite = love.graphics.newImage('/assets/player.png')

local function factory (joy)
  local player = {}

  player.type = 'player'

  player.vec2_pos = cpml.vec2(0,0)
  player.vec2_vel = cpml.vec2(10,0)

  player.col_w = 23
  player.col_h = 30

  player.joy = joy

  function player.on_collision(self, other)
    -- print('Collided with a thing!')
  end

  function player.update(self, dt)
    local x_component = self.joy:getGamepadAxis("leftx")
    local y_component = self.joy:getGamepadAxis("lefty")
    self.vec2_vel = cpml.vec2(x_component, y_component) * 100
    if (self.vec2_vel:len() < 10) then
      self.vec2_vel = cpml.vec2(0,0)
    end
    self.vec2_pos = self.vec2_pos + self.vec2_vel * dt

    self.finalize_motion()
  end

  function player.draw(self)
    local x, y = self.vec2_pos:unpack()
    -- love.graphics.rectangle('fill', x, y, 10, 10)
      love.graphics.draw(player_sprite, math.floor(x), math.floor(y))
  end

  return player
end


return factory