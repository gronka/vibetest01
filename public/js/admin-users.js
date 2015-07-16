
//function removeUserCFs() {
	////ajax.post("/admin/json/remove-user-cfs", true, adminNotify("User Column Families Removed"));
	//reqwest({url: "/admin/json/removeUserCFs",
					 //type: "json", 
					 //contentType: "application/json",
					 //method: "post",
					 //data: { yeah: "okay"},
					 //error: alert("Ajax error occurred."),
					 //success: function(resp) {
						 //adminNotify("\nUser Column Families Removed");
					 //}
	//});
//}
//function initUserCFs() {
	//reqwest({url: "/admin/json/initUserCFs",
					 //type: "json", 
					 //contentType: "application/json",
					 //method: "post",
					 //error: alert("Ajax error occurred."),
					 //success: function(resp) {
						 //adminNotify("\nUser Column Families Initialized");
					 //}
	//});
//}

function adminNotify(input) {
	document.admin_notes.admin_notes.value += input;
}



$(function() {
window.onload = function() {
	document.getElementById("drop_user_cfs").addEventListener("click", function() {
		var r = confirm("Are you sure you want to drop user Column Families?");
		dropUserCFs();
	});
	document.getElementById("init_user_cfs").addEventListener("click", function() {
		var r = confirm("Are you sure you want to initialize user Column Families?");
		initUserCFs();
	});
}

function initUserCFs() {
	$.ajax({
		url: "/admin/json/initUserCFs",
		succsess: function(data) {
			 adminNotify("\nUser Column Families Initialized");
		}
	});
}
function dropUserCFs() {
	$.ajax({
		url: "/admin/json/dropUserCFs",
		succsess: function(data) {
			 adminNotify("\nUser Column Families Dropped");
		}
	});
}



	$(window).bind("load", function() {
		$.ajaxSetup({
					type: 'POST',
					dataType: 'json',
					xhrFields: { withCredentials: true },
					async: true,
					contentType: 'application/json; charset=utf-8',
					success: function(data) {
						if (data == "Fail, reload") {
							location.reload();
						} else {
							location.reload();
						}
					},
					error: function() {
						alert("Ajax error occurred.");
					}
				});
	});

});

