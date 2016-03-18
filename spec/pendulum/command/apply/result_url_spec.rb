describe Pendulum::Command::Apply::ResultURL do
  describe '#changed?' do
    let(:result_url) { described_class.new(client, from, to) }
    subject          { result_url.changed? }

    let(:client)     { nil }

    context 'when no change' do
      let(:from) { 'td://@/database/table' }
      let(:to)   { 'td://@/database/table' }

      it { is_expected.to be false }

      context 'with query params (ignore params order)' do
        let(:from) { 'td://@/database/table?a=b&c=d' }
        let(:to)   { 'td://@/database/table?c=d&a=b' }

        it { is_expected.to be false }
      end

      context 'when define custom result in to_url' do
        let(:from) { 'td://@/database/table?a=b&c=d' }
        let(:to)   { 'name:table' }
        let(:client) do
          client = TreasureData::Client.new('')
          allow(client).to receive(:results).and_return(
            [Hashie::Mash.new(name: 'name', url: 'td://@/database?c=d&a=b')]
          )
          client
        end
        it { is_expected.to be false }
      end
    end

    context 'when change' do
      let(:from) { 'td://@/database/table' }
      let(:to)   { 'td://@/database/table1' }

      it { is_expected.to be true }

      context 'with query params (ignore params order)' do
        let(:from) { 'td://@/database/table?a=b&c=d' }
        let(:to)   { 'td://@/database/table?c=d&a=bbbbb' }

        it { is_expected.to be true }
      end

      context 'when define custom result in to_url' do
        let(:from) { 'td://@/database/table?a=b&c=d' }
        let(:to)   { 'name:table1' }
        let(:client) do
          client = TreasureData::Client.new('')
          allow(client).to receive(:results).and_return(
            [Hashie::Mash.new(name: 'name', url: 'td://@/database?c=d&a=b')]
          )
          client
        end
        it { is_expected.to be true }
      end
    end
  end
end
