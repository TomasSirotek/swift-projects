// let myString = 'world';
//  function solution(string: string) : string {
//   return string.split('').reverse().join('');
// }
// console.log(solution(myString)
//
var haystack = ['3', '123124234', null, 'needle', 'world', 'hay', 2, '3', true, false];
function findNeedle(haystack) {
    var index = haystack.indexOf('needle');
    return "found the needle at position ".concat(index);
}
console.log(findNeedle(haystack));
