<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitionVendorSort.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Exhibition.ExhibitionVendorSort" %>
<script type="text/javascript">
(function($) {
	$(document).ready(function() {
		ChangeSortOrder();
		$(".exibition_sort_rows").sortable({
			beforeStop: function(event, ui) { ChangeSortOrder() }
		});
	});

	ChangeSortOrder = function() {
		var sortOrder = '';
		$('li input', 'ul.exibition_sort_rows').each(function() {
			if (sortOrder == '') {
				sortOrder = $(this).val();
			}
			else {
				sortOrder += '|' + $(this).val();
			}
		});

		$("input[id$='hdnVendorSortOrder']").val(sortOrder);
	}

})(jQuery);
</script>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<div style="width: 315px; float: left" runat="server" id="divVendorList"></div>
		<asp:HiddenField ID="hdnVendorSortOrder" runat="server" />
	</li>
</ul>