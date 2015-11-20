#
module ApplicationHelper
  def phone_number(number)
    Phonelib.parse(number).national
  end

  def footer_js
    content_for :footer_js
  end
end
