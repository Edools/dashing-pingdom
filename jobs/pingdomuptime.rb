require 'rest-client'
require 'cgi'
require 'json'

api_key = ENV['PINGDOM_API_KEY'] || ''
user = ENV['PINGDOM_USER'] || ''
password = ENV['PINGDOM_PASSWORD'] || ''

config = YAML::load_file('config/pingdom.yml')


# Calculation of Uptime for periodInHour
def calc_uptime(user, password, api_key, id, lastTime, nowTime)
  urlUptime = "https://#{CGI::escape user}:#{CGI::escape password}@api.pingdom.com/api/2.0/summary.average/#{id}?from=#{lastTime}&to=#{nowTime}&includeuptime=true"
  responseUptime = RestClient.get(urlUptime, {"App-Key" => api_key})
  responseUptime = JSON.parse(responseUptime.body, :symbolize_names => true)

  totalUp = responseUptime[:summary][:status][:totalup]
  totalUnknown = responseUptime[:summary][:status][:totalunknown]
  totalDown = responseUptime[:summary][:status][:totaldown]

  uptime = (totalUp.to_f - (totalUnknown.to_f + totalDown.to_f)) * 100 / totalUp.to_f
  uptime.round(2)
end

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '50s', :first_in => 0 do |job|

  # Get the unix timestamps
  t24_hours = 86400 # 24 hours in seconds
  last24_hours = (Time.now.to_i - t24_hours )
  t48_hours = t24_hours * 2
  last48_hours = (Time.now.to_i - t48_hours )
  t72_hours = t24_hours * 3
  last72_hours = (Time.now.to_i - t72_hours )
  nowTime = (Time.now.to_i)

  config['checks'].each do |id|
    uptime_24h = calc_uptime(user, password, api_key, id, last24_hours, nowTime)
    uptime_48h = calc_uptime(user, password, api_key, id, last48_hours, last24_hours)
    uptime_72h = calc_uptime(user, password, api_key, id, last72_hours, last48_hours)

    send_event("pingdom-uptime-#{id}", { current: uptime_24h.to_s + '%',
                                  last: uptime_48h.to_s + '%',
                                  lastlast: uptime_72h.to_s + '%',
                                })

  end

end
