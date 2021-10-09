<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RandomizedArticleListSettings.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.RandomizedArticleListSettings" %>

<%@ Register Src="../../Controls/PopupDialogSmartScroller.ascx" TagName="SmartScroller"
	TagPrefix="uc2" %>

<div style="width: 600px">
	<ul class="common_form_area">
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Article List Display Settings
			</div>
			<div class="common_form_row_data">
				<asp:DropDownList ID="ddlArticleListDisplaySetting" runat="server" Height="20px"
					Width="144px">
				</asp:DropDownList>
				<asp:Button ID="btnAddDisplaySettings" runat="server" OnClick="btnAddDisplaySettings_Click"
					Text="Add" CssClass="common_text_button" CausesValidation="False" />
				<div class="common_form_row_div clearfix">
					<asp:ListBox ID="lstArticleListDisplaySetting" runat="server" Width="247px"></asp:ListBox>
				</div>
				<div class="common_form_row_div clearfix">
					<asp:Button ID="btnMoveUp" runat="server" OnClick="btnMoveUp_Click" Text="Move Up"
						CssClass="common_text_button" CausesValidation="False" />
					<asp:Button ID="btnMoveDown" runat="server" Text="Move Down" OnClick="btnMoveDown_Click"
						CssClass="common_text_button" CausesValidation="False" />
					<asp:Button ID="btnRemove" runat="server" OnClick="btnRemove_Click" Text="Remove"
						CssClass="common_text_button" CausesValidation="False" />
					<asp:HiddenField ID="hdnArticleDisplaySettingsValue" runat="server" />
				</div>
			</div>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">
			<div class="common_form_row_lable">
				Number of Articles 
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="txtNumberOfArticles" runat="server" Width="220px"></asp:TextBox>
				<asp:HiddenField ID="hdnNumberOfArticles" runat="server" />
				<asp:CompareValidator ID="cpvNumberOfArticles" runat="server" ErrorMessage="Please enter a numeric value for  'Number of articles'."
					ControlToValidate="txtNumberOfArticles" Type="Integer" Operator="DataTypeCheck"
					SetFocusOnError="True">*</asp:CompareValidator>
			</div>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">
		    <div class="common_form_row_lable">
		        Range Values for Randomization
		    </div>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">
			<div class="common_form_row_lable">
				Maximum Number
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="txtMaxRandomNumber" runat="server" Width="220px"></asp:TextBox>
				<asp:HiddenField ID="hdnMaxRandomNumber" runat="server" />
				<asp:CompareValidator ID="cpvMaxRandomNumber" runat="server" ErrorMessage="Please enter a numeric value for  'Maximum Number for Randomization'."
					ControlToValidate="txtMaxRandomNumber" Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True">*</asp:CompareValidator>
			</div>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;" runat="server" id="liTotalNoOfSlots">
			<div class="common_form_row_lable">
				Minimum Number
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="txtMinRandomNumber" runat="server" Width="220px"></asp:TextBox>
				<asp:HiddenField ID="hdnMinRandomNumber" runat="server" />
				<asp:CompareValidator ID="cpvMinRandomNumber" runat="server" ErrorMessage="Please enter a numeric value for  'Minimum Number for Randomization'."
					ControlToValidate="txtMinRandomNumber" Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True">*</asp:CompareValidator>
			</div>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">
			<div class="common_form_row_lable">
				Article Synopsis Display Length
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="txtSynopsisLength" runat="server" MaxLength="4" Width="220px" /><asp:HiddenField
					ID="hdnSynopsisLength" runat="server" />
				<asp:CompareValidator ID="cmpvSynopsisLength" runat="server" ErrorMessage="Please enter a numeric value for 'Article synopsis display length'"
					ControlToValidate="txtSynopsisLength" Type="Integer" Operator="DataTypeCheck"
					SetFocusOnError="True">*</asp:CompareValidator>
			</div>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">
			<div class="common_form_row_lable">
				Article Thumbnail Size
			</div>
			<div class="common_form_row_data">
				<asp:DropDownList ID="ddlThumbSize" runat="server">
					<asp:ListItem Text="Extra Large Image – 400 x 300" Value="1"></asp:ListItem>
					<asp:ListItem Text="Featured Image – 187 x 140" Value="2"></asp:ListItem>
					<asp:ListItem Text="Thumbnail Image – 134 x 100" Value="3"></asp:ListItem>
					<asp:ListItem Text="Micro Image – 52 x 39" Value="4"></asp:ListItem>
				</asp:DropDownList>
				<asp:HiddenField ID="hdnThumbSize" runat="server" />
			</div>
		</li>
	</ul>
</div>
<p>	&nbsp;</p>
<uc2:SmartScroller ID="SmartScroller1" runat="server" />

