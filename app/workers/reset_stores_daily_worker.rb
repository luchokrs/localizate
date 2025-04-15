class ResetStoresDailyWorker
  include Sidekiq::Worker

  def perform
    Store.update_all(status: 2, last_response_at: nil, last_message_sent_at: nil)
    Rails.logger.info "Todas las tiendas marcadas como cerradas a las 12:01 AM."
  end
end