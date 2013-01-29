var tests = [
    new HelloTest(new Hello())
];

var errors = [];
var results = [];

for(var x in test) {
	var result = {name: x};
	try {
		test[x].call();
		result.pass = true;
	} catch(ex) {
		result.pass = false;
		result.message = ex.message;
		result.stack = ex.stack;
	}
	results.push(result);
}

testality.send(results);
