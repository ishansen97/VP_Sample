<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CategoryControl.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.CategoryControl" %>

<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label"><asp:Literal ID = "ltlCategoryIdText"  runat="server" Text= "Category&nbsp;Id"></asp:Literal></label>
		<div class="controls">
			<asp:Literal ID = "ltlCategoryId"  runat="server"></asp:Literal>
		</div>
	</div>
	 <div class="control-group">
		<label class="control-label">Category Name</label>
		<div class="controls">
			<asp:TextBox ID="txtCategoryName" runat="server" MaxLength="255" Width="250px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvTxtCategoryName" runat="server" ControlToValidate="txtCategoryName"
				ErrorMessage="Please enter category name.">*</asp:RequiredFieldValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Type</label>
		<div class="controls">
			<asp:DropDownList ID="ddlType" runat="server" Width="260px" 
			OnSelectedIndexChanged="ddlType_SelectedIndexChanged" AutoPostBack="true">
			</asp:DropDownList>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Matrix Type</label>
		<div class="controls">
			<asp:DropDownList ID="ddlMatrixType" runat="server" Width="260px" >
			</asp:DropDownList>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Short Name</label>
		<div class="controls">
			<asp:TextBox ID="txtShortName" runat="server" Width="250px"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Description</label>
		<div class="controls">
			<asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Width="500px"
				Height="120px"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Enabled</label>
		<div class="controls">
			<asp:CheckBox ID="chkEnabled" runat="server"/>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label"><asp:Literal ID="ltlImage" runat="server" Text="Image"></asp:Literal></label>
		<div class="controls">
			<div class="vendorImg">
				<asp:Image ID="imgCategory" runat="server" Height="70px" Width="70px" />
			</div>
			<asp:FileUpload ID="fuImage" runat="server" />
			<asp:HiddenField ID="hdnHasImage" runat="server" />
			<asp:HiddenField ID="hdnHasTemporaryImage" runat="server" />
			<asp:HiddenField ID="hdnTemporaryFileName" runat="server" />
			<label class="checkbox" style="padding-left:121px;"><asp:CheckBox ID="chkResizeImage" runat="server" />Create Standard Image Sizes </label>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Has Image</label>
		<div class="controls">
			<asp:CheckBox ID="chkHasImage" runat="server" />
		</div>
	</div>
	<table cellpadding="0" cellspacing="0">
		<tr id="trIsSearchCategory" runat="server" Visible="false">
			<td>
				<div class="control-group">
					<label class="control-label">Search Category</label>
					<div class="controls">
						<asp:CheckBox ID="chkIsSearchCategory" runat="server"/>
					</div>
				</div>
			</td>
		</tr>
		<tr id="isGenerated" runat="server" Visible="false">
			<td>
				<div class="control-group">
					<label class="control-label">Generated Category</label>
					<div class="controls">
						<asp:CheckBox ID="isGeneratedCheckBox" runat="server" Enabled="False"/>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<div class="control-group">
		<label class="control-label">Display Product Count in Product Directory</label>
		<div class="controls">
			<asp:RadioButtonList ID="rblDisplayProductCount" runat="server" RepeatDirection="Horizontal" CellPadding="0" CellSpacing="0">
			</asp:RadioButtonList>
		</div>
	</div>
	<table cellpadding="0" cellspacing="0">
		<tr runat="server" id="trDisplayName" Visible="false">
			<td>
				<div class="control-group">
					<label class="control-label">Display Name</label>
					<div class="controls">
						<asp:TextBox ID="txtDisplayName" runat="server" Width="250px"></asp:TextBox>
						(This name is used to display the child category under the trunk category in the
						home page)
					</div>
				</div>
			</td>
		</tr>
		<tr runat="server" id="trDisplayInDigestView" Visible="false">
			<td>
				<div class="control-group">
					<label class="control-label">Display in Digest View</label>
					<div class="controls">
						<asp:RadioButtonList ID="rblIsDisplayed" runat="server" RepeatDirection="Horizontal" CellPadding="0" CellSpacing="0">
						</asp:RadioButtonList>
					</div>
				</div>
			</td>
		</tr>
		<tr runat="server" id="trHidden">
			<td>
				<div class="control-group">
					<label class="control-label">Hidden</label>
					<div class="controls">
						<asp:CheckBox ID="chkHidden" runat="server" Checked="false"/>
					</div>
				</div>
			</td>
		</tr>
	    <tr runat="server" id="trCategoryOrderIndex">
	        <td>
	            <div class="control-group">
	                <label class="control-label">Sorting Order Index</label>
	                <div class="controls">
	                    <asp:TextBox ID="SortOrder" runat="server" Width="250px"></asp:TextBox>
	                    <asp:RegularExpressionValidator ID="RegExValidatorSortingindex"
	                                                    ControlToValidate="SortOrder" runat="server"
	                                                    ErrorMessage="Please enter valid number"
	                                                    ValidationExpression="\d+">
	                    </asp:RegularExpressionValidator>
	                    <em style="display: block;">Leave empty for last sort order</em>
	                </div>
	            </div>
	        </td>
	    </tr>
	</table>
</div>
<br />
<asp:HyperLink ID="lnkCloneCategory" runat="server" CssClass="aDialog btn" Visible="false">Clone Category</asp:HyperLink>
