require 'net/ping'
require 'net/telnet'
require 'colorize'

def configure(droneSSIDName, droneIP)
  puts droneSSIDName
  begin
    `networksetup -setairportnetwork en0 #{droneSSIDName}`
    puts "  connected to: #{droneSSIDName}"
    sleep(5)
  rescue => e
    puts "  cannot connect to #{droneSSIDName}: #{e}"
    return false
  end

  sharedSSIDName = "poppy"
  subnet = "255.255.255.0"
  command = "killall udhcpd; iwconfig ath0 mode managed essid #{sharedSSIDName}; ifconfig ath0 #{droneIP} netmask #{subnet} up;"
  
  begin
    puts "  telnetting"
    session = Net::Telnet::new({"Host" => '192.168.1.1', "Waittime" => 30, "Timeout" => 30})
    res = session.cmd(command)
    puts res
  rescue => e
    puts "  telnet error: #{e}"
  end
  puts "\n"
end

def check(droneSSIDName, droneIP)
  res = `ping -q -c 1 -t 1 #{droneIP}`
  available = (res =~ /100.0% packet loss/).nil?
  puts "#{droneSSIDName}: #{available}"
end

drones = {
  'forward' => '192.168.1.10',
  # '7digital' => '192.168.1.11',
  # 'mongodb' => '192.168.1.12',
  'clock' => '192.168.1.13',
  # 'bizzby' => '192.168.1.14',
  # 'andrew' => '192.168.1.15',
  # 'maplebird' => '192.168.1.16',
  # 'holidayextras' => '192.168.1.17',
  'mark'=> '192.168.1.18',
  'eventhandler'=> '192.168.1.19',
  #'5apps'=> '192.168.1.20',
}

# drones.each{|k,v| configure(k,v)}
# `networksetup -setairportnetwork en0 poppy`
drones.each{|k,v| check(k,v)}

# `coffee flash.coffee`

