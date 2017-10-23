VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_hosts 'codeclimate.com'
  c.default_cassette_options = { record: :new_episodes }
  c.allow_http_connections_when_no_cassette = true
  c.configure_rspec_metadata!
end

