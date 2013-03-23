arDrone = require("ar-drone")

class Drone
  constructor: (ip) ->
    @speed = 0.5
    @accel = 0.01
    @control = arDrone.createUdpControl(ip: ip)
    @client = arDrone.createClient(ip: ip)
    @ref = {}
    @pcmd = {}
    @rate = 30
    @ip = ip
    setInterval (=>
      @control.ref @ref
      @control.pcmd @pcmd
      @control.flush()
    ), @rate

  takeoff: =>
    @ref.emergency = false
    @ref.fly = true

  land: =>
    @ref.fly = false
    @pcmd = {}

  stop: =>
    @pcmd = {}

  clockwise: =>
    @pcmd.clockwise = @speed;

  up: =>
    @pcmd.up = @speed;

  left: =>
    @pcmd.left = @speed;

  animateLeds: (name, hz, duration)=>
    @client.animateLeds(name, hz, duration)

  move: (directions, reset = true) =>
    # console.log reset
    @pcmd = {} if reset
    for direction, speed of directions
      s = speed || @speed
      @pcmd[direction] = parseFloat(s)

  increaseSpeed: (accel) =>
    @speed += accel || @accel

  decreaseSpeed: (accel) =>
    @speed -= accel || @accel

  setSpeed: (speed) =>
    @speed = speed

module.exports = Drone