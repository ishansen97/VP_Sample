<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Vendors.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.Vendors" %>

<script type="text/javascript">
	function ValidateDropDownListOnVendorSpec(src, args) {
		if ($("select[id*=ddlSpecificationType]").val() > 0) {
			args.IsValid = true;
		}
		else {
			args.IsValid = false;
		}
	}
</script>

<table>
	<tr>
		<td>
			<asp:Label ID="lblSpecificationTypeName" runat="server" Text="Specification Type Name"></asp:Label>
		</td>
		<td>
			<asp:DropDownList ID="ddlSpecificationType" runat="server" Width="181px" DataTextField="SpecType"
				DataValueField="id">
			</asp:DropDownList>
			<asp:CustomValidator ID="cvSpecType" runat="server" ErrorMessage="Please select Specification Type."
				ClientValidationFunction="ValidateDropDownListOnVendorSpec">*</asp:CustomValidator>
		</td>
	</tr>
	<tr>
		<td>
			<asp:Label ID="lblSpecification" runat="server" Text="Specification"></asp:Label>
		</td>
		<td>
			<asp:TextBox ID="txtSpecification" runat="server" Height="97px" Width="181px" TextMode="MultiLine"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rvSpecification" runat="server" ControlToValidate="txtSpecification"
				ErrorMessage="Please enter specification.">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			<asp:Literal ID="ltlDisplayOptions" runat="server" Text="Display Options"></asp:Literal>
		</td>
		<td>
			<asp:CheckBox ID="chkShowInVerticalMatrix" Text="Vertical Matrix" runat="server" />
			<asp:CheckBox ID="chkShowInServiceDetail" Text="Service Detail" runat="server" />
			<asp:CheckBox ID="showInVendorDetail" Text="Vendor Detail" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			<asp:HiddenField ID="hdnEditSpecificationId" runat="server" />
			<asp:HiddenField ID="hdnEditSpecificationTypeId" runat="server" />
		</td>
		<td>
		</td>
	</tr>
</table>
