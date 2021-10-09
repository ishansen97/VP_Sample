<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LeadFormSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.LeadFormSettings" %>

<style type="text/css">
		.form-horizontal .control-group{margin-bottom:5px;}
	</style>
	<div class="form-horizontal">
		<div class="control-group">
			<label class="control-label">Paging in Client Side <br><small>( This option becomes ineffective when "Open LeadForm In Popup" option is enabled )</small></label>
			<div class="controls">
				<asp:CheckBox ID="chkPaging" runat="server" />
				<asp:HiddenField ID="hdnPaging" runat="server" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">User Registration is Required to Submit Lead&nbsp;</label>
			<div class="controls">
				<asp:CheckBox ID="chkUserRegister" runat="server" />
				<asp:HiddenField ID="hdnUserRegister" runat="server" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Redirect Url after Submitting the Lead</label>
			<div class="controls">
				<asp:TextBox ID="txtRedirectUrl" runat="server" Width="328px"></asp:TextBox>
				<asp:HiddenField ID="hdnredirectUrl" runat="server" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Send Confirmation Email</label>
			<div class="controls">
				<asp:CheckBox ID="chkSendMail" runat="server" Checked="True" />
				<asp:HiddenField ID="hdnSendMail" runat="server" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Number of Selected Products to Display Images</label>
			<div class="controls">
				<asp:TextBox ID="txtDisplayImageProductCount" runat="server" Width="50px"></asp:TextBox>
				<asp:HiddenField ID="hdnDisplayImageProductCount" runat="server" />
				<asp:CompareValidator ID="cvDisplayImageProductCount" runat="server"
				ErrorMessage="Number of Selected Products to Display Images should be a numeric value."
				ControlToValidate="txtDisplayImageProductCount" Operator="DataTypeCheck" Type="Integer">*</asp:CompareValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Number of Selected Products to Display Initially</label>
			<div class="controls">
				<asp:TextBox ID="numberOfProductsToShowInitially" runat="server" Width="50px"></asp:TextBox>
				<asp:HiddenField ID="numberOfProductsToShowInitiallyHidden" runat="server" />
				<asp:CompareValidator ID="numberOfProductsToShowInitiallyValidator" runat="server"
				ErrorMessage="Number of Selected Products to Show Initially should be a numeric value."
				ControlToValidate="numberOfProductsToShowInitially" Operator="DataTypeCheck" Type="Integer">*</asp:CompareValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Content Type</label>
			<div class="controls">
				<asp:DropDownList ID="contentTypeList" runat="server"></asp:DropDownList>
				<asp:HiddenField ID="contentTypeHidden" runat="server" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Lead Type</label>
			<div class="controls">
				<asp:DropDownList ID="leadTypeList" runat="server">
					<asp:ListItem Value="0" Text="None"></asp:ListItem>
				</asp:DropDownList>
				<asp:HiddenField ID="leadTypeHidden" runat="server" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Subscribe to newsletters option</label>
			<div class="controls">
				<asp:DropDownList ID="ddlNewslettersField" runat="server" AutoPostBack="true"
					OnSelectedIndexChanged="ddlNewslettersField_OnSelectedIndexChanged"></asp:DropDownList>
				<asp:DropDownList ID="ddlNewslettersOption" runat="server" ></asp:DropDownList>
				<asp:HiddenField ID="hdnNewslettersOption" runat="server" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Subscribe to optins option</label>
			<div class="controls">
				<asp:DropDownList ID="ddlOptinsField" runat="server" AutoPostBack="true"
					OnSelectedIndexChanged="ddlOptinsField_OnSelectedIndexChanged"></asp:DropDownList>
				<asp:DropDownList ID="ddlOptinsOption" runat="server"></asp:DropDownList>
				<asp:HiddenField ID="hdnOptinsOption" runat="server" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Product Summary Display Length</label>
			<div class="controls">
				<asp:TextBox ID="txtDescriptionLength" runat="server" Width="50px"></asp:TextBox>
				<asp:HiddenField ID="hdnDescriptionLength" runat="server" />
				<asp:CompareValidator ID="cvDescriptionLength" runat="server"
				ErrorMessage="Description display length should be a numeric value."
				ControlToValidate="txtDescriptionLength" Operator="DataTypeCheck" Type="Integer">*</asp:CompareValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Selected Products Display Settings</label>
			<div class="controls">
				<asp:DropDownList ID="ddlProductDisplaySetting" runat="server" Width="144px">
				</asp:DropDownList>
				<asp:Button ID="btnAddDisplaySettings" runat="server" OnClick="btnAddDisplaySettings_Click"
				Text="Add" CssClass="btn" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">&nbsp;</label>
			<div class="controls">
				<asp:ListBox ID="lstProductDisplaySetting" runat="server" Width="247px"></asp:ListBox>
				<asp:HiddenField ID="hdnProductDisplaySetting" runat="server" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">&nbsp;</label>
			<div class="controls">
				<asp:Button ID="btnMoveUp" runat="server" OnClick="btnMoveUp_Click" Text="Move Up"
						CssClass="btn" />
				<asp:Button ID="btnMoveDown" runat="server" OnClick="btnMoveDown_Click" Text="Move Down" 
						CssClass="btn" />
				<asp:Button ID="btnRemove" runat="server" OnClick="btnRemove_Click" Text="Remove"
						CssClass="btn" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"> Message for user who already has a login </label>
			<div class="controls">
				<asp:TextBox ID="textValidationMessage" runat="server"  Width="328px" TextMode="MultiLine" Wrap="true"></asp:TextBox>
				<asp:HiddenField ID="hiddenValidationMessage" runat="server" />
			</div>
		</div>
        <div class="control-group">
			<label class="control-label">Modify Page Title</label>
			<div class="controls">
				<asp:CheckBox ID="modifyPageTitleCheckBox" runat="server" Checked="True" />
				<asp:HiddenField ID="modifyPageTitleHidden" runat="server" />
			</div>
		</div>
	</div>
