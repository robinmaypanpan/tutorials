local class = require('../lib/middleclass')

local Apple = class('Apple')

Apple.static.apple = love.graphics.newImage('apple.png')

function Apple:initialize()
    local minX, minY, width, height = love.window.getSafeArea()
    self.x = love.math.random(minX, width)
    self.y = love.math.random(minY, height)   
end

function Apple:draw(x, y)
    love.graphics.draw(Apple.apple, self.x, self.y)
end
return Apple