require 'pingdom-ruby'
require 'time_diff'

api_key = ENV['PINGDOM_API_KEY'] || ''
user = ENV['PINGDOM_USER'] || ''
password = ENV['PINGDOM_PASSWORD'] || ''

config = YAML::load_file('config/pingdom.yml')

def calculate_difference date1, date2
  t = Time.diff(date1, date2)
  "#{t[:day]}d #{t[:hour]}h #{t[:minute]}m"
end

client = Pingdom::Client.new :username => user, :password => password, :key => api_key


# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '50s', :first_in => 0 do |job|
  config['checks'].each do |id|
    check = client.check(id)
    response_time = check.last_response_time
    status = check.status
    last_downtime = calculate_difference(Time.now, Time.at(check.last_error_time))

    send_event("pingdom-status-#{id}", { current: status,
                                  last_downtime: last_downtime,
                                  response_time: response_time.to_s + 'ms'})
  end
end
