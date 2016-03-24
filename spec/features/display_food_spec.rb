require 'rails_helper'

feature 'Display Food' do
  let(:happy_number)  { '11356' }
  let(:sad_number)    { '00000' }
  let(:food)          { instance_double('Food') }
  let(:error_message) { 'something erred' }

  background do
    # Given I can enter a number
    visit root_path
    expect(page).to have_css('input')
  end

  scenario 'entering a valid nutrient database number' do
    expect(Food).to receive(:new).with({ number: happy_number })
      .and_return(food)
    expect(food).to receive(:errors).and_return(nil)
    # When I specify a valid number
    fill_in(:ndbno, with: happy_number)
    click_on('Specify')
    # Then I am on the page where the food is displayed
    expect(current_path).to eq '/food'
  end

  scenario 'entering an invalid number' do
    expect(Food).to receive(:new).with({ number: sad_number })
      .and_return(food)
    expect(food).to receive(:errors).and_return(error_message).twice
    # When I specify an invalid number
    fill_in(:ndbno, with: sad_number)
    click_on('Specify')
    # Then I am on the home page where the number can be re-entered.
    expect(current_path).to eq '/'
    # And an alert is displayed
    expect(page).to have_content error_message
  end
end
