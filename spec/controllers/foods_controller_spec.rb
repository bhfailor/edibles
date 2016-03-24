require 'rails_helper'

describe FoodsController do
  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    context 'with a valid food number' do
      let(:number) { '11356' }
      let(:food)   { instance_double('Food') }

      before :each do
        expect(Food).to receive(:new).with({ number: number })
          .and_return(food)
        expect(food).to receive(:errors).and_return(nil)
        get :show, ndbno: number
      end

      it 'assigns the requested food to @food' do
        expect(assigns(:food)).to eq food
      end

      it 'renders the :show template' do
        expect(response).to render_template :show
      end
    end

    context 'with an invalid food number' do
      let(:number) { '00000' }
      let(:food)   { instance_double('Food') }
      let(:error_message) { 'something erred' }

      before :each do
        expect(Food).to receive(:new).with({ number: number })
          .and_return(food)
        expect(food).to receive(:errors).and_return(error_message).twice
        get :show, ndbno: number
      end

      it 'assigns the flash to display an error' do
        expect(flash[:alert]).to eq error_message
      end

      it 're-renders the :new template' do
        expect(response).to be_redirect
      end
    end
  end
end
