<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditSubHome.ascx.cs"
		Inherits="VerticalPlatformAdminWeb.ModuleAdmin.SubHome.AddEditSubHome" %>

<script type="text/javascript">
	$(document).ready(function() {
	var hdnCategoryId = { contentId: "hdnCategoryId" };
	options = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "10", showName: "true", bindings : hdnCategoryId};
		$("input[type=text][id*=txtCategoryName]").contentPicker(options);
	});

	function change(val) {
		if ($get("<%=txtSubHomeName.ClientID %>").value == "") {
			$get("<%=txtSubHomeName.ClientID %>").value = val;
		}
	}
</script>

<div>
	<table>
		<tr>
			<td>
				<asp:Literal ID="ltlSubHomeTitle" runat="server" Text="Name"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtSubHomeTitle" runat="server" Width="179px" onchange="change(this.value);"/>
				<asp:RequiredFieldValidator ID="rfvSubHomeTitle" runat="server" ErrorMessage="Subhome name cannot be blank." ControlToValidate="txtSubHomeTitle">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator ID="revSubHomeTitle" runat="server" ControlToValidate="txtSubHomeTitle"
					ErrorMessage="Subhome title can have only alphanumerics and underscore." ValidationExpression="^[a-zA-Z0-9_]*$">*</asp:RegularExpressionValidator>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlSubHomeName" runat="server" Text="Display Name"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtSubHomeName" runat="server" Width="179px" />
				<asp:RequiredFieldValidator ID="rfvSubHomeName" runat="server" ErrorMessage="Display name cannot be blank." ControlToValidate="txtSubHomeName">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlCategory" runat="server" Text="Associate Category"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtCategoryName" runat="server" Width="179px"/>
				<asp:HiddenField ID="hdnCategoryId" runat="server" />
				<asp:RequiredFieldValidator ID="rfvCategoryName" runat="server" ErrorMessage="Select a category to be associated." ControlToValidate="txtCategoryName">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlOrder" runat="server" Text="Display Order"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtOrder" runat="server" Width="179px" />
				<asp:RequiredFieldValidator ID="rfvOrder" runat="server" ErrorMessage="Display order cannot be blank." ControlToValidate="txtOrder">*</asp:RequiredFieldValidator>
				<asp:CompareValidator ID="cvOrder" runat="server" ErrorMessage="Display order should be a positive integer." Type="Integer" ControlToValidate="txtOrder" Operator="GreaterThan" ValueToCompare="0">*</asp:CompareValidator>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Label ID="lblEnableSubHome" runat="server" Text="Subhome Enabled"></asp:Label>
			</td>
			<td>
				<asp:CheckBox ID="chkSubHomeEnabled" runat="server" Checked="True" Text=" " />
			</td>
		</tr>
	</table>
</div>