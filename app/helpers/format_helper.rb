module FormatHelper
  include ActionView::Helpers::NumberHelper
  def custom_formatter(
    number,
    precision = 2,
    type = 'currency',
    unit = '',
    custom_format = '%u %n'
  )
    if type == 'stock'
      number_to_currency(
        number,
        precision: precision,
        separator: '.',
        delimiter: ',',
        unit: unit,
        format: custom_format,
      )
      #
    elsif type == 'custom'
      number_to_currency(
        number,
        precision: precision,
        separator: '.',
        delimiter: ',',
        unit: unit,
        format: custom_format,
      )
    else
      if number >= 1_000_000_000
        # If the number is greater than or equal to 1 million, format it as $1M
        number_to_currency(
          number / 1_000_000_000,
          precision: precision,
          format: '$%nB',
        )
      elsif number >= 1_000_000 && number < 1_000_000_000
        # If the number is greater than or equal to 1 million, format it as $1M
        number_to_currency(
          number / 1_000_000,
          precision: precision,
          format: '$%nM',
        )
      elsif number >= 1_000 && number < 1_000_000
        # If the number is greater than or equal to 1 thousand, format it as $234K
        number_to_currency(number / 1_000, precision: precision, format: '$%nK')
      else
        # Otherwise, format it as a regular currency with 2 decimal places
        number_to_currency(
          number,
          precision: precision,
          separator: '.',
          delimiter: ',',
        )
      end
    end
  end
end
