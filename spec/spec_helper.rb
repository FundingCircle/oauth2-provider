require 'rubygems'
require 'bundler/setup'

require 'active_record'
require 'songkick/oauth2/provider'

require 'pry'

# inlined the DB drop/create/connect process here to avoid rewriting this whole implementation
test_db_config = {
  'adapter'  => 'postgresql',
  'host'     => '127.0.0.1',
  'username' => 'postgres',
  'database' => 'oauth2_test'
}
tasks = ActiveRecord::Tasks::PostgreSQLDatabaseTasks.new(test_db_config)
tasks.drop
tasks.create
ActiveRecord::Base.establish_connection(test_db_config)

require 'logger'
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::INFO

Songkick::OAuth2::Model::Schema.up

ActiveRecord::Schema.define do |version|
  create_table :users, :force => true do |t|
    t.string :name
  end
end

require 'test_app/provider/application'
require 'request_helpers'
require 'factories'

require 'thin'
Thin::Logging.silent = true
$VERBOSE = nil

RSpec.configure do |config|
  # to run only specific specs, add :focus to the spec
  #   describe "foo", :focus do
  # OR
  #   it "should foo", :focus do
  config.treat_symbols_as_metadata_keys_with_true_values = true # default in rspec 3
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before do
    Songkick::OAuth2::Provider.enforce_ssl = false
    time = Time.now
    Time.stub(:now).and_return time
  end

  config.after do
    [ Songkick::OAuth2::Model::Client,
      Songkick::OAuth2::Model::Authorization,
      TestApp::User

    ].each { |k| k.delete_all }
  end
end

def create_authorization(params)
  Songkick::OAuth2::Model::Authorization.__send__(:create) do |authorization|
    params.each do |key, value|
      authorization.__send__ "#{key}=", value
    end
  end
end

