function collide(r1,r2)
    return r1.x < r2.x + r2.width and
      r1.x + r1.width > r2.x and
      r1.y < r2.y + r2.height and
      r1.y + r1.height > r2.y
end
return collide