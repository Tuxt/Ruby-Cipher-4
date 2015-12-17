# Clase de RC4
class RC4

	def initialize(key)
		# Variables 'i' y 'j' para la salida (PRGA). Las de KSA son locales
		@i = 0
		@j = 0
		
		# KSA ---------------------------------------: START
		@key = key.bytes
		@S = Array.new(256)
		@S.each_index do |index|
			@S[index] = index 
		end
		
		key_len = @key.count
		j = 0
		256.times do |i|
			j = (j + @S[i] + @key[i % key_len]) % 256
			swap(i,j)
		end
		# KSA ---------------------------------------: END
		
	end
	
	# SWAP
	def swap(i,j)
		tmp = @S[i]
		@S[i] = @S[j]
		@S[j] = tmp
	end
	
	# PRGA
	def more
		@i = (@i + 1) % 256
		@j = (@j + @S[@i]) % 256
		swap(@i, @j)
		k = @S[ ( @S[@i] + @S[@j] ) % 256 ]
		return k
	end
	
end
