#!/usr/bin/env ruby

require "fileutils"

OUT = File.expand_path("../assets/img/publications", __dir__)
FileUtils.mkdir_p(OUT)

INK = "#20201f"
PAPER = "#fffaf0"
PAPER_DIM = "#eee5d3"
RED = "#b53a2e"
BLUE = "#28547f"
YELLOW = "#e0b53f"
MUTED = "#777166"

def rect(x, y, w, h, fill: "none", stroke: INK, sw: 3, rx: 0, opacity: 1)
  %(<rect x="#{x}" y="#{y}" width="#{w}" height="#{h}" rx="#{rx}" fill="#{fill}" stroke="#{stroke}" stroke-width="#{sw}" opacity="#{opacity}"/>)
end

def circle(x, y, r, fill: PAPER, stroke: INK, sw: 3, dash: nil, opacity: 1)
  dash_attr = dash ? %( stroke-dasharray="#{dash}") : ""
  %(<circle cx="#{x}" cy="#{y}" r="#{r}" fill="#{fill}" stroke="#{stroke}" stroke-width="#{sw}"#{dash_attr} opacity="#{opacity}"/>)
end

def line(x1, y1, x2, y2, stroke: INK, sw: 3, dash: nil, opacity: 1)
  dash_attr = dash ? %( stroke-dasharray="#{dash}") : ""
  %(<line x1="#{x1}" y1="#{y1}" x2="#{x2}" y2="#{y2}" stroke="#{stroke}" stroke-width="#{sw}"#{dash_attr} opacity="#{opacity}"/>)
end

def path(d, fill: "none", stroke: INK, sw: 3, dash: nil, opacity: 1)
  dash_attr = dash ? %( stroke-dasharray="#{dash}") : ""
  %(<path d="#{d}" fill="#{fill}" stroke="#{stroke}" stroke-width="#{sw}"#{dash_attr} opacity="#{opacity}"/>)
end

def polygon(points, fill: "none", stroke: INK, sw: 3, opacity: 1)
  %(<polygon points="#{points.map { |point| point.join(",") }.join(" ")}" fill="#{fill}" stroke="#{stroke}" stroke-width="#{sw}" opacity="#{opacity}"/>)
end

def label(x, y, value, size: 20, fill: INK, weight: 700, anchor: "middle", family: "ui-monospace, monospace")
  %(<text x="#{x}" y="#{y}" fill="#{fill}" font-family="#{family}" font-size="#{size}" font-weight="#{weight}" text-anchor="#{anchor}" dominant-baseline="middle">#{value}</text>)
end

def arrow(x1, y1, x2, y2, color: INK, sw: 4)
  angle = Math.atan2(y2 - y1, x2 - x1)
  wing = 11
  spread = 0.58
  points = [
    [x2, y2],
    [x2 - wing * Math.cos(angle - spread), y2 - wing * Math.sin(angle - spread)],
    [x2 - wing * Math.cos(angle + spread), y2 - wing * Math.sin(angle + spread)]
  ]
  line(x1, y1, x2, y2, stroke: color, sw: sw) + polygon(points, fill: color, stroke: color, sw: 1)
end

def write_visual(name, body, accent: RED, secondary: YELLOW)
  svg = <<~SVG
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 480 300">
      <rect width="480" height="300" fill="#{PAPER}"/>
      <path d="M18 52 H462 M18 250 H462" stroke="#{PAPER_DIM}" stroke-width="2"/>
      <g stroke-linecap="round" stroke-linejoin="round">
        #{body}
      </g>
      <g stroke="#{INK}" stroke-width="2">
        <rect x="0" y="0" width="116" height="12" fill="#{accent}"/>
        <rect x="116" y="0" width="174" height="12" fill="#{PAPER}"/>
        <rect x="290" y="0" width="70" height="12" fill="#{BLUE}"/>
        <rect x="360" y="0" width="120" height="12" fill="#{secondary}"/>
      </g>
    </svg>
  SVG
  File.write(File.join(OUT, "#{name}.svg"), svg)
end

# A cardinality network: many Boolean inputs, a compact hierarchy, one count.
bits = 12.times.map do |i|
  fill = [RED, BLUE, YELLOW, PAPER_DIM][i % 4]
  rect(28 + i * 34, 45, 23, 23, fill: fill, sw: 2)
end.join
levels = [
  [[45, 100], [113, 100], [181, 100], [249, 100], [317, 100], [385, 100]],
  [[79, 154], [215, 154], [351, 154]],
  [[147, 210], [283, 210]]
]
wires = 12.times.map { |i| line(39 + i * 34, 68, 45 + (i / 2) * 68, 88, stroke: MUTED, sw: 2) }.join
wires += 6.times.map { |i| line(45 + i * 68, 112, 79 + (i / 2) * 136, 142, stroke: MUTED, sw: 2) }.join
wires += 3.times.map { |i| line(79 + i * 136, 166, 147 + (i / 2) * 136, 198, stroke: MUTED, sw: 2) }.join
gates = levels.flatten(1).map.with_index { |(x, y), i| circle(x, y, 12, fill: [BLUE, YELLOW, RED][i % 3], sw: 2) }.join
write_visual("cardinality-network", bits + wires + gates + arrow(306, 210, 425, 210, color: RED) + label(438, 210, "≤k", size: 24), accent: RED)

# A dense graph automatically rewritten into a cleaner equivalent graph.
left_nodes = [[45,80],[95,62],[135,98],[68,137],[126,151],[42,183],[105,205],[151,188]]
left_edges = [[0,1],[0,3],[1,2],[1,3],[1,4],[2,4],[3,4],[3,5],[3,6],[4,6],[4,7],[5,6],[6,7]].map { |a,b| line(*left_nodes[a], *left_nodes[b], stroke: MUTED, sw: 2) }.join
left = left_edges + left_nodes.map.with_index { |(x,y),i| circle(x,y,9,fill:[RED,BLUE,YELLOW][i%3],sw:2) }.join
right_nodes = [[330,76],[402,76],[366,130],[330,185],[402,185],[366,228]]
right_edges = [[0,1],[0,2],[1,2],[2,3],[2,4],[3,4],[3,5],[4,5]].map { |a,b| line(*right_nodes[a], *right_nodes[b], stroke: INK, sw: 3) }.join
right = right_edges + right_nodes.map.with_index { |(x,y),i| circle(x,y,13,fill:[PAPER,BLUE,YELLOW,RED][i%4],sw:3) }.join
write_visual("automated-reencoding", left + arrow(185,145,285,145,color:RED,sw:5) + right, accent: BLUE, secondary: RED)

# Twin agents move a scientific idea through exploration, reasoning, and checking.
stars = polygon([[93,71],[106,101],[139,105],[113,125],[121,158],[93,138],[64,158],[73,125],[47,105],[80,101]], fill:YELLOW, sw:3)
stars += polygon([[156,92],[166,114],[190,117],[171,132],[177,156],[156,142],[135,156],[141,132],[122,117],[146,114]], fill:BLUE, sw:3)
pipeline = arrow(205,118,278,118,color:RED) + rect(288,79,55,76,fill:PAPER_DIM,sw:3) + label(315,118,"?",size:32,fill:BLUE)
pipeline += arrow(350,118,420,118,color:RED) + circle(438,118,24,fill:YELLOW,sw:3) + path("M426 118 l8 9 l17 -20", stroke:INK, sw:4)
orbit = path("M54 218 C140 174 245 266 420 208", stroke:BLUE, sw:3, dash:"6 8")
samples = [[76,217],[142,203],[220,225],[304,216],[390,205]].map.with_index { |(x,y),i| circle(x,y,8,fill:[RED,YELLOW,BLUE][i%3],sw:2) }.join
write_visual("scientific-research", stars + pipeline + orbit + samples, accent: YELLOW, secondary: RED)

# Rotational symmetry turns a small seed into a constrained point construction.
seed = polygon([[69,128],[111,76],[145,137]],fill:YELLOW,sw:3)
seed += [[69,128],[111,76],[145,137]].map { |x,y| circle(x,y,7,fill:RED,sw:2) }.join
axes = line(327,49,327,249,stroke:MUTED,sw:2,dash:"6 6") + line(228,149,426,149,stroke:MUTED,sw:2,dash:"6 6")
rays = 8.times.map do |i|
  angle = i * Math::PI / 4
  line(327,149,327+Math.cos(angle)*82,149+Math.sin(angle)*82,stroke:PAPER_DIM,sw:2)
end.join
orbit_points = 8.times.map do |i|
  angle = i * Math::PI / 4
  circle(327+Math.cos(angle)*82,149+Math.sin(angle)*82,8,fill:[RED,BLUE,YELLOW][i%3],sw:2)
end.join
center_shape = polygon([[327,83],[384,182],[270,182]],fill:BLUE,stroke:INK,sw:3,opacity:0.38)
write_visual("symmetric-constructions", seed + arrow(165,130,216,130,color:RED) + axes + rays + center_shape + orbit_points + circle(327,149,9,fill:YELLOW,sw:2), accent: BLUE, secondary: YELLOW)

# SAT clauses steer a radio coloring of a projected hypercube.
clause_stack = 3.times.map do |i|
  rect(27,67+i*48,117,31,fill:i == 1 ? YELLOW : PAPER_DIM,sw:2) +
    label(85,83+i*48,["x ∨ ¬y","d ≥ 4","z ∨ y"][i],size:16,fill:i == 1 ? INK : BLUE)
end.join
front_cube = [[284,62],[405,62],[405,183],[284,183]]
back_cube = [[231,111],[352,111],[352,232],[231,232]]
cube_edges = [[0,1],[1,2],[2,3],[3,0]].flat_map do |a,b|
  [line(*front_cube[a],*front_cube[b],stroke:INK,sw:3), line(*back_cube[a],*back_cube[b],stroke:INK,sw:3)]
end.join
cube_edges += 4.times.map { |i| line(*front_cube[i],*back_cube[i],stroke:MUTED,sw:3) }.join
radio_values = [1,5,9,3,7,2,6,10]
cube_nodes = (front_cube + back_cube).map.with_index do |(x,y),i|
  fill = [RED,BLUE,YELLOW,PAPER_DIM][i%4]
  circle(x,y,16,fill:fill,sw:3) + label(x,y,radio_values[i],size:14,fill:i == 3 || i == 7 ? INK : PAPER)
end.join
write_visual("radio-hypercube", clause_stack + arrow(158,145,209,145,color:RED) + cube_edges + cube_nodes, accent: RED, secondary: BLUE)

# A probabilistic decision tree with explanations emphasized at the leaves.
tree_points = [[120,58],[72,112],[169,112],[43,174],[95,174],[145,174],[198,174]]
tree_edges = [[0,1],[0,2],[1,3],[1,4],[2,5],[2,6]].map { |a,b| line(*tree_points[a],*tree_points[b],stroke:INK,sw:3) }.join
tree_nodes = tree_points.map.with_index { |(x,y),i| circle(x,y,i.zero? ? 15 : 11,fill:[YELLOW,PAPER,BLUE,RED][i%4],sw:3) }.join
bars = 4.times.map { |i| rect(278,72+i*42,130,24,fill:PAPER_DIM,sw:2) + rect(278,72+i*42,[92,48,112,70][i],24,fill:[BLUE,YELLOW,RED,BLUE][i],stroke:INK,sw:2) }.join
write_visual("probabilistic-tree", tree_edges + tree_nodes + arrow(218,133,260,133,color:RED) + bars, accent: BLUE, secondary: YELLOW)

# Delayed cache hits shown as requests, a waiting arc, and eventual arrivals.
requests = 9.times.map { |i| circle(34+i*48,70,10,fill:[RED,BLUE,YELLOW][i%3],sw:2) }.join
slots = 6.times.map { |i| rect(57+i*61,207,47,37,fill:i<4 ? [BLUE,YELLOW,RED,PAPER_DIM][i] : PAPER,sw:3) }.join
timeline = line(30,136,450,136,stroke:INK,sw:3) + 8.times.map { |i| line(48+i*52,129,48+i*52,143,stroke:INK,sw:2) }.join
delay = path("M82 94 C118 118 105 171 152 193",stroke:RED,sw:4,dash:"7 7") + arrow(338,95,338,194,color:BLUE,sw:4)
write_visual("delayed-cache", requests + timeline + delay + slots, accent: BLUE, secondary: RED)

# A latency ledger emphasizes the theorem's waiting-time guarantee.
ledger_requests = 8.times.map { |i| circle(40+i*52,67,9,fill:[BLUE,YELLOW,RED][i%3],sw:2) }.join
ledger_ticks = line(35,130,445,130,stroke:INK,sw:3) + 9.times.map { |i| line(40+i*50,122,40+i*50,139,stroke:INK,sw:2) }.join
waiting = path("M91 84 C91 109 143 103 143 120 M247 84 C247 113 347 103 347 120",stroke:RED,sw:4,dash:"6 6")
brackets = path("M84 176 V163 H201 V176",stroke:BLUE,sw:4) + label(143,201,"delay ≤ Δ",size:19,fill:BLUE)
brackets += path("M238 176 V163 H397 V176",stroke:YELLOW,sw:5) + label(318,201,"latency bound",size:18,fill:INK)
write_visual("delayed-cache-journal", ledger_requests + ledger_ticks + waiting + brackets, accent: YELLOW, secondary: BLUE)

# Finite graph samples point toward an infinite asymptotic pattern.
rings = [40,64,88].map.with_index { |r,i| circle(135,150,r,fill:"none",stroke:[RED,BLUE,YELLOW][i],sw:3,dash:i==2 ? "5 7" : nil) }.join
dots = 12.times.map do |i|
  angle = i * Math::PI / 6
  circle(135 + Math.cos(angle)*88, 150 + Math.sin(angle)*88, 5, fill:INK, stroke:INK, sw:1)
end.join
limit = arrow(244,150,329,150,color:INK) + path("M350 198 C375 75 415 75 442 198",stroke:RED,sw:5)
limit += path("M350 198 C375 115 415 115 442 198",stroke:BLUE,sw:5)
write_visual("finite-to-infinite", rings + dots + limit, accent: RED, secondary: BLUE)

# Overlapping hyperedges split into efficient partite blocks.
nodes = [[56,80],[118,63],[171,93],[79,147],[150,154],[42,210],[111,225],[181,210]]
edges = path("M32 55 C88 27 164 38 194 103 C167 139 75 132 32 55",fill:YELLOW,stroke:INK,sw:3,opacity:0.72)
edges += path("M38 119 C101 91 185 121 198 199 C150 241 69 244 38 119",fill:BLUE,stroke:INK,sw:3,opacity:0.5)
left_nodes = nodes.map { |x,y| circle(x,y,9,fill:PAPER,sw:2) }.join
parts = 3.times.map do |col|
  4.times.map { |row| circle(305+col*58,72+row*48,9,fill:[RED,BLUE,YELLOW][col],sw:2) }.join
end.join
part_edges = 4.times.map { |row| line(305,72+row*48,421,72+row*48,stroke:MUTED,sw:2,dash:"4 5") }.join
write_visual("hypergraph-parts", edges + left_nodes + arrow(215,150,270,150,color:RED) + parts + part_edges, accent: YELLOW, secondary: BLUE)

# An isometric three-face cube with a deliberately unsolved corner.
top = polygon([[240,50],[334,101],[240,152],[146,101]],fill:YELLOW,sw:4)
left_face = polygon([[146,101],[240,152],[240,253],[146,202]],fill:BLUE,sw:4)
right_face = polygon([[240,152],[334,101],[334,202],[240,253]],fill:RED,sw:4)
cube_grid = [1,2].map { |i| line(146+47*i,101+25.5*i,240+47*i,50+25.5*i,stroke:INK,sw:2) }.join
cube_grid += [1,2].map { |i| line(146+47*i,202+25.5*i,240+47*i,152+25.5*i,stroke:INK,sw:2) }.join
cube_grid += [1,2].map { |i| line(146,101+50.5*i,240,152+50.5*i,stroke:INK,sw:2) + line(240,152+50.5*i,334,101+50.5*i,stroke:INK,sw:2) }.join
write_visual("rubik-demigod", top + left_face + right_face + cube_grid + path("M352 82 C414 92 417 155 367 177",stroke:BLUE,sw:4) + polygon([[367,177],[378,158],[386,177]],fill:BLUE,stroke:BLUE), accent: RED, secondary: YELLOW)

# A linear separator, one partial region, and an explanatory feature stack.
axes = line(45,235,256,235,stroke:INK) + line(45,235,45,55,stroke:INK)
separator = line(66,211,231,76,stroke:RED,sw:5)
points = [[73,92],[105,118],[123,76],[150,143],[86,164],[184,184],[213,151],[220,213],[157,204]].map.with_index do |(x,y),i|
  circle(x,y,8,fill:i<5 ? BLUE : YELLOW,sw:2)
end.join
halo = circle(150,143,29,fill:"none",stroke:RED,sw:3,dash:"5 5")
features = 4.times.map { |i| rect(312,72+i*43,[88,124,65,105][i],24,fill:[BLUE,YELLOW,RED,PAPER_DIM][i],sw:2) }.join
write_visual("linear-explanations", axes + separator + points + halo + arrow(263,150,298,150,color:INK) + features, accent: BLUE, secondary: RED)

# A partial instance produces a calibrated probability rather than one hard label.
partial = rect(37,74,142,143,fill:PAPER_DIM,sw:3) + 4.times.map do |i|
  fill = [BLUE,YELLOW,PAPER,RED][i]
  rect(57,94+i*28,23,20,fill:fill,sw:2) + line(94,104+i*28,154,104+i*28,stroke:MUTED,sw:3)
end.join
score_line = line(251,222,430,222,stroke:INK,sw:3) + 7.times.map { |i| line(263+i*26,215,263+i*26,229,stroke:INK,sw:2) }.join
density = path("M258 212 C280 206 298 181 315 137 C332 91 355 82 374 119 C391 151 398 196 425 212",stroke:BLUE,sw:5)
probability = line(367,98,367,221,stroke:RED,sw:4,dash:"6 6") + circle(367,98,9,fill:YELLOW,sw:2) + label(367,62,"P = .72",size:20,fill:RED)
write_visual("linear-probabilities", partial + arrow(190,145,235,145,color:RED) + score_line + density + probability, accent: RED, secondary: YELLOW)

# A large encoding collapses into a smaller graph-shaped one.
dense = 7.times.map do |row|
  9.times.map { |col| rect(28+col*19,60+row*26,14,14,fill:((row+col)%4==0 ? RED : PAPER_DIM),stroke:MUTED,sw:1) }.join
end.join
compact_points = [[338,78],[401,78],[370,126],[326,175],[414,175],[370,224]]
compact_edges = [[0,1],[0,2],[1,2],[2,3],[2,4],[3,5],[4,5]].map { |a,b| line(*compact_points[a],*compact_points[b],stroke:INK,sw:3) }.join
compact_nodes = compact_points.map.with_index { |(x,y),i| circle(x,y,11,fill:[BLUE,YELLOW,RED][i%3],sw:2) }.join
write_visual("compact-encodings", dense + arrow(220,145,290,145,color:RED,sw:5) + compact_edges + compact_nodes, accent: RED, secondary: BLUE)

# A query point, its nearest neighbors, and a nearby counterfactual.
plane = rect(35,45,250,205,fill:PAPER,stroke:INK,sw:3)
cloud = [[65,75],[104,62],[145,88],[215,73],[248,113],[74,153],[122,136],[183,145],[234,193],[91,220],[164,215]].map.with_index do |(x,y),i|
  circle(x,y,7,fill:i%3==0 ? RED : BLUE,sw:2)
end.join
query = circle(150,150,11,fill:YELLOW,sw:3) + circle(150,150,56,fill:"none",stroke:YELLOW,sw:4,dash:"6 6")
counter = arrow(178,171,244,224,color:RED) + circle(250,230,11,fill:PAPER,stroke:RED,sw:4)
explanation = 4.times.map { |i| rect(334,74+i*43,94-i*12,23,fill:[BLUE,YELLOW,RED,PAPER_DIM][i],sw:2) }.join
write_visual("knn-explanations", plane + cloud + query + counter + explanation, accent: YELLOW, secondary: BLUE)

# A polyomino net folds into two different boxes.
net_cells = [[1,0],[0,1],[1,1],[2,1],[1,2],[1,3]].map.with_index do |(cx,cy),i|
  rect(46+cx*42,62+cy*42,42,42,fill:[PAPER_DIM,YELLOW,BLUE,RED][i%4],sw:2)
end.join
folds = path("M192 91 C240 57 283 63 311 92",stroke:RED,sw:4,dash:"7 6")
box1 = polygon([[326,78],[385,97],[354,122],[296,102]],fill:YELLOW,sw:3) + polygon([[296,102],[354,122],[354,180],[296,160]],fill:BLUE,sw:3) + polygon([[354,122],[385,97],[385,154],[354,180]],fill:RED,sw:3)
box2 = polygon([[327,200],[388,215],[358,240],[298,225]],fill:PAPER_DIM,sw:3) + line(298,225,298,257) + line(358,240,358,272) + line(388,215,388,246) + line(298,257,358,272) + line(358,272,388,246)
write_visual("box-unfolding", net_cells + folds + box1 + box2, accent: BLUE, secondary: YELLOW)

# One added clause changes which other clauses remain blocked.
clauses = 6.times.map do |i|
  fill = i == 2 ? RED : (i.even? ? PAPER_DIM : PAPER)
  rect(42,55+i*31,164,22,fill:fill,sw:2) + 5.times.map { |j| circle(58+j*28,66+i*31,4,fill:i==2 ? PAPER : [BLUE,YELLOW][j%2],stroke:INK,sw:1) }.join
end.join
cycle_nodes = [[314,77],[395,78],[428,149],[375,220],[296,205],[277,137]]
cycle = cycle_nodes.each_with_index.map { |point,i| arrow(*point,*cycle_nodes[(i+1)%cycle_nodes.size],color:i==2 ? RED : INK,sw:3) }.join
cycle += cycle_nodes.map.with_index { |(x,y),i| circle(x,y,12,fill:[BLUE,YELLOW,RED][i%3],sw:2) }.join
write_visual("blocked-clauses", clauses + arrow(218,145,259,145,color:RED) + cycle, accent: RED, secondary: YELLOW)

# A formal language sits between a decision tree and a compact explanation.
tree_pts = [[82,65],[50,118],[118,118],[31,177],[69,177],[101,177],[139,177]]
tree = [[0,1],[0,2],[1,3],[1,4],[2,5],[2,6]].map { |a,b| line(*tree_pts[a],*tree_pts[b],stroke:INK,sw:3) }.join
tree += tree_pts.map.with_index { |(x,y),i| circle(x,y,10,fill:[YELLOW,BLUE,RED][i%3],sw:2) }.join
syntax = rect(196,79,108,118,fill:PAPER_DIM,sw:3) + label(250,111,"∀x",size:24,fill:RED) + label(250,145,"∧",size:26,fill:INK) + label(250,177,"∃y",size:24,fill:BLUE)
answer = rect(357,92,79,90,fill:PAPER,sw:3) + path("M374 138 l15 16 l31 -38",stroke:RED,sw:5)
write_visual("decision-language", tree + arrow(150,132,183,132,color:RED) + syntax + arrow(315,132,345,132,color:RED) + answer, accent: BLUE, secondary: RED)

# Online sorting: arriving tiles must be committed to a nearly ordered strip.
slots = 12.times.map { |i| rect(24+i*36,190,30,42,fill:[PAPER_DIM,PAPER][i%2],sw:2) }.join
placed = [[1,BLUE],[3,YELLOW],[6,RED],[9,BLUE]].map { |i,color| rect(24+i*36,190,30,42,fill:color,sw:2) + label(39+i*36,211,(i+1).to_s,size:17,fill:PAPER) }.join
falling = rect(251,58,42,42,fill:YELLOW,sw:3) + label(272,79,"5",size:21) + arrow(272,111,272,172,color:RED)
order = arrow(45,254,424,254,color:INK,sw:3)
write_visual("online-sorting", slots + placed + falling + order, accent: YELLOW, secondary: BLUE)

# Rectangles of different proportions make a nearly perfect packing.
packing = rect(53,46,374,208,fill:PAPER,sw:4)
pieces = [
  [53,46,88,68,RED],[141,46,118,42,YELLOW],[259,46,168,84,BLUE],
  [141,88,59,96,BLUE],[200,88,59,96,RED],[53,114,88,140,YELLOW],
  [259,130,96,124,YELLOW],[355,130,72,62,RED],[355,192,72,62,BLUE],
  [141,184,118,70,PAPER_DIM]
].map { |x,y,w,h,color| rect(x,y,w,h,fill:color,sw:2) }.join
write_visual("rectangle-packing", packing + pieces, accent: BLUE, secondary: YELLOW)

# A mixed assortment is matched to a line of indifferent attendees.
stock = 3.times.map do |row|
  4.times.map { |col| rect(35+col*43,62+row*43,31,31,fill:[RED,BLUE,YELLOW,PAPER_DIM][(row+col)%4],sw:2,rx:5) }.join
end.join
people = 7.times.map do |i|
  x = 276+i*25
  circle(x,83+(i%2)*8,9,fill:PAPER,sw:2) + line(x,93+(i%2)*8,x,135+(i%2)*8,stroke:INK,sw:2) + line(x,108+(i%2)*8,x-10,126+(i%2)*8,stroke:INK,sw:2) + line(x,108+(i%2)*8,x+10,126+(i%2)*8,stroke:INK,sw:2)
end.join
choice = arrow(202,125,252,125,color:RED) + 6.times.map { |i| rect(275+i*27,190,22,33,fill:[RED,BLUE,YELLOW][i%3],sw:2,rx:4) }.join
write_visual("conference-assortment", stock + people + choice, accent: YELLOW, secondary: RED)

# A point set with one convex pentagon brought to the foreground.
points = [[63,75],[119,54],[175,88],[238,64],[298,93],[365,64],[420,105],[76,167],[142,144],[214,177],[281,145],[346,180],[413,165],[110,237],[193,220],[270,240],[374,229]]
dots = points.map { |x,y| circle(x,y,5,fill:INK,stroke:INK,sw:1) }.join
pent = polygon([points[2],points[4],points[11],points[15],points[9]],fill:YELLOW,stroke:RED,sw:5,opacity:0.66)
write_visual("pentagon-points", dots + pent, accent: RED, secondary: YELLOW)

# Candidate configurations pass through a proof/certificate funnel.
configs = 3.times.map do |i|
  ox = 28+i*116
  rect(ox,57,92,74,fill:PAPER_DIM,sw:2) + 6.times.map { |j| circle(ox+17+(j%3)*28,75+(j/3)*35,4,fill:[RED,BLUE,YELLOW][(i+j)%3],stroke:INK,sw:1) }.join
end.join
funnel = polygon([[80,158],[350,158],[286,219],[145,219]],fill:PAPER_DIM,stroke:INK,sw:3) + 3.times.map { |i| arrow(75+i*116,133,151+i*52,186,color:[RED,BLUE,YELLOW][i],sw:3) }.join
certificate = rect(354,184,83,55,fill:PAPER,sw:3) + path("M370 211 l12 13 l36 -31",stroke:RED,sw:5)
write_visual("automated-pentagons", configs + funnel + arrow(288,219,343,211,color:INK) + certificate, accent: BLUE, secondary: RED)

# A conspicuously empty hexagon among many points.
hex_points = [[132,77],[223,58],[315,86],[347,172],[279,231],[175,224]]
background = [[62,55],[87,126],[60,210],[119,248],[257,102],[399,63],[423,142],[400,234]].map { |x,y| circle(x,y,5,fill:INK,stroke:INK,sw:1) }.join
hex = polygon(hex_points,fill:PAPER,stroke:RED,sw:6)
vertices = hex_points.map.with_index { |(x,y),i| circle(x,y,8,fill:[BLUE,YELLOW][i%2],sw:2) }.join
write_visual("empty-hexagon", background + hex + vertices, accent: RED, secondary: BLUE)

# A very long machine-checkable proof scroll connects two graph colorings.
scroll = path("M74 72 C50 72 50 102 74 102 H375 C410 102 410 132 375 132 H95 C60 132 60 162 95 162 H392 C427 162 427 192 392 192 H82 C47 192 47 222 82 222 H411",stroke:INK,sw:9)
marks = 22.times.map do |i|
  x = 91 + (i%6)*54
  y = 87 + (i/6)*30
  line(x,y,x+16,y,stroke:[RED,BLUE,YELLOW][i%3],sw:4)
end.join
write_visual("long-proof", scroll + marks + circle(53,72,14,fill:YELLOW,sw:3) + circle(430,222,14,fill:RED,sw:3), accent: YELLOW, secondary: RED)

# A compact thumbnail of the 15-color packing pattern and its local magnification.
packing_palette = [BLUE,RED,YELLOW,PAPER_DIM]
packing_grid = 9.times.map do |row|
  13.times.map do |col|
    rect(29+col*14,67+row*14,14,14,fill:packing_palette[(row*3+col*5+row*col)%4],stroke:PAPER,sw:1)
  end.join
end.join
zoom = rect(282,71,145,145,fill:PAPER,sw:4) + 4.times.map do |row|
  4.times.map do |col|
    fill = packing_palette[(row*3+col*5+row*col)%4]
    rect(293+col*33,82+row*33,33,33,fill:fill,sw:2) + label(309+col*33,99+row*33,[1,2,1,3,1,4,1,5,2,1,6,1,1,3,1,7][row*4+col],size:15,fill:fill == PAPER_DIM || fill == YELLOW ? INK : PAPER)
  end.join
end.join
connectors = line(198,81,282,82,stroke:RED,sw:3) + line(198,193,282,216,stroke:RED,sw:3)
write_visual("packing-fifteen", packing_grid + connectors + zoom + label(122,224,"72 × 72",size:19,fill:BLUE) + label(354,242,"15 colors",size:19,fill:RED), accent: BLUE, secondary: YELLOW)

# A symbolic decision path becomes a compact logical explanation.
tree_pts2 = [[101,55],[59,105],[144,105],[35,163],[80,163],[122,163],[169,163]]
symbolic_tree = [[0,1],[0,2],[1,3],[1,4],[2,5],[2,6]].map { |a,b| line(*tree_pts2[a],*tree_pts2[b],stroke:INK,sw:3) }.join
symbolic_tree += tree_pts2.map.with_index { |(x,y),i| circle(x,y,11,fill:[BLUE,YELLOW,RED][i%3],sw:2) + label(x,y,["x","?","y","0","1","0","1"][i],size:14,fill:i>2 ? PAPER : INK) }.join
path_highlight = path("M101 55 L144 105 L122 163",stroke:RED,sw:7)
logic = rect(257,70,173,120,fill:PAPER_DIM,sw:3) + label(343,103,"x₃ ∧ ¬x₇",size:22,fill:BLUE) + line(282,133,404,133,stroke:INK,sw:2) + label(343,163,"⇒ 1",size:24,fill:RED)
write_visual("symbolic-tree", symbolic_tree + path_highlight + arrow(188,130,242,130,color:RED) + logic, accent: BLUE, secondary: YELLOW)

# Predictions arrive ahead of reality and steer an online choice.
forecast = path("M38 188 C91 112 142 153 192 94 C242 37 286 129 340 86 C381 53 413 78 445 52",stroke:BLUE,sw:5,dash:"8 7")
actual = path("M38 218 C93 177 146 201 194 145 C245 91 290 168 343 127 C389 90 419 120 445 101",stroke:RED,sw:5)
checks = [[92,177],[194,145],[343,127],[445,101]].map { |x,y| circle(x,y,8,fill:YELLOW,sw:2) }.join
tiles = 8.times.map { |i| rect(47+i*49,238,35,27,fill:[PAPER_DIM,YELLOW,BLUE][i%3],sw:2) }.join
write_visual("prediction-stream", forecast + actual + checks + tiles, accent: BLUE, secondary: RED)

# A Wordle-like reduction with three feedback rows and one hard constraint.
word_rows = 4.times.map do |row|
  5.times.map do |col|
    colors = row == 3 ? [YELLOW,RED,BLUE,YELLOW,RED] : [PAPER_DIM,YELLOW,PAPER_DIM,BLUE,PAPER_DIM].rotate(row)
    rect(45+col*48,54+row*48,39,39,fill:colors[col],sw:2)
  end.join
end.join
constraint = arrow(305,150,350,150,color:RED) + rect(365,87,69,126,fill:PAPER,sw:3) + 4.times.map { |i| circle(399,111+i*28,6,fill:[RED,YELLOW,BLUE][i%3],sw:2) }.join
write_visual("word-grid", word_rows + constraint, accent: YELLOW, secondary: BLUE)

# Relational tables and matrices meet in one algebraic object.
table = rect(35,63,135,143,fill:PAPER,sw:3)
table += [1,2,3].map { |i| line(35,63+i*35.75,170,63+i*35.75,stroke:MUTED,sw:2) }.join
table += [1,2].map { |i| line(35+i*45,63,35+i*45,206,stroke:MUTED,sw:2) }.join
matrix = rect(316,72,118,126,fill:PAPER,sw:3)
matrix += 4.times.map { |row| 4.times.map { |col| rect(329+col*25,83+row*25,17,17,fill:[BLUE,YELLOW,RED,PAPER_DIM][(row+col)%4],stroke:"none",sw:0) }.join }.join
operator = circle(241,135,38,fill:PAPER_DIM,sw:3) + label(241,136,"⊕",size:34,fill:RED)
write_visual("lara-algebra", table + arrow(181,135,200,135,color:INK) + operator + arrow(282,135,303,135,color:INK) + matrix, accent: BLUE, secondary: YELLOW)

# Logic provides a bridge between data, models, and explanations.
model = 4.times.map { |i| rect(38,65+i*42,72+i*16,24,fill:[BLUE,YELLOW,RED,PAPER_DIM][i],sw:2) }.join
bridge = path("M164 209 C189 116 287 116 316 209",stroke:INK,sw:9) + line(171,191,308,191,stroke:RED,sw:4,dash:"7 6")
symbols = ["∀","∧","¬","∃"].map.with_index { |s,i| circle(198+i*31,161-(i%2)*18,15,fill:[YELLOW,BLUE][i%2],sw:2) + label(198+i*31,161-(i%2)*18,s,size:16,fill:i.odd? ? PAPER : INK) }.join
answer = rect(349,83,84,104,fill:PAPER,sw:3) + path("M365 136 l14 15 l37 -43",stroke:RED,sw:5)
write_visual("logic-bridge", model + bridge + symbols + answer, accent: RED, secondary: BLUE)

# Linear, tree, and neural models become progressively harder to inspect.
linear_model = line(35,100,122,55,stroke:RED,sw:5) + 7.times.map { |i| circle(42+i*13,121-(i%3)*19,5,fill:i<4 ? BLUE : YELLOW,sw:1) }.join
tree_model = line(222,56,188,104) + line(222,56,257,104) + line(188,104,168,147) + line(188,104,207,147) + line(257,104,239,147) + line(257,104,277,147)
tree_model += [[222,56],[188,104],[257,104],[168,147],[207,147],[239,147],[277,147]].map.with_index { |(x,y),i| circle(x,y,8,fill:[YELLOW,BLUE,RED][i%3],sw:2) }.join
network_pts = 3.times.flat_map { |col| 4.times.map { |row| [347+col*43,66+row*42] } }
network_edges = 2.times.map do |col|
  4.times.map { |a| 4.times.map { |b| line(347+col*43,66+a*42,347+(col+1)*43,66+b*42,stroke:MUTED,sw:1,opacity:0.65) }.join }.join
end.join
network = network_edges + network_pts.map.with_index { |(x,y),i| circle(x,y,6,fill:[RED,BLUE,YELLOW][i%3],sw:1) }.join
glass = circle(255,226,27,fill:"none",stroke:INK,sw:6) + line(274,246,301,270,stroke:INK,sw:7)
write_visual("interpretability-complexity", linear_model + tree_model + network + glass, accent: RED, secondary: YELLOW)

# A tensor is sliced by a convolution window into a smaller matrix.
cube_lines = polygon([[55,88],[157,57],[219,101],[117,133]],fill:PAPER_DIM,sw:3) + polygon([[55,88],[117,133],[117,225],[55,181]],fill:BLUE,sw:3,opacity:0.55) + polygon([[117,133],[219,101],[219,192],[117,225]],fill:YELLOW,sw:3,opacity:0.65)
cube_grid = [1,2].map { |i| line(55+i*34,77+i*15,157+i*31,46+i*22,stroke:MUTED,sw:1) + line(55,88+i*31,117,133+i*31,stroke:MUTED,sw:1) }.join
kernel = rect(253,91,72,72,fill:RED,sw:3,opacity:0.72) + 2.times.map { |i| line(253+24*(i+1),91,253+24*(i+1),163,stroke:INK,sw:1) + line(253,91+24*(i+1),325,91+24*(i+1),stroke:INK,sw:1) }.join
result = rect(370,84,69,96,fill:PAPER,sw:3) + 3.times.map { |row| 2.times.map { |col| rect(382+col*27,96+row*27,20,20,fill:[BLUE,YELLOW,RED][(row+col)%3],stroke:"none",sw:0) }.join }.join
write_visual("tensor-query", cube_lines + cube_grid + arrow(227,132,245,132,color:INK) + kernel + arrow(334,132,359,132,color:INK) + result, accent: BLUE, secondary: RED)

# A sequence splits recursively into a wavelet tree and query path.
sequence = [RED,BLUE,YELLOW,BLUE,RED,YELLOW,RED,BLUE].map.with_index { |color,i| rect(41+i*46,45,34,30,fill:color,sw:2) }.join
tree_pts3 = [[240,104],[145,153],[335,153],[93,215],[192,215],[288,215],[383,215]]
wave_edges = [[0,1],[0,2],[1,3],[1,4],[2,5],[2,6]].map { |a,b| line(*tree_pts3[a],*tree_pts3[b],stroke:INK,sw:3) }.join
wave_nodes = tree_pts3.map.with_index { |(x,y),i| rect(x-28,y-15,56,30,fill:[PAPER_DIM,BLUE,YELLOW,RED][i%4],sw:2,rx:4) }.join
query_path = path("M240 104 L145 153 L192 215",stroke:RED,sw:7)
write_visual("wavelet-tree", sequence + wave_edges + wave_nodes + query_path, accent: YELLOW, secondary: BLUE)

puts "Generated #{Dir[File.join(OUT, '*.svg')].size} publication visuals in #{OUT}"
