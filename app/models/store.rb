class Store < ApplicationRecord
  belongs_to :user

  STATUS_OPEN = 1
  STATUS_CLOSED = 2

  def open?
    status == STATUS_OPEN
  end

  def closed?
    status == STATUS_CLOSED
  end

  def response_expired?
    if last_message_sent_at.present?
      Rails.logger.info "Último mensaje enviado en #{last_message_sent_at}, última respuesta: #{last_response_at}"

      expired = (last_response_at.nil? || last_response_at < last_message_sent_at) &&
                last_message_sent_at < 1.hour.ago

      Rails.logger.info "Respuesta expirada: #{expired}"
      expired
    else
      Rails.logger.info "No se ha enviado ningún mensaje aún, last_message_sent_at es nil"
      false
    end
  end
end
