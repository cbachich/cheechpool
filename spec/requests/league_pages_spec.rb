require 'spec_helper'

describe "League pages" do

  subject { page }

  describe "league page" do
    let(:league) { FactoryGirl.create(:league) }
    before { visit league_path(league) }

    it { should have_selector('h1',    text: league.name) }
    it { should have_selector('title', text: league.name) }
  end

  describe "create page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit new_league_path
    end

    it { should have_selector('h1',    text: 'Create League') }
    it { should have_selector('title', text: 'Create League') }

    let(:submit) { "Create new league" }
    describe "with invalid information" do
      it "should not create a league" do
        expect { click_button submit }.not_to change(League, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example League"
      end

      it "should create a league" do
        expect { click_button submit }.to change(League, :count).by(1)
      end
    end 
  end
end
