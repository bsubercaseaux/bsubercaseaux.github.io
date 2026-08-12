#!/usr/bin/env ruby
# frozen_string_literal: true

require "bibtex"
require "open-uri"
require "optparse"
require "rexml/document"
require "rexml/xpath"

ROOT = File.expand_path("..", __dir__)
BIBLIOGRAPHY_PATH = File.join(ROOT, "_bibliography", "papers.bib")
DBLP_URL = "https://dblp.org/pid/242/3007.bib"

# DBLP is authoritative for citation metadata. Local keys intentionally remain
# stable because they are also DOM ids and keys in publication_visuals.yml.
PUBLICATIONS = {
  "DBLP:journals/talg/BannaiGIKKNS26" => {
    key: "bannai2026repetitiveness", abstract_arxiv: "2207.02571", pdf: false
  },
  "DBLP:conf/fun/MerinoS26" => {
    key: "merino2025demigodsNumber", arxiv: "2501.00144"
  },
  "DBLP:conf/fun/QuanKSM26" => {
    key: "quan2026slowRubiks"
  },
  "DBLP:conf/fun/Subercaseaux26" => {
    key: "subercaseaux2026priceOfLocality", arxiv: "2601.19161"
  },
  "DBLP:conf/sat/KrapivinPS26" => {
    key: "krapivin2026nearOptimalEncodings", arxiv: "2603.28954"
  },
  "DBLP:conf/sat/PrzybockiSH26" => {
    key: "przybocki2026automatedReencoding", arxiv: "2603.27774"
  },
  "DBLP:conf/stoc/KrapivinPSS26" => {
    key: "krapivin2025partiteDecompositions", arxiv: "2511.11855"
  },
  "DBLP:journals/corr/abs-2602-03837" => {
    key: "woodruff2026gemini", arxiv: "2602.03837"
  },
  "DBLP:journals/corr/abs-2604-21187" => {
    key: "przybocki2026doublySaturatedRamsey", arxiv: "2604.21187"
  },
  "DBLP:journals/corr/abs-2606-29157" => {
    key: "arenas2026countingOrderings", arxiv: "2606.29157"
  },
  "DBLP:journals/corr/abs-2607-06407" => {
    key: "arenas2026explainer", arxiv: "2607.06407"
  },
  "DBLP:journals/jair/ArenasBKRS25" => {
    key: "arenas2025probabilisticDecisionTreesJAIR", pdf: false
  },
  "DBLP:journals/pacmmod/BarceloKRSV25" => {
    key: "subercaseauxExplainingKNearest2025", arxiv: "2501.06078"
  },
  "DBLP:conf/aaai/SubercaseauxAM25" => {
    key: "subercaseaux2025linearModelsAAAI", arxiv: "2501.00154",
    sources: %w[subercaseaux2025linearModelsAAAI subercaseaux2025linearModels]
  },
  "DBLP:conf/cade/QianWSH25" => {
    key: "subercaseauxUnfoldingBoxesLocalConstraints2025", arxiv: "2506.01079"
  },
  "DBLP:conf/infocom/GurushankarSS25" => {
    key: "gurushankar2025delayedHitsINFOCOM", arxiv: "2501.16535",
    sources: %w[gurushankar2025delayedHitsINFOCOM gurushankar2025delayedHits]
  },
  "DBLP:conf/mkm/SubercaseauxMQH25" => {
    key: "subercaseauxAutomatedSymmetricConstructions2026", arxiv: "2506.00224"
  },
  "DBLP:journals/corr/abs-2506-14042" => {
    key: "subercaseaux2025smallerEncodings", arxiv: "2506.14042"
  },
  "DBLP:journals/corr/abs-2511-08386" => {
    key: "kirchweger2025norinConjecture", arxiv: "2511.08386"
  },
  "DBLP:conf/cg/CuevasCS24" => {
    key: "cuevas2024placeIt"
  },
  "DBLP:conf/fun/GarrisonHS24" => {
    key: "garrison2024packit", arxiv: "2403.12195"
  },
  "DBLP:conf/itp/SubercaseauxNGC24" => {
    key: "subercaseauxFormalVerificationEmpty2024", arxiv: "2403.17370"
  },
  "DBLP:conf/kr/ArenasBBCS24" => {
    key: "arenas2024uniformLanguage", arxiv: "2310.11636",
    sources: %w[arenas2024uniformLanguage arenas2023symbolic]
  },
  "DBLP:conf/lpar/Subercaseaux24" => {
    key: "BCA2024LPAR"
  },
  "DBLP:conf/mkm/SubercaseauxMHM24" => {
    key: "subercaseauxAutomatedMathematicalDiscovery2024", arxiv: "2311.03645",
    sources: %w[subercaseauxAutomatedMathematicalDiscovery2024 subercaseaux2023minimizing]
  },
  "DBLP:journals/corr/abs-2403-03330" => {
    key: "gutierrez2024assortment", arxiv: "2403.03330"
  },
  "DBLP:journals/corr/abs-2409-17098" => {
    key: "mackey2024pentagonminimizationcomputation", arxiv: "2409.17098"
  },
  "DBLP:conf/lpar/SubercaseauxH23" => {
    key: "sh2023LPAR"
  },
  "DBLP:conf/tacas/SubercaseauxH23" => {
    key: "sh2023", arxiv: "2301.09757"
  },
  "DBLP:journals/tcs/BarceloHPS22" => {
    key: "barcelo2022laraTCS", arxiv: "1909.11693"
  },
  "DBLP:conf/fun/LokshtanovS22" => {
    key: "ls2022", arxiv: "2203.16713"
  },
  "DBLP:conf/nips/0001PS022" => {
    key: "gpss2022"
  },
  "DBLP:conf/nips/ArenasBOS22" => {
    key: "abrs2022", arxiv: "2207.12213"
  },
  "DBLP:conf/sat/SubercaseauxH22" => {
    key: "sh2022"
  },
  "DBLP:conf/fun/BarbayS21" => {
    key: "bs2021", arxiv: "2003.10000"
  },
  "DBLP:conf/nips/ArenasBBPS21" => {
    key: "abbps2021", arxiv: "2110.02376"
  },
  "DBLP:conf/icdt/BarceloH0S20" => {
    key: "bhps2020", arxiv: "1909.11693"
  },
  "DBLP:conf/nips/BarceloM0S20" => {
    key: "bpms2020", arxiv: "2010.12265"
  },
  "DBLP:conf/sigmod/BarceloH0S19" => {
    key: "bhps2019"
  }
}.freeze

