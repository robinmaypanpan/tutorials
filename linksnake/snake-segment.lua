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

SnakeSegment.static.headImg = love.graphics.newImage('images/test.png')
SnakeSegment.static.segmentImg = love.graphics.newImage('images/segment.png')
SnakeSegment.static.tailImg = love.graphics.newImage('images/tail.png')
SnakeSegment.static.width = SnakeSegment.headImg:getWidth()
SnakeSegment.static.height = SnakeSegment.headImg:getHeight()
SnakeSegment.static.originY = SnakeSegment.height * 0.5
SnakeSegment.static.originX = SnakeSegment.width * 0.5

-- The "Constructor" for the snake head
function SnakeSegment:initialize(x, y)
    Entity.initialize(self, SnakeSegment.headImg, x, y)
    self:setDirection("up")
    self.dirX = 0
    self.dirY = 0
    self.moveTimeout = 0
    self.entityType = "snake"
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
    love.graphics.draw(self.image, self.x, self.y, self.orientation, 1, 1, 
        SnakeSegment.originX, SnakeSegment.originY)
     --love.graphics.draw(SnakeSegment.headImg, self.x, self.y)
    if self.next then
        self.next:draw()
    end
end

-- HSSSST
-- 123456

-- Adds a segment to the snake when an apple is eaten
function SnakeSegment:addSegment()
    if self.next then
        self.next:addSegment()
    else --inside the tail
        local dir = spawnDir[self.direction]
        local segment = SnakeSegment:new(self.x + self.width * dir.x, self.y + self.height * dir.y)
        self.next = segment
        segment.previousSegment = self
        if self.previousSegment ~= nil then
            self.image = SnakeSegment.segmentImg
        end
        segment.direction = self.direction
        segment.image = SnakeSegment.tailImg
    end
end

function SnakeSegment:reverseSegmentList()
    -- if self.next == nil and self.previousSegment then 
    --     self.next = self.previousSegment
    --     self.previousSegment = nil
    --     newHead = self
    --     self.next:reverseSegmentList()     
    -- elseif self.next and self.previousSegment then -- this is a body segment
    --     local oldNext = self.next -- this self.next is the old tail
    --     self.next = self.previousSegment -- this should be the next up body segment
    --     self.previousSegment = oldNext -- refers to making the old tail the new head in relation to this segment
    --     self.next:reverseSegmentList()
    -- else
    --     self.previousSegment = self.next
    --     self.next = nil
    --     self.direction = nil
    -- end
    -- if newHead then
    --     return self
    -- end
    if self.next and self.previousSegment == nil then
        self.previousSegment = self.next
        self.next = nil
        self.direction = Opposites[self.direction]
        local newHead = self.previousSegment:reverseSegmentList()
        return newHead
    elseif self.next and self.previousSegment then
        local oldPrevious
        oldPrevious = self.previousSegment
        self.previousSegment = self.next
        self.next = oldPrevious
        self.direction = Opposites[self.direction]
        local newHead = self.previousSegment:reverseSegmentList()
        return newHead
    else
        self.next = self.previousSegment
        self.previousSegment = nil
        self.direction = Opposites[self.direction]
        return self
    end
end

return SnakeSegment