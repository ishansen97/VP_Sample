<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SpecificationType.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.SpecificationType" %>
<div>
	<table>
		<tr>
			<td>
				Product Specification Type
			</td>
			<td>
				<asp:TextBox ID="txtSpecType" runat="server" MaxLength="255" Width="290px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvSpecificationType" runat="server" ErrorMessage="Please enter specification type."
				ControlToValidate="txtSpecType">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				Validation Expression
			</td>
			<td>
				<asp:TextBox ID="txtExpression" runat="server" MaxLength="100" Width="290px"></asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				Is Visible
			</td>
			<td>
				<asp:CheckBox ID="chkIsVisible" runat="server" />
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
		<tr>
			<td>
				Search Enabled
			</td>
			<td>
				<asp:CheckBox ID="chkSearchEnabled" runat="server"/>
			</td>
		</tr>
		<tr>
			<td>
				Expanded View
			</td>
			<td>
				<asp:CheckBox ID="chkExpandedView" runat="server" Checked="True" Text=" " />
			</td>
		</tr>
		<tr>
			<td>
				Display Empty
			</td>
			<td>
				<asp:CheckBox ID="chkDisplayEmpty" runat="server" Checked="True" Text=" " />
			</td>
		</tr>
	    <tr>
	        <td>
	            Auto Truncate Elastic Search Value
	        </td>
	        <td>
	            <asp:CheckBox ID="chkAutoTruncateElasticSearch" runat="server" Checked="False" Text=" " />
	        </td>
	    </tr>
		<tr>
			<td colspan="2">
				<asp:Literal ID="ltlMessage" runat="server"></asp:Literal>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<asp:HiddenField ID="hdnSpecificationTypeId" runat="server" />
			</td>
		</tr>
	</table>
</div>
