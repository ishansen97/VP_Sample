<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CategoryInsert.aspx.cs"
	MasterPageFile="~/MasterPage.Master" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.CategoryAdmin"
	ValidateRequest="false" %>

<%@ Register Src="../MatrixElementDisplaySelector.ascx" TagName="MatrixElementDisplaySelector"
	TagPrefix="uc1" %>
<%@ Register Src="SpecificationType.ascx" TagName="SpecificationType" TagPrefix="uc3" %>
<%@ Register Src="../../Controls/ContentMetadataControl.ascx" TagName="ContentMetadataControl"
	TagPrefix="uc2" %>
<asp:Content ID="cntProduct" ContentPlaceHolderID="cphContent" runat="server">

	<script type="text/javascript">
	    $(document).ready(function() {
			$("#divClone").jqm(
			{
				modal:true
			});
			$("#btnClone").click(function()
			{
				$("#divClone").jqmShow();
			}
			);
		});

		function ValidateRadioButtonForSpecLength(src, args) {
			if ($("input[id*=rdbSpecifySpecLength]:checked").length > 0) {
				if ($("input[id*=txtSpecLength]").val() == '') {
					args.IsValid = false;
				}
				else {
					args.IsValid = true;
				}
			}
		}

		function ValidateRadioButtonForRequestInfo(src, args) {
			if ($("input[id*=rdbSpecifyButtonText]:checked").length > 0) {
				if ($("input[id*=txtButtonText]").val() == '') {
					args.IsValid = false;
				}
				else {
					args.IsValid = true;
				}
			}
		}

		function ValidateRadioButtonForRequestAllInfo(src, args) {
			if ($("input[id*=rdbSpecifyAllButtonText]:checked").length > 0) {
				if ($("input[id*=txtAllButtonText]").val() == '') {
					args.IsValid = false;
				}
				else {
					args.IsValid = true;
				}
			}
		}

		function ValidateRadioButtonForRequestSelectedInfo(src, args) {
			if ($("input[id*=rdbSpecifySelectedInfo]:checked").length > 0) {
				if ($("input[id*=txtSelectedInfoText]").val() == '') {
					args.IsValid = false;
				}
				else {
					args.IsValid = true;
				}
			}
		}
	</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblCategoryDetails" runat="server" Font-Bold="True"></asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
			<table>
				<tr>
					<td>
						<asp:Label ID="lblCtname" runat="server" Text="Category Name"></asp:Label>
					</td>
					<td>
						<asp:TextBox ID="txtCategoryName" runat="server" MaxLength="255" Width="250px" ValidationGroup="saveGroup"></asp:TextBox>
						<asp:RequiredFieldValidator ID="rfvControl" runat="server" ControlToValidate="txtCategoryName"
							ErrorMessage="Please enter category name." ValidationGroup="saveGroup">*</asp:RequiredFieldValidator>
					</td>
				</tr>
				<tr>
					<td>
						Type
					</td>
					<td>
						<asp:DropDownList ID="ddlType" runat="server" Width="260px" AutoPostBack="True" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
						</asp:DropDownList>
					</td>
				</tr>
				<tr>
					<td>
						Matrix Type
					</td>
					<td>
						<asp:DropDownList ID="ddlMatrixType" runat="server" Width="260px">
						</asp:DropDownList>
					</td>
				</tr>
				<tr>
					<td>
						Short Name
					</td>
					<td>
						<asp:TextBox ID="txtShortName" runat="server" Width="250px"></asp:TextBox>
					</td>
				</tr>
				<tr id="displayNameRow" runat="server">
					<td>
						Display Name
					</td>
					<td>
						<asp:TextBox ID="txtDisplayName" runat="server" Width="250px"></asp:TextBox>
						(This name is used to display the child category under the trunk category in the
						home page)
					</td>
				</tr>
				<tr id="DisplayCategoryRow" runat="server">
					<td>
						Display in Digest View
					</td>
					<td>
						<asp:RadioButtonList ID="rblIsDisplayed" runat="server" RepeatDirection="Horizontal">
							<asp:ListItem Selected="True">Yes</asp:ListItem>
							<asp:ListItem>No</asp:ListItem>
						</asp:RadioButtonList>
					</td>
				</tr>
				<tr>
					<td valign="top">
						Description
					</td>
					<td>
						<asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Width="500px"
							Height="120px"></asp:TextBox>
					</td>
				</tr>
				<tr>
					<td>
						<asp:Label ID="lblSpec" runat="server" Text="Specification"></asp:Label>
					</td>
					<td>
						<asp:TextBox ID="txtSpecification" runat="server" MaxLength="200" TextMode="MultiLine"
							Font-Size="10pt" Height="37px" Width="252px"></asp:TextBox>
					</td>
				</tr>
				<tr id="urlRow" runat="server">
					<td>
						URL
					</td>
					<td>
						<asp:TextBox ID="txtUrl" runat="server" Width="251px"></asp:TextBox>
						<asp:RequiredFieldValidator ID="rfvFixedUrl" runat="server" ErrorMessage="Please enter url."
							ValidationGroup="saveGroup" ControlToValidate="txtUrl" Display="Dynamic">*</asp:RequiredFieldValidator>
						<asp:RegularExpressionValidator ID="revFixedUrl" runat="server" ErrorMessage="Url should start with '/', end with '/' and should only contain alpha numeric characters ,'-'. example '/trunk-name/[id]-category-name/'"
							ControlToValidate="txtUrl" ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$"
							Display="Static" ValidationGroup="saveGroup">*</asp:RegularExpressionValidator>
					</td>
				</tr>
				<tr>
					<td>
						Display Product Count in Product Directory
					</td>
					<td>
						<uc1:MatrixElementDisplaySelector ID="medsProductCount" runat="server" Enabled="True"
							HideInheritedStatus="False" />
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<asp:CheckBox ID="chkMatrixB" runat="server" Text="Category Matrix" EnableTheming="True"
							Visible="false" />
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<asp:CheckBox ID="chkEnabled" runat="server" Text="Enabled" />
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<uc2:ContentMetadataControl ID="cmcCategoryMetadata" runat="server" ValidationGroup="saveGroup" />
					</td>
				</tr>
				<tr>
					<td colspan="2">
						&nbsp;
					</td>
				</tr>
				<tr id="cloneRow" runat="server">
					<td colspan="2">
						<asp:HyperLink ID="lnkClone" runat="server" CssClass="aDialog common_text_button">Clone</asp:HyperLink>
						<asp:HiddenField ID="hdnCloneCategoryId" runat="server" />
					</td>
				</tr>
				<tr class="AdminPanelSection" id="SpecificationHeaderRow" runat="server">
					<td colspan="2">
						<h4>
							Product Specification Type(s)</h4>
					</td>
				</tr>
				<tr id="SpecificationRow" runat="server">
					<td colspan="2">
						<div id="divSpecType" runat="server">
							<asp:GridView ID="gvSpecTypeList" runat="server" AutoGenerateColumns="False" Width="569px"
								OnRowDeleting="gvSpecTypeList_RowDeleting" OnRowDataBound="gvSpecTypeList_RowDataBound"
								CssClass="common_data_grid" style="width:auto;">
								<Columns>
									<asp:TemplateField HeaderText="Enabled">
										<ItemTemplate>
											<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false" Text=" " 
												Checked='<%# DataBinder.Eval(Container.DataItem,"CategorySpecificationType.Enabled") %>' />
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField HeaderText="Spec Type">
										<ItemTemplate>
											<asp:Label ID="lblSpcName" runat="server" 
												Text='<%# DataBinder.Eval(Container.DataItem,"SpecificationType.SpecType") %>'></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField HeaderText="Spec Type ID">
										<ItemTemplate>
											<asp:Label ID="lblSpecTypeId" runat="server" 
												Text='<%# DataBinder.Eval(Container.DataItem,"SpecificationType.Id") %>'></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField HeaderText="Sort Order">
										<ItemTemplate>
											<asp:Label ID="lblSpecSortOrder" runat="server" 
												Text='<%# DataBinder.Eval(Container.DataItem,"CategorySpecificationType.SortOrder") %>'>
											</asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField HeaderText="Show in Matrix">
										<ItemTemplate>
											<asp:CheckBox ID="chkShowInMatrix" runat="server" 
												Checked='<%# DataBinder.Eval(Container.DataItem,"CategorySpecificationType.ShowInMatrix") %>'
												Enabled="False" />
										</ItemTemplate>
									</asp:TemplateField>
										<asp:TemplateField HeaderText="Display Length">
										<ItemTemplate>
											<asp:Label ID="lblSpecificationLength" runat="server" Text=""></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField ItemStyle-Width="50px">
										<ItemTemplate>
											<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" 
												ToolTip="Edit">Edit</asp:HyperLink>
											<asp:LinkButton ID="lbtnRemove" runat="server" CausesValidation="false" CommandName="Delete"
												Text="Delete" OnClientClick="return confirm(&quot;Are you sure you want to delete this 
												product specification type &quot;);" CssClass="grid_icon_link delete" ToolTip="Delete">
											</asp:LinkButton>
										</ItemTemplate>
									</asp:TemplateField>
								</Columns>
							</asp:GridView>
							<br />
							<asp:HyperLink ID="lnkAddSpecType" runat="server" CssClass="aDialog common_text_button"
								Style="margin-right: 5px;">Add specification type</asp:HyperLink>
							<asp:HyperLink ID="lnkAddNewSpecType" runat="server" CssClass="aDialog common_text_button">New specification type</asp:HyperLink>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						&nbsp;
					</td>
				</tr>
				<tr class="AdminPanelSection" id="MatrixConfigHeaderRow" runat="server">
					<td colspan="2">
						<h4>
							Category Parameters</h4>
					</td>
				</tr>
				<tr id="MatrixConfigRow" runat="server">
					<td colspan="2">
						<asp:Panel ID="pnlMatrixElementDisplay" runat="server">
							<table>
								<tr>
									<td>
										Specification Length Type
									</td>
									<td>
										<asp:RadioButton ID="rdbInheritSpecLength" runat="server" GroupName="SpecLength"
											Text="Inherit" />
										<asp:RadioButton ID="rdbSpecifySpecLength" runat="server" GroupName="SpecLength"
											Text="Specify" />
									</td>
								</tr>
								<tr>
									<td>
										Specification Length
									</td>
									<td>
										<asp:TextBox ID="txtSpecLength" runat="server"></asp:TextBox>
										<asp:CompareValidator ID="cvSpecLength" ControlToValidate="txtSpecLength" Operator="DataTypeCheck"
											Type="Integer" ErrorMessage="Specification length should be numeric value." ValidationGroup="saveGroup"
											runat="server">*</asp:CompareValidator>
										<input type="hidden" id="hdnMatrixSpecificationLengthId" runat="server" />
										<asp:CustomValidator ID="cmvSpecLength" runat="server" ControlToValidate="txtSpecLength"
											ErrorMessage="Please enter specification length" OnServerValidate="cmvSpecLength_ServerValidate"
											ValidateEmptyText="True" ValidationGroup="saveGroup" ClientValidationFunction="ValidateRadioButtonForSpecLength">*</asp:CustomValidator>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									</td>
								</tr>
								<tr>
									<td>
										Primary Lead Form Button Text Type
									</td>
									<td>
										<asp:RadioButton ID="rdbInheritButtonText" runat="server" GroupName="ButtonText"
											Text="Inherit" />
										<asp:RadioButton ID="rdbSpecifyButtonText" runat="server" GroupName="ButtonText"
											Text="Specify" />
									</td>
								</tr>
								<tr>
									<td>
										Primary Lead Form Button Text
									</td>
									<td>
										<asp:TextBox ID="txtButtonText" runat="server"></asp:TextBox>
										<input type="hidden" id="hdnButtonTextId" runat="server" />
										<asp:CustomValidator ID="cmvButtonText" runat="server" ErrorMessage="Please enter request info button text"
											OnServerValidate="cmvButtonText_ServerValidate" ValidateEmptyText="True" ValidationGroup="saveGroup"
											ClientValidationFunction="ValidateRadioButtonForRequestInfo">*</asp:CustomValidator>
									</td>
								</tr>
								<tr>
									<td>
										Request Information for All Products Button Text Type
									</td>
									<td>
										<asp:RadioButton ID="rdbInheritAllButtonText" runat="server" GroupName="AllButtonText"
											Text="Inherit" />
										<asp:RadioButton ID="rdbSpecifyAllButtonText" runat="server" GroupName="AllButtonText"
											Text="Specify" />
									</td>
								</tr>
								<tr>
									<td>
										Request Information for All Products Button Text
									</td>
									<td>
										<asp:TextBox ID="txtAllButtonText" runat="server"></asp:TextBox>
										<input type="hidden" id="hdnAllButtonTextId" runat="server" />
										<asp:CustomValidator ID="cmvAllButtonText" runat="server" ErrorMessage="Please enter request all info button text"
											OnServerValidate="cmvAllButtonText_ServerValidate" ValidateEmptyText="True" ValidationGroup="saveGroup"
											ClientValidationFunction="ValidateRadioButtonForRequestAllInfo">*</asp:CustomValidator>
									</td>
								</tr>
								<tr>
									<td>
										Request Information for Selected Products Button Text Type
									</td>
									<td>
										<asp:RadioButton ID="rdbInheritSelectedInfo" runat="server" GroupName="SelectedInfoText"
											Text="Inherit" />
										<asp:RadioButton ID="rdbSpecifySelectedInfo" runat="server" GroupName="SelectedInfoText"
											Text="Specify" />
									</td>
								</tr>
								<tr>
									<td>
										Request Information for Selected Products Button Text&nbsp;
									</td>
									<td>
										<asp:TextBox ID="txtSelectedInfoText" runat="server"></asp:TextBox>
										<input type="hidden" id="hdnSelectedInfoId" runat="server" />
										<asp:CustomValidator ID="cmvSelectedInfo" runat="server" ErrorMessage="Please enter request information button text"
											OnServerValidate="cmvSelectedInfo_ServerValidate" ValidateEmptyText="True" ValidationGroup="saveGroup"
											ClientValidationFunction="ValidateRadioButtonForRequestSelectedInfo">*</asp:CustomValidator>
									</td>
								</tr>
								<tr>
									<td>
										No of Rows per Matrix Page
									</td>
									<td>
										<asp:TextBox ID="txtNoOfRows" runat="server"></asp:TextBox>
										<asp:CompareValidator ID="cvNoOfRows" ControlToValidate="txtNoOfRows" Operator="DataTypeCheck"
											Type="Integer" ErrorMessage="No of Rows per Matrix Page should be numeric value"
											ValidationGroup="saveGroup" runat="server">*</asp:CompareValidator>
										<input type="hidden" id="hdnNoOfRowsId" runat="server" />
									</td>
								</tr>
								<tr>
									<td>
										Show Link to Vendor Profile Page
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsVendorProfile" runat="server" Enabled="True"
											HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										Direct Click Through
									</td>
									<td>
										<asp:DropDownList ID="ddlDirectClickThrough" runat="server" Width="88px">
											<asp:ListItem Text="False" Value="False"></asp:ListItem>
											<asp:ListItem Text="True" Value="True"></asp:ListItem>
										</asp:DropDownList>
										<asp:HiddenField ID="hdnDirectClickThroughId" runat="server" />
									</td>
								</tr>
								<tr>
									<td>
										Display Images in Related Product Module
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsDisplayRelatedProductImages" runat="server"
											Enabled="true" />
									</td>
								</tr>
								<tr>
									<td colspan="2">
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<h4>
											Matrix Element Display Status</h4>
									</td>
								</tr>
								<tr>
									<td>
										<asp:Literal ID="ltlImage" runat="server" Text="Show Image in Compare Page"></asp:Literal>
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsImage" runat="server" Enabled="True" HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										<asp:Literal ID="ltlManufacturer" runat="server" Text="Show Manufacturer"></asp:Literal>
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsManufacturer" runat="server" Enabled="True"
											HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										<asp:Literal ID="ltlDistributor" runat="server" Text="Show Distributor"></asp:Literal>
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsDistributor" runat="server" Enabled="True"
											HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										<asp:Literal ID="ltlSpecification" runat="server" Text="Show Specification"></asp:Literal>
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsSpecification" runat="server" Enabled="True"
											HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										<asp:Literal ID="ltlPrice" runat="server" Text="Show Item Price"></asp:Literal>
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsPrice" runat="server" Enabled="True" HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										<asp:Literal ID="ltlLinkToItemDetail" runat="server" Text="Show Link to Item Detail"></asp:Literal>
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsLinkToItemDetail" runat="server" Enabled="True"
											HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										<asp:Literal ID="ltlContentAssociation" runat="server" Text="Show Link to Content Association"></asp:Literal>
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsContentAssociation" runat="server" Enabled="True"
											HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										<asp:Literal ID="ltlLinkToVendorProductPage" runat="server" Text="Show Link to Vendor Product Page"></asp:Literal>
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsLinkToVendorProductPage" runat="server"
											Enabled="True" HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										<asp:Label ID="lblShowReqInfoForAll" runat="server" Text="Show Request Info for All Button"></asp:Label>
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsShowRequestInfoForAll" runat="server" Enabled="True"
											HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										<asp:Label ID="lblShowHorizontalReqInfoForAll" runat="server" Text="Show Request Info for All Button in Horizontal Matrix Page"></asp:Label>
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsShowHorizontalRequestInfoForAll" runat="server" Enabled="True"
											HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										<asp:Label ID="lblShowMatrixImage" runat="server" Text="Show Vertical Matrix Images"></asp:Label>
									</td>
									<td>
										<uc1:MatrixElementDisplaySelector ID="medsShowVerticalMatrixImage" runat="server"
											Enabled="True" HideInheritedStatus="False" />
									</td>
								</tr>
								<tr>
									<td>
										Column Based Matrix
									</td>
									<td>
										<asp:CheckBox ID="chkColumnBasedMatrix" runat="server" />
										<asp:HiddenField ID="hdnColumnBasedMatrix" runat="server" />
									</td>
								</tr>
								<tr>
									<td>
										Category Level Leads
									</td>
									<td>
										<asp:CheckBox ID="chkCategoryLevelLeads" runat="server" />
										<asp:HiddenField ID="hdnCategoryLevelLeads" runat="server" />
									</td>
								</tr>
								<tr>
									<td>
										&nbsp;
									</td>
									<td>
										&nbsp;
									</td>
								</tr>
							</table>
						</asp:Panel>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<asp:Button ID="btnInsertCategory" runat="server" Text="Save" OnClick="btnInsertCategory_Click"
							ValidationGroup="saveGroup" CssClass="common_text_button" />
						&nbsp;
						<asp:Button ID="btnMakeSearchCategory" runat="server" Text="Make Search Category"
							CssClass="common_text_button" OnClick="btnMakeSearchCategory_Click" OnClientClick="return confirm('This will save the category and will navigate you to the Search Category configuration screen. Are you sure you want to continue ?');" />
						&nbsp;
						<asp:HyperLink ID="lnkAssociate" runat="server" CssClass="common_text_button aDialog">Associate Content</asp:HyperLink>
						&nbsp;
						<asp:Button ID="btnCancelCategory" runat="server" Text="Cancel" OnClick="btnCancel_Click"
							CssClass="common_text_button" />
						&nbsp;
						<input type="hidden" id="hdnPossibleToSave" runat="server" />
					</td>
				</tr>
				<tr>
					<td colspan="2">
						&nbsp;
					</td>
				</tr>
			</table>
		</div>
	</div>
</asp:Content>
