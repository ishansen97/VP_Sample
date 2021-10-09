<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditPost.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Forum.AddEditPost" %>
<table>
	<tr>
		<td>
			Subject
		</td>
		<td>
			<asp:TextBox ID="txtSubject" runat="server" Width="500px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvSubject" runat="server" ErrorMessage="Please enter subject."
			 ControlToValidate="txtSubject">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Body
		</td>
		<td>
			<asp:TextBox ID="txtBody" runat="server" Width="500px" Height="100px" TextMode="MultiLine"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvBody" runat="server" ErrorMessage="Please enter body."
			 ControlToValidate="txtBody" >*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Admin Note
		</td>
		<td>
			<asp:TextBox ID="txtAdminNote" runat="server" Width="500px" Height="100px" TextMode="MultiLine"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Enabled
		</td>
		<td>
			<asp:CheckBox ID="chkPostEnabled" runat="server" />
		</td>
	</tr>
</table>
