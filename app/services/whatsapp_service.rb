class WhatsappService
  include HTTParty
  base_uri 'https://graph.facebook.com/v22.0/526736893865730'

  def initialize
    @api_key = "EAAOfNGKDhYsBO0uZBelh3aVb6xgOzPCgbE9Q57I2fV5jeqpKjeqX00Vt3trNq4aGe39TmQFvowoY1okjqkUPHvfssorm0gISqCrmZAyoiQ2ZAwu1Q9vmebi2ZChENMEPr2tDr6ZC9pu41YpMqwQ1PNzSqWkzq3BCGa1h4iKlvhy5YxH6ZB8oZCzDE3TviDrXVeB6PVABCWO8ktTZC51uzl42XoEUPZBmuzPWGpb9z3qHF"  # Tu token de acceso
  end

  def send_interactive_message(phone_number)
    message = {
      messaging_product: 'whatsapp',
      recipient_type: 'individual',
      to: phone_number,
      type: 'interactive',
      interactive: {
        type: 'button',
        body: {
          text: '¿Abrirá su negocio hoy?'
        },
        action: {
          buttons: [
            {
              type: 'reply',
              reply: {
                id: 'open_business',
                title: 'Sí'
              }
            },
            {
              type: 'reply',
              reply: {
                id: 'close_business',
                title: 'No'
              }
            }
          ]
        }
      }
    }

    # Realiza la solicitud POST con los headers necesarios
    response = self.class.post('/messages', 
      body: message.to_json, 
      headers: { 
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{@api_key}"
      })
    
    
    if response.success?
      Rails.logger.info "Mensaje enviado a #{phone_number} con éxito."
    else
      Rails.logger.error "Error al enviar mensaje a #{phone_number}: #{response.body}"
    end
  end
end
