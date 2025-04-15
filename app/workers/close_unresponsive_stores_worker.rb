class CloseUnresponsiveStoresWorker
  include Sidekiq::Worker

  def perform
    # Consulta modificada para incluir todas las tiendas (abiertas o cerradas)
    stores = Store.includes(:user)
    Rails.logger.info "Procesando #{stores.count} tiendas."

    # Procesar las tiendas en lotes de 100
    stores.find_each(batch_size: 100) do |store|
      Rails.logger.info "Verificando tienda: #{store.name}, último mensaje enviado: #{store.last_message_sent_at}, última respuesta: #{store.last_response_at}"

      # Verificar si la tienda ha respondido dentro del plazo de 1 hora
      if store.response_expired?
        Rails.logger.info "Tienda #{store.name} cumple la condición de no respuesta."

        begin
          # Enviar el mensaje de que la tienda fue cerrada por no responder
          phone_number = store.user.phone
          next unless phone_number  # Si no tiene número de teléfono, saltamos a la siguiente tienda

          # Se envía el mensaje antes de cambiar el estado de la tienda
          WhatsappService.new.send_text_message(
            phone_number,
            "Tu tienda fue marcada como Cerrada debido a que no respondiste en el plazo de 1 hora."
          )

          Rails.logger.info "Mensaje enviado a #{phone_number} para tienda #{store.name}."

          # Ahora marcamos la tienda como cerrada (después de enviar el mensaje)
          store.update!(status: Store::STATUS_CLOSED)
          Rails.logger.info "Tienda #{store.name} marcada como cerrada."

        rescue => e
          # Si ocurre un error al procesar la tienda, lo registramos en los logs
          Rails.logger.error "Error procesando tienda #{store.name}: #{e.message}"
        end
      else
        Rails.logger.info "Tienda #{store.name} no cumple la condición de no respuesta."
      end
    end
  end
end