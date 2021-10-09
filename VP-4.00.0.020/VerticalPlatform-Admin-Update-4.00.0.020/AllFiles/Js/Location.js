$(document).ready(function() {
	
	if ($("input[id$='rdbCountry']").attr("checked")) {
		CountrySelected();
	}
	else if ($("input[id$='rdbRegion']").attr("checked")) {
		RegionSelected();
	}
	
	function CountrySelected()
	{
		$(".region").hide();
		$(".country").show();
		$("select[id$='ddlCountry']").val("");
		$("input[type='checkbox'][id$='chkExcludeCountry']").attr("checked", false);
	}
	
	function RegionSelected()
	{
		$(".country").hide();
		$(".region").show();
		$("select[id$='ddlRegion']").val("");
		$("input[type='checkbox'][id$='chkExcludeRegion']").attr("checked", false);
	}
		
	$("input[name$='Location']").change(function() {
		if ($("input[id$='rdbCountry']").attr("checked")) {
			CountrySelected();
		}
		else if ($("input[id$='rdbRegion']").attr("checked")) {
			RegionSelected();
		}
	});

	$("input[id$='btnAddLocation']").click(function() {
		if ($("input[id$='rdbCountry']").attr("checked")) {
			if ($("select[id$='ddlCountry']").val() == "") {
				$.notify({ message: "Please select a country", type: "error" });
				return false;
			}
		}
		else if ($("input[id$='rdbRegion']").attr("checked")) {
			if ($("select[id$='ddlRegion']").val() == "") {
				$.notify({ message: "Please select a region", type: "error" });
				return false;
			}
		}
	});
});