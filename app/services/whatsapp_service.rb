# class WhatsappService
#   include HTTParty
#   base_uri 'https://graph.facebook.com/v22.0/526736893865730'

#   def initialize
#     @api_key = ENV["WEBHOOK_VERIFY_TOKEN"]
#   end

#   def send_interactive_message(phone_number)
#     message = {
#       messaging_product: 'whatsapp',
#       recipient_type: 'individual',
#       to: phone_number,
#       type: 'interactive',
#       interactive: {
#         type: 'button',
#         body: {
#           text: '¿Abrirá su negocio hoy?'
#         },
#         action: {
#           buttons: [
#             {
#               type: 'reply',
#               reply: {
#                 id: 'open_business',
#                 title: 'Sí'
#               }
#             },
#             {
#               type: 'reply',
#               reply: {
#                 id: 'close_business',
#                 title: 'No'
#               }
#             }
#           ]
#         }
#       }
#     }

#     # Nuevo método para mensajes de texto simples
#     def send_text_message(phone_number, text)
#       message = {
#         messaging_product: 'whatsapp',
#         to: phone_number,
#         type: 'text',
#         text: {
#           body: text
#         }
#       }
  
#       response = self.class.post('/messages',
#         body: message.to_json,
#         headers: headers)
  
#       log_response(response, phone_number)
#     end

#     # Realiza la solicitud POST con los headers necesarios
#     response = self.class.post('/messages', 
#       body: message.to_json, 
#       headers: { 
#         'Content-Type' => 'application/json',
#         'Authorization' => "Bearer #{@api_key}"
#       })
    
    
#     if response.success?
#       Rails.logger.info "Mensaje enviado a #{phone_number} con éxito."
#     else
#       Rails.logger.error "Error al enviar mensaje a #{phone_number}: #{response.body}"
#     end
#   end
# end

class WhatsappService
  include HTTParty
  base_uri 'https://graph.facebook.com/v22.0/526736893865730'

  def initialize
    @api_key = ENV["WEBHOOK_VERIFY_TOKEN"]
  end

  # Método actual: sigue funcionando como antes
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

    response = self.class.post('/messages',
      body: message.to_json,
      headers: headers)

    log_response(response, phone_number)
  end

  # Nuevo método para mensajes de texto simples
  def send_text_message(phone_number, text)
    message = {
      messaging_product: 'whatsapp',
      to: phone_number,
      type: 'text',
      text: {
        body: text
      }
    }

    response = self.class.post('/messages',
      body: message.to_json,
      headers: headers)

    log_response(response, phone_number)
  end

  private

  def headers
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{@api_key}"
    }
  end

  def log_response(response, phone_number)
    if response.success?
      Rails.logger.info "Mensaje enviado a #{phone_number} con éxito."
    else
      Rails.logger.error "Error al enviar mensaje a #{phone_number}: #{response.body}"
    end
  end
end
