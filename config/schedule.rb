every :day, at: '09:00 am' do
  runner "WhatsappBroadcastWorker.perform_async"
end