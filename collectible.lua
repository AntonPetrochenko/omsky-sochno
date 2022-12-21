local cpml = require 'cpml'
local sprite = love.graphics.newImage('/assets/carrot.png')

local function factory (x,y)
  local collectible = {}

  collectible.type = 'collectible'

  collectible.vec2_pos = cpml.vec2(x or 100,y or 100)
  collectible.vec2_vel = cpml.vec2(0,0)

  collectible.col_w = 11
  collectible.col_h = 20

  function collectible.on_collision(self, other)
    if other.type == 'player' and not self.should_delete then
      self.should_delete = true
      ADDOBJ( factory(math.random(1,160), math.random(1,90)))
    end
      
  end

  function collectible.update(self, dt)
    self.vec2_pos = self.vec2_pos + self.vec2_vel * dt

    self.finalize_motion()
  end

  function collectible.draw(self)
    local x, y = self.vec2_pos:unpack()
    -- love.graphics.setColor(1,1,0.5)
    -- love.graphics.rectangle('fill', x, y, 10, 10)

    love.graphics.draw(sprite, math.floor(x), math.floor(y))
  end

  return collectible
end


return factory