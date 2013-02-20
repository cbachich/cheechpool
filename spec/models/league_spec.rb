# == Schema Information
#
# Table name: leagues
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  current_week         :integer          default(0)
#  picksheet_close_date :datetime
#

require 'spec_helper'

describe League do

  before { @league = League.new(name: "Example League") }

  subject { @league }

  it { should respond_to(:name) }

  it { should be_valid }

  describe "when name is not present" do
    before { @league.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @league.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      league_with_same_name = @league.dup
      league_with_same_name.name = @league.name.upcase
      league_with_same_name.save
    end

    it { should_not be_valid }
  end
end
