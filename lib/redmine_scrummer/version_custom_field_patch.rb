module RedmineScrummer
	module VersionCustomFieldPatch
		
		def self.included(base)
			base.class_eval do
				unloadable # Send unloadable so it will not be unloaded in development
			end	
			
		end
	end

end