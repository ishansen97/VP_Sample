<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AddEditReview.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Reviews.AddEditReview" %>

<%@ Register src="../Article/ArticleCustomPropertyEditor.ascx" tagname="ArticleCustomPropertyEditor" tagprefix="uc1" %>

<asp:Content ID="AddEditReviewContent" ContentPlaceHolderID="cphContent" runat="server">
  <script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script> 
  <script src="../../Js/jquery.raty.min.js" type="text/javascript"></script> 
  <script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
  <script src="../../Js/ContentPicker.js" type="text/javascript"></script>
  <script src="../../Js/AddEditReview.js" type="text/javascript"></script> 
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="headerLabel" runat="server" BackColor="Transparent" Text="[Review Title]"></asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<div id="divReview">
				<div class="form-horizontal">
						<div class="control-group">
							<h5 class="control-label">Status</h5>
							<div class="controls">
								<table width="100%" class="table table-bordered review-table">
									<tr>
										<th>Email Verified</th>
										<th>Editing\Revisions</th>
										<th>Accepted</th>
										<th>Sent Payment</th> 
										<th>Published</th>
										<th>Rejected</th>
									</tr>                   
									<tr class="review-row">
										<td><asp:Label runat="server" ID="emailVerifiedStatus"></asp:Label></td>
										<td><asp:Label runat="server" ID="revisionStatus"></asp:Label></td> 
										<td><asp:Label runat="server" ID="acceptedStatus" ></asp:Label></td>
										<td><asp:Label runat="server" ID="sentPaymentStatus"></asp:Label></td>
										<td><asp:Label runat="server" ID="publishedStatus" ></asp:Label></td>
										<td><asp:Label runat="server" ID="rejectedStatus"></asp:Label></td>
									</tr>              
								</table>
							</div>
						</div>
						<div class="control-group">
							<h5 class="control-label">Actions</h5>
						</div>
						<div class="control-group">
							<label class="control-label">Send Payment</label>
							<div class="controls">
								<asp:RadioButtonList ID="sendPaymentRadioButtonList" runat="server" RepeatDirection="Horizontal" Enabled="False"
										CellPadding="0" CellSpacing="0">
									<asp:ListItem Text="Yes" Value="Yes"></asp:ListItem>
									<asp:ListItem Text="No" Value="No" Selected="True"></asp:ListItem>
								</asp:RadioButtonList>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Notes</label>
							<div class="controls">
								<asp:TextBox ID="notesTextBox" runat="server" TextMode="MultiLine" Width="500px"
										Height="130px"></asp:TextBox>
							</div>
						</div>
						<div class="control-group">
							<div class="controls">
								<asp:Button runat="server" ID="updateButton" Text="Update" CssClass="btn" OnClick="UpdateButton_Click"/>
								<asp:HyperLink ID="associateLink" runat="server" CssClass="btn aDialog">Associate Content</asp:HyperLink>
							</div>
						</div>
						<hr/>
						<div class="control-group">
							<h5 class="control-label" runat="server" id="reviewTypeTitle">[Review Type]</h5>
						</div>
						<div class="control-group">
							<label class="control-label">Review Title</label>
							<div class="controls">
								<asp:TextBox ID="reviewTitleTextBox" runat="server" MaxLength="255" TextMode="SingleLine" Width="500px"></asp:TextBox>
								<asp:RequiredFieldValidator ID="reviewTitleValidator" runat="server" ValidationGroup="reviewValidator"
								ErrorMessage="Please enter a review title." ControlToValidate="reviewTitleTextBox">*</asp:RequiredFieldValidator>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Product</label>
							<div class="controls">
								<asp:TextBox ID="productTextBox" runat="server" MaxLength="255" TextMode="SingleLine" Width="500px"></asp:TextBox>
								<asp:HiddenField runat="server" ID="productHidden"/>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Company</label>
							<div class="controls">
								<asp:TextBox ID="companyTextBox" runat="server" MaxLength="255" TextMode="SingleLine" Width="500px"></asp:TextBox> 
								<asp:HiddenField runat="server" id="companyHidden"/>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Ratings</label>
							<div class="controls">
								<asp:PlaceHolder ID="ratingContent" runat="server"></asp:PlaceHolder>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Image Name</label>
							<div class="controls">
								<asp:TextBox ID="imageNameTextBox" runat="server" MaxLength="255" TextMode="SingleLine" Width="500px"></asp:TextBox>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Image</label>
							<div class="controls">
								<asp:Image ID="articleImage" runat="server" Height="70px" Width="70px" />
							</div>
						</div>
						<div class="control-group">
							<div class="controls">
								<asp:FileUpload ID="articleThumbnailImageUpload" runat="server" MaxLength="255" Width="190px">
								</asp:FileUpload>
							</div>
						</div>
						<div class="control-group customPropCollection">
							<uc1:ArticleCustomPropertyEditor ID="acpArticleProperty" DisplayTitle="False" ExcludeRatings="True" runat="server" />
						</div>
						<div class="control-group">
							<label class="control-label">Preview URL</label>
							<div class="controls">
								<asp:HyperLink ID="previewUrlLabel" runat="server" Target="_blank"></asp:HyperLink>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Author Name</label>
							<div class="controls">
								<asp:TextBox ID="authorFirstNameTextBox" runat="server" MaxLength="255" TextMode="SingleLine" Width="242px"></asp:TextBox>
								<asp:TextBox ID="authorLastNameTextBox" runat="server" MaxLength="255" TextMode="SingleLine" Width="242px"></asp:TextBox>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Author Email</label>
							<div class="controls">
								<asp:TextBox ID="authorEmailTextBox" runat="server" MaxLength="255" TextMode="SingleLine" Width="500px"></asp:TextBox> 
								<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="authorEmailTextBox" 
									ErrorMessage="Email not in correct format." ValidateEmptyText="true" ClientValidationFunction="VP.ValidateEmail"
									ValidationGroup="reviewValidator">*</asp:CustomValidator>
							</div>
						</div>
						<div class="control-group mappingSectionsGrid">
							<asp:GridView ID="articleMappingSectionsGrid" runat="server" AutoGenerateColumns="False" 
							Width="100%" ShowHeader="False" BorderWidth="0" GridLines="None" CssClass="form-table" 
								onrowdatabound="ArticleMappingSectionsGrid_RowDataBound">
								<RowStyle BorderStyle="None" BorderWidth="0px" />
								<Columns>
									<asp:TemplateField>
										<ItemTemplate >
										<asp:Label ID="mappingSectionNameLabel" runat="server"></asp:Label>
										</ItemTemplate>
										<ItemStyle CssClass="label-column" />
									</asp:TemplateField>
									<asp:TemplateField>
										<ItemTemplate>
										<asp:TextBox ID="mappingSectionText" runat="server" Width="190px"></asp:TextBox>
										</ItemTemplate>
										<ItemStyle />
									</asp:TemplateField>
								</Columns>
							</asp:GridView>
						</div>
						<div class="control-group">
								<asp:Button ID="saveReviewButton" runat="server" Text="Save" CssClass="btn" 
										onclick="saveReviewButton_Click" ValidationGroup="reviewValidator"/> 
								<asp:Button ID="saveAndAcceptButton" runat="server" Text="Save And Accept" CssClass="btn" 
										onclick="SaveAndAcceptButton_Click" ValidationGroup="reviewValidator"/>
								<asp:Button ID="publishButton" runat="server" Text="Publish" CssClass="btn" onclick="publishButton_Click" ValidationGroup="reviewValidator"/>
								<asp:HyperLink ID="sendPaymentButton" runat="server" Text="Send Payment" CssClass="btn"/>
								<asp:Button ID="resendVerificationButton" runat="server" Text="Resend Verification Email" CssClass="btn" OnClick="ResendVerificationButton_Click"  />
								<asp:Button ID="cancelButton" runat="server" Text="Cancel" CssClass="btn" onclick="cancelButton_Click" />
								<asp:Button ID="rejectButton" runat="server" Text="Reject" CssClass="btn" OnClick="RejectButton_Click" />
						</div>
				</div>
			</div>
		</div>
	</div>
</asp:Content>