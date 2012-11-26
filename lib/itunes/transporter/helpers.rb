require 'digest/md5'

module FileHelpers
	def get_file_size(filename)
		file_size = File.size?(filename)
		
		if (file_size == nil || file_size == 0)
			
		end
		
		return file_size
	end

	def get_file_checksum(filename)
		begin
			return Digest::MD5.file(filename).hexdigest			
		rescue
			p 'Unable to find #{filename}'
		end		
	end
end