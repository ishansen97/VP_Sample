<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleCustomPropertyEditor.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ArticleCustomPropertyEditor" %>

<script type="text/javascript">
	$(document).ready(function() {
		$("input.date_picker", "table[id$='gvCustomProperty']").datepicker(
		{
			changeYear: true
		});
	});
</script>

<h5>
	<asp:Label ID="lblCustomProp" runat="server" Text="Article Custom Properties" />
</h5>
<div>
<asp:GridView ID="gvCustomProperty" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvCustomProperty_RowDataBound"
	Width="100%" ShowHeader="False" BorderWidth="0" GridLines="None" CssClass="form-table">
	<RowStyle BorderStyle="None" BorderWidth="0px" />
	<Columns>
		<asp:TemplateField Visible="false">
			<ItemTemplate>
				<asp:Label ID="lblCustomPropertyId" runat="server"></asp:Label>
			</ItemTemplate>
            <ItemStyle CssClass="label-column" />
		</asp:TemplateField>
		<asp:TemplateField>
			<ItemTemplate>
				<asp:Label ID="lblPropertyName" runat="server"></asp:Label>
			</ItemTemplate>
            <ItemStyle CssClass="label-column" />
		</asp:TemplateField>
		<asp:TemplateField>
			<ItemTemplate>
				<asp:TextBox ID="txtPropertyValue" runat="server" Width="190px"></asp:TextBox>
			</ItemTemplate>
			<ItemStyle />
		</asp:TemplateField>
		<asp:TemplateField ItemStyle-BorderWidth="0" ControlStyle-BorderWidth="0">
			<ItemTemplate>
				<asp:PlaceHolder ID="phValidator" runat="server"></asp:PlaceHolder>
			</ItemTemplate>
			<ItemStyle />
		</asp:TemplateField>
		<asp:TemplateField Visible="false">
			<ItemTemplate>
				<asp:Label ID="lblValidatorDataType" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField Visible="false">
			<ItemTemplate>
				<asp:Label ID="lblArticleCustomPropertyId" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField Visible="false">
			<ItemTemplate>
				<asp:Label ID="lblIsNullable" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
</asp:GridView>
</div>
<br />
