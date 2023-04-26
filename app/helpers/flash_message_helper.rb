module FlashMessageHelper
  def render_flash_messages(type, css_class)
    if flash[type]
      content_tag :ul,
                  class:
                    'fixed top-[20px] right-[50%] translate-x-[50%] text-center flex flex-col items-center gap-4 cursor-none fade' do
        flash[type]
          .map { |message| content_tag :li, message, class: css_class }
          .join
          .html_safe
      end
    end
  end
end
