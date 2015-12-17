require("RC4")

Shoes.app title: "Ruby Cipher 4" do
	
	# Cabecera
	stack do
		background black, :margin => 10, :curve => 12
		title "Ruby Cipher 4", :margin => 10, align: "center", :stroke => white
		caption "A Ruby implementation of RC4", align: "center", :stroke => white
	end
	
	# Contenido
	stack do
		
		# Columnas de modo
		flow do
			# Columna izquierda: texto
			stack :width => "50%", :margin => 10 do
				background gray(0.7), :curve => 4
			
				# Linea de radio
				flow do
					@radio_texto = radio :type
					para "Texto"
				end
				
				# Linea de texto
				flow do
					@texto = edit_line :width => "100%", margin: 10
				end
				
			end
			
			# Columna derecha: archivo
			stack :width => "50%", :margin => 10 do
				background gray(0.7), :curve => 4
				
				# Linea de radio
				flow do
					@radio_file = radio :type
					para "Archivo"
				end
				
				# Línea de selección de archivo
				flow :margin => 10 do
					button "Examinar" do
						@browse = ask_open_file
						if @browse.class == String then
							@file.text = @browse
						else
							@file.text = "Selecciona"
						end
						checkRun()
					end
					@file = para "Selecciona", :margin => 10
				end
			end
		end
		
		# Pila de acción
		stack :width => "100%", :margin => 10 do
			background gray(0.7), :curve => 4
			
			# Línea de clave
			flow :width => "100%", :margin => 10 do
				stack :width => "10%" do
					para "Clave"
				end
				stack :width => "90%" do
					@key = edit_line :width => "100%"
				end
			end
			
			# Línea de botón cifrar
			flow :margin => 10 do
				@cifrar = button "CIFRAR", :width => "100%" do
					cifra()
				end
			end
			
			# Línea de botón descifrar
			flow :margin => 10 do
				@descifrar = button "DESCIFRAR", :width => "100%" do
					descifra()
				end
			end
			
		end
		
		# Linea de salida
		flow :margin => 10 do
			@output = edit_line "", :width => "100%"
		end
	end
	
	
	# Ejecución
	@cifrar.state = "disabled"			# Deshabilitamos el botón de ejecución
	@descifrar.state = "disabled"		# Deshabilitamos el botón de ejecución
	
	@texto.change() do				# Al escribir texto plano, comprobar si habilita botón de ejecución
		checkRun()
	end
	
	@key.change() do				# Al escribir clave, comprobar si habilita botón de ejecución
		checkRun()
	end
	
	@radio_texto.click() do			# Al cambiar modo, comrpobar si habilita botón de ejecución
		checkRun()
	end
	
	@radio_file.click() do			# Al cambiar modo, comrpobar si habilita botón de ejecución
		checkRun()
	end
	
	# Comprueba si habilita o deshabilita el botón de ejecución
	def checkRun()
		if (@radio_texto.checked?)
			if(@texto.text.length != 0 && @key.text.length != 0)
				@cifrar.state = nil
				@descifrar.state = nil
			else
				@cifrar.state = "disabled"
				@descifrar.state = "disabled"
			end
		elsif (@radio_file.checked?)
			if(@browse.class == String && @key.text.length != 0)
				@cifrar.state = nil
				@descifrar.state = nil
			else
				@cifrar.state = "disabled"
				@descifrar.state = "disabled"
			end
		end
	end

	def cifra()
		if (@radio_texto.checked?)
			# CIFRA TEXTO
			rc4 = RC4.new(@key.text)
			salida = Array.new
			plaintext = @texto.text.bytes
			plaintext.count.times do |i|
				salida[i] = (plaintext[i] ^ rc4.more)
			end
			
			@output.text = "0x"
			salida.count.times do |i|
				@output.text += ("%02x" % salida[i]).upcase
			end
		elsif (@radio_file.checked?)
			# CIFRA ARCHIVO
			
		end
	end
	
	def descifra()
		if (@radio_texto.checked?)
			# DESCIFRA TEXTO
			rc4 = RC4.new(@key.text)
			salida = Array.new
			
			# Creamos un array para los bytes: la entrada es hexadecimal: mitad de elementos que de caracteres
			elementos = @texto.text.length/2
			ciphertext = Array.new
			elementos.times do |i|
				ciphertext[i] = @texto.text[i*2, 2].to_i(16)
			end
			
			elementos.times do |i|
				salida[i] = (ciphertext[i] ^ rc4.more)
			end
			
			@output.text = ""
			salida.count.times do |i|
				@output.text += (salida[i].chr)
			end
		elsif (@radio_file.checked?)
			# DESCIFRA ARCHIVO
		end
	end
	
end
