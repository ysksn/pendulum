describe Pendulum::DSL::Output::Postgresql do
  describe 'to_url' do
    let(:dsl) { described_class.new }
    subject   { dsl.to_url }
    before do
      dsl.database 'database'
      dsl.table    'table'
    end
    it { is_expected.to eql('postgresql://@/database/table') }

    context 'when pass user and host' do
      before do
        dsl.username 'user'
        dsl.password 'pass'
        dsl.hostname 'host'
        dsl.port     5432
      end
      it { is_expected.to eql('postgresql://user:pass@host:5432/database/table') }
    end

    context 'when pass options' do
      before do
        dsl.ssl    true
        dsl.schema 'schema'
        dsl.mode   :append
        dsl.method :copy
      end
      it { is_expected.to eql('postgresql://@/database/table?ssl=true&schema=schema&mode=append&method=copy') }
    end
  end
end

