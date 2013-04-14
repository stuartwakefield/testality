$(function() {
	
	var TEST_MAX_CHECK_INTERVAL = 10000;
	
	var frms = [
		$("#iframe1").get(0),
		$("#iframe2").get(0)
	];
	var hash = 0;
	var current = null;
	
	function check() {
		
		$.ajax({
			url: "?action=check&hash=" + hash,
			async: true,
			success: function(data) {
				if(hash != data.hash) {
					hash = data.hash;
					frms.push(current = frms.shift());
					
					$(current)
						.load(function() {
							$(this)
								.unbind("load")
								.addClass("shown")
								.height($(this).contents().height());
							
						//	$(current)
							//	.unbind("load")
							//	.addClass("shown")
								// This quite nicely fixes the issue where loading a new iframe returns the
								// scrolling to the top of the page. Instead of having the scroll being controlled
								// by the iframe instead the scrolling is controlled by the parent page. In order
								// to do this the iframe must be the height of its contents, which it does not
								// inherently do
							//	.height(bdy.scrollHeight);
							/*	
							console.log();
							*/
							var me = this;
							setTimeout(function() {
								if($(me).height() < $(me).contents().height())
									$(me).height($(me).contents().height());
							}, 100);

							$(frms[0]).removeClass("shown");
							
						})
						.attr("src", "?action=test");
				}
				check();
			},
			error: function(data) {
				console.error(data);
			}
		});
	}
	
	check();
	
});
