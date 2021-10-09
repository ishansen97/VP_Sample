<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="AddVendor.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.AddVendor" %>
	
<%@ Register Src="../MatrixElementDisplaySelector.ascx" TagName="MatrixElementDisplaySelector"
	TagPrefix="uc2" %>
	
<asp:Content ID="cntAddVendor" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	
	<script language="javascript" type="text/javascript">
		$(document).ready(function() {
			var txtChildVendors = {contentId:"txtChildVendors"};
			var vendorNameOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15",
			    showName: "true", bindings: txtChildVendors, parentVendorOnly : "true"};
			$("input[type=text][id*=txtChildVendors]").contentPicker(vendorNameOptions);
		});
	</script>
	
	
	<div class="AdminPanelHeader">
		<h3>
			<asp:Label ID="lblTitle" runat="server" Font-Bold="True"></asp:Label></h3>
	</div>
	<div class="AdminPanelContent">
		<table>
			<tr>
				<td>
					Name
				</td>
				<td>
					<asp:TextBox ID="txtName" runat="server" MaxLength="100" Width="250px" CausesValidation="true"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvVendorName" runat="server" ControlToValidate="txtName"
						ErrorMessage="Please enter name." ValidationGroup="SaveVendor">*</asp:RequiredFieldValidator>
				</td>
			</tr>
			<tr>
				<td>
					Email
				</td>
				<td>
					<asp:TextBox ID="txtEmail" runat="server" MaxLength="100" Width="250px" CausesValidation="true"></asp:TextBox>
					<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtEmail" 
						ErrorMessage="Invalid email." ValidateEmptyText="true" ClientValidationFunction="VP.ValidateEmail"
						ValidationGroup="SaveVendor">*</asp:CustomValidator>
				</td>
			</tr>
			<tr>
				<td>
					Rank
				</td>
				<td>
					<asp:DropDownList ID="ddlRank" runat="server" Width="260px">
					</asp:DropDownList>
				</td>
			</tr>
			<tr>
				<td>
					Address Line 1
				</td>
				<td>
					<asp:TextBox ID="txtAddressLine1" runat="server" Width="250px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td>
					Address Line 2
				</td>
				<td>
					<asp:TextBox ID="txtAddressLine2" runat="server" Width="250px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td>
					City
				</td>
				<td>
					<asp:TextBox ID="txtCity" runat="server" Width="250px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td>
					State/Province
				</td>
				<td>
					<asp:TextBox ID="txtState" runat="server" Width="250px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td>
					Zip/Postal Code
				</td>
				<td>
					<asp:TextBox ID="txtZipPostalCode" runat="server" Width="250px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td>
					Country
				</td>
				<td>
					<asp:DropDownList ID="ddlCountry" runat="server" Width="260px">
					</asp:DropDownList>
				</td>
			</tr>
			<tr>
				<td>
					Enabled/Disabled
				</td>
				<td>
					<div style="margin-top:7px; margin-bottom:6px">
						<asp:HyperLink ID="lnkEnableDisableVendor" runat="server" CssClass="aDialog common_text_button"/>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top">
					Phone
				</td>
				<td>
					<div id="PhoneDetails" runat="server">
						<asp:ListBox ID="lstPhone" runat="server" Width="260px" style="margin-bottom:5px;"></asp:ListBox>
						<br />
						<asp:TextBox ID="txtPhone" runat="server" Width="130px"></asp:TextBox>
							
						&nbsp;<asp:Button ID="btnAdd" runat="server" OnClick="btnAdd_Click" Text="Add" CssClass="common_text_button" />
						&nbsp;<asp:Button ID="btnRemove" runat="server" OnClick="btnRemove_Click" Text="Remove" CssClass="common_text_button" />
						<input type="hidden" id="hdnPhone" runat="server" />
						<input type="hidden" id="hdnRemovePhoneNumbers" runat="server" />
					</div>
				</td>
			</tr>
			<tr>
				<td>
					URL Display Name
				</td>
				<td>
					<asp:TextBox ID="txtUrlDisplayName" runat="server" Width="250px"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<td>
					Url
				</td>
				<td>
					<asp:TextBox ID="txtUrl" runat="server" Width="250px"></asp:TextBox>
					<asp:RegularExpressionValidator ID="revWebsite" runat="server" ErrorMessage="Not a valid url."
						ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=;]*)?" ControlToValidate="txtUrl"
						ValidationGroup="SaveVendor">*</asp:RegularExpressionValidator>
				</td>
			</tr>
			<tr id="fixedUrlRow" runat="server">
				<td>
					Fixed URL
				</td>
				<td>
					<asp:TextBox ID="txtFixedUrl" runat="server" Width="250px"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvFixedUrl" runat="server" ErrorMessage="Please enter fixed url." ValidationGroup="SaveVendor"
						ControlToValidate="txtFixedUrl" Display="Dynamic">*</asp:RequiredFieldValidator>
					<asp:RegularExpressionValidator ID="revFixedUrl" runat="server" ErrorMessage="Url should start with '/', end with '/' and should only contain alpha numeric characters ,'-'. example '/id-vendor-name/'."
						ControlToValidate="txtFixedUrl" ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$"
						Display="Static" ValidationGroup="SaveVendor">*</asp:RegularExpressionValidator>
				</td>
			</tr>
			<tr>
				<td>
					Has Image
				</td>
				<td>
					<asp:CheckBox ID="chkHasImage" runat="server" />
				</td>
			</tr>
			<tr>
				<td>
					Image
				</td>
				<td>
					<asp:Image ID="imgVendor" runat="server" Width="70px" />
					<br />
					<asp:HiddenField ID="hdnHasImage" runat="server" />
					<asp:HiddenField ID="hdnImageName" runat="server" />
					<asp:FileUpload ID="fuVendorImage" runat="server" Width="246px" />
					&nbsp;&nbsp;&nbsp;
					Create Standard Image Sizes
					&nbsp;
					<asp:CheckBox ID="chkResizeImage" runat="server" />
				</td>
			</tr>
			<tr>
				<td valign="top">
					Keywords
				</td>
				<td>
					<div class="keywordControls">
						<asp:ListBox ID="lstKeywords" runat="server" Width="260px" style="margin-bottom:5px;"></asp:ListBox>
						<br />
						<asp:TextBox ID="txtKeywords" runat="server" Width="130px"></asp:TextBox>
							
						&nbsp;<asp:Button ID="btnAddKeyword" runat="server" Text="Add" 
							CssClass="common_text_button" onclick="btnAddKeyword_Click" />
						&nbsp;<asp:Button ID="btnRemoveKeyword" runat="server" Text="Remove" 
							CssClass="common_text_button" onclick="btnRemoveKeyword_Click" />
						<input type="hidden" id="hdnKeywords" runat="server" />
						<input type="hidden" id="hdnRemovedKeywords" runat="server" />
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<h4>
						Vendor Specifications</h4>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<asp:GridView ID="gvSpecifications" runat="server" AutoGenerateColumns="False"
						OnRowDeleting="gvSpecifications_RowDeleting" OnRowDataBound="gvSpecifications_RowDataBound" CssClass="common_data_grid">
						<Columns>
							<asp:TemplateField HeaderText="Specification Type">
								<ItemTemplate>
									<asp:Label ID="lblSpecificationTypeName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SpecificationType.SpecType") %>'></asp:Label>
								</ItemTemplate>
							</asp:TemplateField>
							<asp:TemplateField HeaderText="Specification">
								<ItemTemplate>
									<asp:Label ID="lblSpecification" runat="server" Text='<%#  DataBinder.Eval(Container.DataItem,"Specification.SpecificationValue")  %>'></asp:Label>
								</ItemTemplate>
							</asp:TemplateField>
							<asp:TemplateField HeaderText="Display Options">
								<ItemTemplate>
									<asp:CheckBox ID="chkShowInVerticalMatrix" runat="server" Text="Vertical Matrix" Checked="false" Enabled="false"/>
									<asp:CheckBox ID="chkShowInServiceDetail" runat="server" Text="Service Detail" Checked="false" Enabled="false"/>
									<asp:CheckBox ID="showInVendorDetail" runat = "server" Text="Vendor Detail" Checked="false" Enabled="false" />
								</ItemTemplate>
							</asp:TemplateField>
							<asp:TemplateField>
								<ItemTemplate>
									<asp:HyperLink ID="lnkEdit" runat="server" CausesValidation="false" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
									<asp:LinkButton ID="lbtnRemove" runat="server" CommandName="Delete" CausesValidation="false"
										OnClientClick="return confirm(&quot;Are you sure you want to delete this vendor specification &quot;);"
										Text="Delete" CssClass="grid_icon_link delete" ToolTip="Delete">
										<asp:HiddenField ID="hdnEditSpecTypeId" runat="server" Value='<%#  DataBinder.Eval(Container.DataItem,"SpecificationType.id")  %>' />
										<asp:HiddenField ID="hdnEditSpecId" runat="server" Value='<%#  DataBinder.Eval(Container.DataItem,"Specification.id")  %>' />
									</asp:LinkButton>
								</ItemTemplate>
							</asp:TemplateField>
						</Columns>
					</asp:GridView>
					<br />
					<asp:HyperLink ID="lnkSpecificationType" runat="server" Text="Add Vendor Specifications" CssClass="aDialog"></asp:HyperLink>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				</td>
			</tr>
			<tr>
				<div id="divChildVendorsHeading" runat="server">
					<td colspan="2">
						<h4>
							Child Vendor Associations
						</h4>
					</td>
				</div>
			</tr>
			<tr>
				<div id="divChildVendorsData" runat="server">
					<td colspan="2">
						<table border="0">
							<tr>
								<td class="style5">
									Child Vendors
								</td>
								<td>
									<asp:TextBox ID="txtChildVendors" runat="server"></asp:TextBox>
									<asp:Button ID="btnAddChildVendors" runat="server" Text="Add" 
										CssClass="common_text_button" onclick="btnAddChildVendors_Click" />
								</td>
							</tr>
							<tr>
								<td class="style5">
									&nbsp;
								</td>
								<td>
									<asp:ListBox ID="lstChildVendors" runat="server" Width="247px"></asp:ListBox>
									<input type="hidden" id="hdnRemovedChildVendors" runat="server" />
								</td>
							</tr>
							<tr>
								<td class="style5">
									&nbsp;
								</td>
								<td><br />
									<asp:Button ID="btnChildVendorsUp" runat="server" Text="Move Up" 
										CssClass="common_text_button" onclick="btnChildVendorsUp_Click" />
									<asp:Button ID="btnChildVendorsDown" runat="server" Text="Move Down" 
										CssClass="common_text_button" onclick="btnChildVendorsDown_Click" />
									<asp:Button ID="btnChildVendorsRemove" runat="server" Text="Remove" 
										CssClass="common_text_button" onclick="btnChildVendorsRemove_Click" />
								</td>
							</tr>
						</table>
					</td>
				</div>
			</tr>
			<tr>
				<td colspan="2">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<h4>
						Vendor Parameters</h4>
				</td>
			</tr>
			<tr>
				<td>
					<asp:Literal ID="ltlShowImage" runat="server" Text="Show Image in Compare Page"></asp:Literal>
				</td>
				<td>
					<uc2:MatrixElementDisplaySelector ID="medsImage" runat="server" Enabled="True" HideInheritedStatus="False" />
				</td>
			</tr>
			<tr>
				<td>
					<asp:Literal ID="ltlShowPrice" runat="server" Text="Show Price in Matrix"></asp:Literal>
				</td>
				<td>
					<uc2:MatrixElementDisplaySelector ID="medsPrice" runat="server" Enabled="True" HideInheritedStatus="False" />
				</td>
			</tr>
			<tr>
				<td>
					<asp:Literal ID="ltlShowRequestInformationLink" runat="server" Text="Show Request Information Link"></asp:Literal>
				</td>
				<td>
					<uc2:MatrixElementDisplaySelector ID="medsShowRequestInformationLink" runat="server" Enabled="True" HideInheritedStatus="False" />
				</td>
			</tr>
			<tr>
				<td>
					<asp:Literal ID="ltlShowRequestInfo" runat="server" Text="Primary Lead Enabled"></asp:Literal>
				</td>
				<td>
					<uc2:MatrixElementDisplaySelector ID="medsShowRequestInfo" runat="server" Enabled="True"
						HideInheritedStatus="true" />
				</td>
			</tr>
			<tr>
				<td>
					Show in Office Setup Page
				</td>
				<td>
					<asp:CheckBox ID="chkShowInOfficeSetup" runat="server" />
					<asp:HiddenField ID="hdnShowInOfficeSetupId" runat="server" />
				</td>
			</tr>
			<tr>
				<td>
					Disable All Actions
				</td>
				<td>
					<uc2:MatrixElementDisplaySelector ID="medsDisableAction" runat="server"
						Enabled="true" HideInheritedStatus="true" CurrentStatus="False"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<br />
					<asp:HyperLink ID="lnkAssociate" runat="server" CssClass="common_text_button aDialog">Associate Content</asp:HyperLink>
					<asp:Button ID="btnSave" runat="server" Text="Save" ValidationGroup="SaveVendor"
						OnClick="btnSave_Click" CssClass="common_text_button"  />
					<asp:Button ID="btnCancelVendor" runat="server" OnClick="btnCancel_Click" Text="Cancel" CssClass="common_text_button"  />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<asp:HiddenField ID="hdnContactId" runat="server" />
				</td>
			</tr>
			
		</table>
	</div>
</asp:Content>
