
--sfx
snd=
{
  jump=1,
}

--music tracks
mus=
{

}

--reset the game to its initial
--state. use this instead of
--_init()
function reset()
  ticks = 0
  player = create_player(64,100)
  player:set_anim("walk")
  cam = create_camera(player)
end

--p8 functions
--------------------------------

function _init()
  reset()
end

function _update60()
  ticks += 1
  player:update()
  cam:update()
end

function _draw()
  cls(0)
  camera(cam:cam_pos())
  map(0, 0, 0, 0, 128, 128)
  player:draw()

  --hud
  camera(0, 0)
end