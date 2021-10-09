<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditThread.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Forum.AddEditThread" %>
<table>
	<tr>
		<td>
			Topic
		</td>
		<td>
			<asp:DropDownList ID="ddlTopic" runat="server">
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			Title
		</td>
		<td>
			<asp:TextBox ID="txtTitle" runat="server" Width="300"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvTitle" runat="server" ErrorMessage="Please enter title."
				ControlToValidate="txtTitle">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr id="fixedUrlRow" runat="server">
		<td>
			Fixed URL
		</td>
		<td>
			<asp:TextBox ID="txtFixedUrl" runat="server" Width="300" MaxLength="255"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvFixedUrl" runat="server" ErrorMessage="Please enter fixed url."
				ValidationGroup="saveGroup" ControlToValidate="txtFixedUrl" Display="Dynamic">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revFixedUrl" runat="server" ErrorMessage="Url should start with '/', end with '/' and should only contain alpha numeric characters ,'-'. example '/id-category-name/id-product-name/'."
				ControlToValidate="txtFixedUrl" ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$"
				Display="Static" ValidationGroup="saveGroup">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Enabled
		</td>
		<td>
			<asp:CheckBox ID="chkEnabled" runat="server" />
		</td>
	</tr>
</table>
