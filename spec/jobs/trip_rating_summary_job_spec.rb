require "rails_helper"

RSpec.describe TripRatingSummaryJob, type: :job do
  describe "#perform" do
    subject(:run_job) { described_class.new.perform }

    context "when trips with various ratings exist" do
      before do
        allow(Trip).to receive(:group).with(:rating).and_return(
          double(count: { 1 => 2, 2 => 0, 3 => 5, 4 => 3, 5 => 1 })
        )
        allow(Trip).to receive(:average).with(:rating).and_return(BigDecimal("3.09"))
      end

      it "logs a summary containing the report header" do
        expect(Rails.logger).to receive(:info) do |message|
          expect(message).to include("Nightly Trip Rating Summary")
        end
        run_job
      end

      it "logs the correct total number of trips" do
        expect(Rails.logger).to receive(:info) do |message|
          expect(message).to include("Total trips : 11")
        end
        run_job
      end

      it "logs a line for every rating from 1 to 5" do
        expect(Rails.logger).to receive(:info) do |message|
          (1..5).each { |star| expect(message).to include("#{star} star") }
        end
        run_job
      end

      it "logs the correct average rating" do
        expect(Rails.logger).to receive(:info) do |message|
          expect(message).to include("Average     : 3.09")
        end
        run_job
      end
    end

    context "when there are no trips" do
      before do
        allow(Trip).to receive(:group).with(:rating).and_return(double(count: {}))
        allow(Trip).to receive(:average).with(:rating).and_return(nil)
      end

      it "logs a summary with zero total" do
        expect(Rails.logger).to receive(:info) do |message|
          expect(message).to include("Total trips : 0")
          expect(message).to include("Average     : 0.0")
        end
        run_job
      end
    end
  end

  describe "job configuration" do
    it "is enqueued on the default queue" do
      expect(described_class.new.queue_name).to eq("default")
    end
  end
end

