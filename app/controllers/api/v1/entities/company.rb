# frozen_string_literal: true

module Api
  module V1
    module Entities
      class Company < Api::V1::Entities::Base
        expose :name,
               documentation: {
                 desc: 'Name.',
                 type: String
               }
        expose :short_name,
               documentation: {
                 desc: 'Short name.',
                 type: String
               }
        expose :address,
               documentation: {
                 desc: 'Address.',
                 type: String
               }
        expose :mail_address,
               documentation: {
                 desc: 'Mailing address.',
                 type: String
               }
        expose :phone,
               documentation: {
                 desc: 'Phone.',
                 type: String
               }
        expose :fax,
               documentation: {
                 desc: 'Fax.',
                 type: String
               }
        expose :email,
               documentation: {
                 desc: 'Email.',
                 type: String
               }
        expose :ogrn,
               documentation: {
                 desc: 'Ogrn.',
                 type: String
               }
        expose :inn,
               documentation: {
                 desc: 'Inn.',
                 type: String
               }
        expose :kpp,
               documentation: {
                 desc: 'Kpp.',
                 type: String
               }
        expose :director,
               documentation: {
                 desc: 'Director.',
                 type: String
               }
        expose :acts_on,
               documentation: {
                 desc: 'Acts on the basis.',
                 type: String
               }
        expose :created_at, format_with: :iso8601, documentation: {
          type: DateTime,
          desc: 'Company create time in iso8601 format.'
        }
        expose :updated_at, format_with: :iso8601, documentation: {
          type: DateTime,
          desc: 'Company update time in iso8601 format.'
        }
      end
    end
  end
end
