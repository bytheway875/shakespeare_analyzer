require_relative '../macbeth_analyzer'
require 'active_support/core_ext/kernel/reporting'

describe MacbethAnalyzer do
  describe 'loading the file' do
    it 'should load the MacBeth xml file and save as accessible method' do
      macbeth_analyzer = MacbethAnalyzer.new
      expect(macbeth_analyzer.send(:macbeth)).to be_a Nokogiri::XML::Document
    end
  end

  describe 'parsing xml' do
    before :each do
      @macbeth_analyzer = MacbethAnalyzer.new
      allow(@macbeth_analyzer).to receive(:macbeth).and_return(Nokogiri::XML(open("example.xml")))
    end

    describe '#speeches' do
      it 'should return all of the speech nodes' do
        @macbeth_analyzer.send(:speeches).each do |speech|
          expect(speech.name).to eq "SPEECH"
        end
      end
    end

    describe '#speakers_hash' do
      it 'should return a hash ' do
        expect(@macbeth_analyzer.send(:speakers_hash)).to be_a Hash
      end

      it 'should count the number of lines a speaker has spoken' do
        result = @macbeth_analyzer.send(:speakers_hash)
        expect(result['MALCOLM']).to eq 16
      end
    end

    describe '#format_results' do
      it 'should create a readable output for the hash' do
        allow(@macbeth_analyzer).to receive(:speakers_hash).and_return({ 'LADY MACBETH' => 16 })
        output = capture :stdout do
          @macbeth_analyzer.send(:format_results)
        end
        expect(output).to include 'Lady Macbeth: 16'
      end
    end
  end
end