var testality = (function() {
	
	var json = {
			
		parse: function(str) {
			var res;
			
			if(window.JSON)
				res = JSON.parse(str);
			else
				res = (new Function("return " + str)) ();
			
			return res;
		},
		
		stringify: function(data) {
			var res;
			
			if(window.JSON) {
				res = JSON.stringify(data);
			
			} else if(data == null) {
				res = "null";
				
			} else if(typeof data === "object" && object instanceof Array) {
				var arr = [];
				for(var i = 0; i < data.length; ++i)
					arr.push(json.stringify(data[i]));
				res = "[" + arr.join(",") + "]";
				
			} else if(typeof data === "object") {
				var arr = [];
				for(var x in data)
					arr.push(json.stringify(x) + ":" + json.stringify(data[x]));
				res = "{" + arr.join(",") + "}";
				
			} else if(typeof data === "string") {
				res = "\"" + data.replace(/\\/, "\\\\", "all").replace(/"/, "\\\"", "all") + "\"";
				
			} else {
				res = data;
			}
			
			
			return res;
		}
		
	};
	
	var updated = function() {
		if(this.readyState === 4) {
			if(this.status === 200) {
				callback(json.parse(this.responseText));
			} else {
				throw new Error("Request failed!");
			}
		}
	};
	
	var send = function(verb, url, data, callback) {
		
		var xhr;
		
		
		
		if(window.XMLHttpRequest) {
			xhr = new XMLHttpRequest();
		} else if(window.ActiveXObject) {
			try {
				xhr = new ActiveXObject("Msxml2.XMLHTTP");
			} catch(ex) {
				try {
					xhr = new ActiveXObject("Microsoft.XMLHTTP");
				} catch(ex) {}
			}
		}
			
		
		if(!xhr) {
			throw new Error("Cannot create XMLHttpRequest");
		}
		
		
		xhr.onreadystatechange = updated;
		
		xhr.open(verb.toUpperCase(), url, true);
		xhr.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
		
		xhr.send(json.stringify(data));
		
	};
	
	var poll;
	
	var receiveStat = function(response) {
		if(response.updates)
			window.location = "/";
		else
			poll();
	};
	
	(poll = function() {
		send("get", "/listen", null, receiveStat);
	}) ();
	
	var receiveResult = function(response) {
		if(!response.success)
			throw new Error("The results were not sent successfully!");
	};
	
	return {
		send: function(result) {
			send("post", "/", result, receiveResult);
		}
	};
	
}) ();