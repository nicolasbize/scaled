function create_block(x, y)
  return {
    x = x,
    y = y,
    w = 8,
    h = 8,
    small = false,
    update = function(self)

    end,
    draw = function(self)
      local frame = 82
      if self.small then frame = 83 end
      spr(frame,
        self.x - self.w / 2,
        self.y - self.h / 2)
    end,
  }
end

function is_block(x, y)
  for b in all(blocks) do
    if not b.small and intersects_point_box(x, y, b.x, b.y, b.w, b.h) then
      return b
    end
  end
  return nil
end