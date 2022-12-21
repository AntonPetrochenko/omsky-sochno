local bump = require 'bump'
local player = require 'player'
local collectible = require 'collectible'
local grass = require 'grass'

OBJECTS = {}
PLAYERS = {}
PHY = bump.newWorld()

function ADDOBJ(obj)
  OBJECTS[#OBJECTS+1] = obj
  PHY:add(obj, obj.vec2_pos.x, obj.vec2_pos.y, obj.col_w, obj.col_h)
  obj.finalize_motion = function ()
    local actualX, actualY, cols = PHY:move(obj, obj.vec2_pos.x, obj.vec2_pos.y, function (item, other)
        if item.col_filter then
          return item.col_filter(other)
        end
        return 'cross'
      end)
      obj.vec2_pos.x = actualX
      obj.vec2_pos.y = actualY
      for i,v in pairs(cols)  do
          v.item.on_collision(v.item, v.other)
          v.other.on_collision(v.other, v.item)
      end
  end

end


function love.update(dt)
  table.sort(OBJECTS, function (left, right)
    return left and right and left.vec2_pos.y + left.col_h < right.vec2_pos.y+right.col_h
  end)
  for i,v in pairs(OBJECTS) do
    if v.should_delete then
      OBJECTS[i] = nil
      PHY:remove(v)
    else
      v:update(dt)
    end
  end
end


CANVAS = love.graphics.newCanvas(160*2, 90*2)
CANVAS:setFilter('nearest')


function love.draw(dt)
  love.graphics.setCanvas(CANVAS)
  love.graphics.clear(0,228/255,54/255)
  love.graphics.setLineStyle('rough')
  for i,v in pairs(OBJECTS) do
      love.graphics.push('all')
      v:draw()
      -- love.graphics.line(0,0,v.vec2_pos.x, v.vec2_pos.y)
      love.graphics.pop()
  end
  love.graphics.setCanvas()
  love.graphics.scale(4,4)
  
  love.graphics.draw(CANVAS,0,0)
end

function love.load()

  local joysticks = love.joystick.getJoysticks()
  for i,joy in pairs (joysticks) do
    local player_object = player(joy)
    PLAYERS[#PLAYERS+1] = {
      obj = player_object,
      joy = joy
    }
    ADDOBJ(player_object)
  end
  ADDOBJ(collectible(20, 20))
  for i=0,128 do
    ADDOBJ(grass())
  end
  
end