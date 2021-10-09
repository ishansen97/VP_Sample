<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditReviewType.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Reviews.AddEditReviewType" %>
	
	<style type="text/css">
		.form-horizontal .control-group{margin-bottom:5px;}
	</style>
	<div class="form-horizontal">
		<div class="control-group">
			<label class="control-label">Name</label>
			<div class="controls">
				<asp:TextBox ID="reviewTypeName" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="reviewTypeValidator" runat="server"
					ErrorMessage="Please enter 'Review Type'." ControlToValidate="reviewTypeName">*</asp:RequiredFieldValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Title</label>
			<div class="controls">
				<asp:TextBox ID="reviewTitle" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="reviewTitleValidator" runat="server"
					ErrorMessage="Please enter 'Review Title'." ControlToValidate="reviewTitle">*</asp:RequiredFieldValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Description</label>
			<div class="controls">
				<asp:TextBox ID="description" runat="server"></asp:TextBox>
			</div>
		</div>
		 <div class="control-group">
			<label class="control-label">Sort Order</label>
			<div class="controls">
				<asp:TextBox ID="sortOrder" runat="server"></asp:TextBox>
					<asp:RegularExpressionValidator ControlToValidate="sortOrder" ValidationExpression="^\d+$"
					ID="sortOrderValidator" runat="server" ErrorMessage="Please enter a numeric value for Sort Order.">*</asp:RegularExpressionValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Enabled</label>
			<div class="controls">
				<asp:CheckBox ID="enabled" runat="server" Checked="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Article Type</label>
			<div class="controls">
				<asp:DropDownList ID="articleTypes" runat="server" onselectedindexchanged="articleTypeList_SelectedIndexChanged" AutoPostBack="true" AppendDataBoundItems="true"> </asp:DropDownList>
				<asp:HyperLink ID="articleTypesLink" runat="server" CssClass="grid_icon_link form" ToolTip="Add Article Type" NavigateUrl="~/ModuleAdmin/Article/ArticleTypeList.aspx" target="_blank">Add&nbsp;Article&nbsp;Type</asp:HyperLink>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Article Template</label>
			<div class="controls">
				<asp:DropDownList id="articleTemplateList" runat="server" AppendDataBoundItems="true">
					<asp:ListItem Text="- Select Article Template -" Value="-1"></asp:ListItem>
				</asp:DropDownList>
				<asp:HyperLink ID="HyperLink1" runat="server" CssClass="grid_icon_link form" ToolTip="Add Article Type" NavigateUrl="~/ModuleAdmin/Article/AddArticle.aspx?iat=true" target="_blank">Add&nbsp;Article&nbsp;Template</asp:HyperLink>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Has Image</label>
			<div class="controls">
				<asp:CheckBox ID="hasImage" runat="server" Checked="true" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Image</label>
			<div class="controls">
				<asp:Image ID="reviewTypeImage" runat="server" Width="70px" Visible="False" />
					<br />
					<asp:HiddenField ID="hasImageHidden" runat="server" />
					<asp:HiddenField ID="imageNameHidden" runat="server" />
					<asp:FileUpload ID="reviewTypeImageFileUpload" runat="server" Width="246px" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Review Tracking Emails (Comma Seperated)</label>
			<div class="controls">
				<asp:TextBox ID="reviewTrackingEmail" runat="server" Checked="true" TextMode="MultiLine"/>
			</div>
		</div>
	</div>
	
	