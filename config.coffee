execSync = require("execSync") # https://github.com/mgutz/execSync
net = require("net")
delay = (ms, func) -> setTimeout func, ms

configure = (droneSSIDName, droneIP) ->
  console.log droneSSIDName
  result = execSync.stdout("networksetup -setairportnetwork en0 " + droneSSIDName)
  console.log result

  sharedSSIDName = "poppy"
  subnet = "255.255.255.0"
  command = "killall udhcpd; iwconfig ath0 mode managed essid #{sharedSSIDName}; ifconfig ath0 #{droneIP} netmask #{subnet} up;"

  delay 2000, ->
    client = net.connect(host: '192.168.1.1', port: 23, -> 
      console.log droneSSIDName, 'connected'
      client.write "#{command}\r\n"
    )

    client.on "data", (data) ->
      console.log droneSSIDName, data.toString()
      client.end()

    client.on "end", ->
      console.log droneSSIDName, "client disconnected"
    delay 5000, ->
      client.destroy()

drones = {
  'forward': '192.168.1.10',
  '7digital': '192.168.1.11',
}

for drone, ip of drones
  configure(drone, ip)