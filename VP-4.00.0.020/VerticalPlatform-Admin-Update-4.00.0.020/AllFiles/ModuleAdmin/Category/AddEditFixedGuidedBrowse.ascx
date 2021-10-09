<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditFixedGuidedBrowse.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.AddEditFixedGuidedBrowse" %>
<style type="text/css">
	.form-horizontal  .control-group{margin-bottom:5px;}
</style>
<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">Fixed Guided Browse Name</label>
		<div class="controls">
			<asp:TextBox ID="txtFixedGuidedBrowseName" runat="server" ></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvGuidedBrowseName" runat="server" ErrorMessage="Please enter fixed guided browse name."
				ControlToValidate="txtFixedGuidedBrowseName">*</asp:RequiredFieldValidator>
		</div>
	</div>
	<table cellpadding="0" cellspacing="0">
		<tr runat="server" ID="segmentSizeRowDisplay">
			<td>
				<div class="control-group">
					<label class="control-label"><asp:Literal ID="ltlSizeLabel" Text="Page Size" runat="server"></asp:Literal></label>
					<div class="controls">
						 <asp:TextBox ID="txtSegmentSize" runat="server"></asp:TextBox>
						<asp:RequiredFieldValidator ID="rfvSegmentSize" runat="server" ErrorMessage="Please enter the page size."
						ControlToValidate="txtSegmentSize">*</asp:RequiredFieldValidator>
						<asp:CompareValidator ID="cpvFixedGuidedBrowseSegmentSize" runat="server" ErrorMessage="Please enter a numeric value for 'Fixed Guided Browse Page Size'."
						ControlToValidate="txtSegmentSize" Type="Integer" Operator="DataTypeCheck"
						SetFocusOnError="True">*</asp:CompareValidator>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<div class="control-group">
		<label class="control-label">Fixed Guided Browse Prefix</label>
		<div class="controls">
			<asp:TextBox ID="txtGuidedBrowsePrefix" runat="server"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Fixed Guided Browse Suffix</label>
		<div class="controls">
			<asp:TextBox ID="txtGuidedBrowseSuffix" runat="server" ></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Naming Rule</label>
		<div class="controls">
			<asp:TextBox ID="txtGuidedBrowseNamingRule" runat="server"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Secondary Naming Rule</label>
		<div class="controls">
			<asp:TextBox ID="secondaryNamingRuleTxt" runat="server"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Enabled</label>
		<div class="controls">
			<asp:CheckBox ID="chkEnabled" runat="server" Checked="true"/>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Load On-Demand</label>
		<div class="controls">
			<asp:CheckBox ID="isDynamic" runat="server" Checked="false"/>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Include in Sitemap</label>
		<div class="controls">
			<asp:CheckBox ID="includeInSitemap" runat="server" Checked="false"/>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Exclude Primary Options</label>
		<div class="controls">
			<asp:CheckBox ID="excludePrimaryOptions" runat="server" Checked="false"/>
		</div>
	</div>

	<div class="control-group">
		<label class="control-label">Image</label>
		<div class="controls">
			<div class="fixedGuidedBrowseImg">
				<asp:Image ID="fgbImg" runat="server" Height="70px" Width="70px" />
			</div>
			<asp:FileUpload ID="imageUpload" runat="server" />
			<br />
			<b>Images will be resized to 52x39.</b>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Has Image</label>
		<div class="controls">
			<asp:CheckBox ID="hasImageCheck" runat="server" />
		</div>
	</div>
</div>

