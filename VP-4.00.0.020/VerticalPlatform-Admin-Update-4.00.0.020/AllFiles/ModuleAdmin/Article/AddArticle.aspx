<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/MasterPage.Master"
	AutoEventWireup="true" CodeBehind="AddArticle.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.AddArticle"
	Title="Untitled Page" %>

<%@ Register Src="ArticleCustomPropertyEditor.ascx" TagName="ArticleCustomPropertyEditor"
	TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script type="text/javascript">
		$(document).ready(function() {
			$("input[type=text][id*=txtStartDate]").datetimepicker();
            var fileInput = document.getElementById("<%=fuThumbnailImage.ClientID%>");
            var allowedExtension = ".jpg";
            console.log(fileInput);
            fileInput.addEventListener("change", function () {
                // Check that the file extension is supported.
                // If not, clear the input.
                var hasInvalidFiles = false;
                for (var i = 0; i < this.files.length; i++) {
                    var file = this.files[i];

                    if (!file.name.toLowerCase().endsWith(allowedExtension)) {
                        hasInvalidFiles = true;
                    }
                }

                if (hasInvalidFiles) {
                    fileInput.value = "";
                    alert("Unsupported file selected.");
                }
            });
		});
    </script>
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script src="../../Js/UrlHelper.js" type="text/javascript"></script>
	<script src="../../Js/Article.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.json-1.3.min.js" type="text/javascript"></script>
	<script src="../../js/ArticleEditor/ArticleSectionValidater.js" type="text/javascript"></script>
	<script src="../../js/ArticleEditor/SectionEditor.js" type="text/javascript"></script>
	<script src="../../js/ArticleEditor/ResourceEditor.js" type="text/javascript"></script>
	<script src="../../js/ArticleEditor/VideoResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/MetaDataResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/ArticleToolsResourceEditor.js" type="text/javascript"></script>
	<script src="../../js/ArticleEditor/LinkResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/EmbededCodeResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/FlashResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/ImageResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/LeadFormResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/RelatedCategoryResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/RelatedProductsResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/TextResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/ExhibitionVendorSpecialResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/AdvertisementResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/RelatedVendorResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/ArticleEditor/RatingResourceEditor.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery-ui-timepicker-addon.js" type="text/javascript"></script>
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent" Text="Add Article"></asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
			<div id="divArticle" runat="server">
				<div class="form-horizontal">
					<div class="control-group">
						<label class="control-label">
							Article Type</label>
						<div class="controls">
							<asp:DropDownList ID="ddlArticleType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlArticleType_SelectedIndexChanged"
								Width="200px">
							</asp:DropDownList>
							<asp:HiddenField ID="hdnSortTitleRequired" runat="server" />
						</div>
					</div>
					<table cellpadding="0" cellspacing="0">
						<tr id="trArticleTemplate" runat="server">
							<td>
								<div class="control-group">
									<label class="control-label">
										Use Article Template</label>
									<div class="controls">
										<asp:DropDownList CssClass="ddlArticleTemplates" ID="ddlArticleTemplates" runat="server"
											Width="200px">
										</asp:DropDownList>
									</div>
								</div>
							</td>
						</tr>
					</table>
					<div class="control-group">
						<label class="control-label">
							Title</label>
						<div class="controls">
							<asp:TextBox ID="txtTitle" runat="server" MaxLength="500" TextMode="SingleLine" Width="190px"></asp:TextBox>
						</div>
					</div>
					
					<asp:HiddenField ID="hdnIsArticleTemplate" runat="server" />
					<div id="divArticleData" runat="server">
						<div class="control-group">
							<label class="control-label">
								Sub Title</label>
							<div class="controls">
								<asp:TextBox ID="subTitleText" runat="server" MaxLength="255" TextMode="SingleLine" 
									Width="190px"></asp:TextBox>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Short Title</label>
							<div class="controls">
								<asp:TextBox ID="txtShortTitle" runat="server" MaxLength="255" TextMode="SingleLine"
									Width="190px"></asp:TextBox>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Is External Article</label>
							<div class="controls">
								<asp:CheckBox ID="chkExternalArticle" runat="server" AutoPostBack="True" OnCheckedChanged="chkExternalArticle_CheckedChanged"
									CssClass="common_check_box" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								External Article URL</label>
							<div class="controls">
								<asp:TextBox ID="txtExternalUrl" runat="server" MaxLength="255" TextMode="SingleLine"
									Width="190px" Enabled="false"></asp:TextBox>
								<asp:RegularExpressionValidator ID="revUrl" runat="server" ControlToValidate="txtExternalUrl"
									ErrorMessage="Invalid Url" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- .,/?%&=#():;]*)?">
								</asp:RegularExpressionValidator>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Open in a New Window</label>
							<div class="controls">
								<asp:CheckBox ID="chkNewWindow" runat="server" AutoPostBack="false" Enabled="false"
									CssClass="common_check_box" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Date Published</label>
							<div class="controls">
								<asp:TextBox ID="txtDatePublished" runat="server" MaxLength="255" TextMode="SingleLine"
									Width="190px"></asp:TextBox>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Associated Authors</label>
							<div class="controls">
								<div class="inline-form-content">
									<asp:DropDownList ID="ddlAuthors" runat="server" DataTextField="FullName" DataValueField="id"
										Width="200px">
									</asp:DropDownList>
									<asp:Button ID="btnAssociateAuthor" runat="server" Text="Associate" OnClick="btnAssociateAuthor_Click"
										CssClass="btn" CausesValidation="false" />
								</div>
								<div style="clear: both;">
									<asp:GridView ID="gvAssociatedAuthors" runat="server" AutoGenerateColumns="false"
										OnRowDataBound="gvAssociatedAuthors_RowDataBound"
										CssClass="common_data_grid" Style="width: auto; margin-bottom: 5px;">
										<AlternatingRowStyle CssClass="DataTableRowAlternate" />
										<RowStyle CssClass="DataTableRow" />
										<Columns>
											<asp:TemplateField HeaderText="Article Author Id">
												<ItemTemplate>
													<asp:Label ID="lblArticleAuthorId" runat="server"  ItemStyle-Width="50"></asp:Label>
												</ItemTemplate>
											</asp:TemplateField>
											<asp:BoundField HeaderText="Author Id" DataField="id" />
											<asp:BoundField DataField="FullName" HeaderText="Name" />
											<asp:TemplateField HeaderText="Verified">
												<ItemTemplate>
													<asp:CheckBox ID="chkVerified" runat="server" ItemStyle-Width="50" Enabled="false"/>
												</ItemTemplate>
											</asp:TemplateField>
											<asp:TemplateField>
												<ItemTemplate>
													<asp:LinkButton ID="lnkRemove" runat="server" OnClientClick="return confirm('Are you sure you want to remove this association ?');"
														OnClick="lnkRemove_Click" CausesValidation="false" CssClass="grid_icon_link delete">Remove</asp:LinkButton>
												</ItemTemplate>
											</asp:TemplateField>
										</Columns>
									</asp:GridView>
								</div>
							</div>
						</div>
						<table cellpadding="0" cellspacing="0">
							<tr id="fixedUrlRow" runat="server">
								<td>
									<div class="control-group">
										<label class="control-label">
											Fixed URL
										</label>
										<div class="controls">
											<asp:TextBox ID="txtFixedUrl" runat="server" MaxLength="255" Width="190px"></asp:TextBox>
											<asp:RequiredFieldValidator ID="rfvFixedUrl" runat="server" ErrorMessage="*" ControlToValidate="txtFixedUrl">*</asp:RequiredFieldValidator>
											<asp:RegularExpressionValidator ID="revFixedUrl" runat="server" ErrorMessage="Url should start with '/', end with '/' and should only contain alpha numeric characters ,'-'. example '/id-article-name/'"
												ControlToValidate="txtFixedUrl" ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$"
												Display="Static">*</asp:RegularExpressionValidator>
										</div>
									</div>
								</td>
							</tr>
						</table>
						<table cellpadding="0" cellspacing="0">
							<tr id="passwordRow" runat="server">
								<td>
									<div class="control-group">
										<label class="control-label">
											Fixed URL Password
										</label>
										<div class="controls">
											<asp:TextBox ID="txtFixedUrlPassword" runat="server" MaxLength="255" Width="190px"></asp:TextBox> 
											<asp:HiddenField ID="fixedUrlPasswordHidden" runat="server"></asp:HiddenField>
										</div>
									</div>
								</td>
							</tr>
						</table>
						<div class="control-group" id="liPreviewUrl" runat="server">
							<label class="control-label">
								Preview Url
							</label>
							<div class="controls">
								<asp:HyperLink ID="lnkPreviewUrl" runat="server" Target="_blank"></asp:HyperLink>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Synopsis
							</label>
							<div class="controls">
								<asp:TextBox ID="txtSummary" runat="server" TextMode="MultiLine" Height="70px" MaxLength="1000"
									Style="padding: 5px;" Width="300px" onKeyUp="ValidateSynopsis()"></asp:TextBox>
								<asp:HiddenField ID="hdnSynopsisRequired" runat="server" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Thumbnail Image Name
							</label>
							<div class="controls">
								<asp:TextBox ID="txtThumbnailImageCode" runat="server" MaxLength="255" Width="190px"
									Text="[ArticleId]"></asp:TextBox>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Thumbnail Image
							</label>
							<div class="controls">
								<asp:Image ID="imgArticle" runat="server" Height="70px" Width="70px" />
							</div>
						</div>
						<div class="control-group">
							<div class="controls">
								<asp:FileUpload ID="fuThumbnailImage" runat="server" MaxLength="255" Width="190px" accept=".jpg">
								</asp:FileUpload>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Featured Settings
							</label>
							<div class="controls">
								<asp:CheckBoxList ID="chklFeaturedSettings" runat="server" RepeatDirection="Horizontal"
									CssClass="common_check_box">
									<asp:ListItem Value="1">Featured – Level 1</asp:ListItem>
									<asp:ListItem Value="2">Featured – Level 2</asp:ListItem>
									<asp:ListItem Value="3">Featured – Level 3</asp:ListItem>
								</asp:CheckBoxList>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Published
							</label>
							<div class="controls">
								<asp:Label ID="lblPublished" runat="server"></asp:Label>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Is Default Article
							</label>
							<div class="controls">
								<asp:CheckBox ID="chkIsDefaultArticle" runat="server" CssClass="common_check_box" />
							</div>
						</div> 
						<div class="control-group">
								<label class="control-label">
									Enable Url Redirect</label>
								<div class="controls">
									<div class="input-prepend">
										<span class="add-on">
											<asp:CheckBox ID="enableUrlRedirect" runat="server" CssClass="checkbox-1 in-prepend"/>
										</span>
										<asp:TextBox ID="redirectUrl" runat="server" Width="223"></asp:TextBox>
									</div>
									<asp:HiddenField ID="enableUrlRedirectHidden" runat="server" />
									<asp:HiddenField ID="redirectUrlHidden" runat="server" />
								</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Article Tags ( <code>,</code> Separated)
							</label>
							<div class="controls">
								<asp:TextBox ID="txtSelectArticleTags" runat="server" MaxLength="255" TextMode="SingleLine"
									Width="190px"></asp:TextBox>
								<asp:Button ID="btnAddTag" runat="server" Text="Add Tag" OnClick="btnAddTag_Click"
									CssClass="btn" CausesValidation="false" />
								<br />
								<asp:ListBox ID="lstArticleTags" runat="server" MaxLength="255"></asp:ListBox>
								<asp:Button ID="btnRemoveTag" runat="server" Text="Remove Tag" OnClick="btnRemoveTag_Click"
									CssClass="btn" CausesValidation="false" />
							</div>
						</div>
					    <div class="control-group">
					        <label class="control-label">
					            Exclude From Search
					        </label>
					        <div class="controls">
					            <asp:CheckBox ID="chkExcludeFromSearch" runat="server" CssClass="common_check_box" />
					        </div>
					    </div> 

						<h5>
							Run Date Range</h5>
						<div class="control-group">
							<label class="control-label">
								Run Start Date
							</label>
							<div class="controls">
								<asp:TextBox ID="txtStartDate" runat="server" MaxLength="255" TextMode="SingleLine"
									Width="190px"></asp:TextBox>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">
								Run End Date
							</label>
							<div class="controls">
								<asp:TextBox ID="txtEndDate" runat="server" MaxLength="255" TextMode="SingleLine"
									Width="190px"></asp:TextBox>
							</div>
						</div>
						<div class="control-group">
							<asp:Label ID="disableDateLabel" Text="Unpublished Date" Visible="false" 
								runat="server" CssClass="control-label"></asp:Label>
							<div class="controls">
								<asp:TextBox ID="disableDate" runat="server" MaxLength="255" TextMode="SingleLine"
									Width="190px" Visible="false"></asp:TextBox>
							</div>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">
							<asp:Label ID="lblIsAllowedAddNewSections" runat="server" Text="Lock Sections"></asp:Label>
						</label>
						<div class="controls">
							<asp:CheckBox ID="chkIsLockedSections" runat="server" CssClass="common_check_box" />
							<asp:HiddenField ID="hdnIsLockedSections" runat="server" />
							<asp:HiddenField ID="hdnArticleId" runat="server" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">
							<asp:Label ID="lblIsSectionReorderEnable" runat="server" Text="Section Reorder Enabled"></asp:Label>
						</label>
						<div class="controls" id="acpArticleProperty">
							<asp:CheckBox ID="chkIsSectionReorderEnable" runat="server" CssClass="common_check_box" />
							<asp:HiddenField ID="hdnIsSectionReorderEnable" runat="server" />
						</div>
					</div>
					<div class="control-group">
						<uc1:ArticleCustomPropertyEditor ID="acpArticleProperty" runat="server" DisplayTitle="True" />
					</div>
				</div>
				</div>
				<div class="inline-form-content">
					<input type="button" value="Save Article" id="btnSaveArticle" class="btn" />
					<asp:Button ID="btnSave" runat="server" Text="Save Article" OnClientClick="return ValidateArticle();"
						OnClick="btnSave_Click" CssClass="btn" />
					<input type="button" value="Save & Edit Sections" id="btnSaveAndEditSection" class="btn" />
					<asp:Button ID="btnSaveAndEdit" runat="server" Text="Save & Edit Sections" OnClientClick="return ValidateArticle();"
						OnClick="btnSaveAndEdit_Click" CssClass="btn" />
					<asp:Button ID="btnAddEditSections" runat="server" Text="Edit Sections" OnClick="btnAddEditSections_Click"
						CssClass="btn" />
					<asp:Button ID="btnPublish" runat="server" Text="Publish" OnClick="btnPublish_Click"
						OnClientClick="return ValidateSections(this);" CssClass="btn" />
					<asp:HyperLink ID="reviewPublishButton" runat="server" Text="Publish" SOnClientClick="return ValidateSections(this);"
						CssClass="btn aDialog" NavigateUrl="~/ModuleAdmin/Article/ReviewGift.ascx" />
					<asp:HyperLink ID="lnkAssociate" runat="server" CssClass="btn aDialog">Associate Content</asp:HyperLink>
					<asp:HyperLink ID="lnkLocations" runat="server" Visible="false" CssClass="btn">Set Locations</asp:HyperLink>
					<asp:HyperLink ID="lnkMetadata" runat="server" CssClass="btn aDialog">Metadata</asp:HyperLink>
					<asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click"
						CausesValidation="false" CssClass="btn" />
					<asp:HyperLink ID="imageManager" runat="server" CssClass="btn">Manage Images</asp:HyperLink>
					<asp:HyperLink ID="addNewAuthor" runat="server" Visible="false" Text="Add New Author" CssClass="aDialog btn" ></asp:HyperLink>
				</div>
			</div>
			<div id="divMessage" runat="server">
			</div>
		</div>
	</div>
</asp:Content>
