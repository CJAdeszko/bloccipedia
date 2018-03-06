module WikisHelper
  def markdown
    render_options = {
      filter_html: true,
      no_links: true,
      hard_wrap: true,
    }

    extensions = {
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      strikethrough: true,
      superscript: true,
      underline: true,
      highlight: true,
      quote: true,
    }

    renderer = Redcarpet::Render::HTML.new(render_options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
  end
end
