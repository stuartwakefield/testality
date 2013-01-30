require "em-websocket"
require "json"

module Testality
	
	class WebSocket
		
		def initialize
			@clients = []
			@results = {}
		end
		
		def start
			
			EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 9292) do |ws|
				
				ws.onopen do 
					puts "New WebSocket client!"
					@clients.push(ws)
					send_results ws, @results
				end
				
				ws.onclose do
					@clients.delete(ws)
					puts "WebSocket closed!"
				end
				
			end
			
		end
		
		def send_results(client, results)
			puts "Sending result to client"
			client.send JSON.pretty_generate(results) 
		end
		
		def update(results)
			
			puts "Sending results to clients"
			@results = results
		#	puts @results
			
			if @clients.length
				for client in @clients
					send_results client, results
				end
			end
			
		end
		
	end
	
end