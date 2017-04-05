require "json"

class Glossa::Language
	def self.import(path = nil)
		path = gets "File path:" if path.nil?

		# Get file from path
		json = '';
		File.open(path).each do |line|
			json << line
		end

		options = JSON.parse(json)
		self.new(false, options)
	end

	def export(path = nil)
		if File.exist? path 
			raise "That file already exists!"
			return
		elsif path.nil?
			raise "File path required"
			return
		end

		lang_state = {}
		self.instance_variables.each do |attribute|
			a = attribute[1..attribute.length]
	      	lang_state[a] = self.instance_variable_get(attribute)
	    end
		File.open(path, "w") { |file| file.write(lang_state.to_json) }
	end
end