const a = [0.79, 0.13, 0.16, 0.64, 0.39, 0.2, 0.89, 0.53, 0.71, 0.42];

const b = Array(10)
	.fill(null)
	.map(() => []);
// const b = Array(10).fill([]); use same []

for (const i of a) {
	const temp = Math.floor(i * 10);
	b[temp].push(i);
	b[temp].sort();
}

console.log("[");
for (const i of b) {
	console.log(i);
}
console.log("]");
// [
// []
// [ 0.13, 0.16 ]
// [ 0.2 ]
// [ 0.39 ]
// [ 0.42 ]
// [ 0.53 ]
// [ 0.64 ]
// [ 0.71, 0.79 ]
// [ 0.89 ]
// []
// ]
