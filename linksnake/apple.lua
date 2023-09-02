local class = require('../lib/middleclass')
local Entity = require('entity')

local Apple = class('Apple', Entity)

Apple.static.apple = love.graphics.newImage('images/apple.png')
Apple.static.redApple = love.graphics.newImage('images/redApple.png')


function Apple:initialize(countdown)
    local borderMargins = 1.1 -- acts as a percentage of the safe area
    local minX, minY, width, height = love.window.getSafeArea()
    local entityType
    if countdown == 0 then
        appleType = Apple.redApple
        entityType = "redApple"
    else
        appleType = Apple.apple
        entityType = "apple"
    end
    minX = minX * borderMargins
    minY = minY * borderMargins
    width = width*2 - width * borderMargins
    height = height*2 - height * borderMargins
    Entity.initialize(self, appleType, 
    love.math.random(minX, width), love.math.random(minY, height),
    entityType) -- add randomized x and y 
end

function Apple:draw() 
    love.graphics.draw(appleType, self.x, self.y)
end
return Apple