<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleRelatedProductsSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ArticleRelatedProductsSettings" %>
<table>
	<tr>
		<td style="width:185px;">
			Redirect Product Links to &nbsp
		</td>
		<td>
			<asp:RadioButton ID="rdoProductDetails" runat="server" Text="Product Details page"
				GroupName="RedirectionPage" Checked="true"/>
			<asp:RadioButton ID="rdoLeadForm" runat="server" Text="Lead Form" GroupName="RedirectionPage" />
			<asp:HiddenField ID="hdnRedirectionPageSettingId" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Product Summary Length &nbsp
		</td>
		<td>
			<asp:TextBox ID="txtSummaryLength" runat="server" />
			<asp:HiddenField ID="hdnSummaryLength" runat="server" />
			<asp:CompareValidator ID="cpvSummeryLength" runat="server" Operator="DataTypeCheck" 
			Type="Integer" ControlToValidate="txtSummaryLength" 
				ErrorMessage="Please enter an integer for 'Product summary length'."> * </asp:CompareValidator>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<div class="GroupItems">
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td style="padding-right:5px;">
								Related Products Display Settings
							</td>
							<td>
								<asp:DropDownList ID="ddlRelatedProductsDisplaySetting" runat="server" Height="20px" Width="144px">
								</asp:DropDownList>
								<asp:Button ID="btnAddDisplaySettings" runat="server" OnClick="btnAddDisplaySettings_Click"
									Text="Add" CssClass="common_text_button" />
							</td>
						</tr>
						<tr>
							<td class="style5">
								&nbsp;
							</td>
							<td style="padding-top:5px;">
								<asp:ListBox ID="lstRelatedProductsDisplaySetting" runat="server" Width="247px"></asp:ListBox>
							</td>
						</tr>
						<tr>
							<td class="style5">
								&nbsp;
							</td>
							<td style="padding-top:5px;">
								<asp:Button ID="btnMoveUp" runat="server" OnClick="btnMoveUp_Click" Text="Move Up" CssClass="common_text_button" />
								<asp:Button ID="btnMoveDown" runat="server" Text="Move Down" OnClick="btnMoveDown_Click" CssClass="common_text_button" />
								<asp:Button ID="btnRemove" runat="server" OnClick="btnRemove_Click" Text="Remove" CssClass="common_text_button" />
							</td>
						</tr>
					</table>
			<asp:HiddenField ID="hdnRelatedProductsDisplaySettingsValue" runat="server" />
			</div>
		</td>
	</tr>
</table>