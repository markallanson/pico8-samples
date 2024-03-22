pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- purple rain pico 8 demo
-- inspired by coding train #4.
-- https://www.youtube.com/watch?v=kkyidi6rqji
-- 
-- i have taken the creative
-- liberty of adding wind 
-- adjutable using l/r buttons
-- and speed using u/d buttons.
width = 128
height = 128
bgc = 14 -- pink background 
fgc = 2 -- dark purple rain
gravity = 0.8 -- gravity const
speed = 1.5 -- speed control

-- wind controls change in the x
-- direction of the raindrops
-- each z direction get's it's
-- own wind speed.
wind = {
  0.5, 0.2, 0.1, 0.05
}
-- wind strength controls how
-- strong the wind direction
-- is. it acts as a multiplier
wind_strength = 0.75

-- map values from one range to
-- another relative to position
-- in the first range
function map(p,la,ua,lb,ub)
  new_p = (
    ((p - la) / (ua - la) 
    * (ub - lb)) + lb
  )
  return new_p & -1
end

-- create a new drop at 
-- random x and y
function init_drop(reset)
  drop = {}

  -- how far away is the drop
  drop.z = flr(rnd(4))+1

  -- length is based on how far
  -- away the drop is. the
  -- closer the drop the longer
  -- it is.
  drop.length = flr(map(
    drop.z, 0, 4, 10, 0
  ))

  -- speed depends on how far
  -- away the drop is. the 
  -- further away the slower 
  -- it falls
  drop.yspeed = map(
    drop.z, 0, 4, 5, 1
  )

  -- x is a random position.
  -- note that we generate 
  -- drops beyond the viewpane
  -- so that when the wind is
  -- blowing strong it doesn't
  -- look like we're missing
  -- raindrops. as a consequence
  -- we need to generate more 
  -- drops to fill the screen
  drop.x = flr(
    rnd(width * 1.5) - width/2
  )
  
  -- if we're resetting then
  -- position the drop off 
  -- screen
  if reset then
    drop.y = -drop.length
  else
    drop.y = flr(rnd(height))
  end

  return drop
end

-- generate num raindrops
function init_drops(num)
  drops = {}
  for i=1, num do
     drops[i] = init_drop()
  end
  return drops
end

-- adjust the wind speed
-- based on L/R buttons
function adjust_wind_strength()
  if btn(0) then
    wind_strength -= 0.1 
  elseif btn(1) then
    wind_strength += 0.1
  end
end

-- adjust the drop speed
-- based on U/D buttons
function adjust_drop_speed()
  if btn(2) then
    speed -= 0.1 
  elseif btn(3) then
    speed += 0.1
  end
  speed = max(speed, 0.4)
end

-- make each raindrop fall
function move_raindrops(rds)
  for i=1, count(rds) do
    drop = rds[i]
     
    -- move x by the wind
    -- strength at it's
    -- distance
    drop.x += (
      wind[drop.z] 
      * wind_strength
    )
    
    -- reset the drop to the
    -- top of the screen if
    -- it's beyond the bottom
    if drop.y >= height then
      rds[i] = init_drop(true)
    else
      drop.y = drop.y 
        + (drop.yspeed * speed) 
    end
    -- add a bit of gravity
    -- to the drop. the futher
    -- away the drop is, the 
    -- less the gravity constant
    -- applies
    drop_gravity = map(
      drop.z, 
      0, 4,
      gravity, 0
    )
    drop.yspeed += drop_gravity
  end
end

function draw_raindrops(rds)
  for i=1, count(rds) do
     drop = rds[i]
     windx = (
       wind[drop.z] * wind_strength
     )
     
     sx = drop.x
     sy = drop.y
     ex = drop.x + windx
     ey = drop.y + drop.length
     palt(fgc, 0.1)
     line(sx, sy, ex, ey)
  end
end

drops = init_drops(120)

function _update()
  adjust_wind_strength()
  adjust_drop_speed()
  move_raindrops(drops)
end

function _draw()
  -- clear to our lovely pink
  -- backgrounf
  cls(bgc)

  -- set the raindrop colour
  color(fgc)
  
  -- draw the raindrop
  draw_raindrops(drops)
end
