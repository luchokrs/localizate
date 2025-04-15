class WhatsappBroadcastWorker
  include Sidekiq::Worker

  def perform
    stores = Store.includes(:user).where.not(user: { phone: nil })
    
    stores.each do |store|
      phone_number = store.user.phone
      next unless phone_number

      Rails.logger.info "Enviando mensaje a la tienda: #{store.name}"

      # Enviar el mensaje interactivo
      resp = WhatsappService.new.send_interactive_message(phone_number)

      store.update(last_message_sent_at: Time.current, last_response_at: nil)

      if resp == 'Mensaje enviado'
        Rails.logger.info "Mensaje enviado a #{phone_number} con éxito."
      else
        Rails.logger.error "Error al enviar mensaje a #{phone_number}: #{resp}"
      end
    end
  end
end
