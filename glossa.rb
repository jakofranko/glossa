# TODO: All of the things defined at the bottom of language.js should be module constants
# TODO: Create class 'Language' that's part of the Glossa module
# TODO: Convert all the makeLanguage type functions into initialization options for the Language class
# TODO: Anything that's not a constant should either be a module method, or should be instance methods of the Language class
# TODO: Document a bit better what each function is doing (RDoc comments?)
module Glossa
	# function choose(list, exponent) {
	#     exponent = exponent || 1;
	#     return list[Math.floor(Math.pow(Math.random(), exponent) * list.length)];
	# }
	def choose(list, exponent = 1)
		listIndex = ((rand ** exponent) * list.length).floor

		list[listIndex]
	end

	# function randrange(lo, hi) {
	#     if (hi == undefined) {
	#         hi = lo;
	#         lo = 0;
	#     }
	#     return Math.floor(Math.random() * (hi - lo)) + lo;
	# }

	# this is already how rand works?
	def rand_range(lo, hi = nil)
		if hi.nil?
			hi = lo
			lo = 0
		end
		
		(rand * (hi - lo) + lo).floor
	end

	# function shuffled(list) {
	#     var newlist = [];
	#     for (var i = 0; i < list.length; i++) {
	#         newlist.push(list[i]);
	#     }
	#     for (var i = list.length - 1; i > 0; i--) {
	#         var tmp = newlist[i];
	#         var j = randrange(i);
	#         newlist[i] = newlist[j];
	#         newlist[j] = tmp;
	#     }
	#     return newlist;
	# }

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

	# function join(list, sep) {
	#     if (list.length == 0) return '';
	#     sep = sep || '';
	#     var s = list[0];
	#     for (var i = 1; i < list.length; i++) {
	#         s += sep;
	#         s += list[i];
	#     }
	#     return s;
	# }
	# TODO: name the s variable better
	def join(list, sep = '')
		return '' if list.length == 0
		s = list[0]
		list.each do |item|
			s << sep << item
		end

		s
	end

	# function spell(lang, syll) {
	#     if (lang.noortho) return syll;
	#     var s = '';
	#     for (var i = 0; i < syll.length; i++) {
	#         var c = syll[i];
	#         s += lang.cortho[c] || lang.vortho[c] || defaultOrtho[c] || c;
	#     }
	#     return s;
	# }

	# TODO: Better var names
	def spell(lang, syllables)
		return syllables if lang.noortho
		s = ''
		syllables.each do |syllable|
			if lang.cortho[syllable]
				s << lang.cortho[syllable]
			elsif lang.vortho[syllable]
				s << lang.vortho[syllable]
			elsif defaultOrtho[syllable]
				s << defaultOrtho[syllable]
			else
				s << syllable
			end
		end
		s
	end

	# function makeSyllable(lang) {
	#     while (true) {
	#         var syll = "";
	#         for (var i = 0; i < lang.structure.length; i++) {
	#             var ptype = lang.structure[i];
	#             if (lang.structure[i+1] == '?') {
	#                 i++;
	#                 if (Math.random() < 0.5) {
	#                     continue;
	#                 }
	#             }
	#             syll += choose(lang.phonemes[ptype], lang.exponent);
	#         }
	#         var bad = false;
	#         for (var i = 0; i < lang.restricts.length; i++) {
	#             if (lang.restricts[i].test(syll)) {
	#                 bad = true;
	#                 break;
	#             }
	#         }
	#         if (bad) continue;
	#         return spell(lang, syll);
	#     }
	# }

	def make_syllable(lang)
		while true
			syll = ''
			lang.structure.each_with_index do |ptype, index|
				if lang.structure[index + 1] == '?' && rand < 0.5
					continue
				end
				syll << choose(lang.phonemes[ptype], lang.exponent)
			end
			bad = false
			lang.restricts.each do |regex|
				if regex =~ syll
					bad = true
					break
				end
			end
			continue if bad

			return spell(lang, syll)
		end
	end

	# function getMorpheme(lang, key) {
	#     if (lang.nomorph) {
	#         return makeSyllable(lang);
	#     }
	#     key = key || '';
	#     var list = lang.morphemes[key] || [];
	#     var extras = 10;
	#     if (key) extras = 1;
	#     while (true) {
	#         var n = randrange(list.length + extras);
	#         if (list[n]) return list[n];
	#         var morph = makeSyllable(lang);
	#         var bad = false;
	#         for (var k in lang.morphemes) {
	#             if (lang.morphemes[k].includes(morph)) {
	#                 bad = true;
	#                 break;
	#             }
	#         }
	#         if (bad) continue;
	#         list.push(morph);
	#         lang.morphemes[key] = list;
	#         return morph;
	#     }
	# }

	def get_morpheme(lang, key = '')
		return make_syllable(lang) if lang.nomorph

		# Use the morphemes we've already made for this kind of word if possible
		list = lang.morphemes[key] || []			

		# If we don't have morphemes for this kind of word, make 10 to start with
		# otherwise, just make one new one
		extras = key ? 1 : 10

		while true
			n = rand_range(list.length + extras)
			return list[n] if list[n]

			morph = make_syllable(lang)

			# No duplicates!
			bad = false
			lang.morphemes.each do |k|
				if lang.morphemes[k].include? morph
					bad = true
					break
				end
			end
			continue if bad
			list << morph
			lang.morphemes[key] = list

			return morph
		end
	end

	# function makeWord(lang, key) {
	#     var nsylls = randrange(lang.minsyll, lang.maxsyll + 1);
	#     var w = '';
	#     var keys = [];
	#     keys[randrange(nsylls)] = key;
	#     for (var i = 0; i < nsylls; i++) {
	#         w += getMorpheme(lang, keys[i]);
	#     }
	#     return w;
	# }

	def make_word(lang, key)
		num_sylls = rand_range(lang.minsyll, lang.maxsyll + 1)
		w = ''
		keys = []
		keys[rand_range(num_sylls)] = key
		num_sylls.times { |i| w << get_morpheme(lang, keys[i]) }

		w
	end

	# function getWord(lang, key) {
	#     key = key || '';
	#     var ws = lang.words[key] || [];
	#     var extras = 3;
	#     if (key) extras = 2;
	#     while (true) {
	#         var n = randrange(ws.length + extras);
	#         var w = ws[n];
	#         if (w) {
	#             return w;
	#         }
	#         w = makeWord(lang, key);
	#         var bad = false;
	#         for (var k in lang.words) {
	#             if (lang.words[k].includes(w)) {
	#                 bad = true;
	#                 break;
	#             }
	#         }
	#         if (bad) continue;
	#         ws.push(w);
	#         lang.words[key] = ws;
	#         return w;
	#     }
	# }

	def get_word(lang, key = '')
		ws = lang.words[key] || []
		extras = key ? 2 : 3

		while true
			n = rand_range(ws.length + extras)
			w = ws[n]
			return w if w

			new_word = make_word(lang, key)
			bad = false
			lang.words.each do |word|
				if word.include? new_word
					bad = true
					break
				end
			end
			continue if bad
			ws << new_word
			lang.words = ws

			return new_word
		end
	end

	# function makeName(lang, key) {
	#     key = key || '';
	#     lang.genitive = lang.genitive || getMorpheme(lang, 'of');
	#     lang.definite = lang.definite || getMorpheme(lang, 'the');
	#     while (true) {
	#         var name = null;
	#         if (Math.random() < 0.5) {
	#             name = capitalize(getWord(lang, key));
	#         } else {
	#             var w1 = capitalize(getWord(lang, Math.random() < 0.6 ? key : ''));
	#             var w2 = capitalize(getWord(lang, Math.random() < 0.6 ? key : ''));
	#             if (w1 == w2) continue;
	#             if (Math.random() > 0.5) {
	#                 name = join([w1, w2], lang.joiner);
	#             } else {
	#                 name = join([w1, lang.genitive, w2], lang.joiner);
	#             }
	#         }
	#         if (Math.random() < 0.1) {
	#             name = join([lang.definite, name], lang.joiner);
	#         }
	# 
	#         if ((name.length < lang.minchar) || (name.length > lang.maxchar)) continue;
	#         var used = false;
	#         for (var i = 0; i < lang.names.length; i++) {
	#             var name2 = lang.names[i];
	#             if ((name.indexOf(name2) != -1) || (name2.indexOf(name) != -1)) {
	#                 used = true;
	#                 break;
	#             }
	#         }
	#         if (used) continue;
	#         lang.names.push(name);
	#         return name;
	#     }
	# }

	def make_name(lang, key = '')
		lang.genitive ||= get_morpheme(lang, 'of')
		lang.definitive ||= get_morpheme(lang, 'the')

		while true
			# 50% chance that the name will be a single word, 50% chance that it will be two words combined somehow
			name = rand < 0.5 ? get_word(lang, key) : nil
			if name.nil?
				# 60% chance that each word will use the same key as invoked
				w1_key = rand < 0.6 ? key : ''
				w1 = get_word(lang, w1_key).capitalize
				w2_key = rand < 0.6 ? key : ''
				w2 = get_word(lang, w2_key).capitalize

				# 50% chance to be joined without the lang's genitive word
				if rand > 0.5
					name = join([w1, w2], lang.joiner)
				else
					name = join([w1, lang.genitive, w2], lang.joiner)
				end
			end

			# 10% to prefix with definitive
			name = join([lang.definitive, name], lang.joiner) if rand < 0.1

			continue if name.length < lang.minchar || name.length > lang.maxchar

			used = false
			lang.names.each do |lang_name|
				if name.include? lang_name || lang_name.include? name
					used = true
					break
				end
			end

			continue if used

			lang.names << name
			return name
		end
	end

	# function makeBasicLanguage() {
	#     return {
	#         phonemes: {
	#             C: "ptkmnls",
	#             V: "aeiou",
	#             S: "s",
	#             F: "mn",
	#             L: "rl"
	#         },
	#         structure: "CVC",
	#         exponent: 2,
	#         restricts: [],
	#         cortho: {},
	#         vortho: {},
	#         noortho: true,
	#         nomorph: true,
	#         nowordpool: true,
	#         minsyll: 1,
	#         maxsyll: 1,
	#         morphemes: {},
	#         words: {},
	#         names: [],
	#         joiner: ' ',
	#         maxchar: 12,
	#         minchar: 5
	#     };
	# }

	class Language
		attr_accessor 
			:phonemes,
			:structure,
			:exponent,
			:restricts,
			:cortho,
			:vortho,
			:noortho,
			:nomorph,
			:nowordpool,
			:minsyll,
			:maxsyll,
			:morphemes,
			:words,
			:names,
			:joiner,
			:maxchar,
			:minchar
		def initialize(random = false, options = nil)
			unless random
				options ||= {}
				@phonemes 	= options[:phonemes] 		|| {
		            "C" => "ptkmnls",
		            "V" => "aeiou",
		            "S" => "s",
		            "F" => "mn",
		            "L" => "rl"
		        },
				@structure 	= options[:structure] 	|| "CVC",
				@exponent 	= options[:exponent] 	|| 2,
				@restricts 	= options[:restricts] 	|| [],
				@cortho 	= options[:cortho] 		|| {},
				@vortho 	= options[:vortho] 		|| {},
				@noortho 	= options[:noortho] 	|| true,
				@nomorph 	= options[:nomorph] 	|| true,
				@nowordpool = options[:nowordpool] 	|| true,
				@minsyll 	= options[:minsyll] 	|| 1,
				@maxsyll 	= options[:maxsyll] 	|| 1,
				@morphemes 	= options[:morphemes] 	|| {},
				@words 		= options[:words] 		|| {},
				@names 		= options[:names] 		|| [],
				@joiner 	= options[:joiner] 		|| ' ',
				@maxchar 	= options[:maxchar] 	|| 12,
				@minchar 	= options[:minchar] 	|| 5
			end
		end
	end

	def make_basic_language()
		{
			"phonemes" => {
	            "C" => "ptkmnls",
	            "V" => "aeiou",
	            "S" => "s",
	            "F" => "mn",
	            "L" => "rl"
	        },
	        "structure" 	=> "CVC",
	        "exponent" 		=> 2,
	        "restricts" 	=> [],
	        "cortho" 		=> {},
	        "vortho" 		=> {},
	        "noortho" 		=> true,
	        "nomorph" 		=> true,
	        "nowordpool" 	=> true,
	        "minsyll" 		=> 1,
	        "maxsyll" 		=> 1,
	        "morphemes" 	=> {},
	        "words" 		=> {},
	        "names" 		=> [],
	        "joiner" 		=> ' ',
	        "maxchar" 		=> 12,
	        "minchar" 		=> 5
		}
	end
	# function makeOrthoLanguage() {
	#     var lang = makeBasicLanguage();
	#     lang.noortho = false;
	#     return lang;
	# }
	 
	def make_ortho_language()
		lang = make_basic_language()
		lang.noortho = false
		lang
	end

	# function makeRandomLanguage() {
	#     var lang = makeBasicLanguage();
	#     lang.noortho = false;
	#     lang.nomorph = false;
	#     lang.nowordpool = false;
	#     lang.phonemes.C = shuffled(choose(consets, 2).C);
	#     lang.phonemes.V = shuffled(choose(vowsets, 2).V);
	#     lang.phonemes.L = shuffled(choose(lsets, 2).L);
	#     lang.phonemes.S = shuffled(choose(ssets, 2).S);
	#     lang.phonemes.F = shuffled(choose(fsets, 2).F);
	#     lang.structure = choose(syllstructs);
	#     lang.restricts = ressets[2].res;
	#     lang.cortho = choose(corthsets, 2).orth;
	#     lang.vortho = choose(vorthsets, 2).orth;
	#     lang.minsyll = randrange(1, 3);
	#     if (lang.structure.length < 3) lang.minsyll++;
	#     lang.maxsyll = randrange(lang.minsyll + 1, 7);
	#     lang.joiner = choose('   -');
	#     return lang;
	# }

	def make_random_language()
		lang = make_basic_language
		lang.noortho = false
	    lang.nomorph = false
	    lang.nowordpool = false
	    lang.phonemes.C = shuffled(choose(consets, 2).C)
	    lang.phonemes.V = shuffled(choose(vowsets, 2).V)
	    lang.phonemes.L = shuffled(choose(lsets, 2).L)
	    lang.phonemes.S = shuffled(choose(ssets, 2).S)
	    lang.phonemes.F = shuffled(choose(fsets, 2).F)
	    lang.structure = choose(syllstructs)
	    lang.restricts = ressets[2].res
	    lang.cortho = choose(corthsets, 2).orth
	    lang.vortho = choose(vorthsets, 2).orth
	    lang.minsyll = randrange(1, 3)
	    if (lang.structure.length < 3) lang.minsyll++
	    lang.maxsyll = randrange(lang.minsyll + 1, 7)
	    lang.joiner = choose('   -')
	    return lang
	end
end