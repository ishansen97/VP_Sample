<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FixedUrlControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.FixedUrls.FixedUrlControl" %>	
<table>
	<tr>
		<td>
			URL
		</td>
		<td>
			<asp:TextBox ID="txtUrl" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvUrl" runat="server" ErrorMessage="Please enter fixed url." ControlToValidate="txtUrl"
				Display="Dynamic">*</asp:RequiredFieldValidator><br />
		</td>
		<td rowspan="2">
		<asp:RegularExpressionValidator ID="revUrl" runat="server" ErrorMessage="Url should start with '/', end with '/' and should only contain alpha numeric characters ,'-'. example '/id-content-name/'."
				ControlToValidate="txtUrl" ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$" style="float:left; width:200px; display:none;">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Query&nbsp;String
		</td>
		<td>
			<asp:TextBox ID="txtQueryString" runat="server"></asp:TextBox>
		</td>
	</tr>
</table>
