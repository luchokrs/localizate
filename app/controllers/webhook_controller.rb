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

    if message && message["type"] == "text"
      phone_number_id = body.dig("entry", 0, "changes", 0, "value", "metadata", "phone_number_id")
      sender = message["from"]
      text = message.dig("text", "body")

      send_whatsapp_message(phone_number_id, sender, text, message["id"])
      mark_message_as_read(phone_number_id, message["id"])
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
      text: { body: "Echo: #{text}" },
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