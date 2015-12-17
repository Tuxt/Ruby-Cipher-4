require("RC4")
require("Converter")

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
				flow :margin => [10, 0, 10, 0] do
					@texto = edit_line :width => "100%"
				end
				
				# Linea de selección de entrada
				para strong("Entrada"), :margin => [10, 10, 10, 0]
				flow :width => "100%", :margin_left => 10 do
					@radio_entrada_ascii = radio :modo_entrada
					para "ASCII"
					@radio_entrada_base = radio :modo_entrada, :margin_left => 20
					para "Base"
					@base_entrada = edit_line :width => "50", :height => 25, :margin_left => 5
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
			flow :width => "100%", :margin => [10,10,10,0] do
				stack :width => "10%" do
					para "Clave"
				end
				stack :width => "90%" do
					@key = edit_line :width => "100%"
				end
			end
			
			# Línea de botón cifrar
			flow :margin => [10,0,10,10] do
				@cifrar = button "RUN", :width => "100%" do
					cifra()
				end
			end
		end
		
		# Linea de selección de salida
		para strong("Salida"), :margin => [10, 0, 10, 0]
		flow :width => "100%", :margin_left => 10 do
			@radio_salida_ascii = radio :modo_salida
			para "ASCII"
			@radio_salida_base = radio :modo_salida, :margin_left => 20
			para "Base"
			@base_salida = edit_line :width => "50", :height => 25, :margin_left => 5
		end
		
		# Linea de salida
		flow :margin => [10,0,10,0] do
			@output = edit_line "", :width => "100%"
		end
	end
	
	
	# Ejecución
	@cifrar.state = "disabled"			# Deshabilitamos el botón de ejecución
	
	# Actualizar botones cuando cambien entradas y modos
	@texto.change() do
		checkRun()
	end
	
	@key.change() do
		checkRun()
	end
	
	@radio_texto.click() do
		checkRun()
	end
	
	@radio_file.click() do
		checkRun()
	end
	
	@radio_entrada_ascii.click() do
		checkRun()
	end
	
	@radio_entrada_base.click() do 
		checkRun()
	end
	
	@radio_salida_ascii.click() do
		checkRun()
	end
	
	@radio_salida_base.click() do 
		checkRun()
	end
	
	@base_entrada.change() do
		checkRun()
	end

	@base_salida.change() do
		checkRun()
	end
	
	# Actualizar botones ------------------------------- END
	
	
	# Comprueba si habilita o deshabilita el botón de ejecución
	def checkRun()
		if (@radio_texto.checked?)									# Comprobaciones modo texto
			if(@texto.text.length != 0 && @key.text.length != 0)
				if ( (@radio_entrada_ascii.checked? || ( @radio_entrada_base.checked? && checkBase(@base_entrada.text) ))  &&
					  (@radio_salida_ascii.checked? || ( @radio_salida_base.checked? && checkBase(@base_salida.text) )) )
					@cifrar.state = nil
				else
					@cifrar.state = "disabled"
				end
			else
				@cifrar.state = "disabled"
			end
		elsif (@radio_file.checked?)								# Comprobaciones modo archivo
			if(@browse.class == String && @key.text.length != 0)
				@cifrar.state = nil
			else
				@cifrar.state = "disabled"
			end
		end
	end

	def checkBase(base)
		true if Integer(base) rescue false
	end
	
	def cifra()
		if (@radio_texto.checked?)
			# CIFRA TEXTO
			# Comprueba bases
			if (@radio_entrada_base.checked? && (Integer(@base_entrada.text) < 1 || Integer(@base_entrada.text) > 30))
				alert("Base de entrada inválida")
				return
			end
			if (@radio_salida_base.checked? && (Integer(@base_salida.text) < 1 || Integer(@base_salida.text) > 30))
				alert("Base de salida inválida")
				return
			end
				
			rc4 = RC4.new(@key.text)
			
			# Obtenemos texto plano
			if (@radio_entrada_ascii.checked?)
				message = Converter.ascii_to_dec_array(@texto.text)
			elsif (@radio_entrada_base.checked?)
				message = Converter.num_to_dec_array(@texto.text, @base_entrada.text)
			end
			
			# Ciframos
			message.count.times do |i|
				message[i] = message[i] ^ rc4.more
			end
			# Devolvemos texto cifrado
			if (@radio_salida_ascii.checked?)
				@output.text = Converter.dec_array_to_ascii(message)
			elsif (@radio_salida_base.checked?)
				@output.text = Converter.dec_array_to_num(message, @base_salida.text)
			end
			
		elsif (@radio_file.checked?)
			# CIFRA ARCHIVO
			alert("Not implemented yet")
		end
	end
	
end
