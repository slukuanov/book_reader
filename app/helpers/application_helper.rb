module ApplicationHelper
  def flash_normal
    render "flashes"
  end

  def twitterized_type(type)
    case type
      when :errors
        "alert-error"
      when :alert
        "alert-warning"
      when :error
        "alert-error"
      when :notice
        "alert-success"
      else
        "alert-info"
    end
  end
end
