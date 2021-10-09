<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CampaignTypeContentGroup.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignTypeContentGroup" %>
<script type="text/javascript">
	$(document).ready(function() {
		var selectedButton = $("input[id$='hdnEditButton']").val();
		if (selectedButton != '') {
			$("#" + selectedButton).parents('tr').css("background-color", "#eeeeee");
		}
	});
</script>
<table>
	<tr>
		<td valign="top" style="padding-right:10px">
			<span class="label_span">Group Name</span>
		</td>
		<td valign="top">
			<asp:TextBox runat="server" ID="txtGroupName" ValidationGroup="AddContentGroup" Width="120"></asp:TextBox>
			<asp:RequiredFieldValidator runat="server" ID="rfvGroupName" ControlToValidate="txtGroupName"
				ErrorMessage="Please enter group name." ValidationGroup="AddContentGroup">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revName" ControlToValidate="txtGroupName" ValidationExpression="^[a-z]+\w*$"
				runat="server" ErrorMessage="Group name should start with simple letter and special characters or white spaces are not allowed inside name." ValidationGroup="AddContentGroup">*</asp:RegularExpressionValidator>
		</td>
		<td valign="top"  style="padding-right:10px">
			<span class="label_span">Title</span>
		</td>
		<td valign="top">
			<asp:TextBox runat="server" ID="txtTitle" ValidationGroup="AddContentGroup" Width="120"></asp:TextBox>
			<asp:RequiredFieldValidator runat="server" ID="rfvTitle" ControlToValidate="txtTitle"
				ErrorMessage="Please enter title." ValidationGroup="AddContentGroup">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td valign="top"  style="padding-right:10px">
			<span class="label_span">Min Number of Items</span>
		</td>
		<td valign="top">
			<asp:TextBox runat="server" ID="txtMinContent" ValidationGroup="AddContentGroup" Width="120"></asp:TextBox>
			<asp:RequiredFieldValidator runat="server" ID="rfvMinContent" ControlToValidate="txtMinContent"
				ErrorMessage="Please enter min number of item." ValidationGroup="AddContentGroup">*</asp:RequiredFieldValidator>
		</td>
		<td valign="top"  style="padding-right:10px">
			<span class="label_span">Max Number of Items</span>
		</td>
		<td valign="top">
			<asp:TextBox runat="server" ID="txtMaxContent" ValidationGroup="AddContentGroup" Width="120"></asp:TextBox>
			<asp:CompareValidator ID="cvMaxNumberOfItems" runat="server" 
				ControlToValidate="txtMaxContent" 
				ErrorMessage="Please enter a valid max number of items." 
				Operator="DataTypeCheck" Type="Integer" ValidationGroup="AddContentGroup">*</asp:CompareValidator>
		</td>
		
	</tr>
	<tr>
		<td valign="top"  style="padding-right:10px">
			<span class="label_span">Truncate Characters at</span>
		</td>
		<td valign="top">
			<asp:TextBox runat="server" ID="txtTruncationLength" Text="100" ValidationGroup="AddContentGroup" Width="120"></asp:TextBox>
			<asp:RequiredFieldValidator runat="server" ID="rfvTruncationLength" ControlToValidate="txtTruncationLength"
				ErrorMessage="Please enter truncate at value." ValidationGroup="AddContentGroup">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revTruncationLength" runat="server" ControlToValidate="txtTruncationLength"
				ErrorMessage="Please enter a number" ValidationExpression="^\d+$" ValidationGroup="AddContentGroup">*</asp:RegularExpressionValidator>
		</td>
		
		<td valign="top"  style="padding-right:10px">
			<span class="label_span">Content Type</span>
		</td>
		<td valign="top">
			<asp:DropDownList runat="server" ID="ddlContentType" Width="120" ValidationGroup="AddContentGroup">
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td valign="top"  style="padding-right:10px">
			<span class="label_span">Enabled</span>
		</td>
		<td colspan="4">
			<asp:CheckBox runat="server" ID="chkEnabled" Checked="true" ValidationGroup="AddContentGroup"></asp:CheckBox>
		</td>
	</tr>
	<tr>
		<td colspan="7">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="7">
			<asp:Button ID="btnSaveCampaignTypeContentGroup" runat="server" Text="Save" 
				onclick="btnSaveCampaignTypeContentGroup_Click" CssClass="btn" ValidationGroup="AddContentGroup" />
			<asp:Button ID="btnReset" runat="server" Text="Reset" 
				onclick="btnReset_Click" ValidationGroup="ResetContentGroup" CssClass="btn"/>
		</td>
	</tr>
</table>
<br />
<%--<strong>Campaign type content groups</strong>--%>
<asp:GridView ID="gvContentGroups" runat="server" AutoGenerateColumns="False" OnRowCommand="gvContentGroups_RowCommand" OnRowDataBound="gvContentGroups_RowDataBound"
	CssClass="common_data_grid table table-bordered" Caption="Campaign Type Content Groups" CaptionAlign="NotSet">
	<Columns>
		<asp:BoundField HeaderText="ID" DataField="Id" />
		<asp:TemplateField HeaderText="Content Type">
			<ItemTemplate>
				<asp:Label ID="lblContentType" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:BoundField HeaderText="Name" DataField="Name" />
		<asp:BoundField HeaderText="Title" DataField="Title" />
		<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" />
		<asp:BoundField HeaderText="Min Contents" DataField="MinContent" />
		<asp:BoundField HeaderText="Max Contents" DataField="MaxContent" />
		<asp:BoundField HeaderText="Truncation Length" DataField="TruncationLength" />
		<asp:TemplateField>
			<ItemTemplate>
				<asp:LinkButton ID="lbtnEdit" runat="server" CommandName="EditContentGroup" ValidationGroup="ContentGroups">Edit</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField>
			<ItemTemplate>
				<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteContentGroup" ValidationGroup="ContentGroups">Delete</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>No campaign type content groups found.</EmptyDataTemplate>
</asp:GridView>
<asp:HiddenField ID="hdnEditButton" runat="server" /> 
