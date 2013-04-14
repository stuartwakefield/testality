var tester = {	
				
	_tests: [],
	_logs: [],
	
	addTest: function(name, test) {
		this._tests.push({
			name: name,
			test: test	
		});				
	},
	
	runTests: function() {
		var log = {};
		for(var i = 0; i < this._tests.length; ++i) {
			var name = this._tests[i].name;
			var unit = this._tests[i].test;
			for(var x in unit) {
				
				if(x.search(/^test/) != -1) {
					try {
						if(unit.setUp)
							unit.setUp();
						unit[x].call(unit);	
						this.log(name, x, true, "Passed successfully");	
					} catch(ex) {
						this.log(name, x, false, ex.message, ex.stack);
					}
					if(unit.tearDown)
						unit.tearDown();
				}	
			}
		}					
	},
	
	getResult: function(test) {
		
		var result = {
			passCount: 0,
			failCount: 0,
			testCount: 0,
			cases: []
		};
		
		for(var x in this._logs) {
			
			var caseResult = {
				name: x,
				passCount: 0,
				failCount: 0,
				testCount: 0,
				methods: []
			};
			
			for(var y in this._logs[x]) {
				
				var method = {
					name: y,
					pass: this._logs[x][y].pass,
					message: this._logs[x][y].msg
				};
				
				if(this._logs[x][y].stack)
					method.stack = this._logs[x][y].stack;
				caseResult.testCount ++;
				if(this._logs[x][y].pass) {
					caseResult.passCount ++;
				} else {
					caseResult.failCount ++;
				}
				
				caseResult.methods.push(method);
			}
			result.passCount += caseResult.passCount;
			result.failCount += caseResult.failCount;
			result.testCount += caseResult.testCount;
			result.cases.push(caseResult);
		}
		return result;
	},
	
	log: function(test, method, pass, msg, stack) {
		if(this._logs[test] == null)
			this._logs[test] = {};
		this._logs[test][method] = {
			pass: pass,
			msg: msg
		};
		if(stack)
			this._logs[test][method].stack = stack;
	}
	
};
