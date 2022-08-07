# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RoomSettingsController, type: :controller do
  let(:user) { create(:user) }
  let(:room) { create(:room, user:) }

  before do
    request.headers['ACCEPT'] = 'application/json'
    session[:user_id] = user.id
  end

  describe '#show' do
    skip 'TODO' do
      # TODO
    end
  end

  describe '#update' do
    it 'uses MeetingOption::get_config_value and updates the setting if its config is "optional"' do
      expect(MeetingOption).to receive(:get_config_value).with(name: 'setting', provider: 'greenlight').and_call_original

      meeting_option = create(:meeting_option, name: 'setting')
      create(:rooms_configuration, meeting_option:, provider: 'greenlight', value: 'optional')

      put :update, params: { room_setting: { settingName: 'setting', settingValue: 'notOptionalAnymore' }, friendly_id: room.friendly_id }
      expect(response).to have_http_status(:ok)
      expect(room.room_meeting_options.take.value).to eq('notOptionalAnymore')
    end

    context 'AuthZ' do
      it 'returns :forbidden if the setting config is "true"' do
        meeting_option = create(:meeting_option, name: 'setting')
        create(:rooms_configuration, meeting_option:, provider: 'greenlight', value: 'true')

        put :update, params: { room_setting: { settingName: 'setting', settingValue: 'notTrueAnymore' }, friendly_id: room.friendly_id }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns :forbidden if the setting config is "false"' do
        meeting_option = create(:meeting_option, name: 'setting')
        create(:rooms_configuration, meeting_option:, provider: 'greenlight', value: 'false')

        put :update, params: { room_setting: { settingName: 'setting', settingValue: 'notFalseAnymore' }, friendly_id: room.friendly_id }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'AuthN' do
      it 'returns :unauthorized response for unauthenticated requests' do
        session[:user_id] = nil

        put :update, params: { friendly_id: room.friendly_id }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'returns :forbidden for unfound config' do
      put :update, params: { room_setting: { settingName: '404', settingValue: 'valueOfWhat?' }, friendly_id: room.friendly_id }
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns :forbidden when updating a read only setting' do
      stub_const('RoomSettingsController::READ_ONLY_SETTINGS', %w[read_only])

      put :update, params: { room_setting: { settingName: 'read_only', settingValue: 'notReadOnlyAnymore' }, friendly_id: room.friendly_id }
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns :bad_request for invalid params' do
      put :update, params: { not_room_setting: { notSettingName: 'setting', notSettingValue: 'someValue' }, friendly_id: room.friendly_id }
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns :not_found for unfound room' do
      put :update, params: { room_setting: { settingName: 'setting', settingValue: 'someValue' }, friendly_id: '404' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
