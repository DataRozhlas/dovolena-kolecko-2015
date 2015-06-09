{matrix, data, inverseData} = ig.getData!
container = d3.select ig.containers.base
new Tooltip!watchElements!
chord = d3.layout.chord!
  ..matrix matrix
  ..padding 0.035
width = 720
height = 720
innerRadius = 680 * 0.48
outerRadius = 680 * 0.5
arcFill = (d, i) ->
  chordFill i

chordFill = d3.scale.category20c!

svg = container.append \svg
  ..attr \width width
  ..attr \height height
defs = svg.append \defs

drawing = svg.append \g
  ..attr \transform "translate(#{width / 2}, #{height / 2})"
def = d3.svg.arc!innerRadius innerRadius .outerRadius outerRadius + 5
def2 = d3.svg.arc!innerRadius innerRadius .outerRadius outerRadius
drawing.selectAll \path.radius .data chord.groups .enter!append \path
  ..attr \class \radius
  ..style \fill arcFill
  ..attr \d def2
  ..attr \data-tooltip (d) ->
      outbound = 0
      inbound = 0
      index = d.index
      for i in [0 til 28]
        outbound += data[i][index]
        inbound += data[index][i]
      "Turistů: #{ig.utils.formatNumber outbound}<br>
      Návštěvníků:#{ig.utils.formatNumber inbound}"
defs.selectAll \path .data chord.groups .enter!append \path
  ..attr \id (d, i) -> "textPath-#i"
  ..attr \d def
euCodes = <[BE BG CZ DK DE EE IE EL ES FR HR IT CY LV LT LU HU MT NL AT PL PT RO SI SK FI SE UK]>
drawing.selectAll \text .data chord.groups .enter!append \text
  ..append \textPath
    ..attr \xlink:href (d, i) -> '#textPath-' + i
    ..text (d, i) ->
      euCodes[i]

def = d3.svg.chord!radius innerRadius


drawing.selectAll \path.chord .data chord.chords .enter!append \path
  ..attr \class \chord
  ..attr \d def
  ..style \fill (d, i) -> chordFill i
  ..style \stroke (d, i) -> chordFill i
  ..attr \data-tooltip ({source, target}:d) ->
    "#{euCodes[target.index]} -> #{euCodes[source.index]} #{ig.utils.formatNumber data[source.index][target.index]}<br>
    #{euCodes[source.index]} -> #{euCodes[target.index]} #{ig.utils.formatNumber data[target.index][source.index]}"
