require "socket"
require "testality/request"

module Testality
	
	class Server
		
		def initialize(port, resources, listener)
			@resources = resources
			@port = port
			@listener = listener
			@results = {}
		end
		
		def start
			
			puts "Server starting up on port #{@port}..."
			
			# Start up the server
			server = TCPServer.new "0.0.0.0", @port
			
			puts "Server started"
			
			loop do
				
				puts "Server accepting clients..."
				
				# Don't block the server, allow multiple clients
				Thread.fork(server.accept) do |client|
					port, ip = Socket.unpack_sockaddr_in(client.getpeername)
					
					puts "Client from IP " + ip + " accepted!"
					
					request = Request.new client
					
					# Handle request
					handle request
				end
			end
		end
		
		def update_after(time)
			not @last == nil and @last > time
		end
		
		def expand_path(path)
			File.expand_path("assets/harness.html", File.dirname(__FILE__))
		end
		
		def read_file(path)
			File.open(File.expand_path(path, File.dirname(__FILE__)), "r").read
		end
		
		def handle_main(request)
			puts "Requesting the test harness..."	
			resource = "assets/harness.html"	
			puts expand_path(resource)
			respond request.get_socket, "200 OK", "text/html", read_file(resource)	
			puts "Test harness sent"
		end
		
		def handle_test_harness(request) 
			puts "The test client is requesting the testality client script"
			respond request.get_socket, "200 OK", "text/javascript", read_file("assets/testality.js")	
		end
		
		def handle_test_source(request)
			puts "The test client is requesting the resource scripts"		
			response = @resources.get	
			respond request.get_socket, "200 OK", "text/javascript", response
		end
		
		def handle_listen(request)
			puts "The test client is polling for updates"
			timeout = Time.now + 30
			time = Time.now
			begin 
				sleep(0.1)
			end while Time.now < timeout and not update_after time
			puts "Sending response"
			if @last != nil and @last > time
				puts "There were updates"
				respond request.get_socket, "200 OK", "application/json", "{\"updates\":true}"
			else
				puts "No updates"
				respond request.get_socket, "200 OK", "application/json", "{\"updates\":false}"
			end
		end
		
		def handle_monitor(request)
			puts "The monitoring client is requesting the interface"
			respond request.get_socket, "200 OK", "text/html", read_file("assets/summary.html")	
		end
		
		def handle_results(request)
			puts "The test client has posted results"		
			@results[request.get_headers["User-Agent"]] = request.get_body	
			puts @results
			@listener.update @results	
			# Our test is responding
			respond request.get_socket, "200 OK", "application/json", "{\"success\":true}"
		end
		
		def handle(request)
			
			# Send the tests to the client
			request.on "GET", "/" do |req|
				handle_main req
			end
			
			request.on "GET", "/scripts/testality" do |req|
				handle_test_harness req
			end
				
			request.on "GET", "/scripts/resource" do |req|
				handle_test_source req
			end
					
			request.on "GET", "/listen" do |req|
				handle_listen req
			end
			
			request.on "GET", "/monitor" do |req|
				handle_monitor req
			end
			
			request.on "POST", "/" do |req|
				handle_results req
			end
			
		end
		
		def update
			@last = Time.now
			@results = {}
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
			
			client.puts response
			
			# Release the client
			client.close
		end
		
	end
	
end
