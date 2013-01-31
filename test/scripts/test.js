var tests = [
    new HelloTest(new Hello())
];

var errors = [];
var results = [];

for(var i = 0; i < tests.length; ++i) {
	var test = tests[i];
	
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
	
}

// Send the results to testality
testality.send(results);
