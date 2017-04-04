class Glossa::Language
	attr_accessor :phonemes, :structure, :exponent, :restricts, :cortho, :vortho, :noortho, :nomorph, :nowordpool, :minsyll, :maxsyll, :morphemes, :words, :names, :genitive, :definitive, :joiner, :maxchar, :minchar

	def initialize(random = false, options = nil)
		if random
			@phonemes = {
				"C" => shuffle(choose(Glossa::CON_SETS, 2)[:C]),
				"V" => shuffle(choose(Glossa::VOW_SETS, 2)[:V]),
				"L" => shuffle(choose(Glossa::L_SETS, 2)[:L]),
				"S" => shuffle(choose(Glossa::S_SETS, 2)[:S]),
				"F" => shuffle(choose(Glossa::F_SETS, 2)[:F])
			}
		    @noortho 	= false
		    @nomorph 	= false
		    @nowordpool = false
		    @structure 	= choose(Glossa::SYLL_STRUCTS)
		    @exponent	= rand(1..3) # a larger exponent means less variation when randomly choosing some elements
		    @restricts 	= Glossa::RESTRICT_SETS[2][:res]
		    @cortho 	= choose(Glossa::C_ORTH_SETS, 2)[:orth]
		    @vortho 	= choose(Glossa::V_ORTH_SETS, 2)[:orth]
		    @morphemes 	= {}
		    @words		= {}
		    @names		= []
		    @joiner 	= choose('   -')
		    @maxchar 	= rand(10...15)
			@minchar 	= rand(3...5)
		    @minsyll 	= rand(1...3)
		    @maxsyll 	= rand(@minsyll + 1...7)

		    if @structure.length < 3
		    	@minsyll += 1;
		    end
		else
		    options ||= {}
			@phonemes 	= options[:phonemes] 	|| {
	            "C" => "ptkmnls",
	            "V" => "aeiou",
	            "S" => "s",
	            "F" => "mn",
	            "L" => "rl"
	        }
			@structure 	= options[:structure] 	|| "CVC"
			@exponent 	= options[:exponent] 	|| 2
			@restricts 	= options[:restricts] 	|| []
			@cortho 	= options[:cortho] 		|| {}
			@vortho 	= options[:vortho] 		|| {}
			@noortho 	= options[:noortho] 	|| true
			@nomorph 	= options[:nomorph] 	|| true
			@nowordpool = options[:nowordpool] 	|| true
			@minsyll 	= options[:minsyll] 	|| 1
			@maxsyll 	= options[:maxsyll] 	|| 1
			@morphemes 	= options[:morphemes] 	|| {}
			@words 		= options[:words] 		|| {}
			@names 		= options[:names] 		|| []
			@joiner 	= options[:joiner] 		|| ' '
			@maxchar 	= options[:maxchar] 	|| 12
			@minchar 	= options[:minchar] 	|| 5
		end

		@genitive 	= get_morpheme('of')
		@definitive	= get_morpheme('the')
	end

	##
	# Takes an array and picks a semi-random element, with the first
	# elements weighted more frequently the the last elements by using
	# the power of a given exponent.
	def choose(list, exponent = 1)
		listIndex = ((rand ** exponent) * list.length).floor

		list[listIndex]
	end

	##
	# Takes an array or string and shuffles it into a random order.
	def shuffle(list)
		is_string = list.is_a? String
		l = is_string ? list.chars : list
		new_list = l.dup

		i = 0;
		l.each do |item|
			tmp = item
			rand_index = rand(i)
			new_list[i] = new_list[rand_index]
			new_list[rand_index] = tmp
			i += 1;
		end

		if is_string
			return new_list.join
		else
			return new_list
		end
	end

	##
	# Takes an array of strings and an optional joiner string
	# and concatenates them into a single string
	def join(list, sep = '')
		return '' if list.length == 0
		first_word = list.shift
		list.each do |item|
			first_word << sep << item
		end

		first_word
	end

	##
	# Takes an array of phonetic syllables, and spells them using the languages orthography
	def spell(syllables)
		return syllables if self.noortho
		s = syllables.chars
		word = ''
		s.each do |syllable|
			if self.cortho[syllable]
				word << self.cortho[syllable]
			elsif self.vortho[syllable]
				word << self.vortho[syllable]
			elsif Glossa::DEFAULT_ORTHO[syllable]
				word << Glossa::DEFAULT_ORTHO[syllable]
			else
				word << syllable
			end
		end
		word
	end

	##
	# Creates a spelled (see the spell() method) syllable, according to
	# the language's syllable structure. It does this by selecting a semi-random
	# phonetic letter for the appropriate phoneme type in the structure, making sure
	# that it doesn't conflict with a restricted pattern, and then spells the
	# phonetic word according to the language's orthography.
	def make_syllable
		structure = self.structure.chars
		while true
			syll = ''
			structure.each do |ptype|
				# If the char is '?', skip with 50% chance to remove last character
				# (think RegEx usage of '?')
				if ptype == '?'
					if rand < 0.5
						syll = syll[0...syll.length - 1]
					end
					next
				end
				
				syll << choose(self.phonemes[ptype], self.exponent)
			end

			# Make sure this syllable doesn't violate a restriction
			bad = false
			self.restricts.each do |regex|
				if regex =~ syll
					bad = true
					break
				end
			end
			next if bad

			return spell(syll)
		end
	end

	##
	# The lowest common-denominator "word" that we will store for our language.
	# Morphemes are the smallest unit of language that has a meaning.
	# A "morpheme," in this sense, is a unique syllable (spelled according to our orthography)
	# with a type (key). Whenever a morpheme is created, we store it in the class instance,
	# so as to make sure we don't create duplicates. Morphemes comprise words.
	def get_morpheme(key = '')
		return make_syllable if self.nomorph

		# make_word will sometimes pass in nil
		if key.nil? 
			key = ''
		end

		# Use the morphemes we've already made for this kind of word if possible
		list = self.morphemes[key] || []

		# If a key is not specified, make 10 generic morphemes
		# otherwise, just make one new one
		extras = key == '' ? 10 : 1

		while true
			# As more morphemes are created, there is a
			# diminishing chance that a new one will be created.
			n = rand(list.length + extras)
			return list[n] if list[n]

			# An existing morpheme was not selected, so create a new one
			morph = make_syllable

			# No duplicates!
			bad = false
			self.morphemes.each do |k|
				next if self.morphemes[k].nil?
				if self.morphemes[k].include? morph
					bad = true
					break
				end
			end
			next if bad
			list << morph
			self.morphemes[key] = list

			return morph
		end
	end

	##
	# Given the min- and max-syllables for our language, create a new
	# word out of a random number of morphemes.
	def make_word(key)
		num_sylls = rand(self.minsyll..self.maxsyll)
		word = ''
		keys = []

		# If a key is defined, then select one of the syllables
		# to have a morpheme of that type.
		keys[rand(num_sylls)] = key
		num_sylls.times { |i| word << get_morpheme(keys[i]) }

		word
	end

	##
	# This method has a chance to use an existing word, or create a new
	# one of the type (key) specified using the make_word method. If a
	# new word is created, it will make sure that it is not duplicating
	# an existing word, and then add it to the list of stored words.
	def get_word(key = '')
		words = self.words[key] || []
		extras = key == '' ? 2 : 3

		while true
			n = rand(words.length + extras)
			existing_word = words[n]
			return existing_word if existing_word

			new_word = make_word(key)
			bad = false
			self.words.each do |word|
				if word.include? new_word
					bad = true
					break
				end
			end
			next if bad
			words << new_word
			self.words[key] = words

			return new_word
		end
	end

	##
	# A wrapper with some additional logic around the get_word method.
	# make_name will create a name, using get_word (so the words created
	# to make up the name will be saved by the specified key), and have
	# a 50% chance to add an additional word, and potentially the genitive
	# and definitive words. After checking to make sure that it's an ok size
	# and isn't already used, it saves and returns the name
	def make_name(key = '')
		## If you don't dup these, words will get concatenated onto them during the join process
		genitive = self.genitive.dup
		definitive = self.definitive.dup

		while true
			# 50% chance that the name will be a single word, 50% chance that it will be two words combined somehow
			name = rand < 0.5 ? get_word(key) : nil
			if name.nil?
				# 60% chance that each word will use the same key as invoked
				w1_key = rand < 0.6 ? key : ''
				w1 = get_word(w1_key).capitalize
				w2_key = rand < 0.6 ? key : ''
				w2 = get_word(w2_key).capitalize

				# 50% chance to be joined without the lang's genitive word
				if rand > 0.5
					name = join([w1, w2], self.joiner)
				else
					name = join([w1, genitive, w2], self.joiner)
				end
			end

			# 10% to prefix with definitive
			name = join([definitive, name], self.joiner) if rand < 0.1

			# Generate another one if this doesn't meet the min- or maxchar reqs
			next if (name.length < self.minchar) || (name.length > self.maxchar)

			name.capitalize!

			# Check to see if this string has already been generated
			used = false
			self.names.each do |lang_name|
				if (name.include? lang_name) || (lang_name.include? name)
					used = true
					break
				end
			end

			# Start over if this name exists already
			next if used

			self.names << name
			return name
		end
	end
end