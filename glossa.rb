# TODO: All of the things defined at the bottom of language.js should be module constants
# TODO: Create class 'Language' that's part of the Glossa module
# TODO: Convert all the makeLanguage type functions into initialization options for the Language class
# TODO: Anything that's not a constant should either be a module method, or should be instance methods of the Language class
# TODO: Document a bit better what each function is doing (RDoc comments?)
module Glossa
	DEFAULT_ORTHO = {
	    'ʃ' => 'sh',
	    'ʒ' => 'zh',
	    'ʧ' => 'ch',
	    'ʤ' => 'j',
	    'ŋ' => 'ng',
	    'j' => 'y',
	    'x' => 'kh',
	    'ɣ' => 'gh',
	    'ʔ' => '‘',
	    'A' => "á",
	    'E' => "é",
	    'I' => "í",
	    'O' => "ó",
	    'U' => "ú"
	}

	C_ORTH_SETS = [
	    {
	        "name" => "Default",
	        "orth" => {}
	    },
	    {
	        "name" => "Slavic",
	        "orth" => {
	            'ʃ' => 'š',
	            'ʒ' => 'ž',
	            'ʧ' => 'č',
	            'ʤ' => 'ǧ',
	            'j' => 'j'
	        }
	    },
	    {
	        "name" => "German",
	        "orth" => {
	            'ʃ' => 'sch',
	            'ʒ' => 'zh',
	            'ʧ' => 'tsch',
	            'ʤ' => 'dz',
	            'j' => 'j',
	            'x' => 'ch'
	        }
	    },
	    {
	        "name" => "French",
	        "orth" => {
	            'ʃ' => 'ch',
	            'ʒ' => 'j',
	            'ʧ' => 'tch',
	            'ʤ' => 'dj',
	            'x' => 'kh'
	        }
	    },
	    {
	        "name" => "Chinese (pinyin)",
	        "orth" => {
	            'ʃ' => 'x',
	            'ʧ' => 'q',
	            'ʤ' => 'j',
	        }
	    }
	]

	V_ORTH_SETS = [
	    {
	        "name" => "Ácutes",
	        "orth" => {}
	    },
	    {
	        "name" => "Ümlauts",
	        "orth" => {
	            "A" => "ä",
	            "E" => "ë",
	            "I" => "ï",
	            "O" => "ö",
	            "U" => "ü"
	        }
	    },
	    {
	        "name" => "Welsh",
	        "orth" => {
	            "A" => "â",
	            "E" => "ê",
	            "I" => "y",
	            "O" => "ô",
	            "U" => "w"
	        }
	    },
	    {
	        "name" => "Diphthongs",
	        "orth" => {
	            "A" => "au",
	            "E" => "ei",
	            "I" => "ie",
	            "O" => "ou",
	            "U" => "oo"
	        }
	    },
	    {
	        "name" => "Doubles",
	        "orth" => {
	            "A" => "aa",
	            "E" => "ee",
	            "I" => "ii",
	            "O" => "oo",
	            "U" => "uu"
	        }
	    }
	]

	CON_SETS = [
	    {
	        "name" => "Minimal",
	        "C" => "ptkmnls"
	    },
	    {
	        "name" => "English-ish",
	        "C" => "ptkbdgmnlrsʃzʒʧ"
	    },
	    {
	        "name" => "Pirahã (very simple)",
	        "C" => "ptkmnh"
	    },
	    {
	        "name" => "Hawaiian-ish",
	        "C" => "hklmnpwʔ"
	    },
	    {
	        "name" => "Greenlandic-ish",
	        "C" => "ptkqvsgrmnŋlj"
	    },
	    {
	        "name" => "Arabic-ish",
	        "C" => "tksʃdbqɣxmnlrwj"
	    },
	    {
	        "name" => "Arabic-lite",
	        "C" => "tkdgmnsʃ"
	    },
	    {
	        "name" => "English-lite",
	        "C" => "ptkbdgmnszʒʧhjw"
	    }
	]

	S_SETS = [
	    {
	        "name" => "Just s",
	        "S" => "s"
	    },
	    {
	        "name" => "s ʃ",
	        "S" => "sʃ"
	    },
	    {
	        "name" => "s ʃ f",
	        "S" => "sʃf"
	    }
	]

	L_SETS = [
	    {
	        "name" => "r l",
	        "L" => "rl"
	    },
	    {
	        "name" => "Just r",
	        "L" => "r"
	    },
	    {
	        "name" => "Just l",
	        "L" => "l"
	    },
	    {
	        "name" => "w j",
	        "L" => "wj"
	    },
	    {
	        "name" => "r l w j",
	        "L" => "rlwj"
	    }
	]

	F_SETS = [
	    {
	        "name" => "m n",
	        "F" => "mn"
	    },
	    {
	        "name" => "s k",
	        "F" => "sk"
	    },
	    {
	        "name" => "m n ŋ",
	        "F" => "mnŋ"
	    },
	    {
	        "name" => "s ʃ z ʒ",
	        "F" => "sʃzʒ"
	    }
	]

	VOW_SETS = [
	    {
	        "name" => "Standard 5-vowel",
	        "V" => "aeiou"
	    },
	    {
	        "name" => "3-vowel a i u",
	        "V" => "aiu"
	    },
	    {
	        "name" => "Extra A E I",
	        "V" => "aeiouAEI"
	    },
	    {
	        "name" => "Extra U",
	        "V" => "aeiouU"
	    },
	    {
	        "name" => "5-vowel a i u A I",
	        "V" => "aiuAI"
	    },
	    {
	        "name" => "3-vowel e o u",
	        "V" => "eou"
	    },
	    {
	        "name" => "Extra A O U",
	        "V" => "aeiouAOU"
	    }
	]

	SYLL_STRUCTS = [
	    "CVC",
	    "CVV?C",
	    "CVVC?", "CVC?", "CV", "VC", "CVF", "C?VC", "CVF?",
	    "CL?VC", "CL?VF", "S?CVC", "S?CVF", "S?CVC?",
	    "C?VF", "C?VC?", "C?VF?", "C?L?VC", "VC",
	    "CVL?C?", "C?VL?C", "C?VLC?"
	]

	RESTRICT_SETS = [
	    {
	        "name" => "None",
	        "res" => []
	    },
	    {
	        "name" => "Double sounds",
	        "res" => [/(.)\1/]
	    },
	    {
	        "name" => "Doubles and hard clusters",
	        "res" => [/[sʃf][sʃ]/, /(.)\1/, /[rl][rl]/]
	    }
	]

	class Language
		attr_accessor :phonemes, :structure, :exponent, :restricts, :cortho, :vortho, :noortho, :nomorph, :nowordpool, :minsyll, :maxsyll, :morphemes, :words, :names, :joiner, :maxchar, :minchar

		def initialize(random = false, options = nil)
			if random
				@phonemes = {
					"C" => shuffled(choose(CON_SETS, 2)[:C]),
					"V" => shuffled(choose(VOW_SETS, 2)[:V]),
					"L" => shuffled(choose(L_SETS, 2)[:L]),
					"S" => shuffled(choose(S_SETS, 2)[:S]),
					"F" => shuffled(choose(F_SETS, 2)[:F])
				}
			    @noortho = false
			    @nomorph = false
			    @nowordpool = false
			    @structure = choose(SYLL_STRUCTS)
			    @restricts = RESTRICT_SETS[2][:res]
			    @cortho = choose(C_ORTH_SETS, 2)[:orth]
			    @vortho = choose(V_ORTH_SETS, 2)[:orth]
			    @minsyll = randrange(1, 3)
			    @maxsyll = randrange(@minsyll + 1, 7)
			    @joiner = choose('   -')

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
		        },
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
		# This is already how rand works? Need to verify
		def rand_range(lo, hi = nil)
			if hi.nil?
				hi = lo
				lo = 0
			end

			(rand * (hi - lo) + lo).floor
		end

		##
		# Takes an array and shuffles it into a random order.
		def shuffle(list)
			new_list = list.dup

			list.each_with_index do |item, index|
				tmp = item
				rand_index = rand_range(index)
				new_list[index] = new_list[rand_index]
				new_list[rand_index] = tmp
			end

			new_list
		end

		##
		# Takes an array of strings and an optional joiner string
		# and concatenates them into a single string
		def join(list, sep = '')
			return '' if list.length == 0
			first_word = list[0]
			list.each do |item|
				first_word << sep << item
			end

			first_word
		end

		##
		# Takes an array of phonetic syllables, and spells it using the languages orthography
		# TODO: Better var names
		def spell(syllables)
			return syllables if self.noortho
			word = ''
			syllables.each do |syllable|
				if self.cortho[syllable]
					word << self.cortho[syllable]
				elsif self.vortho[syllable]
					word << self.vortho[syllable]
				elsif DEFAULT_ORTHO[syllable]
					word << defaultOrtho[syllable]
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
			while true
				syll = ''
				self.structure.each_with_index do |ptype, index|
					if (self.structure[index + 1] == '?') && (rand < 0.5)
						continue
					end
					syll << choose(self.phonemes[ptype], self.exponent)
				end
				bad = false
				self.restricts.each do |regex|
					if regex =~ syll
						bad = true
						break
					end
				end
				continue if bad

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

			# Use the morphemes we've already made for this kind of word if possible
			list = self.morphemes[key] || []

			# If a key is not specified, make 10 generic morphemes
			# otherwise, just make one new one
			extras = key == '' ? 10 : 1

			while true
				# As more morphemes are created, there is a
				# diminishing chance that a new one will be created.
				n = rand_range(list.length + extras)
				return list[n] if list[n]

				morph = make_syllable

				# No duplicates!
				bad = false
				self.morphemes.each do |k|
					if self.morphemes[k].include? morph
						bad = true
						break
					end
				end
				continue if bad
				list << morph
				self.morphemes[key] = list

				return morph
			end
		end

		##
		# Given the min- and max-syllables for our language, create a new
		# word out of a random number of morphemes.
		def make_word(key)
			num_sylls = rand_range(self.minsyll, self.maxsyll + 1)
			word = ''
			keys = []

			# If a key is defined, then select one of the syllables
			# to have a morpheme of that type.
			# TODO: Probably need to fix...
			keys[rand_range(num_sylls)] = key
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
				n = rand_range(words.length + extras)
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
				continue if bad
				words << new_word
				self.words = words

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
			self.genitive ||= get_morpheme('of')
			self.definitive ||= get_morpheme('the')

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
						name = join([w1, self.genitive, w2], self.joiner)
					end
				end

				# 10% to prefix with definitive
				name = join([self.definitive, name], self.joiner) if rand < 0.1

				continue if (name.length < self.minchar) || (name.length > self.maxchar)

				used = false
				self.names.each do |lang_name|
					if (name.include? lang_name) || (lang_name.include? name)
						used = true
						break
					end
				end

				continue if used

				self.names << name
				return name
			end
		end
	end
end