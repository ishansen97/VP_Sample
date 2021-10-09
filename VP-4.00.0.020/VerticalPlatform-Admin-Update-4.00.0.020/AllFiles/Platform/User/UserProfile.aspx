<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="UserProfile.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.User.UserProfile"
	Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<div class="add-button-container"><asp:HyperLink ID="lnkResetPassword" runat="server" CssClass="aDialog btn">Change Password</asp:HyperLink></div>
	
	<div class="form-horizontal">
		<div class="control-group">
			<label class="control-label">Salutation</label>
			<div class="controls">
				<asp:DropDownList ID="ddlSalutation" runat="server" AppendDataBoundItems="true">
					<asp:ListItem Text="" Value=""></asp:ListItem>
				</asp:DropDownList>
				<asp:RequiredFieldValidator ID="rfvSalutation" runat="server" ValidationGroup="EditUser"
					ErrorMessage="Select salutation." ControlToValidate="ddlSalutation">*</asp:RequiredFieldValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">First Name</label>
			<div class="controls">
				<asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ValidationGroup="EditUser"
					ErrorMessage="Enter first name." ControlToValidate="txtFirstName">*</asp:RequiredFieldValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Last Name</label>
			<div class="controls">
				<asp:TextBox ID="txtLastName" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvLastName" runat="server" ValidationGroup="EditUser"
					ErrorMessage="Enter last name." ControlToValidate="txtLastName">*</asp:RequiredFieldValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Email</label>
			<div class="controls">
				<asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
				<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtEmail" ValidateEmptyText="true"
					ErrorMessage="Please enter a valid email address." ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Address Line1</label>
			<div class="controls">
				<asp:TextBox ID="txtAddressLine1" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ValidationGroup="EditUser"
					ErrorMessage="Enter address line1." ControlToValidate="txtAddressLine1">*</asp:RequiredFieldValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Address Line2</label>
			<div class="controls">
				<asp:TextBox ID="txtAddressLine2" runat="server"></asp:TextBox>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">City</label>
			<div class="controls">
				<asp:TextBox ID="txtCity" runat="server"></asp:TextBox>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">State</label>
			<div class="controls">
				<asp:TextBox ID="txtState" runat="server"></asp:TextBox>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Zip / Postal Code</label>
			<div class="controls">
				<asp:TextBox ID="txtPostal" runat="server"></asp:TextBox>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Country</label>
			<div class="controls">
				<asp:DropDownList ID="ddlCountry" runat="server" AppendDataBoundItems="true">
					<asp:ListItem Text="" Value=""></asp:ListItem>
				</asp:DropDownList>
				<asp:RequiredFieldValidator ID="rfvCountry" runat="server" ValidationGroup="EditUser"
					ErrorMessage="Select country" ControlToValidate="ddlCountry">*</asp:RequiredFieldValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Institution</label>
			<div class="controls">
				<asp:TextBox ID="txtInstitution" runat="server"></asp:TextBox>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Phone</label>
			<div class="controls">
				<asp:TextBox ID="txtPhone" runat="server"></asp:TextBox>
			</div>
		</div>
		<div class="control-group">
			<div class="controls"><asp:Label ID="lblMessage" runat="server"></asp:Label></div>
		</div>
		<div class="control-group">
			<div class="controls">
				<asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="btn" ValidationGroup="EditUser"/>
			</div>
		</div>
	</div>

				
	
</asp:Content>
