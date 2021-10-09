<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReSaveBulkEmailSegment.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.ReSaveBulkEmailSegment" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<style type="text/css">
		.form-horizontal .control-group{margin-bottom:5px;}
</style>



<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">Segment Name</label>
		<div class="controls">
			<asp:TextBox ID="segmentName" runat="server" Style="margin-left: 0px" Width="204px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="segmentNameRequiredFieldValidator" runat="server" ControlToValidate="segmentName"
				ErrorMessage="Please enter segment name.">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="segmentNameRegularExpressionValidator" runat="server" 
					ControlToValidate="segmentName"
					ErrorMessage="Invalid segment name. Following characters are allowed(alpha numeric, _, -)." 
					ValidationExpression="^[a-zA-Z0-9-_\s]*$">*</asp:RegularExpressionValidator>
		</div>
	</div>

	<div class="control-group">
		<label class="control-label">New Segment Type</label>
		<div class="controls">
			<asp:DropDownList ID="newSegmentTypeDropDownList" runat="server"
					style="padding:3px;" AutoPostBack="True" 
				onselectedindexchanged="newSegmentTypeDropDownList_SelectedIndexChanged"></asp:DropDownList>
		</div>
	</div>

	<div class="control-group">
		<label class="control-label">Site</label>
		<div class="controls">
			<asp:DropDownList ID="sitesDropDownList" runat="server" style=" 
					padding:3px;" AutoPostBack="True" 
				onselectedindexchanged="sitesDropDownList_SelectedIndexChanged"></asp:DropDownList>
		</div>
	</div>

	<div class="control-group">
		<label class="control-label">Segment Type</label>
		<div class="controls">
			<asp:DropDownList ID="segmentTypeDropDownList" runat="server" 
					style="padding:3px;" AutoPostBack="True" 
				onselectedindexchanged="segmentTypeDropDownList_SelectedIndexChanged"></asp:DropDownList>
		</div>
	</div>

	<div class="control-group">
		<label class="control-label">Status</label>
		<div class="controls">
			<asp:DropDownList ID="segmentStatus" runat="server" 
					style="padding:3px;" AutoPostBack="True" onselectedindexchanged="segmentStatus_SelectedIndexChanged">
					</asp:DropDownList>
		</div>
	</div>

	<div class="control-group">
		<label class="control-label">Segment</label>
		<div class="controls">
			<asp:DropDownList ID="segmentDropDownList" runat="server" 
					style="padding:3px;" AutoPostBack="True"></asp:DropDownList>
			<asp:RequiredFieldValidator ID="segmentRequiredFieldValidator" runat="server" 
					ErrorMessage="Please select a segment." ControlToValidate="segmentDropDownList">*</asp:RequiredFieldValidator>
		</div>
	</div>

	<div class="control-group">
		<label class="control-label">Limit Results for the Defined Cap</label>
		<div class="controls">
			<asp:CheckBox ID="cappedApplicableCheckBox" runat="server" Enabled="true" Checked="true" />
		</div>
	</div>

	<div class="control-group">
		<div class="controls">
			<asp:Button ID="addSegmentButton" runat="server" Text="Add Segment" 
					CssClass="btn" onclick="addSegmentButton_Click"/>
		</div>
	</div>

	<div class="control-group">
		<asp:GridView ID="segmentsGridView" runat="server" AutoGenerateColumns="False" 
			CssClass="common_data_grid" onrowdatabound="segmentsGridView_RowDataBound" 
			onrowcommand="segmentsGridView_RowCommand">
			<Columns>
				<asp:TemplateField HeaderText="Segment">
					<ItemTemplate>
						<asp:Literal ID="nameLiteral" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Site">
					<ItemTemplate>
						<asp:Literal ID="siteLiteral" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Type">
					<ItemTemplate>
						<asp:Literal ID="typeLiteral" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Action">
					<ItemTemplate>
						<asp:LinkButton ID="deleteLinkButton" runat="server" CommandName="deleteSegment">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
		</asp:GridView>
	</div>
</div>
