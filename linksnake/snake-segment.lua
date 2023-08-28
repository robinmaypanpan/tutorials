local class = require('../lib/middleclass')
local myMath = require('../lib/math')

local Opposites = {
    up='down',
    down='up',
    left='right',
    right='left'
}

local SnakeSegment = class('SnakeSegment') -- 'Fruit' is the class' name

SnakeSegment.static.width = 15
SnakeSegment.static.height = 15

SnakeSegment.static.speed = .003

-- The "Constructor" for the snake head
function SnakeSegment:initialize(x,y)
    self.x = x
    self.y = y
    self.direction = "right"
end

function SnakeSegment:setDirection(newDirection)
    if newDirection ~= self.direction 
        and newDirection ~= Opposites[self.direction] then
        self.direction = newDirection
    end
end

-- Called prior to drawing the SnakeSegment to update its location according to its speed and direction
function SnakeSegment:update()
    local minX, minY, width, height = love.window.getSafeArea()

    local vspeed = SnakeSegment.speed * height
    local hspeed = SnakeSegment.speed * width

    if self.direction == "up" then
        self.y = self.y - vspeed
    elseif self.direction == "down" then
        self.y = self.y + vspeed
    elseif self.direction == "left" then
        self.x = self.x - hspeed
    elseif self.direction == "right" then
        self.x = self.x + hspeed
    end

    self.x = myMath:mid(minX, self.x, minX + width - SnakeSegment.width)
    self.y = myMath:mid(minY, self.y, minY + height - SnakeSegment.height)
end

-- Draws the SnakeSegment
function SnakeSegment:draw()
    love.graphics.rectangle("fill", self.x, self.y, SnakeSegment.width, SnakeSegment.height, 2, 2)
end

return SnakeSegment