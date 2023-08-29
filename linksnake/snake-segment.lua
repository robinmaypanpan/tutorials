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

local spawnDir = {
    up = {x = 0, y = 1},
    down = {x = 0, y = -1},
    left = {x = 1, y = 0},
    right = {x = -1, y = 0},
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
    self.dirX = 0
    self.dirY = 0
    self.moveTimeout = 0
end

function SnakeSegment:setDirection(newDirection)
    if self.moveTimeout == 0 
        and newDirection ~= self.direction 
        and newDirection ~= Opposites[self.direction] then
            self.direction = newDirection
            self.moveTimeout = 8
    end
    
end

-- Called prior to drawing the SnakeSegment to update its location according to its speed and direction
function SnakeSegment:update()
    if self.moveTimeout > 0 then
        self.moveTimeout = self.moveTimeout - 1
    end

    if self.previousSegment then
        -- Runs for all segments that are not the head
        -- define a direction for the segment
        if self.previousSegment.x > self.x and self.previousSegment.y == self.y then
            self.direction = "right"
        elseif self.previousSegment.x < self.x and self.previousSegment.y == self.y then
            self.direction = "left"
        elseif self.previousSegment.y > self.y and self.previousSegment.x == self.x then
            self.direction = "down"
        elseif self.previousSegment.y < self.y and self.previousSegment.x == self.x then
            self.direction = "up"
        end
    end

    local minX, minY, width, height = love.window.getSafeArea()

    -- local vspeed = SnakeSegment.speed * height
    -- local hspeed = SnakeSegment.speed * width
    local vspeed = self.height / 8
    local hspeed = self.width / 8

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
     --love.graphics.draw(SnakeSegment.soloPart, self.x, self.y)
    if self.next then
        self.next:draw()
    end
end

-- Adds a segment to the snake when an apple is eaten
function SnakeSegment:addSegment()
    if self.next then
        self.next:addSegment()
    else --inside the tail
        local dir = spawnDir[self.direction]
        local segment = SnakeSegment:new(self.x + self.width * dir.x, self.y + self.height * dir.y)
        self.next = segment
        segment.previousSegment = self
        segment.direction = self.direction
    end
end
return SnakeSegment


-- 