require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let (:wiki) { create(:wiki) }

  describe "attributes" do
    it "has title, body, public, and user attributes" do
      expect(wiki).to have_attributes(title: wiki.title, body: wiki.body, user: wiki.user)
    end
  end
  
end
