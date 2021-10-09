<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchHeaderSettings.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.SearchHeaderSettings" %>


<div class="searchHeaderSettings">
	<ul class="common_form_area">
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				No Search Results Message
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="noSearchResultsMessage" runat="server" Width="407px" Height="213px" 
					TextMode="MultiLine"></asp:TextBox>
				<asp:HiddenField ID="noSearchResultsMessageHiddenVal" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Display Search Result Counts
			</div>
			<div class="common_form_row_data">
				<asp:CheckBox ID="contentCountChkBox" runat ="server"/>
				<asp:HiddenField ID="contentCountChkBoxHiddenVal" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Enable No Search Performed Message
			</div>
			<div class="common_form_row_data">
				<asp:CheckBox ID="noSearchPerformedChkBox" runat ="server" 
				OnCheckedChanged="noSearchPerformedChkBox_CheckedChanged" AutoPostBack="True"/>
				<asp:HiddenField ID="noSearchPerformedMessageChkBoxHiddenVal" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				<asp:Label runat="server" ID="noSearchPerformedMessageLabel" Text="No Search Performed Message" />
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="noSearchPerformedMessage" runat="server" Width="407px" Height="213px" 
					TextMode="MultiLine"></asp:TextBox>
				<asp:HiddenField ID="noSearchPerformedMessageHiddenVal" runat="server" />
			</div>
		</li>
	    <li class="common_form_row clearfix group_row">
	        <div class="common_form_row_lable">
	            <asp:Label runat="server" ID="Label1" Text="Sub Heading" />
	        </div>
	        <div class="common_form_row_data">
	            <asp:TextBox ID="subHeadingText" runat="server" Width="407px"></asp:TextBox>
	            <asp:HiddenField ID="subHeadingHiddenVal" runat="server" />
	        </div>
	    </li>
	</ul>
</div>
