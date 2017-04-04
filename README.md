[![Gem Version](https://badge.fury.io/rb/glossa.svg)](https://badge.fury.io/rb/glossa)

Note: Version 1.0.0 is an (almost) direct port of [mewo2's JavaScript naming-language generator](https://github.com/mewo2/naming-language). These initial ideas are his, and I have changed very little of the actual inner-workings (other than basically turn it into a class). I would _*highly*_ encourage everybody to go and checkout his original repo (link above), [read his documentation on how the language generator works](http://mewo2.com/notes/naming-language/), and [follow @unchartedatlas](https://twitter.com/unchartedatlas)

## Recent Updates

* v1.0.2 - Minor re-factor moving `Glossa::Language` into its own file, removed some debug statements, and fixed a bug that was generating morphemes with a key of `nil`

## Installation

`gem install glossa`

## Usage

`Glossa` is a module that holds the API for a "naming language generator generator."

You can create a basic language via `lang = Glossa::Language.new`, a random language by `Glossa::Language.new(true)`, or you can create a language with specific rules by passing in a hash: `Glossa::Language.new(false, options)`

Creating an instance of `Language` like this will provide you with a name/word generator that follows the specific rules for syllables, phonemes, morphology, orthography etc. that were defined in initialization.

Generate a new name: `lang.make_name([optional type])`. This will create a new name constructed using a mash of typed and un-typed phonemes.

Generate a new word: `lang.get_word([optional type])`. Will create a simpler than a name but unique word.

Passing in a type will generate phonemes that have only that type in order to create words that sound unified.

### Example Usage

`lang.make_name("tree")`

`lang.make_name("city")`

`lang.make_name`

`lang.get_word("city")`

`lang.get_word`

## TODO

I'll go ahead and put the same ideas as mewo2 had for his language tool, and add some of my own too:

* Synchronic sound changes: rules which change some of the sounds depending on context (e.g. German /d/ becomes /t/ at the end of a word, Latin /k/ becomes /ʧ/ before /i/ or /e/)
* Historical sound changes: start with an 'ancestral form' and evolve the word systematically. Do this in multiple ways to produce a family of languages.
* Generated scripts: why should a generated language use the Roman alphabet? How do these people write things among themselves? Invent an alphabet (or similar) and show how the names are really spelled.
* Better grammar: break our morphemes out into roots and modifiers, and come up with some rules about how they're combined
* Import and export functionality for an instance of `Language`