<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditSearchRelevance.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Search.AddEditSearchRelevance" %>
<table >
	<tr>
		<td>Content Type</td>
		<td><asp:DropDownList ID="ddlContentType" AutoPostBack="true" runat="server" Width="150"
		onselectedindexchanged="ddlContentType_SelectedIndexChanged" ></asp:DropDownList></td>
	</tr>
	<tr>
		<td>Property Name</td>
		<td><asp:DropDownList ID="ddlPropertyName" runat="server" Width="150"></asp:DropDownList></td>
	</tr>
	<tr>
		<td>Relevancy Weight</td>
		<td><asp:TextBox ID="txtRelevanceWeight" runat="server" Width="150" MaxLength="2"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfRangeEnd" runat="server"
			ErrorMessage="Please enter 'Relevance Weight'." ControlToValidate="txtRelevanceWeight">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revRangeEnd" runat="server"  
				ErrorMessage="Please enter a numeric value for 'Relevance Weight'." ControlToValidate="txtRelevanceWeight" 
				ValidationExpression="^\d+$">*</asp:RegularExpressionValidator>
			</td>
	</tr>
</table>