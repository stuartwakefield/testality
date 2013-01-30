require "./testality/server"
require "./testality/watcher"
require "./testality/resources"
require "./testality/websocket"

files = ["../test/scripts/**/*.js"]
port = 9191

resources = Testality::Resources.new files
websocket = Testality::WebSocket.new
server = Testality::Server.new port, resources, websocket
watcher = Testality::Watcher.new resources, server

websocketThread = Thread.fork websocket do |ws|
	ws.start
end

watcherThread = Thread.fork watcher do |w|
	w.start 
end

serverThread = Thread.fork server do |s|
	s.start
end

watcherThread.join
serverThread.join
websocketThread.join
