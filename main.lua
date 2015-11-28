function gradient(colors)
    local direction = colors.direction or "horizontal"
    if direction == "horizontal" then
        direction = true
    elseif direction == "vertical" then
        direction = false
    else
        error("Invalid direction '" .. tostring(direction) "' for gradient.  Horizontal or vertical expected.")
    end
    local result = love.image.newImageData(direction and 1 or #colors, direction and #colors or 1)
    for i, color in ipairs(colors) do
        local x, y
        if direction then
            x, y = 0, i - 1
        else
            x, y = i - 1, 0
        end
        result:setPixel(x, y, color[1], color[2], color[3], color[4] or 255)
    end
    result = love.graphics.newImage(result)
    result:setFilter('linear', 'linear')
    return result
end

function drawinrect(img, x, y, w, h, r, ox, oy, kx, ky)
    return -- tail call for a little extra bit of efficiency
    love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end

function drawSprite(character, sprite)
  local sectionWidth = character.width / character.spriteDims[1]
  local sectionHeight = character.height / character.spriteDims[2]
  local y = character.y - character.height / 2
  for i, row in ipairs(sprite) do
    local x = character.x - character.width / 2
    y = y + sectionHeight
    for j, col in ipairs(row) do
      x = x + sectionWidth
      if col == 1 then
        love.graphics.rectangle("fill", x, y, sectionWidth, sectionHeight)
      end
    end
  end
end

function explodeSprite(character, sprite)
  local sectionWidth = character.width / character.spriteDims[1]
  local sectionHeight = character.height / character.spriteDims[2]
  local y = character.y - character.height / 2
  for i, row in ipairs(sprite) do
    local x = character.x - character.width / 2
    y = y + sectionHeight
    for j, col in ipairs(row) do
      x = x + sectionWidth
      if col == 1 then
        if math.random() > 0.7 then
          love.graphics.setColor(255 * math.random(), 255 * math.random(), 255 * math.random(), 255)
          love.graphics.rectangle("fill", x, y, sectionWidth, sectionHeight)
        end
      end
    end
  end
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function makeBomb(xPos, yPos)
  local bomb = {}
  bomb.x = xPos
  bomb.y = yPos

  table.insert(bombs, bomb)
end

function makeHero()
  hero.ammo = 20
  hero.shots = {}
  hero.x = 300
  hero.y = 450
  hero.speed = 200
  hero.width = 36
  hero.height = 20
  hero.lives = 3
  hero.protectedUntil = 0
  hero.score = 0
  hero.sprite = {{0, 0, 0, 0, 1, 0, 0, 0, 0}, {0, 0, 0, 1, 1, 1, 0, 0, 0}, {0, 1, 1, 1, 1, 1, 1, 1, 0}, {1, 1, 1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1, 1}}
  hero.spriteDims = {9, 5}
end

function makeEnemies()
  world.numberOfEnemies = 6
  enemies.speed = 30
  for i = 0, world.numberOfEnemies - tablelength(enemies) do
    enemy = {}
    enemy.random = math.random()
    enemy.width = 44
    enemy.height = 32
    enemy.x = world.width * math.random()
    enemy.y = 0
    enemy.speed = enemies.speed
    enemy.r = math.random() * 255
    enemy.g = math.random() * 255
    enemy.b = math.random() * 255
    enemy.a = 0
    enemy.spriteDims = {11, 8}
    enemy.sprite1 = {{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0}, {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0}, {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0}, {0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1}, {1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1}, {0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0}}
    enemy.sprite2 = {{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0}, {1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1}, {1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1}, {1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0}, {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0}, {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0}}
    table.insert(enemies, enemy)
  end
end

function makeLife()
  life.height = 20
  life.width = 20
  life.x = math.random(life.width, world.width - life.width)
  life.y = world.ground - life.height
  life.sprite = {}
end

function shoot()
  if hero.ammo > 0 then
    local shot = {}
    shot.x = hero.x + hero.width/2
    shot.y = hero.y
    table.insert(hero.shots, shot)
    hero.ammo = hero.ammo - 1
  end
end

function love.keyreleased(key)
  if key == " " then
      shoot()
  end
  if key == "r" and world.pause then
    hero = {}
    enemies = {}
    makeHero()
    makeEnemies()
    explosions = {}
    bombs = {}
    bombs.probability = 0.995
    world.pause = false
    world.time = 0
  end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1 end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function controlHero(dt)
  if love.keyboard.isDown("left") then
    hero.x = hero.x - hero.speed*dt
  elseif love.keyboard.isDown("right") then
    hero.x = hero.x + hero.speed*dt
  end
  if hero.x < 0 then
    hero.x = 800 - hero.width
  elseif hero.x > 800 then
    hero.x = 0
  end
end

function addMoreEnemies()
  if tablelength(enemies) < world.numberOfEnemies then
    makeEnemies()
  end
end

function new2DRandomTable(xLength, yLenth)
  print(xLength)
  local new2D = {}
  for i = 0, xLength do
    local row = {}
    for j = 0, yLenth do
      table.insert(row, math.floor(math.random(0.5, 1.5)))
    end
  end
end

function newStar()
  local star = {}
  star.x = math.random(0, 800)
  star.y = math.random(0, world.ground)
  star.spriteDims = stars.spriteDims
  star.width = stars.width
  star.height = stars.height
  return star
end

function newBuilding()
  local building = {}
  building.windows = {}
  building.height = math.random(20, 300)
  building.width = math.random(50, 150)
  building.x = math.random(0, 800)
  building.y = world.ground - building.height
  building.random = math.random(50, 100)
  return building
end

function love.load()
  math.randomseed( os.time() )
  -- new2DRandomTable(10, 10)
  love.window.setTitle('Invaders Must Die')
  love.graphics.setBackgroundColor(255, 255, 255)
  titleFont = love.graphics.newFont("8-BIT WONDER.TTF", 100)
  bodyFont = love.graphics.newFont("8-BIT WONDER.TTF", 30)
  scoreFont = love.graphics.newFont("8-BIT WONDER.TTF", 20)
  hero = {}
  enemies = {}
  world = {}
  explosions = {}
  bombs = {}
  world.width, world.height, world.flags = love.window.getMode()
  world.ground = 465
  world.tab = 20
  world.time = 0
  world.pause = true
  bombs.probability = 0.995
  stars = {}
  stars.population = 50
  stars.spriteDims = {5, 5}
  stars.width = 4
  stars.height = 4
  stars.sprite = {{1, 0, 0, 0, 1}, {0, 1, 0, 1, 0}, {0, 0, 1, 0, 0}, {0, 1, 0, 1, 0}, {1, 0, 0, 0, 1}}
  for i = 0, stars.population do
    table.insert(stars, newStar())
  end
  buildings = {} --could be city...
  buildings.population = 10
  for i = 0, buildings.population do
    table.insert(buildings, newBuilding())
  end

  makeHero()
  makeEnemies()
end

function love.update(dt)
  world.time = world.time + dt
  if not world.pause then
    local remEnemy = {}
    local remShot = {}
    controlHero(dt)
    addMoreEnemies()
    -- Control Enemies
    for i,v in ipairs(enemies) do
      v.y = v.y + dt * v.speed
      v.x = v.x + math.sin(v.random*(world.time + v.random))
      if v.a < 255 then
        v.a = v.a + 50*dt
      end
      if v.a >= 255 and  bombs.probability < math.random() then
        makeBomb(v.x + v.width/2, v.y)
      end
      if v.y > (world.ground - v.height) then
        table.remove(enemies, i)
        if hero.protectedUntil < world.time then
          hero.lives = hero.lives - 1
          hero.protectedUntil = world.time + 2
        end
      end
    end
    -- Control Bombs
    for i,v in ipairs(bombs) do
      v.y = v.y + dt * 500
      if v.y > world.ground then
        table.remove(bombs, i)
      end
      if CheckCollision(v.x, v.y, 2, 5, hero.x, hero.y, hero.width, hero.height) then
        if hero.protectedUntil < world.time then
          hero.lives = hero.lives - 1
          hero.protectedUntil = world.time + 2
        end
      end
    end
    -- Control Shots
    for i,v in ipairs(hero.shots) do
      v.y = v.y - dt * 500
      if v.y == 0 then
        table.remove(hero.shots, i)
      end
      for ii, vv in ipairs(enemies) do
        if CheckCollision(v.x, v.y, 2, 5, vv.x, vv.y, vv.width, vv.height) then
          hero.score = hero.score + math.ceil(vv.y / 100)
          hero.ammo = hero.ammo + math.ceil(vv.y / 100)
          explosion = deepcopy(vv)
          explosion.sprite = vv.sprite1
          explosion.duration = world.time + 1
          table.insert(explosions, explosion)
          table.remove(enemies, ii)
          table.remove(hero.shots, i)
        end
        if vv.x < 0 then
          vv.x = vv.x + world.width
        end
        if vv.x > world.width then
          vv.x = vv.x - world.width
        end
      end
    end
    for h, explosion in ipairs(explosions) do
      if explosion.duration < world.time then
        table.remove(explosions, h)
      else
        explosion.height = explosion.height - 1
        explosion.width = explosion.width - 1
      end
    end
    if hero.lives < 1 then
      world.pause = true
    end
    if math.mod(hero.score, 20) == 0 and hero.score > 19 then
      enemies.speed = enemies.speed + 0.5
    end
    if math.mod(hero.score, 50) == 0 and hero.score > 19 then
      world.numberOfEnemies = world.numberOfEnemies + 1
    end
  end
end

function love.draw()
  -- The Sky
  for i = 0, 600 do
    love.graphics.setColor(20 + 2 * i, 15 + 2 * i, i*10, 255) -- ehh
    love.graphics.rectangle("fill", 0, i*20, world.width, 20)
  end
  -- The Ground
  for i = 0, 40 do
    love.graphics.setColor(100, 255 - i * 20, 60 , 255) -- ehh
    love.graphics.rectangle("fill", 0, world.ground + i*20, world.width, 20)
  end
  -- The Stars
  for i, star in ipairs(stars) do
    love.graphics.setColor(255, 255, 0, 255 - star.y * 255/465)
    drawSprite(star, stars.sprite)
  end
  -- The City
  for i, building in ipairs(buildings) do
    love.graphics.setColor(building.random, building.random, building.random, 255)
    love.graphics.rectangle("fill", building.x, building.y, building.width, building.height)

  end
  -- The Hero
  if hero.protectedUntil > world.time then
    explodeSprite(hero, hero.sprite)
  else
    love.graphics.setColor(255, 255, 0, 255)
    drawSprite(hero, hero.sprite)
  end
  love.graphics.setColor(255, 255, 0, 255)
  for i = 1, hero.lives do
    local tempHero = deepcopy(hero)
    tempHero.x = world.width - i * 2.5 * world.tab
    tempHero.y = world.tab
    drawSprite(tempHero, tempHero.sprite)
    i = i + 1
  end
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(scoreFont)
  love.graphics.printf("SCORE " .. hero.score, world.tab, world.tab, world.width, 'left')
  love.graphics.printf("AMMO  " .. hero.ammo, world.tab, 2 * world.tab, world.width, 'left')
  -- The Enemies
  for i, v in ipairs(enemies) do
    love.graphics.setColor(v.r, v.g, v.b, v.a)
    if math.floor((world.time + v.random) * 3) % 2 == 0 then
      drawSprite(v, v.sprite2)
    else
      drawSprite(v, v.sprite1)
    end
  end
  -- The Explosions
  for h, explosion in ipairs(explosions) do
    explodeSprite(explosion, explosion.sprite)
  end
  -- The Bullets
  love.graphics.setColor(255, 255, 255, 255)
  for i,v in ipairs(hero.shots) do
    love.graphics.rectangle("fill", v.x - hero.width / 2 + 3, v.y, 2, 5)
    love.graphics.rectangle("fill", v.x - 2 - hero.width / 2 + 3, v.y + 5, 6, 2) -- drawing bullets here is trivial / easier
  end
  -- The Bombs
  love.graphics.setColor(255, 255, 255, 255)
  for i,v in ipairs(bombs) do
    love.graphics.rectangle("fill", v.x - hero.width / 2 + 3, v.y + 5, 2, 6)
    love.graphics.rectangle("fill", v.x - 2 - hero.width / 2 + 3, v.y, 6, 2) -- drawing bullets here is trivial / easier
  end
  if world.pause then
    if hero.lives == 0 then
      love.graphics.setFont(titleFont)
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf("GAME OVER", 0, 100, world.width, 'center')
      love.graphics.setFont(bodyFont)
      love.graphics.printf("Press r to Lose Again", 0, 400, world.width, 'center')
    else
      love.graphics.setFont(titleFont)
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf("INVADERS MUST DIE", 0, 100, world.width, 'center')
      love.graphics.setFont(bodyFont)
      love.graphics.printf("Press r to Lose Eventually", 0, 400, world.width, 'center')
    end
  end
end