# These records are arXiv versions of canonical records above (or a data
# artifact rather than a paper). Listing them makes newly added DBLP records
# detectable instead of silently dropping them.
IGNORED_DBLP_KEYS = %w[
  DBLP:journals/corr/abs-2601-19161
  DBLP:journals/corr/abs-2603-27774
  DBLP:journals/corr/abs-2603-28954
  DBLP:journals/corr/abs-2501-00144
  DBLP:journals/corr/abs-2501-00154
  DBLP:journals/corr/abs-2501-06078
  DBLP:journals/corr/abs-2501-16535
  DBLP:journals/corr/abs-2506-00224
  DBLP:journals/corr/abs-2506-01079
  DBLP:journals/corr/abs-2511-11855
  DBLP:journals/corr/abs-2403-12195
  DBLP:journals/corr/abs-2403-17370
  DBLP:journals/corr/abs-2301-09757
  DBLP:journals/corr/abs-2310-11636
  DBLP:journals/corr/abs-2311-03645
  DBLP:journals/corr/abs-2203-16713
  DBLP:journals/corr/abs-2207-12213
  DBLP:journals/corr/abs-2110-02376
  DBLP:journals/corr/abs-2003-10000
  DBLP:journals/corr/abs-2010-12265
  DBLP:journals/corr/abs-1909-11693
  DBLP:data/11/SubercaseauxNGCCH24
].freeze

LOCAL_ONLY_KEYS = %w[
  subercaseauxHeuleNAW
  bps2020
  clps2016
].freeze

PRESERVED_FIELDS = %i[
  selected supp blog code poster slides website
].freeze

CONFERENCE_LABELS = {
  "aaai" => "AAAI",
  "cade" => "CADE",
  "cg" => "CG",
  "fun" => "FUN",
  "icdt" => "ICDT",
  "infocom" => "INFOCOM",
  "itp" => "ITP",
  "kr" => "KR",
  "lpar" => "LPAR",
  "mkm" => "CICM",
  "nips" => "NeurIPS",
  "sat" => "SAT",
  "sigmod" => "DEEM@SIGMOD",
  "stoc" => "STOC",
  "tacas" => "TACAS"
}.freeze

TITLE_OVERRIDES = {
  "subercaseauxExplainingKNearest2025" =>
    "Explaining k-Nearest Neighbors: Abductive and Counterfactual Explanations",
  "gpss2022" => "Augmenting Online Algorithms with ε-Accurate Predictions"
}.freeze

