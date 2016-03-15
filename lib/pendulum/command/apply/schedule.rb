module Pendulum::Command
  class Apply
    class Schedule
      attr_accessor :client, :from, :to, :dry_run, :force
      def initialize(client, from, to, dry_run=false, force=false)
        self.client  = client
        self.from    = from
        self.to      = to
        self.dry_run = dry_run
        self.force   = force
      end

      def apply
        case
        when will_create? then create
        when will_update? then update
        when will_delete? then delete
        end
      end

      def create
        puts message_with_dry_run(message_for_create)
        client.create_schedule(to.name, to.to_params) unless dry_run?
      end

      def update
        puts message_with_dry_run(message_for_update)
        puts message_for_diff
        if force? || has_diff?
          client.update_schedule(to.name, to.to_params) unless dry_run?
        end
      end

      def delete
        puts message_with_dry_run(message_for_delete)
        client.update_schedule(from.name) if force? && !dry_run?
      end

      private

      def will_create?
        !from && to
      end

      def will_update?
        from && to
      end

      def will_delete?
        from && !to
      end

      def has_diff?
        !diff.empty?
      end

      def diff
        return {} unless will_update?

        @diff ||= begin
                    default_params.merge(to.to_params).select do |k, v|
                      if k == :result_url
                        result_url_changed?(from.result_url, v)
                      else
                        v != from.send(k)
                      end
                    end
                  end
      end

      def message_for_create
        message_for(:create)
      end

      def message_for_update
        if force? || has_diff?
          message_for(:update)
        else
          "No change schedule: #{name}"
        end
      end

      def message_for_delete
        if force?
          message_for(:delete)
        else
          "Undefined schedule (pass `--force` if you want to remove): #{name}"
        end
      end

      def message_with_dry_run(message)
        message += ' (dry-run)' if dry_run?
        message
      end

      def message_for(action)
        "#{action.to_s.capitalize} schedule: #{name}"
      end

      def message_for_diff
        diff.map do |name, value|
          "  set #{name}=#{value}"
        end.join("\n")
      end

      def name
        from.name || to.name
      end

      def dry_run?
        dry_run
      end

      def force?
        force
      end

      def default_params
        {
          database:    '',
          query:       nil,
          retry_limit: 0,
          priority:    0,
          cron:        nil,
          timezone:    'Asia/Tokyo', # TODO: require timezone.
          delay:       0,
          result_url:  ''
        }
      end

      def result_url_changed?(from_url, to_url)
        Apply::ResultURL.new(from_url, to_url).changed?
      end
    end
  end
end

