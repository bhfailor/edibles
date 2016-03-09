require 'rails_helper'

describe Food::Calculator do
  let(:fixtures_dir) { File.join(Rails.root, 'spec', 'fixtures') }

  context 'cod liver oil' do
    let(:happy_response) { YAML
        .load(File.open(File.join(fixtures_dir, 'happy_cod_oil.yml')))}
    let(:fd) { JSON.parse(happy_response.read_body)['report']['food'] }
    let(:kalculator) { Food::Calculator.new(sources: Food::SOURCES, food: fd) }

    it 'returns the expected results for nutrients' do
      expect(kalculator.results['208'])
        .to eq( { name: "Energy", unit: "kcal", value: "902" })
    end

    it 'returns the expected results for food name' do
      expect(kalculator.results['name'])
        .to eq({ name: "food",
                 unit: "string",
                 value: "Fish oil, cod liver" })
    end

    it 'returns the expected results for ndbno' do
      expect(kalculator.results['ndbno'])
        .to eq({ name: 'ndb food number',
                 unit: 'string',
                 value: '04589' })
    end

    it 'returns the expected results for dft' do
      expect(kalculator.results['dft'])
        .to eq({ name: 'base mass',
                 unit: 'g',
                 value: '100' })
    end

    it 'returns the expected results for omega-3' do
      expect(kalculator.results['calc omega-3'])
        .to eq({ name: 'omega-3',
                 unit: 'mg',
                 value: '20671.0' })
    end

    it 'returns the expected results for omega-6' do
      expect(kalculator.results['calc omega-6'])
        .to eq({ name: 'omega-6',
                 unit: 'mg',
                 value: '935.0' })
    end

    it 'returns the expected results for calories from carbs' do
      expect(kalculator.results['calc carb Cal'])
        .to eq({ name: 'carbohydrate E',
                 unit: 'calorie',
                 value: '0.0' })
    end

    it 'returns the expected results for calories from fat' do
      expect(kalculator.results['calc fat Cal'])
        .to eq({ name: 'fat E',
                 unit: 'calorie',
                 value: '902.0' })
    end

    it 'returns the expected results for calories from protein' do
      expect(kalculator.results['calc protein Cal'])
        .to eq({ name: 'protein E',
                 unit: 'calorie',
                 value: '0.0' })
    end

    it 'returns the expected results for calories from fat' do
      expect(kalculator.results['calc alcohol Cal'])
        .to eq({ name: 'alcohol E',
                 unit: 'calorie',
                 value: '0.0' })
    end

    it 'returns the expected results for price' do
      expect(kalculator.results['food price'])
        .to eq({ name: 'price',
                 unit: 'USD',
                 value: 'user-specified' })
    end

    it 'returns the expected results for vegetable mass' do
      expect(kalculator.results['vegetable grams'])
        .to eq({ name: 'vegetable mass',
                 unit: 'g',
                 value: 'user-specified' })
    end

    it 'returns the expected results for fruit mass' do
      expect(kalculator.results['fruit grams'])
        .to eq({ name: 'fruit mass',
                 unit: 'g',
                 value: 'user-specified' })
    end
  end
  context 'baked russet potato' do
    let(:happy_response) { YAML
        .load(File.open(File.join(fixtures_dir, 'happy_response.yml')))}
    let(:fd) { JSON.parse(happy_response.read_body)['report']['food'] }
    let(:kalculator) { Food::Calculator.new(sources: Food::SOURCES, food: fd) }

    it 'returns the expected results for nutrients' do
      expect(kalculator.results['208'])
        .to eq( { name: "Energy", unit: "kcal", value: "97" })
    end

    it 'returns the expected results for food name' do
      expect(kalculator.results['name'])
        .to eq({ name: "food",
                 unit: "string",
                 value: "Potatoes, Russet, flesh and skin, baked" })
    end

    it 'returns the expected results for ndbno' do
      expect(kalculator.results['ndbno'])
        .to eq({ name: 'ndb food number',
                 unit: 'string',
                 value: '11356' })
    end

    it 'returns the expected results for dft' do
      expect(kalculator.results['dft'])
        .to eq({ name: 'base mass',
                 unit: 'g',
                 value: '100' })
    end

    it 'returns the expected results for omega-3' do
      expect(kalculator.results['calc omega-3'])
        .to eq({ name: 'omega-3',
                 unit: 'mg',
                 value: '13.0' })
    end

    it 'returns the expected results for omega-6' do
      expect(kalculator.results['calc omega-6'])
        .to eq({ name: 'omega-6',
                 unit: 'mg',
                 value: '41.0' })
    end

    it 'returns the expected results for calories from carbs' do
      expect(kalculator.results['calc carb Cal'])
        .to eq({ name: 'carbohydrate E',
                 unit: 'calorie',
                 value: '85.3' })
    end

    it 'returns the expected results for calories from fat' do
      expect(kalculator.results['calc fat Cal'])
        .to eq({ name: 'fat E',
                 unit: 'calorie',
                 value: '1.2' })
    end

    it 'returns the expected results for calories from protein' do
      expect(kalculator.results['calc protein Cal'])
        .to eq({ name: 'protein E',
                 unit: 'calorie',
                 value: '10.5' })
    end

    it 'returns the expected results for calories from fat' do
      expect(kalculator.results['calc alcohol Cal'])
        .to eq({ name: 'alcohol E',
                 unit: 'calorie',
                 value: '0.0' })
    end

    it 'returns the expected results for price' do
      expect(kalculator.results['food price'])
        .to eq({ name: 'price',
                 unit: 'USD',
                 value: 'user-specified' })
    end

    it 'returns the expected results for vegetable mass' do
      expect(kalculator.results['vegetable grams'])
        .to eq({ name: 'vegetable mass',
                 unit: 'g',
                 value: 'user-specified' })
    end

    it 'returns the expected results for fruit mass' do
      expect(kalculator.results['fruit grams'])
        .to eq({ name: 'fruit mass',
                 unit: 'g',
                 value: 'user-specified' })
    end
  end
end

=begin
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
      it 'has the correct units' do
        # confirm the number of elements first, then the actual values
        expect(food.results[:units].count).to eq Food::UNITS.count
        expect(food.results[:units].count).to eq Food::SOURCES.count
        expect(food.results[:units].count).to eq Food::NAMES.count
      end
      
      
=end
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
=begin
    end
    
    
  end
end
=end
