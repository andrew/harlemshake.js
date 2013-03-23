exec = require('child_process').exec
Drone = require './drone'

delay = (ms, func) -> setTimeout func, ms

testflight = (drone) ->
  drone.takeoff()
  console.log 'takeoff'
  delay 6000, ->
    drone.land()
    console.log 'landed'

danceMove = (drone, time, m, cb) ->
  i = 1
  console.log(i)
  timer = setInterval ->
    i += 1
    m(drone, i)
  , 1000
  setTimeout ->
    clearInterval(timer)
    cb()
  , time

genericMove = (drone, i, speed, move) ->
  if i%2 == 0
    direction = -1
  else
    direction = 1
  drone.stop()
  move(drone, speed*direction)

upDown = (drone, i) ->
  genericMove drone, i, 0.5, (i)->
    console.log drone.ip, 'upDown'
    drone.animateLeds('blinkOrange', 10,1)

leftRight = (drone, i) ->
  genericMove drone, i, 0.5, (i)->
    console.log drone.ip, 'leftRight'
    drone.animateLeds('blinkRed', 10,1)

twist = (drone, i) ->
  genericMove drone, i, 1, (i)->
    console.log drone.ip, 'twist'
    drone.animateLeds('blinkGreen', 10,1)

dance = (drone, m, wait) ->
  delay wait, ->
    # drone.takeoff()
    console.log drone.ip, 'takeoff'
    delay 4000, ->
      dancePeriod = 26000 - wait
      console.log drone.ip, 'dance'
      # (drone, time, m, cb)

      danceMove drone, dancePeriod, m, ->
        console.log drone.ip, 'finished dancing'

      delay dancePeriod, ->
        console.log drone.ip, 'land'
        # drone.stop()
        # drone.land()

firstIP= '192.168.1.18'
twists = ['192.168.1.19']
verticals = ['192.168.1.13']
horizontals = ['192.168.1.10']

start = ->
  firstDrone = new Drone(firstIP)
  dance(firstDrone, twist, 0)
  delay 4000, -> exec('open ~/Downloads/HarlemShake.mp3')
  for ip in twists
    drone = new Drone(ip)
    dance(drone, twist, 15000)
  for ip in verticals
    drone = new Drone(ip)
    dance(drone, upDown, 15000)
  for ip in horizontals
    drone = new Drone(ip)
    dance(drone, leftRight, 15000)

start()

