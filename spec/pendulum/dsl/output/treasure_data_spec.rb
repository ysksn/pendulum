describe Pendulum::DSL::Output::TreasureData do
  describe 'to_url' do
    let(:dsl) { described_class.new }
    subject   { dsl.to_url }
    before do
      dsl.database 'database'
      dsl.table    'table'
    end
    it { is_expected.to eql('td://@/database/table') }

    context 'when pass mode option' do
      before { dsl.mode :append }
      it { is_expected.to eql('td://@/database/table?mode=append') }
    end
  end
end

