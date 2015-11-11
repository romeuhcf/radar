#
module ApplicationHelper
  def footer_js
    content_for(:footer_js)
  end

  def style
    content_for(:style)
  end
end
