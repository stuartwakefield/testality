require "testality/server"
require "testality/watcher"
require "testality/resources"
require "testality/websocket"

require "testality/headers"

module Testality

	class Serve
	
		def initialize(port, mport, srcs)

			headers = Testality::Headers.new "something"
			print headers.name

#			resources = Testality::Resources.new srcs
#			websocket = Testality::WebSocket.new mport
#			server = Testality::Server.new port, resources, websocket
#			watcher = Testality::Watcher.new resources, server

#			websocketThread = Thread.fork websocket do |ws|
#				ws.start
#			end

#			watcherThread = Thread.fork watcher do |w|
#				w.start 
#			end

#			serverThread = Thread.fork server do |s|
#				s.start
#			end

#			watcherThread.join
#			serverThread.join
#			websocketThread.join
			
		end
	
	end

end
