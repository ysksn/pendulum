describe Pendulum::Command::Apply::Schedule do
  describe '#apply' do
    let(:schedule) { described_class.new(client, from, to, dry_run, force, color) }
    subject        { schedule.apply }

    let(:client)  { nil }
    let(:dry_run) { false }
    let(:force)   { false }
    let(:color)   { false }

    context 'when schedule created' do
      let(:client) do
        client = double('TreasureData::Client')
        expect(client).to receive(:create_schedule).and_return(true).once
        expect(client).to receive(:update_schedule).and_return(true).exactly(0).times
        expect(client).to receive(:delete_schedule).and_return(true).exactly(0).times
        client
      end
      let(:from) { nil }
      let(:to)   { Pendulum::DSL::Schedule.new('name') }

      it { is_expected.to be true }
    end

    context 'when schedule no change' do
      let(:client) do
        client = double('TreasureData::Client')
        expect(client).to receive(:create_schedule).and_return(true).exactly(0).times
        expect(client).to receive(:update_schedule).and_return(true).exactly(0).times
        expect(client).to receive(:delete_schedule).and_return(true).exactly(0).times
        client
      end

      let(:from) do
        default = Pendulum::Command::Apply::Schedule.new(nil, nil, nil)
          .send(:default_params)
        from = Hashie::Mash.new({name: 'name'}.merge(default))
        from.result_url = from.result
        from
      end
      let(:to)   { Pendulum::DSL::Schedule.new('name') }

      it { is_expected.to be_nil }

      context 'with force option' do
        let(:force) { true }
        let(:client) do
          client = double('TreasureData::Client')
          expect(client).to receive(:create_schedule).and_return(true).exactly(0).times
          expect(client).to receive(:update_schedule).and_return(true).once
          expect(client).to receive(:delete_schedule).and_return(true).exactly(0).times
          client
        end
        it { is_expected.to be true }
      end
    end

    context 'when schedule changed' do
      let(:client) do
        client = double('TreasureData::Client')
        expect(client).to receive(:create_schedule).and_return(true).exactly(0).times
        expect(client).to receive(:update_schedule).and_return(true).once
        expect(client).to receive(:delete_schedule).and_return(true).exactly(0).times
        client
      end

      let(:from) do
        default = Pendulum::Command::Apply::Schedule.new(nil, nil, nil)
          .send(:default_params)
        from = Hashie::Mash.new({name: 'name'}.merge(default))
        from.result_url = from.result
        from
      end
      let(:to) do
        to = Pendulum::DSL::Schedule.new('name')
        to.cron '* * * * *'
        to
      end

      it { is_expected.to be true }
    end

    context 'when schedule deleted' do
      let(:from) { Hashie::Mash.new(name: 'name') }
      let(:to)   { nil }

      let(:client) do
        client = double('TreasureData::Client')
        expect(client).to receive(:create_schedule).and_return(true).exactly(0).times
        expect(client).to receive(:update_schedule).and_return(true).exactly(0).times
        expect(client).to receive(:delete_schedule).and_return(true).exactly(0).times
        client
      end
      it { is_expected.to be_nil }

      context 'with force option' do
        let(:force) { true }
        let(:client) do
          client = double('TreasureData::Client')
          expect(client).to receive(:create_schedule).and_return(true).exactly(0).times
          expect(client).to receive(:update_schedule).and_return(true).exactly(0).times
          expect(client).to receive(:delete_schedule).and_return(true).once
          client
        end
        it { is_expected.to be true }
      end
    end
  end
end
