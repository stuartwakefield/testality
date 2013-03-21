module Testality
	
	class Resources
		
		def initialize(array)
			@array = array
		end
		
		def get
			dir = Dir.glob @array, 0
			contents = []
			dir.each do |filename|
				contents << (File.open filename, "r").read
			end
			contents.join "\r\n"
		end
		
		def hash
			Digest::SHA2.hexdigest get
		end
		
	end
	
end