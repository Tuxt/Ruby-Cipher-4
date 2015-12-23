require("RC4_progress")
require("Converter")

Shoes.app title: "Ruby Cipher 4" do
	
	# Header
	stack do
		background black, :margin => 10, :curve => 12
		title "Ruby Cipher 4", :margin => 10, align: "center", :stroke => white
		caption "A Ruby implementation of RC4", align: "center", :stroke => white
	end
	
	# Content
	stack do
		
		# Mode columns
		flow do
			# Left column: text
			stack :width => "50%", :margin => 10 do
				background gray(0.7), :curve => 4
			
				# Radio line
				flow do
					@radio_text = radio :type
					para "Text"
				end
				
				# Text line
				flow :margin => [10, 0, 10, 0] do
					@text_input = edit_line :width => "100%"
				end
				
				# Input selection line
				para strong("Input"), :margin => [10, 10, 10, 0]
				flow :width => "100%", :margin_left => 10 do
					@radio_input_ascii = radio :input_mode
					para "ASCII"
					@radio_input_base = radio :input_mode, :margin_left => 20
					para "Base"
					@input_base = edit_line :width => "50", :height => 25, :margin_left => 5
				end
			end
			
			# Right column: file
			stack :width => "50%", :margin => 10 do
				background gray(0.7), :curve => 4
				
				# Radio line
				flow do
					@radio_file = radio :type
					para "File"
				end
				
				# File selection line
				flow :margin => 10 do
					button "Browse" do
						@browse = ask_open_file
						if @browse.class == String then
							@file.text = @browse
						else
							@file.text = "Select"
						end
						checkRun()
					end
					@file = para "Select", :margin => 10
				end
			end
		end
		
		# Action stack
		stack :width => "100%", :margin => 10 do
			background gray(0.7), :curve => 4
			
			# Key line
			flow :width => "100%", :margin => [10,10,10,0] do
				stack :width => "10%" do
					para "Key"
				end
				stack :width => "90%" do
					@key = edit_line :width => "100%"
				end
			end
			
			# Run button line
			flow :margin => [10,0,10,10] do
				@run_button = button "RUN", :width => "100%" do
					encrypt()
				end
			end
		end
		
		
		# Output stack
		stack :width => "100%", :margin => [10,10,10,0] do
			background gray(0.7), :curve => 5
		
			# Output selection line
			para strong("Output"), :margin => [10, 5, 10, 0]
			flow :width => "100%", :margin_left => 10 do
				@radio_output_ascii = radio :output_mode
				para "ASCII"
				@radio_output_base = radio :output_mode, :margin_left => 20
				para "Base"
				@base_output = edit_line :width => "50", :height => 25, :margin_left => 5
			end
		
			# Output line
			flow :margin => [10,0,10,0] do
			@output = edit_line "", :width => "100%"
			end
		
			# Progress bar
			flow :margin => 10 do
				@progress_bar = progress :width => "100%"
			end
		end
	end
	
	
	# Execution
	@run_button.state = "disabled"
	
	# Check/Update run button ------------------------------- START
	@text_input.change() do
		checkRun()
	end
	
	@key.change() do
		checkRun()
	end
	
	@radio_text.click() do
		checkRun()
	end
	
	@radio_file.click() do
		checkRun()
	end
	
	@radio_input_ascii.click() do
		checkRun()
	end
	
	@radio_input_base.click() do 
		checkRun()
	end
	
	@radio_output_ascii.click() do
		checkRun()
	end
	
	@radio_output_base.click() do 
		checkRun()
	end
	
	@input_base.change() do
		checkRun()
	end

	@base_output.change() do
		checkRun()
	end
	
	# Check/Update run button ------------------------------- END
	
	
	# Enable/Disable run button
	def checkRun()
		if (@radio_text.checked?)									# Text mode
			if(@text_input.text.length != 0 && @key.text.length != 0)
				if ( (@radio_input_ascii.checked? || ( @radio_input_base.checked? && checkBase(@input_base.text) ))  &&
					  (@radio_output_ascii.checked? || ( @radio_output_base.checked? && checkBase(@base_output.text) )) )
					@run_button.state = nil
				else
					@run_button.state = "disabled"
				end
			else
				@run_button.state = "disabled"
			end
		elsif (@radio_file.checked?)								# File mode
			if(@browse.class == String && @key.text.length != 0)
				@run_button.state = nil
			else
				@run_button.state = "disabled"
			end
		end
	end

	def checkBase(base)
		true if Integer(base) rescue false
	end
	
	def encrypt()
		if (@radio_text.checked?)
			# ENCRYPT TEXT
			# Check base
			if (@radio_input_base.checked? && (Integer(@input_base.text) < 2 || Integer(@input_base.text) > 30))
				alert("Invalid input base")
				return
			end
			if (@radio_output_base.checked? && (Integer(@base_output.text) < 2 || Integer(@base_output.text) > 30))
				alert("Invalid output base")
				return
			end
				
			rc4 = RC4.new(@key.text)
			
			# Gets original text
			if (@radio_input_ascii.checked?)
				message = Converter.ascii_to_dec_array(@text_input.text)
			elsif (@radio_input_base.checked?)
				message = Converter.num_to_dec_array(@text_input.text, @input_base.text)
			end
			
			# Encrypt
			message.count.times do |i|
				message[i] = message[i] ^ rc4.more
			end
			
			# Show result text
			if (@radio_output_ascii.checked?)
				@output.text = Converter.dec_array_to_ascii(message)
			elsif (@radio_output_base.checked?)
				@output.text = Converter.dec_array_to_num(message, @base_output.text)
			end
			
		elsif (@radio_file.checked?)
			# ENCRYPT FILE
			# Start cipher algorithm
			rc4 = RC4.new(@key.text)
			# Run in a thread
			Thread.new do
				rc4.run(@browse)
			end
			
			# Update progress bar
			@animate_bar = animate do
				if ((@progress_bar.fraction = rc4.percent) == 1.0)
					@animate_bar.stop
					alert("File encrypted!")
				end
			end
		end
	end
	
end
