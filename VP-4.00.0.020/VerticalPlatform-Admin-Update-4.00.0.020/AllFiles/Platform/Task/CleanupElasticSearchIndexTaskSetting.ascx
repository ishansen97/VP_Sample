<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CleanupElasticSearchIndexTaskSetting.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Task.CleanupElasticSearchIndexTaskSetting" %>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 250px;"><label>
			Batch Size</label></span> <span>
		<asp:TextBox runat="server" ID="batchSize" ToolTip="Batch Size" MaxLength="5"></asp:TextBox></span>
	</li>
    <li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;"><label>
			For All Products</label></span> <span>
				<asp:CheckBox ID="forAllProductsCheck" runat="server" />
		</span>
	</li>
</ul>
