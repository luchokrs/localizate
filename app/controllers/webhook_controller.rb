class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Verificación del Webhook
  def verify
    mode = params["hub.mode"]
    token = params["hub.verify_token"]
    challenge = params["hub.challenge"]

    if mode == "subscribe" && token == ENV["WEBHOOK_VERIFY_TOKEN"]
      render plain: challenge, status: 200
    else
      render plain: "Forbidden", status: 403
    end
  end

  # Recibir mensajes de WhatsApp
  def receive_message
    body = JSON.parse(request.body.read)
    Rails.logger.info "Incoming webhook message: #{body.to_json}"
    
    message = body.dig("entry", 0, "changes", 0, "value", "messages", 0)
    Rails.logger.info "message: #{message}"
    
    if message
      phone_number_id = body.dig("entry", 0, "changes", 0, "value", "metadata", "phone_number_id")
      sender_phone = message["from"]
      
      # Manejar mensaje interactivo (botón presionado)
      if message["type"] == "interactive" && message.dig("interactive", "type") == "button_reply"
        button_id = message.dig("interactive", "button_reply", "id")
        Rails.logger.info "button_id>>: #{button_id}"
        
        user = User.find_by(phone: sender_phone)
  
        if user&.store
          store = user.store
  
          # Determinar el nuevo estado según el botón presionado
          new_status = (button_id == "open_business") ? 1 : 2
          
          # Actualizar el estado de la tienda
          store.update(status: new_status, last_response_at: Time.current)
          # store.update(status: new_status)
  
          Rails.logger.info "Estado de tienda #{store.name} actualizado a #{store.status}"
          
          # Responder al usuario
          send_whatsapp_message(phone_number_id, sender_phone, "Tu tienda ha sido marcada como #{new_status == 2 ? 'Cerrada' : "Abierta"}.", message["id"])
        else
          Rails.logger.warn "No se encontró un usuario con el número #{sender_phone}"
        end
  
        mark_message_as_read(phone_number_id, message["id"])
      end
    end
  
    render json: { status: "ok" }, status: 200
  end

  private

  # Enviar respuesta a WhatsApp
  def send_whatsapp_message(phone_number_id, to, text, message_id)
    uri = URI("https://graph.facebook.com/v18.0/#{phone_number_id}/messages")
    request = Net::HTTP::Post.new(uri, headers)
    request.body = {
      messaging_product: "whatsapp",
      to: to,
      text: { body: "#{text}" },
      context: { message_id: message_id }
    }.to_json

    send_request(uri, request)
  end

  # Marcar mensaje como leído
  def mark_message_as_read(phone_number_id, message_id)
    uri = URI("https://graph.facebook.com/v18.0/#{phone_number_id}/messages")
    request = Net::HTTP::Post.new(uri, headers)
    request.body = {
      messaging_product: "whatsapp",
      status: "read",
      message_id: message_id
    }.to_json

    send_request(uri, request)
  end

  # Encabezados de la API
  def headers
    {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['GRAPH_API_TOKEN']}"
    }
  end

  # Realizar la solicitud HTTP
  def send_request(uri, request)
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    Rails.logger.info "API Response: #{response.body}"
  end
end