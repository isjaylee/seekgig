module ApplicationHelper

  def render_stars(value)
    if value.present?
      output = ''
      output += "<i class='fa fa-fw fa-star text-yellow-800'></i>" * value.floor
      output += "<i class='fa fa-fw fa-star-half text-yellow-800'></i>" if value % 1 != 0
      output += "<i class='fa fa-fw fa-star-o text-yellow-800'></i>" * (5 - value)
      output.html_safe
    end
  end

  def with_user(user, conversation)
    if current_user.id == conversation.sender_id
      User.find(conversation.recipient_id).fullname
    else
      User.find(conversation.sender_id).fullname
    end
  end

  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true, 
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true, 
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def sorting(column)
    direction = sort_direction == "asc" ? "desc" : "asc"
    link_to column, params.merge(sort: column.downcase, direction: direction)
  end
end