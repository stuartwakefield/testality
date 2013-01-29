require "./testality/server"
require "./testality/watcher"
require "./testality/resources"

files = ["../test/scripts/**/*.js"]
port = 9191

resources = Testality::Resources.new files

server = Testality::Server.new port, resources
serverThread = Thread.fork server do |s|
	s.start
end

watcherThread = Thread.fork server, resources do |s, r|
	watcher = Testality::Watcher.new r, s
end

watcherThread.join
serverThread.join
