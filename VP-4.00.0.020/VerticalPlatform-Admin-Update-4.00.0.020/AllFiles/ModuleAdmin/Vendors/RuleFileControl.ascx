<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RuleFileControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.RuleFileControl" %>

<div class="form-horizontal">
	
	<br />
	 <div class="control-group">
		<label class="control-label">Rule File</label>
		<div class="controls">
			<asp:FileUpload class="vendor-rule-file" ID="fuRuleFile" runat="server" AllowMultiple="false" accept=".csv" />	
			<asp:RequiredFieldValidator ID="RuleFileValidator" runat="server" ErrorMessage="Please Select Rule File."
				ControlToValidate="fuRuleFile" ValidationGroup="RuleFile">*</asp:RequiredFieldValidator>
		</div>
	</div>

	<div class="control-group">
		<div class="controls">
			<asp:Button ID="btnAddRuleFile" runat="server" Text="Add File" CssClass="btn" ValidationGroup="RuleFile"  OnClick="btnAddRuleFile_Click"  />
		</div>
	</div>
</div>
<br />
<asp:GridView ID="gvRuleFile" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
	 OnRowDataBound="gvRuleFile_RowDataBound">
	<Columns>
		<asp:TemplateField HeaderText="Source Column Name">
			<ItemTemplate>
				<asp:Label ID="lblSourceColumnName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Column Type">
			<ItemTemplate>
				<asp:Label ID="lblColumnType" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Field Name">
			<ItemTemplate>
				<asp:Label ID="lblFieldName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Spec Type Id">
			<ItemTemplate>
				<asp:Label ID="lblSpecTypeId" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>	
		
	</Columns>
	<EmptyDataTemplate>
		No Rule File Found.</EmptyDataTemplate>
</asp:GridView>
