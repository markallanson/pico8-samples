pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- pico8 version of 
-- codigntrain's starfield. 
-- https://www.youtube.com/watch?v=17wooqgxsrm
-- note this uses the flr
-- optimisation `& -1`
width = 128
height = 128
speed = 4
btn_up = 2
btn_down = 3
min_speed = -15
max_speed = 15
num_stars = 300
camshift_x = -64
camshift_y = -64

-- point the camera at the
-- middle of the screen (by 
-- moving the canvas, not cam)
camera(camshift_x, camshift_y)

-- resets a star to a new random
-- position
function reset_star(star, nz)
  -- rnd only generates positive
  -- numbers, so shift x,y by
  -- the camera offsets
  star.x = (
    (rnd(width) & -1) 
    + camshift_x
  )
  star.y = (
    (rnd(height) & -1) 
    + camshift_y
  )
  star.z = nz
  return star
end

-- create the starfield
function create_sf(star_count)
  s = {}
  last_z = width
  for i=1, star_count do
  	 -- to avoid having to sort
  	 -- by depth later, each
  	 -- new star has to be closer
  	 -- than the last
  	 --repeat
  	   z = rnd(width) & -1
  	 --until z <= last_z
    s[i] = reset_star({}, z)
  end
  return s
end

-- alter speed of the starfield
-- increase speed when up
-- decrease speed when down
-- function will cap both 
-- forward and reverse speed.
function adjust_speed()
  if (
    btn(btn_up) 
    and speed < max_speed
  ) then 
    speed = speed + 0.2 
  elseif (
    btn(btn_down) 
    and speed > min_speed
  ) then 
    speed = speed - 0.2
  end
end

-- move all the stars in the 
-- starfield.
-- reset star positions if they
-- are exiting or entering the
-- field of view.
function move_stars() 
  for i=1, count(stars) do
    star = stars[i]    
    star.z = star.z - speed
    if star.z < 1 do
      reset_star(star, width)
    elseif star.z > width then
      reset_star(star, 1)
    end
  end 
end

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

stars = create_sf(num_stars)

function _update()
		adjust_speed()
		move_stars()
end

function _draw()
  cls()

  for i=1, count(stars) do
    star = stars[i]
    
    draw_x = map(
      star.x / star.z, 
      0, 1, 0, width
    )
    draw_y = map(
      star.y / star.z, 0, 1, 0,
      height
    )
	
    radius = map(
      star.z, 0, width, 3, 0
    )
    star_color = map(
      radius,
      -- 5 = dark grey
      -- 7 = white
      0, 2, 5, 7
    )
        
    circfill(
      draw_x, 
      draw_y, 
      radius,
      star_color      
    )
  end 
end

