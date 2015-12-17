# Clase de conversion 
class Converter

	# ASCII String -> Bytes[]
	def self.ascii_to_dec_array(ascii)
		return ascii.bytes
	end
	
	# Bytes[] -> ASCII String
	def self.dec_array_to_ascii(array)
		return array.pack("c"*array.count)
	end
	
	# Base String -> Bytes[]
	def self.num_to_dec_array(num, base)
		base = base.to_i
		
		array = num.split(" ")
		array.count.times do |i|
			array[i] = array[i].to_i(base)
		end
		return array
	end
	
	# Bytes[] -> Base String
	def self.dec_array_to_num(array, base)
		base = base.to_i
		
		result = ""
		array.count.times do |i|
			result << array[i].to_s(base)
			result << " "
		end
		
		return result;
	end
	
end
