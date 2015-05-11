module StartappHelper
  def set_locale
    parsed_locale = request.host.split('.').last
    case parsed_locale
      when 'bg' then Il8n.locale = :bg
    else
      I18n.locale = :en  #this is now your 'default'
    end
  end
end
