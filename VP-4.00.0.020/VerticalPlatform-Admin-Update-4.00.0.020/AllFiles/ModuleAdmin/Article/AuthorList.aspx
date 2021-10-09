<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/MasterPage.Master"
	AutoEventWireup="true" CodeBehind="AuthorList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.AuthorList"
	Title="Untitled Page" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script type="text/javascript">
		RegisterNamespace("VP.Author");
		$(document).ready(function() {
			$(".author_srh_btn").click(function() {
				$(".author_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
				$("#divSearchCriteria").toggleClass("hide");
			});

			$("#divSearchCriteria").append(VP.Author.GetSearchCriteriaText());
		});

		VP.Author.GetSearchCriteriaText = function() {
			var txtAuthorId = $("input[id$='txtAuthorId']");
			var txtFirstName = $("input[id$='txtFirstName']");
			var txtLastName = $("input[id$='txtLastName']");
			var searchHtml = "";

			if (txtAuthorId.val().trim().length > 0) {
				searchHtml += " ; <b>Author Id</b> : " + txtAuthorId.val().trim();
			}
			if (txtFirstName.val().trim().length > 0) {
				searchHtml += " ; <b>First Name</b> : " + txtFirstName.val().trim();
			}
			if (txtLastName.val().trim().length > 0) {
				searchHtml += " ; <b>Last Name</b> : " + txtLastName.val().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml) {
				searchHtml += " )";
			}
			
			return searchHtml;
		};
	</script>
	
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3><asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Author List</asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
			<div class="author_srh_btn">Filter</div>
			<div id="divSearchCriteria"></div>
			<br />
			<div id="divSearchPane" class="author_srh_pane" style="display: none;">
				<div class="form-horizontal">
					<div class="control-group">
						<label class="control-label">Author Id</label>
						<div class="controls">
							<asp:TextBox runat="server" ID="txtAuthorId" Width="120px" MaxLength="100"></asp:TextBox>
							<asp:CompareValidator ID="cvAuthorId" runat="server" ControlToValidate="txtAuthorId" ValidationGroup="FilterList"
								ErrorMessage="Please enter a number for Author Id." Type="Integer" Operator="DataTypeCheck">*</asp:CompareValidator>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">First Name</label>
						<div class="controls">
							<asp:TextBox runat="server" ID="txtFirstName" Width="120px" MaxLength="100"></asp:TextBox>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Last Name</label>
						<div class="controls">
							<asp:TextBox runat="server" ID="txtLastName" Width="120px" MaxLength="100"></asp:TextBox>
						</div>
					</div>
					<div class="form-actions">
						<asp:Button ID="btnFilter" runat="server" Text="Filter" ValidationGroup="FilterList" CssClass="btn"
						OnClick="btnFilter_Click" />&nbsp;
						<asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn" />
					</div>
				</div>
			</div>
			<br />
			<div class="add-button-container">
				<asp:HyperLink ID="lnkAddAuthor" runat="server" Text="Add Author" CssClass="aDialog btn"></asp:HyperLink>
			</div>
			<table style="width: 100%">
				<tr>
					<td>
						<asp:GridView ID="gvAuthorList" runat="server" AutoGenerateColumns="False"
							OnRowDataBound="gvAuthorList_RowDataBound" Width="100%" CssClass="common_data_grid table table-bordered">
							<AlternatingRowStyle CssClass="DataTableRowAlternate" />
							<RowStyle CssClass="DataTableRow" />
							<Columns>
								<asp:BoundField HeaderText="ID" DataField="Id" />
								<asp:BoundField DataField="Title" HeaderText="Title" />
								<asp:BoundField HeaderText="First Name" DataField="FirstName" />
								<asp:BoundField HeaderText="Last Name" DataField="LastName" />
								<asp:BoundField DataField="Email" HeaderText="Email" />
								<asp:BoundField DataField="Position" HeaderText="Position" />
								<asp:BoundField DataField="Department" HeaderText="Department" />
								<asp:BoundField HeaderText="Organization" DataField="Organization" />
								<asp:TemplateField HeaderText="Country">
									<ItemTemplate>
										<asp:Label ID="lblCountry" runat="server" />
									</ItemTemplate>
								</asp:TemplateField>
								<asp:BoundField DataField="Created" HeaderText="Created" />
								<asp:BoundField DataField="Modified" HeaderText="Modified" />
								<asp:BoundField HeaderText="Degree" DataField="Degree" />
								<asp:BoundField HeaderText="Speaker Title" DataField="SpeakerTitle" />
								<asp:BoundField HeaderText="Author Type" DataField="AuthorType" />
								<asp:TemplateField HeaderText="Enabled">
									<ItemTemplate>
										<asp:CheckBox ID="chkEnabledAuthor" runat="server" Enabled="false" />
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField>
									<ItemTemplate>
										<asp:HyperLink ID="lnkEdit" Text="Edit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit"></asp:HyperLink>
									</ItemTemplate>
								</asp:TemplateField>
							</Columns>
						</asp:GridView>
						<br />
						<uc1:Pager ID="pgrAuthor" runat="server" />
					</td>
				</tr>
			</table>
		</div>
	</div>	
	<asp:HiddenField ID="hdnAuthorId" runat="server" />
</asp:Content>
