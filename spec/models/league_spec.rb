# == Schema Information
#
# Table name: leagues
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
end
