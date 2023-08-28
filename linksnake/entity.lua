local class = require('../lib/middleclass')

local Entity = class('Entity')

function Entity:initialize(imageFile)
    self.image = imageFile
    local minX, minY, width, height = love.window.getSafeArea()
    self.x = love.math.random(minX, width)
    self.y = love.math.random(minY, height)  
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Entity:getCollisionRectangle(x, y)
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height
    }
end

return Entity