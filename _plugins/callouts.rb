CALLOUT_STYLES = {
  'NOTE'      => { border: '#0969da', bg: '#ddf4ff', color: '#0550ae', icon: 'Note' },
  'TIP'       => { border: '#1a7f37', bg: '#dafbe1', color: '#1a7f37', icon: 'Tip' },
  'IMPORTANT' => { border: '#8250df', bg: '#fbefff', color: '#6639ba', icon: 'Important' },
  'WARNING'   => { border: '#9a6700', bg: '#fff8c5', color: '#7d4e00', icon: 'Warning' },
  'CAUTION'   => { border: '#cf222e', bg: '#ffebe9', color: '#a40e26', icon: 'Caution' },
}.freeze

def transform_callouts(content)
  types = CALLOUT_STYLES.keys.join('|')
  content.gsub(/<blockquote>\s*<p>\[!(#{types})\]([^<]*?)\s*<\/p>(.*?)<\/blockquote>/m) do
    type  = $1
    title = $2.strip.empty? ? CALLOUT_STYLES[type][:icon] : $2.strip
    body  = $3.strip
    s     = CALLOUT_STYLES[type]
    <<~HTML
      <div class="callout callout-#{type.downcase}" style="border-left:4px solid #{s[:border]};background:#{s[:bg]};padding:0.75em 1em;margin:1em 0;border-radius:0 4px 4px 0;">
        <div class="callout-title" style="font-weight:600;color:#{s[:color]};margin-bottom:0.3em;">#{title}</div>
        <div class="callout-body">#{body.gsub(/<(ul|ol)(\s|>)/, '<\1 style="padding-left:1.5em"\2')}</div>
      </div>
    HTML
  end
end

Jekyll::Hooks.register [:pages, :posts, :documents], :post_render do |doc|
  doc.output = transform_callouts(doc.output) if doc.output
end
