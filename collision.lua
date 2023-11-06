
--check if pushing into side tile and resolve.
--requires self.dx,self.x,self.y, and
--assumes tile flag 0 == solid
--assumes sprite size of 8x8
function collide_side(self)
	local offset = self.w / 3
	for i = -self.w / 3, self.w / 3, 2 do
		if self.dx > 0 and iswall(self.x + self.w / 2 - 1, self.y + i) then
			self.dx = 0
		elseif self.dx < 0 and iswall(self.x - self.w / 2, self.y + i) then
			self.dx = 0
		end
	end
end


function get_pushed_block(self)
	local offset = self.w / 3
	for i = -self.w / 3, self.w / 3, 2 do
		if self.dx > 0 then
			local b = is_block(self.x + self.w - 1, self.y + i)
			if b ~= nil then
				self.dx = 0
				return b
			end
		elseif self.dx < 0 then
			local b = is_block(self.x, self.y + i)
			if b ~= nil then
				self.dx = 0
			  return b
			end
		end
	end
	return nil
end

--check if pushing into floor tile and resolve.
--requires self.dx,self.x,self.y,self.grounded,self.airtime and
--assumes tile flag 0 or 1 == solid
function collide_floor(self, blocks)
	--only check for ground when falling.
	if self.dy < 0 then
		return false
	end
	--check for collision at multiple points along the bottom
	--of the sprite: left, center, and right.
	if self.dy >= 0 then
		for i = -self.w / 3, self.w / 3, 2 do
			local tile = mget((self.x + i) / 8, (self.y + (self.h / 2)) / 8)
			if fget(tile, 0) or fget(tile, 1) then
				self.dy = 0
				self.y = 8 * flr((self.y + (self.h / 2)) / 8) - self.h / 2
				self.grounded = true
				self.airtime = 0
				return true
			end
		end
		for i = 0, self.w, 2 do
			for b in all(blocks) do
	      if not b.small and intersects_point_box(self.x + i, self.y + self.h, b.x, b.y, b.w, b.h) then
	      	self.dy = 0
	      	self.y = b.y - self.h
	      	self.grounded = true
	      	self.airtime = 0
	      	return true
	      end
			end
		end
	end
end

--check if pushing into roof tile and resolve.
--requires self.dy,self.x,self.y, and
--assumes tile flag 0 == solid
function collide_roof(self)
	--check for collision at multiple points along the top
	--of the sprite: left, center, and right.
	for i =- self.w / 3, self.w / 3, 2 do
		if fget(mget((self.x + i) / 8, (self.y - self.h / 2) / 8), 0) then
			self.dy = 0
			self.y = flr((self.y - self.h / 2) / 8) * 8 + 8 + self.h / 2
			self.jump_hold_time = 0
		end
	end
end

function push_right(self, blocks)
	for b in all(blocks) do
	  if not b.small and intersects_point_box(self.x + self.w, self.y + self.h / 2, b.x, b.y, b.w, b.h) then
	  	if iswall(b.x + b.w / 2, b.y) then
	  		self.dx = 0
			else
	    	b.x += 1
	    end
			self.x = b.x - self.w
	    return true
	  end
	end
end

function push_left(self, blocks)
	for b in all(blocks) do
	  if not b.small and intersects_point_box(self.x - 1, self.y + self.h / 2, b.x, b.y, b.w, b.h) then
	  	if iswall(b.x - b.w / 2, b.y) then
	  		self.dx = 0
			else
	    	b.x -= 1
	    end
			self.x = b.x + b.w
	    return true
	  end
	end
end