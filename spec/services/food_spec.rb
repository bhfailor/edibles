require 'rails_helper'

describe Food do
  let(:klass) { Food }
  it 'responds to :new' do
    expect(klass.new.class).to eq klass
  end

  context 'invalid food number' do
    let(:invalid_code) {'00000'}

    it 'reports errors' do
      food = Food.new(code: invalid_code)
      expect(food.errors).to eq "No data for this ndbno: #{invalid_code}"
    end
  end

  context 'valid food number' do
    let(:valid_code) {'11356'}

    it 'reports no errors' do
      food = Food.new(code: valid_code)
      expect(food.errors).to eq nil
    end
  end
end
