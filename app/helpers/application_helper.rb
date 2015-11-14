#
module ApplicationHelper
  def phone_number(number)
    Phonelib.parse(number).national
  end
end
