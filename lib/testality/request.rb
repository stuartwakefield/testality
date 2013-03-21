require "json"

module Testality
	
	class Request
		
		def initialize(socket)

			puts "New request"
		
			@socket = socket
		
			puts "Parsing request"

			@request = parse_request @socket

			puts "Parsing headers"

			# Parse headers
			@headers = parse_headers @socket
			
			puts "Parsing body"

			# Parse body
			@body = parse_body @headers, @socket

			puts "Parsed"

		end
		
		def parse_request(socket)
			# Get the request information (parse HTTP, perhaps there is a library
			# that exists to do this already...)
			str = socket.gets
			str.strip!
			
			req = {}
			
			regexp = /^(\w+)\s(.+)\s(.+)$/
			req[:verb] = str[regexp, 1]
			req[:uri] = str[regexp, 2]
			req[:path] = parse_path(req[:uri])	
			req[:querystring] = parse_querystring(req[:uri])
			req[:get] = parse_querystring_params(req[:querystring])
			# protocol = request[regexp, 3]
			return req
		end
		
		def parse_path(uri)
			path = uri
			split = uri.index("?")
			if split != nil
				if split == 1
					path = uri[0]
				else
					path = uri[0..(split - 1)]
				end
			end
			return path
		end
		
		def parse_querystring(uri)
			qs = ""
			split = uri.index("?")
			if split != nil				
				qs = uri[(split + 1)..(uri.length - 1)]
			end
			return qs
		end
		
		def parse_querystring_params(querystring)	
			map = {}

			puts querystring

			querystring.lines("&") do |line|
				
				puts "Parsing parameter pair"

				# Will not handle params without a value
				index = line.index("=")
				param = line[0..(index - 1)]
				value = line[(index + 1)..(line.length - 1)]
				map[param] = value
			end
			return map
		end
		
		def parse_headers(socket)
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
			return headers
		end
		
		def parse_body(headers, socket)
			body = nil
			if headers["Content-Length"]
				length = Integer(headers["Content-Length"])
				body = socket.read length
				
				# The response is json
				if headers["Content-Type"].index("application/json") != nil
					puts "Parsing json"
					body = JSON.parse(body)
				end
			end
			return body
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
			if @request[:verb] == verb and @request[:path] == path
				yield(self)
			end
		end
				
		def get_socket
			@socket
		end
		
	end
	
end
