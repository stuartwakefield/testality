module Testality
	
	class Resources
		
		def initialize(array)
			@array = array
		end
		
		def get
			dir = Dir.glob(@array, 0)
			contents = "";
			dir.each do |filename|
				file = File.open filename, "r"
				contents += file.read + "\r\n"
			end
			contents.gsub(/\s+/, " ")
		end
		
		def hash
			Digest::SHA2.hexdigest get
		end
		
	end
	
end