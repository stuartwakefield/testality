function HelloTest(hello) {
	
	this.testSayHello = function() {
		var expected = "Hello";
		var actual = hello.sayHello();
		if(expected !== actual) {
			throw new Error("Should have said " + expected + ", actually said " + actual);
		}
	}
	
}