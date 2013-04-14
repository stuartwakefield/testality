var assertion = {
	
	isNull: function(v, msg) {
		if(v != null)
			throw new Error(msg || "Should be null!");
	},
	
	isNotNull: function(v, msg) {
		if(v == null)
			throw new Error(msg || "Should not be null!");			
	},
	
	isTrue: function(v, msg) {
		if(v != true)
			throw new Error(msg || "Should be true!");	
	},
	
	isFalse: function(v, msg) {
		if(v != false)
			throw new Error(msg || "Should be false!");
	},
	
	isString: function(v, msg) {
		if(typeof v != "string")
			throw new Error(msg || "Should be a <string> but was a <" + typeof v + ">!");
	},
	
	areEqual: function(expected, actual, msg) {
		if(expected != actual)
			throw new Error(msg || expected + " and " + actual + " should be equal!");	
	},
	
	areNotEqual: function(expected, actual, msg) {
		if(expected == actual)
			throw new Error(msg || expected + " and " + actual + " should not be equal!");	
	},
	
	areSame: function(expected, actual, msg) {
		if(expected !== actual)
			throw new Error(msg || expected + " and " + actual + " should be the same!");	
	},
	
	areNotSame: function(expected, actual, msg) {
		if(expected === actual)
			throw new Error(msg || expected + " and " + actual + " should not be the same!");	
	}
	
};