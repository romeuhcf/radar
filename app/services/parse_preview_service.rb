require 'extensions/file'
class ParsePreviewService

  def preview(transmission_request, request_options)
    self.send('preview_' + transmission_request.batch_file_type, transmission_request, request_options)
  end

  def preview_csv(transmission_request, request_options)
    head_content = File.head(transmission_request.batch_file.current_path).join.strip

    col_sep = request_options['field_separator']
    headers_at_first_line = request_options['headers_at_first_line'] != '0' # TODO... make it a real boolean

    rows =  CSV.parse(head_content, col_sep: col_sep, headers: headers_at_first_line)

    headers = headers_at_first_line ? rows.first.headers : (1..(rows.first.size)).to_a

    if ! headers_at_first_line
      rows.each_with_index do |row, index|
        rows[index] = [index, *rows[index]]
      end
    end
    {headers: headers, rows: rows}
  end
end
