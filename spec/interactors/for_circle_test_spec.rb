require 'rails_helper'

RSpec.feature 'ForCricleTestSpec', type: :interactor do
  describe "create candidate" do
    it { expect(Date.today).to eq(Date.today) }
  end
end