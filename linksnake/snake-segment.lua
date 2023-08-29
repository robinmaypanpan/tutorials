local class = require('../lib/middleclass')
local myMath = require('../lib/math')
local Entity = require('entity')

local SnakeSegment = class('SnakeSegment', Entity) 

local Opposites = {
    up='down',
    down='up',
    left='right',
    right='left'
}


SnakeSegment.static.speed = .003

SnakeSegment.static.soloPart = love.graphics.newImage('images/test.png')
SnakeSegment.static.width = SnakeSegment.soloPart:getWidth()
SnakeSegment.static.height = SnakeSegment.soloPart:getHeight()
SnakeSegment.static.originY = SnakeSegment.height * 0.5
SnakeSegment.static.originX = SnakeSegment.width * 0.5

-- The "Constructor" for the snake head
function SnakeSegment:initialize(x, y)
    Entity.initialize(self, SnakeSegment.soloPart, x, y)
    self:setDirection("up")
end

function SnakeSegment:setDirection(newDirection)
    if newDirection ~= self.direction 
        and newDirection ~= Opposites[self.direction] then
        self.direction = newDirection
    end
    if self.next then
        self.next:setDirection(newDirection)
    end
end

-- Called prior to drawing the SnakeSegment to update its location according to its speed and direction
function SnakeSegment:update()
    local minX, minY, width, height = love.window.getSafeArea()

    local vspeed = SnakeSegment.speed * height
    local hspeed = SnakeSegment.speed * width

    if self.direction == "up" then
        self.y = self.y - vspeed
        self.orientation = 0
    elseif self.direction == "down" then
        self.y = self.y + vspeed
        self.orientation = math.pi
    elseif self.direction == "left" then
        self.x = self.x - hspeed
        self.orientation = math.pi*1.5
    elseif self.direction == "right" then
        self.x = self.x + hspeed
        self.orientation = math.pi*0.5
    end

    self.x = myMath:mid(minX, self.x, minX + width - SnakeSegment.width)
    self.y = myMath:mid(minY, self.y, minY + height - SnakeSegment.height)
    if self.next then
        self.next:update()
    end
end

-- Draws the SnakeSegment
function SnakeSegment:draw()
    love.graphics.draw(SnakeSegment.soloPart, self.x, self.y, self.orientation, 1, 1, 
        SnakeSegment.originX, SnakeSegment.originY)
    if self.next then
        self.next:draw()
    end
end

-- Adds a segment to the snake when an apple is eaten
function SnakeSegment:addSegment()
    if self.next then
        self.next:addSegment()
    else
        local segment = SnakeSegment:new(self.x, self.y)
        self.next = segment
    end
end
return SnakeSegment