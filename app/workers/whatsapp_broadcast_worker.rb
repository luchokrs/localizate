class WhatsappBroadcastWorker
  include Sidekiq::Worker

  def perform
    stores = Store.includes(:user).where.not(user: { phone: nil })
    
    stores.each do |store|
      phone_number = store.user.phone
      next unless phone_number

      # Enviar el mensaje interactivo
      resp = WhatsappService.new.send_interactive_message(phone_number)

      if resp == 'Mensaje enviado'
        Rails.logger.info "Mensaje enviado a #{phone_number} con éxito."
      else
        Rails.logger.error "Error al enviar mensaje a #{phone_number}: #{resp}"
      end
    end
  end
end
