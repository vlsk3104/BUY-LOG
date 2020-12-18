require 'rails_helper'

RSpec.describe Genre, type: :model do
  let!(:genre) { create(:genre) }

  it "有効な状態であること" do
    expect(genre).to be_valid
  end
end