require 'rails_helper'

describe TimeDisplayHelper do

  describe "#display_interview_datetime" do
    it "returns true" do
      expect(helper.display_interview_datetime(DateTime.new(2014, 12, 1, 17, 0))).to eq "hari Senin tanggal 1 Desember 2014 jam 5:00 sore"
    end

    it "returns true" do
      expect(helper.display_interview_datetime(DateTime.new(2014, 12, 1, 12, 0))).to eq "hari Senin tanggal 1 Desember 2014 jam 12:00 siang"
    end

    it "returns true" do
      expect(helper.display_interview_datetime(DateTime.new(2014, 12, 1, 9, 0))).to eq "hari Senin tanggal 1 Desember 2014 jam 9:00 pagi"
    end
  end

  describe "#display_interview_time" do
    it "returns true" do
      expect(helper.display_interview_time(DateTime.new(2014, 12, 1, 17, 0))).to eq "jam 5:00 sore"
    end

    it "returns true" do
      expect(helper.display_interview_time(DateTime.new(2014, 12, 1, 12, 0))).to eq "jam 12:00 siang"
    end

    it "returns true" do
      expect(helper.display_interview_time(DateTime.new(2014, 12, 1, 9, 0))).to eq "jam 9:00 pagi"
    end
  end

  describe "#display_zone" do
    it "returns true" do
      expect(helper.display_zone(DateTime.new(2012, 1, 1, 10, 0))).to eq 'pagi'
      expect(helper.display_zone(DateTime.new(2012, 1, 1, 12, 0))).to eq 'siang'
      expect(helper.display_zone(DateTime.new(2012, 1, 1, 14, 0))).to eq 'siang'
      expect(helper.display_zone(DateTime.new(2012, 1, 1, 15, 0))).to eq 'sore'
      expect(helper.display_zone(DateTime.new(2012, 1, 1, 9, 0))).to eq 'pagi'
    end
  end

end
