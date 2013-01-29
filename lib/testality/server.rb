require "socket"

module Testality
	
	class Server
		
		def initialize(port, resources)
			@resources = resources
			@lastupdate = nil
			@port = port
		end
		
		def start
			# Start up the server
			server = TCPServer.new @port
			loop do
				
				# Don't block the server, allow multiple clients
				Thread.fork(server.accept) do |client|
					
					# Get the request information
					request = client.gets
					
					regexp = /^(\w+)\s(.+)\s(.+)$/
					request_verb = request[regexp, 1].downcase
					request_uri = request[regexp, 2]
					request_protocol = request[regexp, 3]
					
					handle(client, request_verb, request_uri)
				end
			end
		end
		
		def handle(client, verb, uri)
			# Send the tests to the client
			if verb == "get" and uri == "/"
				
				puts "The test client is requesting the test"
				
				# Create the response
				response = "<!DOCTYPE html>" +
					"<html>" +
					"<head>" +
					"<script src=\"http://code.jquery.com/jquery-1.9.0.min.js\"></script>" + 
					"<script>#{@resources.get}</script>" +
					"<script>(function() {" +
						"var poll;" +
						"(poll = function() {" + 
							"$.ajax({" +
								"url:\"/subscribe\"," +
								"type: \"get\"," +
								"dataType: \"json\"," +
								"success: function(result) {" + 
									"if(result.updates) {" + 
										"window.location = \"/\";" +
									"} else {" + 
										"poll();" + 
									"}" +
								"}" +
							"});" +
						"})();" +
					"})();</script>" +
					"</head>" +
					"</html>"
					
				respond client, "200 OK", "text/html", response
			end
			
			# We have a long-poll test subscriber
			if verb == "get" and uri == "/subscribe"
				
				puts "The test client is polling for updates"
				
				timeout = Time.now + 30
				time = Time.now
				begin 
					sleep(0.1)
					puts "Checking from: " << time.to_s
					if @lastupdate != nil
						puts "Last:" << @lastupdate.to_s
					end
				end while Time.now < timeout and @lastupdate == nil or @lastupdate < time
				if @lastupdate > time
					respond client, "200 OK", "application/json", "{\"updates\":true}"
				else
					respond client, "200 OK", "application/json", "{\"updates\":false}"
				end
			end
			
			# Receive the test results from the client
			if verb == "post" and uri == "/"
										
				puts "The test client has posted results"
				
				# Our test is responding
				respond client, "200 OK", "application/json", "{\"success\":true}"
			end
			
		end
		
		def update
			@lastupdate = Time.now
		end
		
		def respond(client, status)
			respond(status, nil, nil)
		end
		
		def respond(client, status, mimetype, content)
			
			response = "HTTP/1.1 #{status}\r\n"
			
			if mimetype and content
				response = response +
					"Connection: close\r\n" +
					"Content-Type: #{mimetype}\r\n" +
					"Content-Length: #{content.length.to_s()}\r\n" +
					"\r\n#{content}"
			end
			
			puts response
			
			client.puts response
			
			# Release the client
			client.close
		end
		
	end
	
end