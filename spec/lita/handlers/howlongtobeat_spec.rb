require "spec_helper"

describe Lita::Handlers::Howlongtobeat, lita_handler: true do
  it { is_expected.to route_command("howlongtobeat witcher 3").to(:howlongtobeat) }
  it { is_expected.to route_command("hltp witcher 3").to(:howlongtobeat) }
  it { is_expected.to route_command("hltb witcher 3").to(:howlongtobeat) }

  describe "#howlongtobeat" do
    before :each do
      stub_request(:post, described_class::HowlongtobeatSearch::SEARCH_URL).with(body: {"detail"=>"0", "queryString"=>"sdfdfsfdfds", "sortd"=>"Normal Order", "sorthead"=>"popular", "t"=>"games"}).to_return(File.read('spec/fixtures/nothing_found.txt'))
    end

    context "with a term with results" do
      before :each do
        stub_request(:post, described_class::HowlongtobeatSearch::SEARCH_URL).with(body: {"detail"=>"0", "queryString"=>"witcher 3", "sortd"=>"Normal Order", "sorthead"=>"popular", "t"=>"games"}).to_return(File.read('spec/fixtures/witcher_3.txt'))
      end

      it "returns the title and the main story length" do
        send_command "howlongtobeat witcher 3"
        expect(replies.count).to eq 2
        expect(replies[0]).to match "It will take about 43½ Hours to beat the main story of 'The Witcher 3: Wild Hunt'"
        expect(replies[1]).to match "Source: #{described_class::HowlongtobeatSearch::SITE_URL}/game.php?id=10270"
      end
    end

    context "with a term with no main story results" do
      before :each do
        stub_request(:post, described_class::HowlongtobeatSearch::SEARCH_URL).with(body: {"detail"=>"0", "queryString"=>"legacy of the void", "sortd"=>"Normal Order", "sorthead"=>"popular", "t"=>"games"}).to_return(File.read('spec/fixtures/no_main.txt'))
      end

      it "returns a helpful note" do
        send_command "howlongtobeat legacy of the void"
        expect(replies.count).to eq 1
        expect(replies[0]).to match "No data found for how long it will take to complete the main story of 'StarCraft II: Legacy of the Void'"
      end
    end

    context "with no results" do
      let(:command){'sdfdfsfdfds'}

      before :each do
        stub_request(:post, described_class::HowlongtobeatSearch::SEARCH_URL).with(body: {"detail"=>"0", "queryString"=> command, "sortd"=>"Normal Order", "sorthead"=>"popular", "t"=>"games"}).to_return(File.read('spec/fixtures/nothing_found.txt'))
      end

      it "returns an error" do
        send_command "hltp #{command}"
        expect(replies.count).to eq 1
        expect(replies[0]).to match "No results found for #{command}"
      end
    end
  end
end
