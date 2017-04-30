# Application Helper
module ApplicationHelper
  def convert_bootstrap_flash_type
    flash.map do |message_type, message|
      case message_type
      when 'notice' then
        message_type = 'info'
      when 'alert' then
        message_type = 'danger'
      end
      [message_type, message]
    end
  end
end
