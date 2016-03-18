# Pendulum [![Build Status](https://travis-ci.org/monochromegane/pendulum.svg?branch=master)](https://travis-ci.org/monochromegane/pendulum)

Pendulum is a tool to manage Treasure Data scheduled jobs.

It defines the state of Treasure Data scheduled jobs using DSL, and updates the jobs according as DSL.

## Usage

```sh
# Export from Treasure Data
$ pendulum --apikey='...' -e -o Schedfile

# Update Schedfile
$ vi Schedfile

# Apply scheduled jobs
$ pendulum --apikey='...' -a --dry-run
$ pendulum --apikey='...' -a
```

## Schedfile

```rb
schedule 'test-scheduled-job' do
  database    'db_name'
  query       'select time from access;'
  retry_limit 0
  priority    :normal
  cron        '30 0 * * *'
  timezone    'Asia/Tokyo'
  delay       0
  result      'td://@/db_name/table_name'
end
```

#### query_file

If your query is long, you can specify `query_file`.

```rb
query_file 'queries/test-scheduled-job.hql'
```

#### result

You can use `result` DSL instead of `result_url`.

```rb
schedule 'test-scheduled-job' do
  database   'db_name'
  ...
  result :td do
    database 'db_name'
    table    'table_name'
  end
end
```

Now, Pendulum supports `td` and `postgresql` result export.
If you want to use other result export, please send pull request :smile:

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pendulum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pendulum

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/monochromegane/pendulum.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

