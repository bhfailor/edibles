require 'rails_helper'

describe Food do
  let(:fixtures_dir) { File.join(Rails.root, 'spec', 'fixtures') }
  let(:sad_response) { YAML
      .load(File.open(File.join(fixtures_dir, 'sad_response.yml')))}
  let(:happy_response) { YAML
      .load(File.open(File.join(fixtures_dir, 'happy_response.yml')))}
  let(:http_double) { double }

  context 'invalid food number' do
    let(:invalid_number) {'00000'}

    it 'reports errors' do
      expect(Net::HTTP).to receive(:new).and_return(http_double)
      expect(http_double).to receive(:request).and_return(sad_response)
      food = Food.new(number: invalid_number)
      expect(food.errors).to eq "No data for this ndbno: #{invalid_number}"
    end
  end

  context 'valid food number' do
    let(:valid_number) {'11356'} # baked russet potatoes, flesh and skin
    let(:food) { Food.new(number: valid_number) }

    it 'reports no errors' do
      expect(Net::HTTP).to receive(:new).and_return(http_double)
      expect(http_double).to receive(:request).and_return(happy_response)
      expect(food.errors).to eq nil
    end

    it 'returns results hash' do
      expect(Net::HTTP).to receive(:new).and_return(http_double)
      expect(http_double).to receive(:request).and_return(happy_response)
      expect(food.results).not_to eq nil
    end

    describe 'results hash' do
      it 'has the correct keys' do
        expect(food.results.keys).to eq Food::SOURCES
      end

=begin
I have the header values for names, units, and sources.  I can compare that
with the calculated names and units.  And also calculate the values.
I can compare the values for a few foods on nutritiondata.self.com

Once the values look right, I need to get a controller working with the new and
show actions -- :new will allow the input of the food number and will act as the
root page for the app; :show will display the results so they can be cut and
pasted into the spreadsheet program.  I am planning to join all the elements
with tab characters to that they will paste directly into the cells in the 
spreadsheet.  Joining and then displaying the tabs may be tricky.  I thought 
that I would use a form tag and prefill it with the values of the strings to be
cut and pasted.
=end
    end
    
    
  end
end
