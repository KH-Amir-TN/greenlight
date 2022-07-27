# frozen_string_literal: true

class RoomSettingsGetter
  # Special options are meeting options that have different values other than `true|false` to represent postives and negatives.
  # The `special_options` hash is a registry that keeps hold of all of the special options used in GL3 along with their postive and negative values.
  # When adding a new special option just register it in this Hash respecting the fallowing format:
  # Hash(`<option_name> => {'true' => <Postive>, 'false' => <Negative>})`
  SPECIAL_OPTIONS = { 'guestPolicy' => { 'true' => 'ASK_MODERATOR', 'false' => 'ALWAYS_ACCEPT' } }.freeze

  def initialize(room_id:, provider:, prefix: '')
    @room_id = room_id
    @prefix = prefix
    @rooms_configs = MeetingOption.joins(:rooms_configurations)
                                  .where(rooms_configurations: { provider: })
                                  .pluck(:name, :value)
                                  .to_h
  end

  def call
    room_settings = MeetingOption.joins(:room_meeting_options)
                                 .where.not('name ILIKE :prefix', prefix: @prefix)
                                 .where(room_meeting_options: { room_id: @room_id })
                                 .pluck(:name, :value)
                                 .to_h

    room_settings.to_h { |name, value| get_setting(name, value) }
  end

  private

  def get_setting(name, value)
    config = @rooms_configs[name]

    if %w[true false].include?(config)
      forced_value = if SPECIAL_OPTIONS.key? name
                       SPECIAL_OPTIONS[name][config]
                     else
                       config
                     end
      return [name, forced_value]
    end

    [name, value]
  end
end
