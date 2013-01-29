require "digest"

module Testality
	
	class Watcher
		
		def initialize(resources, listener)
			
			@lasthash = nil
			
			loop do
				hash = resources.hash
				if @lasthash == nil or @lasthash != hash
					@lasthash = hash
					puts "Changed: #{hash}"
					listener.update
				end
				sleep(0.1)
			end  
			
		end
		
	end
	
end