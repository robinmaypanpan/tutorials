local class = require('../lib/middleclass')

local Monsta = class('Monsta')

PLANT = 1
HERBIVORE = 2
CARNIVORE = 3

function Monsta:initialize()
    local minX, minY, width, height = love.window.getSafeArea()
    self.x = love.math.random(minX, minX + width)
    self.y = love.math.random(minY, minY + height)
    self.type = love.math.random(1, 3)
end

function Monsta:update()
    -- TASK: Find the nearest thing this monsta wants to eat and move towards it
end

function Monsta:draw()
    if self.type == PLANT then
        love.graphics.setColor(0, 1, 0, 1)
    elseif self.type == HERBIVORE then
        love.graphics.setColor(0, 0, 1, 1)
    elseif self.type == CARNIVORE then
        love.graphics.setColor(1, 0, 0, 1)
    end
    love.graphics.rectangle("fill", self.x, self.y, 15, 15, 2, 2)
end

return Monsta
