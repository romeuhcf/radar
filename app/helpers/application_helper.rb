#
module ApplicationHelper
  def phone_number(number)
    Phonelib.parse(number).national
  end
  def pn(number)
    phone_number(number)
  end
  def footer_js
    content_for :footer_js
  end

  def simple_form_horizontal_setup
    {
      wrapper: :horizontal_form,
      wrapper_mappings: {
        check_boxes: :horizontal_radio_and_checkboxes,
        radio_buttons: :horizontal_radio_and_checkboxes,
        file: :horizontal_file_input,
        boolean: :horizontal_boolean
      }
    }
  end

end
