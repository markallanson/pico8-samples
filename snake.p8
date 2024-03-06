pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
// a simple snake game
// inspired by coding trains
// code challenge 3 - snake
// https://www.youtube.com/watch?v=aagk-fj-bam
width = 128
height = 128

function create_snake()
  snake = {}
  -- ensure the snake doesn't
  -- spawn too close to the
  -- edge of the screen
  snake.x = flr(rnd(width/2)) 
    + 32
  snake.y = flr(rnd(height/2)) 
    + 32
  snake.xspeed = 1
  snake.yspeed = 0
  snake.total = 0
  snake.tail = {}
  return snake
end

function reset_food()
  f = {}
  -- -2 and +1 are here to stop
  -- food spawning in the border
  f.x = flr(rnd(width-2)) + 1
  f.y = flr(rnd(height-2)) + 1
  return f
end

snake = create_snake()
food = reset_food()

function change_direction()
  if btn(0) then
    snake.xspeed = -1
    snake.yspeed = 0
  elseif btn(1) then
    snake.xspeed = 1
    snake.yspeed = 0
  elseif btn(2) then
    snake.xspeed = 0
    snake.yspeed = -1
  elseif btn(3) then
    snake.xspeed = 0
    snake.yspeed = 1
  end
end

function move_snake()
  -- rotate the tail by shifting  
  -- the tail to leave an empty
  -- slot for the current x/y
  -- drops the oldest tail pixel
  for i=1,count(snake.tail)-1 do
    snake.tail[i] 
      = snake.tail[i + 1] 
  end
  -- add the current snake pos
  -- to the tail
  if snake.total >= 1 then
    new_tail = {}
    new_tail.x = snake.x
    new_tail.y = snake.y
  
    snake.tail[snake.total] 
      = new_tail
    printh(count(snake.tail))
  end
 
  -- move the snake
  snake.x += snake.xspeed
  snake.y += snake.yspeed
end

function check_endgame()
  if (
    snake.x < 1
    or snake.x > width - 2
    or snake.y < 1
    or snake.y > height - 2
  ) then
    stop("game over")
  end
end

function eat()
  if (
    snake.x == food.x
    and snake.y == food.y
  ) then
    food = reset_food()
    snake.total += 1
  end
end

function _update()
  if not endgame then
    change_direction()
    move_snake()
    check_endgame()
    eat()
  end
end

function cprint(text, y, c)
    local x = (128 - (#text * 4)) / 2
    print(text, x, y, c)
end

function _draw()
  cls()
  
  -- score is just the number
  -- of food eaten
  print("score: ", 2, 2)
  print(snake.total)
  
  -- draw the game b0undary
  rect(
    0, 0, width-1, height-1, 7
  )

  -- draw the food  
  pset(
    food.x, food.y, 3
  )
  -- and the snake
  pset(
    snake.x, snake.y, 7
  )
  -- and it's tail
  for i=1,count(snake.tail) do
    tail = snake.tail[i]
    pset(tail.x, tail.y, 7)
  end
end

