
--check if pushing into side tile and resolve.
--requires self.dx,self.x,self.y, and 
--assumes tile flag 0 == solid
--assumes sprite size of 8x8
function collide_side(self)

	local offset=self.w/3
	for i=-(self.w/3),(self.w/3),2 do
	--if self.dx>0 then
		if fget(mget((self.x+(offset))/8,(self.y+i)/8),0) then
			self.dx=0
			self.x=(flr(((self.x+(offset))/8))*8)-(offset)
			return true
		end
	--elseif self.dx<0 then
		if fget(mget((self.x-(offset))/8,(self.y+i)/8),0) then
			self.dx=0
			self.x=(flr((self.x-(offset))/8)*8)+8+(offset)
			return true
		end
--	end
	end
	--didn't hit a solid tile.
	return false
end

--check if pushing into floor tile and resolve.
--requires self.dx,self.x,self.y,self.grounded,self.airtime and 
--assumes tile flag 0 or 1 == solid
function collide_floor(self)
	--only check for ground when falling.
	if self.dy<0 then
		return false
	end
	local landed=false
	--check for collision at multiple points along the bottom
	--of the sprite: left, center, and right.
	for i=-(self.w/3),(self.w/3),2 do
		local tile=mget((self.x+i)/8,(self.y+(self.h/2))/8)
		if fget(tile,0) or (fget(tile,1) and self.dy>=0) then
			self.dy=0
			self.y=(flr((self.y+(self.h/2))/8)*8)-(self.h/2)
			self.grounded=true
			self.airtime=0
			landed=true
		end
	end
	return landed
end

--check if pushing into roof tile and resolve.
--requires self.dy,self.x,self.y, and 
--assumes tile flag 0 == solid
function collide_roof(self)
	--check for collision at multiple points along the top
	--of the sprite: left, center, and right.
	for i=-(self.w/3),(self.w/3),2 do
		if fget(mget((self.x+i)/8,(self.y-(self.h/2))/8),0) then
			self.dy=0
			self.y=flr((self.y-(self.h/2))/8)*8+8+(self.h/2)
			self.jump_hold_time=0
		end
	end
end
