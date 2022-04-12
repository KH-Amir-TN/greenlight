# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#current_user' do
    let(:user) { create(:user) }

    it 'returns the authenticated user record' do
      session[:user_id] = user.id
      first_call = controller.current_user
      second_call = controller.current_user
      expect(first_call).to eq(user)
      expect(first_call).to be(second_call)
    end
  end
  describe '#render_json' do
    before do
      allow(controller).to receive(:render).and_return(true)
    end
    it 'calls the ActionController::Base#render' do
        data = 'dummy'
        errors = ['Some Error']
        status = 201
        json = {
          data:,
          errors:
        }
        controller.render_json data:, errors:, status: status
        expect(controller).to receive(:render).with(json:, status:)
    end
  end
end
