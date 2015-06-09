{matrix, data, inverseData} = ig.getData!
container = d3.select ig.containers.base
new Tooltip!watchElements!
chord = d3.layout.chord!
  ..matrix matrix
  ..padding 0.035
width = 720
height = 720
innerRadius = 670 * 0.48
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
euCodes = <[BE BG CZ DK DE EE IE EL ES FR HR IT CY LV LT LU HU MT NL AT PL PT RO SI SK FI SE UK]>
fullNames =
  "Belgie"
  "Bulharsko"
  "Česká republika"
  "Dánsko"
  "Německo"
  "Estonsko"
  "Irsko"
  "Řecko"
  "Španělsko"
  "Francie"
  "Chorvatsko"
  "Itálie"
  "Kypr"
  "Lotyšsko"
  "Litva"
  "Luxemburg"
  "Maďarsko"
  "Malta"
  "Nizozemí"
  "Rakousko"
  "Polsko"
  "Portugalsko"
  "Rumunsko"
  "Slovinsko"
  "Slovensko"
  "Finsko"
  "Švédsko"
  "Spojené království"
euNames =
  "Belgie"
  "BG"
  "CZ"
  "Dán."
  "Německo"
  "EE"
  "Irsko"
  "Řec."
  "Španělsko"
  "Francie"
  "HR"
  "Itálie"
  "CY"
  "LV"
  "LT"
  "LU"
  "HU"
  "MT"
  "Nizoz."
  "Rakousko"
  "Pol."
  "PT"
  "RO"
  "SI"
  "SK"
  "Fin."
  "Švéd."
  "Spojené království"
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
      "<b>#{fullNames[index]}</b><br>
      Odjíždějící #{ig.utils.formatNumber outbound}<br>
      Přijíždějící #{ig.utils.formatNumber inbound}"
defs.selectAll \path .data chord.groups .enter!append \path
  ..attr \id (d, i) -> "textPath-#i"
  ..attr \d def
drawing.selectAll \text .data chord.groups .enter!append \text
  ..append \textPath
    ..attr \xlink:href (d, i) -> '#textPath-' + i
    ..text (d, i) ->
      euNames[i]

def = d3.svg.chord!radius innerRadius


drawing.selectAll \path.chord .data chord.chords .enter!append \path
  ..attr \class \chord
  ..attr \d def
  ..style \fill (d, i) -> chordFill i
  ..style \stroke (d, i) -> chordFill i
  ..attr \data-tooltip ({source, target}:d) ->
    "#{fullNames[target.index]} ➔ #{fullNames[source.index]} #{ig.utils.formatNumber data[source.index][target.index]}<br>
    #{fullNames[source.index]} ➔ #{fullNames[target.index]} #{ig.utils.formatNumber data[target.index][source.index]}"
