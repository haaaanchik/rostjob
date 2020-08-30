module Cmd
  module OrderTemplate
    class Create
      include Interactor::Organizer

      organize Cmd::Price::ParamsWithPrice,
               Cmd::OrderTemplate::ToCreate,
               Cmd::OrderTemplate::FirstOrderTemplateCreate

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        end
      end
    end
  end
end
