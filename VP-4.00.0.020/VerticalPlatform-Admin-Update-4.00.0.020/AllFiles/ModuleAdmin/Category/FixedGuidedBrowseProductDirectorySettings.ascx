<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FixedGuidedBrowseProductDirectorySettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.FixedGuidedBrowseProductDirectorySettings" %>
<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">
			Select Category</label>
		<div class="controls">
			<asp:DropDownList runat="server" ID="fixedGuidedBrowseCategoryList" AutoPostBack="true"
				OnSelectedIndexChanged="fixedGuidedBrowseCategoryListSelectedIndexChanged" />
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Fixed Guided Browse</label>
		<div class="controls">
			<asp:DropDownList runat="server" ID="fixedGuidedBrowseList" AutoPostBack="true" OnSelectedIndexChanged="fixedGuidedBrowseListSelectedIndexChanged">
			</asp:DropDownList>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Embed in Product Directory</label>
		<div class="controls">
			<asp:GridView ID="embedInProductDirectorySettings" runat="server" AutoGenerateColumns="False"
					OnRowDataBound="embedInProductDirectorySettingsRowDataBound" CssClass="common_data_grid">
				<Columns>
					<asp:TemplateField HeaderText="Fixed Guided Browse Link">
						<ItemTemplate>
							<asp:HiddenField ID="fixedGuidedBrowseLinkId" runat="server" />
							<asp:Label ID="fixedGuidedBrowseLink" runat="server" />
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Product Directory Column">
						<ItemTemplate>
							<asp:DropDownList ID="productDirectoryColumn" runat="server" Width="100px" />
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Product Directory Placement">
						<ItemTemplate>
							<asp:TextBox ID="productDirectoryPlacement" runat="server" Width="30px" MaxLength="3"/>
							<asp:RangeValidator ID="productDirectoryPlacementRangeValidator" ControlToValidate="productDirectoryPlacement"
								Type="Integer" MinimumValue="0" MaximumValue="100" runat="server" ErrorMessage="Placement index should be between 0 and 100.">*</asp:RangeValidator>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					Couldn't create the fixed guided browse links. Please run the Prebuild Guided Browse task to create the links.
				</EmptyDataTemplate>
			</asp:GridView>
		</div>
	</div>
</div>
