/**
 * User-defined function (UDF) to transform elements as part of a Dataflow
 * template job.
 *
 * @param {string} inJson input JSON message (stringified)
 * @return {?string} outJson output JSON message (stringified)
 */
// function process(inJson) {
//   const obj = JSON.parse(inJson);

//   // Add a field: obj.newField = 1;
//   // Modify a field: obj.existingField = '';
//   // Filter a record: return null;

//   return JSON.stringify(obj);
// }
function transform(line) {
var values = line.split(',');

var obj = new Object();
obj.Date = values[0];
obj.Open = values[1];
obj.High = values[2];
obj.Low = values[3];
obj.Close = values[4];
obj.Adj_Close = values[5];
obj.Volume = values[6];
var jsonString = JSON.stringify(obj);

return jsonString;
}