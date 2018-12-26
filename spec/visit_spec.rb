require_relative './helper/spec_helper'

describe RoutificApi::Location do
  describe "valid parameters" do
    subject(:visit) { Factory::VISIT }

    it "has id" do
      expect(visit.id).to eq(Factory::VISIT_ID)
    end

    it "has start" do
      expect(visit.start).to eq(Factory::VISIT_START)
    end

    it "has end" do
      expect(visit.end).to eq(Factory::VISIT_END)
    end

    it "has duration" do
      expect(visit.duration).to eq(Factory::VISIT_DURATION)
    end

    it "has load" do
      expect(visit.load).to eq(Factory::VISIT_LOAD)
    end

    it "has priority" do
      expect(visit.priority).to eq(Factory::VISIT_PRIORITY)
    end

    it "has type" do
      expect(visit.type).to eq(Factory::SINGLE_TYPE)
    end

    it "has time_windows" do
      expect(visit.time_windows.kind_of?(Array)).to be(true)
      expect(visit.time_windows[0]).to eq(Factory::TIME_WINDOW)
    end

    describe "#as_json" do
      subject(:visitJSON) { visit.as_json() }

      it "can be reconverted to JSON" do
        expect { visitJSON }.to_not raise_error
      end

      it "has start" do
        expect(visitJSON["start"]).to eq(Factory::VISIT_START)
      end

      it "has end" do
        expect(visitJSON["end"]).to eq(Factory::VISIT_END)
      end

      it "has duration" do
        expect(visitJSON["duration"]).to eq(Factory::VISIT_DURATION)
      end

      it "has load" do
        expect(visitJSON["load"]).to eq(Factory::VISIT_LOAD)
      end

      it "has priority" do
        expect(visitJSON["priority"]).to eq(Factory::VISIT_PRIORITY)
      end

      it "has type" do
        expect(visitJSON["type"]).to eq(Factory::SINGLE_TYPE)
      end

      it "has time_windows" do
        expect(visitJSON["time_windows"]).to eq(Factory::VISIT_TIME_WINDOWS)
      end
    end
  end

  describe "valid multiple type" do
    subject(:visit) { Factory::VISIT_MULTIPLE_TYPE }

    it "has type" do
      expect(visit.type).to eq(Factory::MULTIPLE_TYPE)
    end

    describe "#as_json" do
      subject(:visitJSON) { visit.as_json }

      it "has type" do
        expect(visitJSON["type"]).to eq(Factory::MULTIPLE_TYPE)
      end
    end
  end

  describe "missing location" do
    subject(:visit) { RoutificApi::Visit.new(Faker::Lorem.word, {}) }

    it "raises an error" do
      expect { visit }.to raise_error(ArgumentError)
    end
  end

  describe "missing optional parameters" do
    subject(:visit) { RoutificApi::Visit.new(Faker::Lorem.word, {
      "location" => {
        "lat" => Faker::Address.latitude.to_f,
        "lng" => Faker::Address.longitude.to_f,
      }}) }

    it "does not raise any errors" do
      expect { visit }.to_not raise_error
    end

    describe "#as_json" do
      subject(:visitJSON) { visit.as_json }

      it "does not have start" do
        expect(visitJSON["start"]).to be_nil
      end

      it "does not have end" do
        expect(visitJSON["end"]).to be_nil
      end

      it "does not have duration" do
        expect(visitJSON["duration"]).to be_nil
      end

      it "does not have load" do
        expect(visitJSON["load"]).to be_nil
      end

      it "does not have priority" do
        expect(visitJSON["priority"]).to be_nil
      end

      it "has location" do
        expect(visitJSON["location"]).to_not be_nil
      end
    end
  end
end
