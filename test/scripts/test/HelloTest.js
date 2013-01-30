function HelloTest(hello) {
	
	var assert = function(expected, actual) {
		if(expected !== actual) {
			throw new Error("Should have said " + expected + ", actually said " + actual);
		}
	};
	
	this.testSayHello = function() {
		assert("Hello", hello.sayHello());
	};
	
	this.testSayGoodbye = function() {
		assert("Goodbye", hello.sayGoodbye());
	};
	
}