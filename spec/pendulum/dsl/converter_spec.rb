describe Pendulum::DSL::Converter do
  describe '#convert' do
    let(:converter) { described_class.new([Hashie::Mash.new(schedule)]) }
    let(:default_schedule) do
      {
        name:       'name',
        database:   'database',
        result_url: ''
      }
    end

    describe 'schedule' do
      subject { converter.convert[:schedule] }

      let(:schedule) { default_schedule }
      it do
        is_expected.to eql(<<-EOS)
schedule 'name' do
  database    'database'
end
        EOS
      end

      context 'when has query' do
        let(:schedule) do
          default_schedule.merge(
            query:      'select time from access;',
            retry_limit: 0,
            priority:    0
          )
        end

        it do
          is_expected.to eql(<<-EOS)
schedule 'name' do
  database    'database'
  query_file  'queries/name.hql'
  # type      :hive # FIXME: Treasure Data schedule api dosen't contain type result.
  retry_limit 0
  priority    0
end
          EOS
        end
      end

      context 'when has cron' do
        let(:schedule) do
          default_schedule.merge(
            cron:     '* * * * *',
            timezone: 'Asia/Tokyo',
            delay:    0
          )
        end

        it do
          is_expected.to eql(<<-EOS)
schedule 'name' do
  database    'database'
  cron        '* * * * *'
  timezone    'Asia/Tokyo'
  delay       0
end
          EOS
        end
      end

      context 'when has result_url' do
        let(:schedule) do
          default_schedule.merge(
            result_url: 'td://@/database/table'
          )
        end

        it do
          is_expected.to eql(<<-EOS)
schedule 'name' do
  database    'database'
  result_url  'td://@/database/table'
end
          EOS
        end
      end
    end
    describe 'queries' do
      subject { converter.convert[:queries] }

      let(:schedule) { default_schedule }
      it { is_expected.to be_empty }

      context 'when has query' do
        let(:schedule) do
          default_schedule.merge(
            query:      'select time from access;',
            retry_limit: 0,
            priority:    0
          )
        end

        it { is_expected.to eql([name: 'name.hql', query: 'select time from access;']) }
      end
    end
  end
end
