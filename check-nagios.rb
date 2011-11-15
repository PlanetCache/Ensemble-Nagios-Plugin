#!/usr/bin/ruby
# 2010 Ron Sweeney, Health Neutral
# Ensemble Nagios Plug In

# requirements:
#  ruby
#  Enslib.TCP.StatusService instance running in a target Ensemble
#  production.


require 'socket'


# set debug flag
if ARGV.last == "-debug"
  ARGV.pop
  debug = true
end

# check input
if !(ARGV.size == 3)
  puts "Usage: #{$0} CONFIGITEM HOST PORT [-debug]"
  exit 1
end

# connect to Enslib.TCP.StatusService
s = TCPSocket.open(ARGV[1],ARGV[2])

s.puts "configitemstatus #{ARGV[0]}"

# get the response
# example: "1 job listening | Inactive | found a job with status = 'running'\n"
response = s.gets

#close the socket.
s.close

# check for error
if !(response =~ /running/)
   puts response if debug
   print "#{ARGV[0]} Down"
   exit 2
end

# check for success
if (response =~ /running/)
   puts response if debug
   print "#{ARGV[0]} Running"
   exit 0
# no idea what happened

else
    print "Script failure"
    exit 3
end

