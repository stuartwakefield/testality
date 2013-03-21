module Testality
	class Headers
		def initialize(name)
			set_name do 
				name
			end
		end
		def set_name
			@name = yield
		end
	end
end