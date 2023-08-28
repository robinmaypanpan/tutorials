local class = require('../lib/middleclass')
local Entity = require('entity')

local Apple = class('Apple', Entity)

Apple.static.apple = love.graphics.newImage('images/apple.png')


function Apple:initialize()
    Entity.initialize(self, Apple.apple)
end

function Apple:draw(x, y)
    love.graphics.draw(Apple.apple, self.x, self.y)
end
return Apple