ABSTRACT_OVERRIDES = {
  "quan2026slowRubiks" => <<~'TEXT',
    We study, for different Rubik's puzzles, whether from any starting state one can solve the puzzle as slowly as possible, visiting every reachable state exactly once before reaching the solved configuration. This question corresponds to the existence of Hamiltonian paths (ending in the solved state) in the Cayley graphs associated with these puzzles. A major conjecture attributed to Lovász is that every Cayley graph has a Hamiltonian path. An even stronger version of the conjecture, considered by Dupuis and Wagon (2015) and Gregor et al. (2024), is that every Cayley graph of degree at least 3 is either bipartite and has Hamiltonian paths between any pair of vertices on opposite parts, or is non-bipartite and has Hamiltonian paths between any pair of vertices. Our study of slowly solving Rubik's puzzles amounts to studying this Strong Lovász Conjecture in their respective Cayley graphs. We first verify the Strong Lovász Conjecture computationally for small Rubik's puzzles like the $1 \times 2 \times 3$ or $1 \times 3 \times 3$ cuboids, which have under 200 states. This approach, however, becomes infeasible for the $2 \times 2 \times 2$, which has over 3.6 million states. Our main result is then showing that the Strong Lovász Conjecture holds for the $2 \times 2 \times 2$ cube, using a careful graph-theoretic construction based on the subgroup induced by the R and U turns.
  TEXT
  "cuevas2024placeIt" => <<~'TEXT',
    In the single-player game of PlaceIt, a player must sort a random sequence of numbers in an online fashion. The game begins by sampling a sequence $S = (s_1, \ldots, s_{20})$ of numbers uniformly at random from $\{1, \ldots, 999\}$ without replacement. The elements of $S$ are presented one by one to the player. Upon seeing an element $s_i$, a player must try to guess its rank, that is, the number $n$ such that $s_i$ is the $n^{\text{th}}$ smallest number in $S$. The player must guess the rank of all 20 numbers correctly to win the game. Additionally, the game requires each guess to be consistent with previous guesses. If at any point the player cannot make a consistent guess, they lose immediately, and once a rank has been assigned it cannot be changed. We prove that the optimal strategy wins with probability close to 0.0001335, and extend our analysis to a continuous variant of the game.
  TEXT
  "arenas2025probabilisticDecisionTreesJAIR" => <<~'TEXT'
    Formal XAI (explainable AI) is a growing area that focuses on computing explanations with mathematical guarantees for the decisions made by machine-learning models. Inside formal XAI, one of the most studied cases is that of explaining the choices taken by decision trees. Recent work has focused on sufficient reasons: given a decision tree $T$ and an instance $x$, one explains the decision $T(x)$ by providing a subset $y$ of the features of $x$ such that every other instance $z$ compatible with $y$ satisfies $T(z) = T(x)$. It has been argued, however, that sufficient reasons constitute a restrictive notion of explanation. We study their probabilistic counterpart, in which the probability that $T(z) = T(x)$ must be at least some value $\delta \in (0,1]$. We settle the computational complexity of $\delta$-sufficient reasons over decision trees, showing that finding reasons minimal either in size or inclusion-wise is computationally intractable. This is in stark contrast with the deterministic case ($\delta = 1$), where inclusion-wise minimal sufficient reasons are easy to compute. We answer open problems raised by Izza et al. and extend hardness results of Wäldchen et al. to decision trees. Furthermore, we present sharp non-approximability results under a widely believed complexity hypothesis. On the positive side, we identify structural restrictions of decision trees that make the problem tractable.
  TEXT
}.freeze

def squish(text)
  text.to_s.gsub(/\s+/, " ").strip
end

def read_source(path, url)
  path ? File.read(path) : URI.open(url, &:read)
end

def arxiv_abstracts(atom)
  document = REXML::Document.new(atom)
  namespaces = { "atom" => "http://www.w3.org/2005/Atom" }
  REXML::XPath.match(document, "atom:feed/atom:entry", namespaces).to_h do |entry|
    url = REXML::XPath.first(entry, "atom:id", namespaces)&.text.to_s
    id = url[%r{/(\d{4}\.\d{4,5})(?:v\d+)?\z}, 1]
    summary = REXML::XPath.first(entry, "atom:summary", namespaces)&.text
    [id, squish(summary)]
  end
end

