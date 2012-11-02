require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { "CheechPool" }

  describe "Home page" do

    it "should have the h1 'CheechPool'" do
      visit root_path
      page.should have_selector('h1', :text => 'CheechPool')
    end

    it "should have the base title'" do
      visit root_path
      page.should have_selector('title', :text => "#{base_title}")
    end

    it "should not have a custom page title" do
      visit root_path
      page.should_not have_selector('title', :text => '| Home')
    end
  end

  describe "Help page" do

   it "should have the h1 'Help'" do
      visit help_path
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the title 'Help'" do
      visit help_path
      page.should have_selector('title', :text => "#{base_title} | Help")
    end 
  end

  describe "About page" do

    it "should have the h1 'About Us'" do
      visit about_path
      page.should have_selector('h1', :text => 'About Us')
    end

    it "should have the title 'About Us'" do
      visit about_path
      page.should have_selector('title', :text => "#{base_title} | About Us")
    end  
  end

  describe "Contact page" do

   it "should have the h1 'Contact'" do
      visit contact_path
      page.should have_selector('h1', :text => 'Contact Us')
    end

    it "should have the title 'Contact'" do
      visit contact_path
      page.should have_selector('title', :text => "#{base_title} | Contact Us")
    end 
  end
end
