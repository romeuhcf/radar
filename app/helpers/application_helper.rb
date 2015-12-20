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

  def stats_today
    @@stats_today||=begin
                      h = Message.where(owner: current_user).where(created_at: (Time.zone.now.beginning_of_day)..(Time.zone.now.end_of_day)).group(:transmission_state).count
                      h['total'] = h.values.sum
                      h
                    end
  end

  def stats_month
    @@stats_month||=begin
                      h = Message.where(owner: current_user).where(created_at: (Time.zone.now.beginning_of_month)..(Time.zone.now.end_of_month)).group(:transmission_state).count
                      h['total'] = h.values.sum
                      h
                    end
  end

  def stats_ever
    @@stats_ever||=begin
                     h = Message.where(owner: current_user).group(:transmission_state).count
                     h['total'] = h.values.sum
                     h
                   end
  end


  def stats(period, what)
    n =  self.send("stats_#{period}")[what.to_s] || 0
    number_with_delimiter n
  end

  def field(f, field)
    type = 'text_field'
    if field.is_a? Hash
      field, type = *field.flatten
    end
    content_tag(:div, class:'form-group') do
      [
        f.label( field, class: "col-sm-2 control-label") ,
        content_tag(:div, class: 'col-sm-6') do
          f.send(type, field, class: "form-control" )
        end
      ].join(' ').html_safe
    end
  end
end
