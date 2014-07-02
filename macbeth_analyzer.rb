#There are many speeches. Each speech has a speaker. Each speech has many lines.
class MacbethAnalyzer
  require 'nokogiri'
  require 'open-uri'
  require 'active_support/inflector'
  require 'byebug'

  # Initializing a MacbethAnalyzer object will load the document, and run the program.
  def initialize
    @macbeth = Nokogiri::XML(open("http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml"))
    format_results
  end

  private

  attr_accessor :macbeth

  # Find all speech nodes
  def speeches
    macbeth.xpath("//SPEECH")
  end

  # Loop through speech nodes to find the speakers and assign the corresponding lines within
  # the speech node to that speaker.
  def speakers_hash
    speeches.inject(Hash.new(0)) do |speakers, speech|
      speaker = speech.xpath("SPEAKER").text
      speakers[speaker] += speech.xpath("LINE").count
      speakers
    end
  end

  # Format the results into a something more readable. Titleize the names to ensure they're
  # all consistent
  def format_results
    speakers_hash.each_pair do |speaker, lines|
      puts "#{speaker.titleize}: #{lines}"
    end
  end
end

MacbethAnalyzer.new