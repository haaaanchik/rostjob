module Cmd
  module Profile
    module Settings
      class Update
        include Interactor

        def call
          settings_hash.each do |name, value|
            bool_val = !value.to_i.zero?
            current_profile.settings(:general).update!(name => bool_val)
          end
        end

        private

        def current_profile
          context.profile
        end

        def settings_hash
          context.settings_hash
        end
      end
    end
  end
end