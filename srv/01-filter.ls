require! fs
euCodes = <[BE BG CZ DK DE EE IE EL ES FR HR IT CY LV LT LU HU MT NL AT PL PT RO SI SK FI SE UK]>
lines = fs.readFileSync "#__dirname/../data/all.tsv" .toString!split "\n"
  ..shift!
  ..pop!
out = []
outLines = for line in lines
  [where, who, ...years] = line.split "\t"
  continue unless where in euCodes and who in euCodes
  value = years
    .map parseInt _, 10
    .filter -> it
    .pop!
  continue unless value
  whereIndex = euCodes.indexOf where
  whoIndex = euCodes.indexOf who
  out[whereIndex] ?= euCodes.map -> 0
  continue if whereIndex == whoIndex
  out[whereIndex][whoIndex] = value
  "#where\t#who\t#value"

# out.unshift euCodes
fs.writeFileSync do
  "#__dirname/../data/matrix.tsv"
  out
    .map (-> it.join "\t")
    .join "\n"

# outLines.unshift "where\twho\tvalue"
# fs.writeFileSync "#__dirname/../data/data.tsv" outLines.join "\n"
