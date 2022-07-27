# frozen_string_literal: true

require 'rails_helper'

describe RoomSettingsGetter, type: :service do
  describe '#call' do
    context 'Normal room settings' do
      it 'returns a Hash("name" => "value") of room settings according to the configurations' do
        room = create(:room)
        setting1 = create(:meeting_option, name: 'setting1')
        setting2 = create(:meeting_option, name: 'setting2')
        setting3 = create(:meeting_option, name: 'setting3')

        create(:room_meeting_option, room:, meeting_option: setting1, value: 'value1')
        create(:room_meeting_option, room:, meeting_option: setting2, value: 'value2')
        create(:room_meeting_option, room:, meeting_option: setting3, value: 'value3')

        create(:rooms_configuration, meeting_option: setting1, provider: 'greenlight', value: 'true')
        create(:rooms_configuration, meeting_option: setting2, provider: 'greenlight', value: 'optional')
        create(:rooms_configuration, meeting_option: setting3, provider: 'greenlight', value: 'false')

        res = described_class.new(room_id: room.id, provider: 'greenlight').call

        expect(res).to eq({
                            'setting1' => 'true',
                            'setting2' => 'value2',
                            'setting3' => 'false'
                          })
      end
    end

    context 'special room settings' do
      it 'returns a Hash("name" => "value") of room settings according to the configurations' do
        stub_const('RoomSettingsGetter::SPECIAL_OPTIONS', {
                     'IamSpecial!' => { 'true' => 'SPECIAL_FORCE', 'false' => 'NOT_SPECIAL' },
                     'IamSpecialToo!!' => { 'true' => 'SPECIAL_FORCE', 'false' => 'NOT_SPECIAL' },
                     'KingOfSpecials!!!' => { 'true' => 'SPECIAL_FORCE', 'false' => 'NOT_SPECIAL' }
                   })
        room = create(:room)
        setting1 = create(:meeting_option, name: 'IamSpecial!')
        setting2 = create(:meeting_option, name: 'IamSpecialToo!!')
        setting3 = create(:meeting_option, name: 'KingOfSpecials!!!')

        create(:room_meeting_option, room:, meeting_option: setting1, value: 'SPECIAL')
        create(:room_meeting_option, room:, meeting_option: setting2, value: 'SPECIAL')
        create(:room_meeting_option, room:, meeting_option: setting3, value: 'SPECIAL')

        create(:rooms_configuration, meeting_option: setting1, provider: 'greenlight', value: 'true')
        create(:rooms_configuration, meeting_option: setting2, provider: 'greenlight', value: 'optional')
        create(:rooms_configuration, meeting_option: setting3, provider: 'greenlight', value: 'false')

        res = described_class.new(room_id: room.id, provider: 'greenlight').call

        expect(res).to eq({
                            'IamSpecial!' => 'SPECIAL_FORCE',
                            'IamSpecialToo!!' => 'SPECIAL',
                            'KingOfSpecials!!!' => 'NOT_SPECIAL'
                          })
      end
    end

    context 'prefix' do
      it 'returns a filtered Hash("name" => "value") of room settings that does not start with a :prefix' do
        room = create(:room)
        setting1 = create(:meeting_option, name: 'badSetting')
        setting2 = create(:meeting_option, name: 'BAdBAdSetting')
        setting3 = create(:meeting_option, name: 'YourOnlyGoodSetting')

        create(:room_meeting_option, room:, meeting_option: setting1, value: 'bad')
        create(:room_meeting_option, room:, meeting_option: setting2, value: 'bad')
        create(:room_meeting_option, room:, meeting_option: setting3, value: 'good')

        create(:rooms_configuration, meeting_option: setting1, provider: 'greenlight', value: 'optional')
        create(:rooms_configuration, meeting_option: setting2, provider: 'greenlight', value: 'optional')
        create(:rooms_configuration, meeting_option: setting3, provider: 'greenlight', value: 'optional')

        res = described_class.new(room_id: room.id, provider: 'greenlight', prefix: 'bad%').call

        expect(res).to eq({
                            'YourOnlyGoodSetting' => 'good'
                          })
      end
    end
  end
end
