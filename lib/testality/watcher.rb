require "digest"

module Testality
	
	class Watcher
		
		def initialize(resources, listener)
			@resources = resources
			@listener = listener
			@last = resources.hash
		end
		
		def start
			loop do
				hash = @resources.hash
				if @last == nil or @last != hash
					@last = hash
					puts "Changed: #{hash}"
					@listener.update
				end
				sleep(0.1)
			end
		end
		
	end
	
end