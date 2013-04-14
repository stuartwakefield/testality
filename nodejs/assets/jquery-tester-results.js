function zerofill(n, d) {
	for(--d; d > 0; --d) {
		if(n < Math.pow(10, d))
			n = "0" + n;
	}
	return n;
}

var renderer = (function() {
	
	var resultLogs, resultSummary, resultTests, runat;
	
	function init() {
		resultLogs = $(".resultLogs");
		resultSummary = $(".resultSummary");
		resultTests = $(".resultTests");
		runat = $(".runat");
	}
	
	function render(result) {
		
		var frag = document.createDocumentFragment();
		for(var i = 0; i < result.cases.length; ++i) {
			
			var id = result.cases[i].name.replace(/\./g, "-");
			var $el = $(
				'<li>' + 
					'<h3/>' +
					'<ul/>' +
				'</li>'
			);
			
			$el.find("h3")
				.text(result.cases[i].name)
				.attr("id", id);
				
			var $list = $el.find("ul");
			
			for(var j = 0; j < result.cases[i].methods.length; ++j) {
				
				var $li = $(
					'<li class="log">' +
						'<div class="test"/> ' +
						'<div class="message"/>' + 
						(result.cases[i].methods[j].stack ? '<pre class="stack"/>' : '') +
					'</li>'
				);
				
				!result.cases[i].methods[j].pass 
					&& $li.addClass("failLog");
					
				$li.find(".test").text(result.cases[i].methods[j].name);
				$li.find(".message").text(result.cases[i].methods[j].message);
				if(result.cases[i].methods[j].stack)
					$li.find(".stack").text(result.cases[i].methods[j].stack);
				$list.append($li);
			}
			frag.appendChild($el.get(0));
		}
		resultLogs.empty().append(frag);
		
		var frag = document.createDocumentFragment();
		for(var i = 0; i < result.cases.length; ++i) {
			
			var id = result.cases[i].name.replace(/\./g, "-");
			var $el = $(
				'<li class="test">' +
					'<a></a>' +
					'<div class="testResults">' +
						'<dl class="methodCount">' +
							'<dt>Test methods</dt>' +
							'<dd/>' +
						'</dl>' +
						'<dl class="methodFailures">' +
							'<dt>Failures</dt>' +
							'<dd/>' +
						'</dl>' +
						'<dl class="methodPasses">' +
							'<dt>Passes</dt>' +
							'<dd/>' +
						'</dl>' +
					'</div>' +
				'</li>'
			);
			
			$el.find("a")
				.text(result.cases[i].name)
				.attr("href", "#" + id);
				
			result.cases[i].failCount != 0 
					&& $el.addClass("failTest");
				
			$el.find(".methodCount dd").text(result.cases[i].testCount);
			$el.find(".methodFailures dd").text(result.cases[i].failCount);
			$el.find(".methodPasses dd").text(result.cases[i].passCount);
			frag.appendChild($el.get(0));
		}
		resultTests.empty().append(frag);
		
		resultSummary.find(".summaryCount dd").text(result.testCount);
		resultSummary.find(".summaryFailures dd").text(result.failCount);
		resultSummary.find(".summaryPasses dd").text(result.passCount);
		
		if(result.failCount > 0) {
			resultSummary.addClass("failResult");
		} else {
			resultSummary.removeClass("failResult");				
		}
		
		var now = new Date();
		runat.text(
			zerofill(now.getDate(), 2) + "/" + 
			zerofill(now.getMonth(), 2) + "/" + 
			now.getFullYear() + " " + 
			zerofill(now.getHours(), 2) + ":" + 
			zerofill(now.getMinutes(), 2) + ":" + 
			zerofill(now.getSeconds(), 2)
		);
	}
	
	return {
		init: init,
		render: render
	}

}) ();