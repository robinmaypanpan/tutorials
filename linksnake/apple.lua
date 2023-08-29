local class = require('../lib/middleclass')
local Entity = require('entity')

local Apple = class('Apple', Entity)

Apple.static.apple = love.graphics.newImage('images/apple.png')


function Apple:initialize()
    local minX, minY, width, height = love.window.getSafeArea()
    Entity.initialize(self, Apple.apple, 
    love.math.random(minX, width), love.math.random(minY, height)) -- add randomized x and y  
end

function Apple:draw(x, y)
    love.graphics.draw(Apple.apple, self.x, self.y)
end
return Apple