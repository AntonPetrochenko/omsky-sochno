local cpml = require 'cpml'

return function ()
  local grass = {}

  grass.type = 'grass'

  grass.vec2_pos = cpml.vec2(math.random(160),math.random(90))
  grass.vec2_vel = cpml.vec2(10,0)
  grass.vec2_sway = cpml.vec2(-5,0)

  grass.col_w = 5
  grass.col_h = 5

  function grass.on_collision(self, other)
    self.vec2_sway = self.vec2_sway + other.vec2_vel/30
  end

  function grass.update(self, dt)
    grass.vec2_sway = (grass.vec2_sway + cpml.vec2(0,-dt*5)):trim(5)
    grass.vec2_sway = grass.vec2_sway:trim(5)
  end

  function grass.draw(self)
    local x, y = self.vec2_pos:unpack()
    local x2, y2 = (self.vec2_pos + self.vec2_sway):unpack()
    
    love.graphics.setColor(0,135/255,81/255)
    love.graphics.setLineWidth(1)
    love.graphics.line(math.floor(x),math.floor(y),math.floor(x2), math.floor(y2))
  end

  return grass
end