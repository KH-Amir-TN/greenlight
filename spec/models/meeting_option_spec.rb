# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MeetingOption, type: :model do
  describe 'validations' do
    it { is_expected.to have_many(:room_meeting_options).dependent(:restrict_with_exception) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'classs methods' do
    describe '#bbb_options' do
      it 'returns all non-greenlight options' do
        room = create(:room)
        setting1 = create(:meeting_option, name: 'glSetting1')
        setting2 = create(:meeting_option, name: 'glSetting2')
        setting3 = create(:meeting_option, name: 'setting1')
        setting4 = create(:meeting_option, name: 'setting2')

        create(:room_meeting_option, room:, meeting_option: setting1)
        create(:room_meeting_option, room:, meeting_option: setting2)
        room_option1 = create(:room_meeting_option, room:, meeting_option: setting3, value: 'value1')
        room_option2 = create(:room_meeting_option, room:, meeting_option: setting4, value: 'value2')

        expect(
          described_class.bbb_options(room_id: room.id)
        ).to eq([
                  [setting3.name, room_option1.value],
                  [setting4.name, room_option2.value]
                ])
      end
    end

    describe '#get_setting_value' do
      context 'existing setting' do
        it 'returns the room meeting option value' do
          room = create(:room)

          meeting_option1 = create(:meeting_option, name: 'setting')
          create(:room_meeting_option, room:, meeting_option: meeting_option1, value: 'value1')

          room_meeting_option = described_class.get_setting_value(name: 'setting', room_id: room.id)

          expect(room_meeting_option.value).to eq('value1')
        end
      end

      context 'inexisting setting' do
        it 'returns nil' do
          expect(
            described_class.get_setting_value(name: 'notASettingTrustMe', room_id: 'YouAlreadyTrustedMe')
          ).to be_nil
        end
      end
    end

    describe '#get_config_value' do
      context 'existing configuration' do
        it 'returns the rooms configuration value' do
          meeting_option = create(:meeting_option, name: 'setting')
          create(:rooms_configuration, meeting_option:, provider: 'greenlight', value: 'optional')

          rooms_config = described_class.get_config_value(name: 'setting', provider: 'greenlight')
          expect(rooms_config.value).to eq('optional')
        end
      end

      context 'inexisting configuration' do
        it 'returns nil' do
          expect(
            described_class.get_config_value(name: 'notAConfigTrustMe', provider: 'YouShould\'ve')
          ).to be_nil
        end
      end
    end

    describe '#access_codes_configs' do
      it 'returns the access codes configs pluck(:name, :value)' do
        viewer_code_conf = create(:meeting_option, name: 'glViewerAccessCode')
        moderator_code_conf = create(:meeting_option, name: 'glModeratorAccessCode')
        create(:rooms_configuration, meeting_option: viewer_code_conf, provider: 'greenlight', value: 'true')
        create(:rooms_configuration, meeting_option: moderator_code_conf, provider: 'greenlight', value: 'false')

        res = described_class.access_codes_configs(provider: 'greenlight')
        expect(res).to match_array([%w[glViewerAccessCode true], %w[glModeratorAccessCode false]])
      end
    end
  end
end
