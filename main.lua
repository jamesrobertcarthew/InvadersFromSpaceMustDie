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
          love.graphics.setColor(255, 255 * math.random(), 100 * math.random(), 255)
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
  hero.lifecost = 10
  hero.ammocost = 5
  hero.sineGunCost = 25
  hero.sprite = {{0, 0, 0, 0, 1, 0, 0, 0, 0}, {0, 0, 0, 1, 1, 1, 0, 0, 0}, {1, 1, 1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1, 1}}
  hero.spriteDims = {9, 5}
  hero.sineGun = 0
  hero.afk = false
end

function makeEnemies() -- I try not to
  for i = 0, world.numberOfEnemies - tablelength(enemies) do
    enemy = {}
    enemy.random = math.random()
    enemy.x = world.width * math.random()
    enemy.y = 0
    enemy.speed = enemies.speed
    enemy.r = math.random() * 255
    enemy.g = math.random() * 255
    enemy.b = math.random() * 255
    if enemy.r < enemy.g then
      if enemy.g < enemy.b then
        enemy.g = 255
      else
        enemy.r = 255
      end
    elseif enemy.b > enemy.r then
      enemy.b = 255
    end
    enemy.a = 0
    local dice = math.random()
    if dice < 0.33 then
      -- my favourite guy
      enemy.sprite1 = {{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0}, {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0}, {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0}, {0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1}, {1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1}, {0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0}}
      enemy.sprite2 = {{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0}, {1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1}, {1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1}, {1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0}, {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0}, {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0}}
      enemy.width = 44
      enemy.height = 32
      enemy.spriteDims = {11, 8}
    elseif dice > 0.66 then
      -- skull man
      enemy.sprite1 = {{0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0}, {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0}, {0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0}, {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1}}
      enemy.sprite2 = {{0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0}, {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0}, {0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0}, {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0}}
      enemy.width = 48
      enemy.height = 32
      enemy.spriteDims = {12, 8}
    elseif dice < 0.66 then
      -- squid man
      enemy.sprite1 = {{0, 0, 0, 1, 1, 0, 0, 0}, {0, 0, 1, 1, 1 ,1, 0, 0}, {0, 1, 1, 1, 1, 1, 1, 0}, {1, 1, 0, 1, 1, 0, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1}, {0, 1, 0, 1, 1, 0, 1, 0}, {1, 0, 0, 0, 0, 0, 0, 1}, {0, 1, 0, 0, 0, 0, 1, 0}}
      enemy.sprite2 = {{0, 0, 0, 1, 1, 0, 0, 0}, {0, 0, 1, 1, 1 ,1, 0, 0}, {0, 1, 1, 1, 1, 1, 1, 0}, {1, 1, 0, 1, 1, 0, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1}, {0, 0, 1, 0, 0, 1, 0, 0}, {0, 1, 0, 1, 1, 0, 1, 0}, {1, 0, 1, 0, 0, 1, 0, 1}}
      enemy.width = 32
      enemy.height = 32
      enemy.spriteDims = {8, 8}
    end
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
    if hero.sineGun > 0 then
      hero.sineGun = hero.sineGun - 1
      local shot = {}
      shot.x = hero.x + hero.width
      shot.y = hero.y + 5
      table.insert(hero.shots, shot)
      local shot = {}
      shot.x = hero.x
      shot.y = hero.y + 5
      table.insert(hero.shots, shot)
    end

  end
end

function love.keyreleased(key)
  if key == " " then
      shoot()
  end
  if key == "h" and world.pause then
    hero = {}
    enemies = {}
    enemies.speed = 30
    explosions = {}
    bombs = {}
    bombs.probability = 0.995
    world.pause = false
    world.time = 0
    world.populationLatch = 5
    world.speedLatch = 10
    world.numberOfEnemies = 6
    makeHero()
    makeEnemies()
    boss.lifeThreshold = 5
    hero.sineGunCost = 25
  end
  if key == "e" and world.pause then
    hero = {}
    enemies = {}
    enemies.speed = 20
    explosions = {}
    bombs = {}
    bombs.probability = 0.997
    world.pause = false
    world.time = 0
    world.populationLatch = 6
    world.speedLatch = 12
    world.numberOfEnemies = 5
    makeHero()
    makeEnemies()
    hero.ammo = hero.ammo + 10
    hero.ammocost = 3
    boss.lifeThreshold = 6
    hero.sineGunCost = 20

  end
  if key == "p" then
    world.pause = not world.pause
    hero.afk = not hero.afk
  end
  if not world.pause then
    if key == "1" then
      if hero.score >= hero.ammocost then
        hero.ammo = hero.ammo + 10
        hero.score = hero.score - hero.ammocost
        world.ammoprompt = false
      end
    end
    if key == "2" then
      if hero.score >= hero.lifecost then
        hero.lives = hero.lives + 1
        hero.score = hero.score - hero.lifecost
        world.lifeprompt = false
	hero.lifecost = hero.lifecost + 1
      end
    end
    if key == "3" then
      if hero.score >= hero.sineGunCost then
        hero.sineGun = hero.sineGun + 10
        hero.ammo = hero.ammo + 10
        hero.score = hero.score - hero.sineGunCost
      end
    end
    if key == "4" then -- speed increase
      if hero.score > hero.sineGunCost and hero.speed < 500 then
        hero.speed = hero.speed * 1.5
        hero.score = hero.score - hero.sineGunCost
      end
    end
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
  building.height = math.random(50, 300)
  building.width = math.random(50, 150)
  building.x = math.random(0, 800)
  building.y = world.ground - building.height
  building.random = math.random(50, 100)
  return building
