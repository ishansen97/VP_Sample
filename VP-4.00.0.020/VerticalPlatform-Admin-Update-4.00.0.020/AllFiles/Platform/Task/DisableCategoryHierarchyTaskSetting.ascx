<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DisableCategoryHierarchyTaskSetting.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Task.DisableCategoryHierarchySettings" %>

<ul class="common_form_area" style="width:430px">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>
				Leaf category Ids
			</label>
		</span>
		<span>
			<textarea runat="server" id="leafCategoryIdsList" rows="2" cols="100"></textarea>
			<asp:RegularExpressionValidator id="leafCategoryIdsListValidator" 
					ControlToValidate="leafCategoryIdsList"
					ValidationExpression="[0-9]+(,[0-9]+)*"
					ErrorMessage="Invalid list of category Ids"
					runat="server">*</asp:RegularExpressionValidator>
		</span>
	</li>
</ul>
