# frozen_string_literal: true

module Api
  module V1
    module Entities
      module Profiles
        class Logo < Api::V1::Entities::Base
          expose(:short_name,
                 documentation: {
                   desc: 'Company name.',
                   type: String
                 }
          ) do |profile|
            profile.company.short_name
          end

          expose(:logo_url,
                 documentation: {
                   desc: 'Company logo.',
                   type: String
                 }
          ) do |profile, options|
            "#{options[:base_url]}#{profile.photo.url}"
          end
        end
      end
    end
  end
end




