require "json"

module Testality
	
	class Request
		
		def initialize(socket)
			
			@socket = socket
			
			# Get the request information (parse HTTP, perhaps there is a library
			# that exists to do this already...)
			request = socket.gets
			request.strip!
			
			regexp = /^(\w+)\s(.+)\s(.+)$/
			@verb = request[regexp, 1]
			@uri = request[regexp, 2]
			split = @uri.index("?")
			
			@path = @uri
			@querystring = ""
			@get = {}
			
			if split != nil
				
				if split == 1
					@path = @uri[0]
				else
					@path = @uri[0..(split - 1)]
				end
				
				@querystring = @uri[(split + 1)..(@uri.length - 1)]
				
				# Will not handle params without a value
				@querystring.lines("&") do |line|
					index = line.index("=")
					param = line[0..(index - 1)]
					value = line[(index + 1)..(line.length - 1)]
					@get[param] = value
				end
				
			end
			# protocol = request[regexp, 3]

			# Parse headers
			headers = {}
			loop do 
				line = socket.gets
				if line.index("\r\n") == 0
					break
				end
				index = line.index(":")
				param = line[0..(index - 1)]
				value = line[index + 1..(line.length - 1)]
				param.strip!
				value.strip!
				headers[param] = value
			end
			@headers = headers
			
			# Parse body
			@body = nil
			if headers["Content-Length"]
				length = Integer(headers["Content-Length"])
				body = socket.read length
				
				# The response is json
				if headers["Content-Type"].index("application/json") != nil
					body = JSON.parse(body)
				end
				
				@body = body
			end
			
		end
		
		def has_body
			@body != nil
		end
		
		def get_body
			@body
		end
		
		def get_headers
			@headers
		end
				
		def on(verb, path)
			if @verb == verb and @path == path
				yield(self)
			end
		end
				
		def get_socket
			@socket
		end
		
	end
	
end