end

function love.load()
  math.randomseed(os.time())
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
  boss = {}
  boss.lifeThreshold = 5
  boss.sprite = {{0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0}, {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0}, {0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1,0, 0 }, {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0}}
  boss.spriteDims = {16, 7}
  boss.width = 64
  boss.height = 28
  boss.active = false
  boss.x = -40
  boss.y = 100
  boss.travelled = 0
  boss.interval = 0
  boss.speed = 0
  boss.lasttime = 0
  world.width, world.height, world.flags = love.window.getMode()
  world.ground = 465
  world.tab = 20
  world.time = 0
  world.pause = true
  world.populationLatch = 5
  world.speedLatch = 10
  world.numberOfEnemies = 6
  bombs.probability = 0.995
  world.ammoprompt = true
  world.lifeprompt = true
  world.animTime = 0
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
  enemies.speed = 30
  makeHero()
  makeEnemies()
end

function love.update(dt)
  world.animTime = world.animTime + dt
  if not world.pause then
    world.time = world.time + dt
  end
  if not world.pause then
    if boss.active then
      boss.x = boss.x + dt * (hero.speed + 5)
      boss.y = boss.y + math.sin(world.time)
      if boss.x > boss.interval then
        makeBomb(boss.x + boss.width/4, boss.y)
        boss.interval = boss.x + 50
      end
    end

    if boss.x > world.width + boss.width then
      boss.active = false
      boss.x = -50
      boss.interval = 0
    end
    if hero.lives > 5 and boss.lasttime < (world.time -30) then
      boss.active = true
      boss.lasttime = world.time
    end

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
        local explosion = deepcopy(v)
        explosion.sprite = v.sprite1
        explosion.duration = world.time + 0.5
        table.insert(explosions, explosion)
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
        local bang = newStar()
        bang.x = v.x
        bang.y = v.y
        explosion = deepcopy(bang)
        explosion.sprite = stars.sprite
        explosion.duration = world.time + 0.2
        table.insert(explosions, explosion)
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
      if hero.sineGun > 0 then
        v.x = v.x + 10 * math.sin(world.time * 100)
      end
      if v.y == 0 then
        table.remove(hero.shots, i)
      end
      for ii, vv in ipairs(enemies) do
        if CheckCollision(v.x, v.y, 2, 5, vv.x, vv.y, vv.width, vv.height) then
          hero.score = hero.score + math.ceil(vv.y / 100)
          -- hero.ammo = hero.ammo + math.ceil(vv.y / 100)
          explosion = deepcopy(vv)
          explosion.sprite = vv.sprite1
          explosion.duration = world.time + 0.5
          table.insert(explosions, explosion)
          table.remove(enemies, ii)
          table.remove(hero.shots, i)
        end

      if CheckCollision(v.x, v.y, 2, 5, boss.x, boss.y, boss.width, boss.height) then
        explosion = deepcopy(boss)
        explosion.duration = world.time + 0.5
        table.insert(explosions, explosion)
        table.remove(hero.shots, i)
        hero.score = hero.score + 2
        boss.active = false
        boss.x = -50
        boss.travelled = 0
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
        if explosion.y > world.ground - 50 then
          explosion.height = explosion.height + 1
          explosion.width = explosion.width + 50
        else
          explosion.height = explosion.height - 1
          explosion.width = explosion.width - 1
        end
      end
    end
    if hero.ammo == 0 and hero.score < 5 then
      hero.score = hero.score + dt
    end
    if hero.lives < 1 then
      world.pause = true
    end
    -- Increase Difficulty
    if math.floor(hero.score) > world.populationLatch then
        if world.numberOfEnemies < 30 then
          world.numberOfEnemies = world.numberOfEnemies + 1 -- Increase numbers
          world.populationLatch = hero.score + 15
        end
      end
  end
  if math.floor(hero.score) > world.speedLatch and enemies.speed < 60 then
    if world.speedLatch < 45 then
      enemies.speed = enemies.speed + 1
    else
      enemies.speed = enemies.speed + 5
    end
    world.speedLatch = hero.score + 5
  end