options = {}
OptionParser.new do |parser|
  parser.banner = "Usage: bundle exec ruby scripts/update_publications.rb [options]"
  parser.on("--dblp-bib PATH", "Read a downloaded DBLP BibTeX file") { |path| options[:dblp] = path }
  parser.on("--arxiv-atom PATH", "Read a downloaded arXiv Atom response") { |path| options[:arxiv] = path }
end.parse!

local = BibTeX.open(BIBLIOGRAPHY_PATH)
dblp = BibTeX.parse(read_source(options[:dblp], DBLP_URL))

known = PUBLICATIONS.keys + IGNORED_DBLP_KEYS
unknown = dblp.entries.keys - known
abort("Unmapped DBLP records:\n  #{unknown.join("\n  ")}") unless unknown.empty?

arxiv_ids = PUBLICATIONS.values.flat_map do |config|
  [config[:arxiv], config[:abstract_arxiv]]
end.compact.uniq
arxiv_url = "https://export.arxiv.org/api/query?id_list=#{arxiv_ids.join(',')}&max_results=#{arxiv_ids.length}"
abstracts = arxiv_abstracts(read_source(options[:arxiv], arxiv_url))
missing_arxiv = arxiv_ids - abstracts.keys
abort("Missing arXiv records: #{missing_arxiv.join(', ')}") unless missing_arxiv.empty?

entries = PUBLICATIONS.map do |dblp_key, config|
  entry = dblp[dblp_key]&.dup or abort("Missing DBLP record: #{dblp_key}")
  entry.key = config[:key]
  entry[:title] = TITLE_OVERRIDES.fetch(entry.key, entry[:title].to_s)

  conference_key = dblp_key[%r{DBLP:conf/([^/]+)/}, 1]
  entry[:venue] = CONFERENCE_LABELS[conference_key] if CONFERENCE_LABELS.key?(conference_key)

  if entry[:url]
    url = entry[:url].to_s.sub(%r{\Ahttp://papers\.nips\.cc}, "https://papers.nips.cc")
    entry[:url] = url
  end

  source_keys = config.fetch(:sources, [config[:key]])
  sources = source_keys.filter_map { |key| local[key] }

  PRESERVED_FIELDS.each do |field|
    value = sources.filter_map { |source| source[field]&.to_s }.first
    entry[field] = value if value && !value.empty?
  end
  entry[:selected] = "true" if sources.any? { |source| source[:selected]&.to_s == "true" }

  entry[:html] = entry[:url].to_s if entry[:url]
  entry[:bibtex_show] = "true"

  arxiv_id = config[:arxiv]
  if arxiv_id
    entry[:arxiv] = arxiv_id
    entry[:pdf] = "https://arxiv.org/pdf/#{arxiv_id}.pdf"
  elsif config[:pdf] != false
    local_pdf = sources.filter_map { |source| source[:pdf]&.to_s }.first
    entry[:pdf] = local_pdf if local_pdf && !local_pdf.empty?
  end

  local_abstract = sources.filter_map { |source| source[:abstract]&.to_s }.first
  abstract_source = config[:abstract_arxiv] || arxiv_id
  abstract = ABSTRACT_OVERRIDES[entry.key] || abstracts[abstract_source] || local_abstract
  entry[:abstract] = squish(abstract)
  entry
end

LOCAL_ONLY_KEYS.each do |key|
  entry = local[key]&.dup or abort("Missing local-only publication: #{key}")
  entry[:bibtex_show] = "true"
  entry[:html] = entry[:url].to_s if !entry[:html] && entry[:url]
  entries << entry
end

duplicate_keys = entries.group_by(&:key).select { |_key, group| group.length > 1 }.keys
abort("Duplicate local keys: #{duplicate_keys.join(', ')}") unless duplicate_keys.empty?

incomplete = entries.filter_map do |entry|
  required = %i[author title year abstract bibtex_show]
  required << (entry.type == :article ? :journal : :booktitle)
  missing = required.reject { |field| entry[field] && !entry[field].to_s.empty? }
  "#{entry.key}: #{missing.join(', ')}" unless missing.empty?
end
abort("Incomplete publications:\n  #{incomplete.join("\n  ")}") unless incomplete.empty?

output = BibTeX::Bibliography.new
entries.each { |entry| output << entry }
temp_path = "#{BIBLIOGRAPHY_PATH}.tmp"
File.write(temp_path, "#{output}".rstrip + "\n")
File.rename(temp_path, BIBLIOGRAPHY_PATH)

formal = entries.count { |entry| entry.type == :inproceedings || entry[:journal].to_s != "CoRR" }
puts "Updated #{entries.length} publications (#{formal} formal records, #{entries.length - formal} preprints)."
