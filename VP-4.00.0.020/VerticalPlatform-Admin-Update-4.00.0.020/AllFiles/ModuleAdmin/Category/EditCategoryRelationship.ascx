<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditCategoryRelationship.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.EditCategoryRelationship" %>

<div style="padding:10px 10px">
	<asp:Literal ID="ltlMessage" runat="server"></asp:Literal>
</div>
<table id="categoryLinkDetails" runat="server" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<div class="form-horizontal">
				<div class="control-group">
					<label class="control-label">Hidden</label>
					<div class="controls">
						<asp:CheckBox runat="server" id="hidden"/>
					</div>
				</div>	
			</div>
		</td>
	</tr>
	<tr>
		<td>
			<div class="form-horizontal">
				<div class="control-group">
					<label class="control-label">Jump Page Display Name</label>
					<div class="controls">
						<asp:TextBox ID="jumpPageDisplayName" runat="server"></asp:TextBox>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>
