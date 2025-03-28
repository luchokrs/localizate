class WhatsappBroadcastWorker
  include Sidekiq::Worker

  def perform
    stores = Store.includes(:user).where.not(user: { phone: nil })
    
    stores.each do |store|
      phone_number = store.user.phone
      next unless phone_number

      # Enviar el mensaje interactivo
      resp = WhatsappService.new.send_interactive_message(phone_number)

      Rails.logger.info "resp #{resp} con éxito."
      # Aquí simulas la respuesta (esto es solo para probar, deberías hacer esto más dinámico o hacer que se registre de alguna manera real)
      # Simulamos que la respuesta es 'open_business' o 'close_business' dependiendo de alguna lógica o configuración
      # response = simulate_response(store)
    end
  end
end
