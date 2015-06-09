require! fs
euCodes = <[BE BG CZ DK DE EE IE EL ES FR HR IT CY LV LT LU HU MT NL AT PL PT RO SI SK FI SE UK]>
lines = fs.readFileSync "#__dirname/../data/all.tsv" .toString!split "\n"
  ..shift!
  ..pop!

outLines = for line in lines
  [where, who, ...years] = line.split "\t"
  continue unless where in euCodes and who in euCodes
  value = years
    .map parseInt _, 10
    .filter -> it
    .pop!
  continue unless value
  "#where\t#who\t#value"

outLines.unshift "where\twho\tvalue"
fs.writeFileSync "#__dirname/../data/data.tsv" outLines.join "\n"
