--point to box intersection.
function intersects_point_box(px,py,x,y,w,h)
	if flr(px)>=flr(x) and flr(px)<flr(x+w) and
				flr(py)>=flr(y) and flr(py)<flr(y+h) then
		return true
	else
		return false
	end
end

--box to box intersection
function intersects_box_box(
	x1,y1,
	w1,h1,
	x2,y2,
	w2,h2)

	local xd=x1-x2
	local xs=w1*0.5+w2*0.5
	if abs(xd)>=xs then return false end

	local yd=y1-y2
	local ys=h1*0.5+h2*0.5
	if abs(yd)>=ys then return false end
	
	return true
end


--make 2d vector
function m_vec(x,y)
	local v=
	{
		x=x,
		y=y,
		
  --get the length of the vector
		get_length=function(self)
			return sqrt(self.x^2+self.y^2)
		end,
		
  --get the normal of the vector
		get_norm=function(self)
			local l = self:get_length()
			return m_vec(self.x / l, self.y / l),l;
		end,
	}
	return v
end

--square root.
function sqr(a) return a*a end

--round to the nearest whole number.
function round(a) return flr(a+0.5) end
