{matrix, data, inverseData} = ig.getData!
container = d3.select ig.containers.base
new Tooltip!watchElements!
chord = d3.layout.chord!
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
def3 = d3.svg.chord!radius innerRadius
euCodes = <[CZ BE BG DK DE EE IE EL ES FR HR IT CY LV LT LU HU MT NL AT PL PT RO SI SK FI SE UK]>
fullNames =
  "Česká republika"
  "Belgie"
  "Bulharsko"
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
  "Česko"
  "Belgie"
  "BG"
  "Dán."
  "Německo"
  "EE"
  "Irsko"
  "Řecko"
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
  "Nizozemsko"
  "Rakousko"
  "Polsko"
  "PT"
  "RO"
  "SI"
  "SK"
  "Finsko"
  "Švédsko"
  "Spojené království"
draw = (data) ->
  chord.matrix data
  drawing.selectAll \path.radius .data chord.groups
    ..enter!append \path
      ..attr \class \radius
      ..style \fill arcFill
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

    ..transition!
      ..duration 800
      ..attr \d def2
  defs.selectAll \path .data chord.groups
    ..enter!append \path
      ..attr \id (d, i) -> "textPath-#i"
    ..transition!
      ..duration 800
      ..attr \d ->
        {startAngle, endAngle} = it
        endAngle += 0.1
        def {startAngle, endAngle}
  drawing.selectAll \text .data chord.groups
    ..enter!append \text
      ..attr \class (d, i) -> euCodes[i]
      ..append \textPath
        ..attr \xlink:href (d, i) -> '#textPath-' + i
        ..text (d, i) ->
          euNames[i]

  drawing.selectAll \path.chord .data chord.chords
    ..enter!append \path
      ..attr \class \chord
      ..style \fill (d, i) -> chordFill i
      ..style \stroke (d, i) -> chordFill i
    ..attr \data-tooltip ({source, target}:d) ->
      "#{fullNames[target.index]} ➔ #{fullNames[source.index]} #{ig.utils.formatNumber data[source.index][target.index]}<br>
      #{fullNames[source.index]} ➔ #{fullNames[target.index]} #{ig.utils.formatNumber data[target.index][source.index]}"
    ..transition!
      ..duration 800
      ..attr \d def3

draw matrix
