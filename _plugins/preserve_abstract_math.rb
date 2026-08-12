# frozen_string_literal: true

# jekyll-scholar's LaTeX filter is useful for names and titles, but it also
# decodes commands inside abstract math (for example, `\mathbb{Q}` becomes
# `\mathbbQ`). Keep a raw copy of every abstract for the page template while
# letting the normal filter continue to clean up the bibliographic fields.
Jekyll::Hooks.register :site, :post_read do |site|
  source = File.join(site.source, "_bibliography", "papers.bib")
  next unless File.file?(source)

  bibliography = BibTeX.open(source)
  site.data["publication_abstracts"] = bibliography.entries.values.to_h do |entry|
    [entry.key, entry[:abstract]&.to_s]
  end
end
