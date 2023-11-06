
--sfx
snd=
{
  jump=1,
}

--music tracks
mus=
{

}

blocks = {
  create_block(100, 116),
}

--reset the game to its initial
--state. use this instead of
--_init()
function reset()
  ticks = 0
  player = create_player(64, 100)
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
  player:update(blocks)
  cam:update()
end

function _draw()
  cls(0)
  camera(cam:cam_pos())
  map(0, 0, 0, 0, 128, 128)
  for block in all(blocks) do
    block:draw()
  end
  player:draw()

  --hud
  camera(0, 0)
end