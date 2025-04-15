set :output, "log/cron.log"
set :environment, 'development'

job_type :custom_runner, "cd :path && /home/lucho-krs/snap/code/187/.local/share/mise/installs/ruby/3.4.2/bin/bundle exec bin/rails runner -e :environment ':task'"

every 1.day, at: '8:00 am' do
  custom_runner "Rails.logger.info '🔥 CRON ejecutado a las #{Time.now}'"
  custom_runner "WhatsappBroadcastWorker.perform_async"
end

every 20.minutes do
  custom_runner "CloseUnresponsiveStoresWorker.perform_async"
end

every 1.day, at: '12:01 am' do
  custom_runner "ResetStoresDailyWorker.perform_async"
end