require 'spec_helper'
require 'cloudinary'

describe Cloudinary::Api do
  PREDEFINED_PROFILES = ["4k", "full_hd", "hd", "sd", "full_hd_wifi", "full_hd_lean", "hd_lean"]
  break puts("Please setup environment for api test to run") if Cloudinary.config.api_secret.blank?
  include_context "cleanup", TIMESTAMP_TAG

  prefix = TEST_TAG + "_#{Time.now.to_i}"
  test_id_1 = "#{prefix}_1"
  test_id_2 = "#{prefix}_2"
  test_id_3 = "#{prefix}_3"
  before(:all) do

    @api = Cloudinary::Api
  end

  describe 'create_streaming_profile' do
    it "should create a streaming profile with representations" do
      result = @api.create_streaming_profile test_id_1, :representations =>
          [{:transformation => {:crop => 'scale', :width => "1200", :height => "1200", :bit_rate => "5m"}}]
      expect(result).not_to be_blank
    end
  end

  describe 'list_streaming_profile' do
    it "should list streaming profile" do
      result = @api.list_streaming_profiles
      expect(result).to have_key('profiles')
      expect(result['profiles'].map{|p| p['name']}).to include(*PREDEFINED_PROFILES)
    end
  end

  describe 'delete_streaming_profile' do
    it "should delete a streaming profile" do
      result = @api.create_streaming_profile test_id_2, :representations =>
          [{:transformation => {:crop => 'scale', :width => "1200", :height => "1200", :bit_rate => "5m"}}]
      expect(result).not_to be_blank
      result = @api.delete_streaming_profile test_id_2
      expect(result).to have_key('message')
      expect(result['message']).to eq("deleted")
      result = @api.list_streaming_profiles
      expect(result['profiles'].map{|p| p['name']}).not_to include(test_id_2)
    end
  end

  describe 'get_streaming_profile' do
    it "should get a specific streaming profile" do
      result = @api.get_streaming_profile(PREDEFINED_PROFILES[1])
      expect(result.keys).to include('name', 'display_name', 'representations')
    end
  end
end