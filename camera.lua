--make the camera.
function create_camera(target)
	return {
		tar = target, --target to follow.
		x = target.x,
		y = target.y,

		--how far from center of screen target must
		--be before camera starts following.
		--allows for movement in center without camera
		--constantly moving.
		pull_threshold = 16,

		--min and max positions of camera.
		--the edges of the level.
		pos_min = vector2(64, 64),
		pos_max = vector2(320, 64),

		shake_remaining = 0,
		shake_force = 0,

		update = function(self)

			self.shake_remaining = max(0, self.shake_remaining - 1)

			--follow target outside of pull range.
			if self:pull_max_x() < self.tar.x then
				self.x += min(self.tar.x - self:pull_max_x(), 4)
			end
			if self:pull_min_x() > self.tar.x then
				self.x += min((self.tar.x - self:pull_min_x()), 4)
			end
			if self:pull_max_y() < self.tar.y then
				self.y += min(self.tar.y - self:pull_max_y(), 4)
			end
			if self:pull_min_y() > self.tar.y then
				self.y += min((self.tar.y - self:pull_min_y()), 4)
			end

			--lock to edge
			self.x = mid(self.x, self.pos_min.x, self.pos_max.x)
			self.y = mid(self.y, self.pos_min.y, self.pos_max.y)
		end,

		cam_pos = function(self)
			--calculate camera shake.
			local shk = vector2(0,0)
			if self.shake_remaining > 0 then
				shk.x = rnd(self.shake_force) - (self.shake_force / 2)
				shk.y = rnd(self.shake_force) - (self.shake_force / 2)
			end
			return self.x - 64 + shk.x, self.y - 64 + shk.y
		end,

		pull_max_x = function(self)
			return self.x + self.pull_threshold
		end,

		pull_min_x = function(self)
			return self.x - self.pull_threshold
		end,

		pull_max_y = function(self)
			return self.y + self.pull_threshold
		end,

		pull_min_y = function(self)
			return self.y - self.pull_threshold
		end,

		shake = function(self, ticks, force)
			self.shake_remaining = ticks
			self.shake_force = force
		end
	}
end