end

function love.draw()
  -- The Sky
  for i = 0, 600 do
    love.graphics.setColor(20 + 2 * i, 15 + 2 * i, i*10, 255) -- ehh
    love.graphics.rectangle("fill", 0, i*20, world.width, 20)
  end
  for j, exp in ipairs(explosions) do
    if exp.duration > world.time and exp.y > world.ground - 50 then
      for i = 0, 600 do
        love.graphics.setColor(255 * (exp.duration - world.time + 0.5), 255 * (exp.duration - world.time + 0.5), 0, 255 * (exp.duration - world.time)) -- ehh
        love.graphics.rectangle("fill", 0, i*20, world.width, 20)
      end
    end
  end
  -- The Ground
  for i = 0, 40 do
    love.graphics.setColor(100, 255 - i * 20, 60 , 255) -- ehh
    love.graphics.rectangle("fill", 0, world.ground + i*20, world.width, 20)
  end
  -- The Stars
  for i, star in ipairs(stars) do
    love.graphics.setColor(255, 255, 0, 255 - star.y * (255/465 * math.sin(world.animTime + star.x)))
    drawSprite(star, stars.sprite)
  end
  -- The Store Menu
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(scoreFont)
  love.graphics.printf("Press 1 for 10 ", world.tab + world.tab, world.ground + world.tab, world.width, 'left')
  love.graphics.printf("COST "..hero.ammocost .." POINTS ", world.tab + world.tab * 20, world.ground + world.tab, world.width, 'left')
  love.graphics.rectangle("fill", world.tab + 16 * world.tab - hero.width / 2 + 3, world.ground + world.tab, 2, 5)
  love.graphics.rectangle("fill", world.tab + 16 * world.tab - 2 - hero.width / 2 + 3, world.ground + world.tab + 5, 6, 2) -- drawing bullets here is trivial / easier
  love.graphics.printf("Press 2 for 1", world.tab + world.tab, world.ground + world.tab * 2, world.width, 'left')
  love.graphics.printf("COST "..hero.lifecost .." POINTS", world.tab + world.tab* 20, world.ground + world.tab * 2, world.width, 'left')

  love.graphics.printf("Press 3 for 10 ", world.tab + world.tab, world.ground + world.tab * 3, world.width, 'left')
  love.graphics.printf("COST "..hero.sineGunCost .." POINTS ", world.tab + world.tab * 20, world.ground + world.tab * 3, world.width, 'left')

  love.graphics.rectangle("fill", world.tab + 16 * world.tab - hero.width / 2 + 3, world.ground + world.tab * 3, 2, 5)
  love.graphics.rectangle("fill", world.tab + 16 * world.tab - 2 - hero.width / 2 + 3, world.ground + world.tab * 3 + 5, 6, 2) -- drawing bullets here is trivial / easier

  love.graphics.rectangle("fill", world.tab + -hero.width / 2 + 16 * world.tab - hero.width / 2 + 3, 5 + world.ground + world.tab * 3, 2, 5)
  love.graphics.rectangle("fill", world.tab + -hero.width / 2 + 16 * world.tab - 2 - hero.width / 2 + 3, 5 + world.ground + world.tab * 3 + 5, 6, 2) -- drawing bullets here is trivial / easier

  love.graphics.rectangle("fill", world.tab + hero.width / 2 + 16 * world.tab - hero.width / 2 + 3, 5 + world.ground + world.tab * 3, 2, 5)
  love.graphics.rectangle("fill", world.tab + hero.width / 2 + 16 * world.tab - 2 - hero.width / 2 + 3, 5 + world.ground + world.tab * 3 + 5, 6, 2) -- drawing bullets here is trivial / easier

  love.graphics.printf("Press 4 for UP SPEED", world.tab + world.tab, world.ground + world.tab * 4, world.width, 'left')
  love.graphics.printf("COST "..hero.sineGunCost .." POINTS ", world.tab + world.tab * 20, world.ground + world.tab * 4, world.width, 'left')

  local tempHero = deepcopy(hero)
  tempHero.x = world.tab* 15 + world.tab + 2
  tempHero.y = world.ground + world.tab * 2 + 2
  love.graphics.setColor(255, 0, 0, 255)
  drawSprite(tempHero, tempHero.sprite)

  -- The City
  for i, building in ipairs(buildings) do
    love.graphics.setColor(building.random, building.random, building.random, 255)
    love.graphics.rectangle("fill", building.x, building.y, building.width, building.height)
    love.graphics.setColor(building.random - 20, building.random - 20, building.random - 20, 255)
    love.graphics.rectangle("fill", building.x, building.y, building.width/2, building.height)
    love.graphics.setColor(255, 255, 0, 255)
  end
  -- The Hero
  if hero.protectedUntil > world.time then
    explodeSprite(hero, hero.sprite)
  else
    love.graphics.setColor(255, 0, 0, 255)
    drawSprite(hero, hero.sprite)
  end
  love.graphics.setColor(255, 0, 0, 255)
  for i = 1, hero.lives do
    local tempHero = deepcopy(hero)
    tempHero.x = world.width - i * 2.5 * world.tab
    tempHero.y = world.tab
    drawSprite(tempHero, tempHero.sprite)
    i = i + 1
  end
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(scoreFont)
  love.graphics.printf("SCORE " .. math.floor(hero.score), world.tab, world.tab, world.width, 'left')
  love.graphics.printf("AMMO  " .. hero.ammo, world.tab, 2 * world.tab, world.width, 'left')
  love.graphics.printf("TIME  " .. math.floor(world.time), world.tab, 3 * world.tab, world.width, 'left')
  -- The Enemies
  for i, v in ipairs(enemies) do
    love.graphics.setColor(v.r, v.g, v.b, v.a)
    if not world.pause then
      if math.floor((world.time + v.random) * 3) % 2 == 0 then
        drawSprite(v, v.sprite2)
      else
        drawSprite(v, v.sprite1)
      end
    else
      if math.floor(v.random * 3) % 2 == 0 then
        drawSprite(v, v.sprite2)
      else
        drawSprite(v, v.sprite1)
      end
    end
  end
  if boss.active then
    -- The boss
    local randomBossR = math.random() * 255
    local randomBossG = randomBossR + 128
    local randomBossB = randomBossR - 128
    love.graphics.setColor(randomBossR, randomBossG, randomBossB, 255)
    drawSprite(boss, boss.sprite)
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
    love.graphics.rectangle("fill", v.x - hero.width / 2 + 3, v.y + 4, 2, 6)
    love.graphics.rectangle("fill", v.x - 2 - hero.width / 2 + 3, v.y + 2, 6, 2) -- drawing bullets here is trivial / easier
  end

  if not world.pause and world.ammoprompt and hero.ammo <= 0 then
    love.graphics.setFont(bodyFont)
    love.graphics.printf("Press 1 for Ammo", 0, 290, world.width, 'center')
  end
  if not world.pause and world.lifeprompt and hero.lives == 2 and not world.ammoprompt then
    love.graphics.setFont(bodyFont)
    love.graphics.printf("Press 2 for life", 0, 290, world.width, 'center')
  end

  if world.pause and not hero.afk then
    if hero.lives == 0 then
      love.graphics.setFont(titleFont)
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf("GAME OVER", 0, 100, world.width, 'center')
      love.graphics.setFont(bodyFont)
      -- The Unnecessary Fire
      for f = 0, 100 do
        local flamesprite = deepcopy(hero)
        flamesprite.y = world.ground - flamesprite.height + 6
        flamesprite.x = (f * world.width )/100
        explodeSprite(flamesprite, flamesprite.sprite)
      end
      love.graphics.setColor(255, 255, 255, 255)
      if hero.ammo == 0 then
        love.graphics.printf("\nDID You remember to buy enough ammo \n\nHard H\nEasy E", 0, 290, world.width, 'center')
      else
        love.graphics.printf("\ndid you buy enough tanks \n\nHard H\nEasy E", 0, 290, world.width, 'center')
      end
    else
      love.graphics.setFont(titleFont)
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.printf("INVADERS MUST DIE", 0, 100, world.width, 'center')
      love.graphics.setFont(bodyFont)
      love.graphics.printf("In SPACE because IF they hit \nthe ground then you will \ndie and that would be lame\n\nHard H\nEasy E", 0, 290, world.width, 'center')
    end
  end
end
