local class = require('../lib/middleclass')

local Entity = class('Entity')

function Entity:initialize(imageFile, x, y, entityType)
    self.image = imageFile
    self.x = x
    self.y = y
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.entityType = entityType
end

function Entity:getCollisionRectangle(x, y)
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height,
    }
end

return Entity