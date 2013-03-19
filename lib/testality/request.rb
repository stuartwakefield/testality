require "json"

module Testality
	
	class Request
		
		def initialize(socket)
			
			@socket = socket
			
			@request = parse_request(socket)

			# Parse headers
			@headers = parse_headers(socket)
			
			# Parse body
			@body = parse_body(headers, socket)
			
			
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
			split = req[:uri].index("?")
			
			req[:path] = req[:uri]
			req[:querystring] = ""
			req[:get] = {}
			
			if split != nil
				
				if split == 1
					req[:path] = req[:uri][0]
				else
					req[:path] = req[:uri][0..(split - 1)]
				end
				
				req[:querystring] = req[:uri][(split + 1)..(req[:uri].length - 1)]
				
				# Will not handle params without a value
				req[:querystring].lines("&") do |line|
					index = line.index("=")
					param = line[0..(index - 1)]
					value = line[(index + 1)..(line.length - 1)]
					req[:get][param] = value
				end
				
			end
			# protocol = request[regexp, 3]
			return req
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
