require 'rubygems'
require 'geminabox'

Geminabox.data = '/opt/geminabox/data'
Geminabox.build_legacy = ENV['BUILD_LEGACY'] && ENV['BUILD_LEGACY'].downcase.strip == 'true'

#carry on providing gems when rubygems.org is unavailable
if ENV['GEMS_STOP_ON_RUBYGEMS_FAILURE']
  Geminabox.allow_remote_failure = false
else
  Geminabox.allow_remote_failure = true
fi

if ENV['GEMS_USERNAME'].nil? ||  ENV['GEMS_PASSWORD'].nil?
  fail 'Please configure credentials with GEMS_USERNAME and GEMS_PASSWORD'
end

def generate_random_key(length = 40)
  range = [*'0'..'9',*'A'..'Z',*'a'..'z']
  Array.new(length){ range.sample }.join
end

API_KEY = ENV.fetch("GEMS_API_KEY", generate_random_key)
$stdout.sync = true
puts "API_KEY set to: #{API_KEY}"
$stdout.sync = false

Geminabox::Server.helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Geminabox")
      halt 401, "No pushing or deleting without auth.\n"
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials &&
       @auth.credentials == [ENV['GEMS_USERNAME'], ENV['GEMS_PASSWORD']]
  end

end

Geminabox::Server.before '/upload' do
  protected!
end

Geminabox::Server.before do
  protected! if request.delete?
end

Geminabox::Server.before '/api/v1/gems' do
  unless env['HTTP_AUTHORIZATION'] == API_KEY
    halt 401, "Access Denied. Api_key invalid or missing.\n"
  end
end

run Geminabox::Server
