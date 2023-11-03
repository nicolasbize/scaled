function create_key(btn_index)
  return {
    update = function(self)
      --start with assumption
      --that not a new press.
      self.is_pressed = false
      if btn(btn_index) then
        if not self.is_down then
          self.is_pressed = true
        end
        self.is_down = true
        self.ticks_down += 1
      else
        self.is_down = false
        self.is_pressed = false
        self.ticks_down = 0
      end
    end,
    --state
    is_pressed = false,--pressed this frame
    is_down = false,--currently down
    ticks_down = 0,--how long down
  }
end