require 'rails_helper'

feature 'Display Food' do
  let(:happy_number) { '11356' }
  let(:sad_number)   { '00000' }

  background do
    # Given I can enter a number
    visit root_path
    expect(page).to have_css('input')
  end

  scenario 'entering a valid nutrient database number' do
    # When I specify a valid number
    fill_in(:ndbno, with: happy_number)
    click_on('Specify')
    # Then I am on the page where the food is displayed
    expect(current_path).to eq '/food'
  end

  scenario 'entering an invalid number' do
  end
end
