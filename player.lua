
--make the player
function create_player(x,y)

	return {
		x = x, -- position
		y = y,
		velocity = vector2(0, 0),
		w = 8, -- sprite size
		h = 8,

		max_dx = 1, --max x speed
		max_dy = 2, --max y speed

		jump_speed = -1.75, --jump veloclity
		acc = 0.05, --acceleration
		dcc = 0.8, --decceleration
		air_dcc = 1, --air decceleration
		grav = 0.15,

		--helper for more complex
		--button press tracking.
		--todo: generalize button index.
		jump_button = create_key(5),

		jump_hold_time = 0,--how long jump is held
		min_jump_press = 5,--min time jump can be held
		max_jump_press = 15,--max time jump can be held
		grounded = false,--on ground
		airtime = 0,--time since grounded

		--animation definitions.
		--use with set_anim()
		anims = {
			["stand"] =	{
				ticks = 30,--how long is each frame shown.
				frames = {0, 1},--what frames are shown.
			},
			["walk"] = {
				ticks = 5,
				frames = {2, 3, 4, 5},
			},
			["jump"] = {
				ticks = 1,
				frames = {1},
			},
			["slide"] = {
				ticks = 1,
				frames = {6},
			},
		},

		curanim = "stand", --currently playing animation
		curframe = 1,--curent frame of animation.
		animtick = 0,--ticks until next frame should show.
		flipx = false,--show sprite be flipped.

		--request new animation to play.
		set_anim = function(self, anim)
			if(anim == self.curanim) return--early out.
			local a = self.anims[anim]
			self.animtick = a.ticks--ticks count down.
			self.curanim = anim
			self.curframe = 1
		end,

		--call once per tick.
		update = function(self)
			--track button presses
			local left_pressed = btn(0) --left
			local right_pressed = btn(1) --right

			--move left/right
			if left_pressed == true then
				self.velocity.x -= self.acc
				right_pressed = false --handle double press
				self.flipx = true
			elseif right_pressed == true then
				self.velocity.x += self.acc
				self.flipx = false
			else
				if self.grounded then
					self.velocity.x *= self.dcc
				else
					self.velocity.x *= self.air_dcc
				end
			end

			--limit walk speed
			self.velocity.x = mid(-self.max_dx, self.velocity.x, self.max_dx)

			--move in x
			self.x += self.velocity.x

			--hit walls
			collide_side(self)

			--jump buttons
			self.jump_button:update()

			--jump is complex. we allow jump if:
			--	on ground
			--	recently on ground
			--	pressed btn right before landing
			--jump velocity is not instant. it applies over multiple frames.
			if self.jump_button.is_down then
				--is player on ground recently.
				--allow for jump right after
				--walking off ledge.
				local on_ground = self.grounded or self.airtime < 5
				--was btn presses recently?
				--allow for pressing right before
				--hitting ground.
				local recently_jumped = self.jump_button.ticks_down < 10
				--is player continuing a jump
				--or starting a new one?
				if self.jump_hold_time > 0 or (on_ground and recently_jumped) then
					if(self.jump_hold_time == 0) sfx(snd.jump)
					self.jump_hold_time += 1
					--keep applying jump velocity
					--until max jump time.
					if self.jump_hold_time < self.max_jump_press then
						self.velocity.y = self.jump_speed--keep going up while held
					end
				end
			else
				self.jump_hold_time = 0
			end

			--move in y
			self.velocity.y += self.grav
			self.velocity.y = mid(-self.max_dy, self.velocity.y, self.max_dy)
			self.y += self.velocity.y

			--floor
			if not collide_floor(self) then
				self:set_anim("jump")
				self.grounded = false
				self.airtime += 1
			end

			--roof
			collide_roof(self)

			--handle playing correct animation when
			--on the ground.
			if self.grounded then
				if right_pressed then
					if self.velocity.x < 0 then
						--pressing right but still moving left.
						self:set_anim("slide")
					else
						self:set_anim("walk")
					end
				elseif left_pressed then
					if self.velocity.x > 0 then
						--pressing left but still moving right.
						self:set_anim("slide")
					else
						self:set_anim("walk")
					end
				else
					self:set_anim("stand")
				end
			end

			--anim tick
			self.animtick -= 1
			if self.animtick <= 0 then
				self.curframe += 1
				local a = self.anims[self.curanim]
				self.animtick = a.ticks--reset timer
				if self.curframe > #a.frames then
					self.curframe = 1--loop
				end
			end

		end,

		--draw the player
		draw = function(self)
			local a = self.anims[self.curanim]
			local frame = a.frames[self.curframe]
			local offset = 0
			--slightly jump while running
			if frame == 2 then
				offset = 1
			end
			spr(frame,
				self.x - self.w / 2,
				self.y - self.h / 2 - offset,
				self.w / 8, self.h / 8,
				self.flipx,
				false)
		end,
	}
end