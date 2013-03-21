module Testality
	class Headers
		def initialize(name)
			set_name do 
				get_default_name()
			end
		end
		def get_default_name
			"Bob"
		end
	end
end