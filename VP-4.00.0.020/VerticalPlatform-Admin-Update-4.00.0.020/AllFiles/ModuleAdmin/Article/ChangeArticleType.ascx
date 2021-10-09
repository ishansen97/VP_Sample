<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ChangeArticleType.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ChangeArticleType" %>

<div id="ChangeArticleType">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span">Old Article Type</span> <span>
			<asp:DropDownList runat="server" ID="ddlOldArticleType" AutoPostBack="true" 
				onselectedindexchanged="ddlOldArticleType_SelectedIndexChanged" Width="130px"></asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvOldArticleType" runat="server" 
				ControlToValidate="ddlOldArticleType" ErrorMessage="Please select old article type.">*</asp:RequiredFieldValidator>
		</span></li>
		<li class="common_form_row clearfix"><span class="label_span">Old Article Template</span> <span>
			<asp:DropDownList ID="ddlOldArticleTemplate" runat="server" Width="130px">
			</asp:DropDownList>
		</span></li>
		<li class="common_form_row clearfix"><span class="label_span">New Article Type</span> <span>
			<asp:DropDownList runat="server" ID="ddlNewArticleType" 
				onselectedindexchanged="ddlNewArticleType_SelectedIndexChanged" AutoPostBack="true" Width="130px"></asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvNewArticleType" runat="server"
				ControlToValidate="ddlNewArticleType" ErrorMessage="Please select new article type."></asp:RequiredFieldValidator>
		</span></li>
		<li class="common_form_row clearfix"><span class="label_span">New Article Template</span> <span>
			<asp:DropDownList ID="ddlNewArticleTemplate" runat="server" Width="130px">
			</asp:DropDownList>
		</span></li>
		<li class="common_form_row clearfix" style="margin-top:5px;"><span style="display:block;"><strong>Add Articles</strong></span>
			<span class="label_span">Article</span><asp:TextBox ID="txtArticle" runat="server"></asp:TextBox>
			<asp:Button ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" CssClass="common_text_button" />
			<div class="clear" style="margin-bottom:10px;"></div>
			<asp:GridView ID="gvArticles" runat="server" CssClass="common_data_grid" AutoGenerateColumns="false"
				OnRowCommand="gvArticles_RowCommand" OnRowDataBound="gvArticles_RowDataBound">
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="Id" />
					<asp:BoundField DataField="Title" HeaderText="Title" />
					<asp:TemplateField>
						<ItemTemplate>
							<asp:LinkButton ID="lbtnRemove" runat="server" CommandName="Remove">Remove</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>No Articles added.</EmptyDataTemplate>
			</asp:GridView>
		</li>
	</ul>
</div>
