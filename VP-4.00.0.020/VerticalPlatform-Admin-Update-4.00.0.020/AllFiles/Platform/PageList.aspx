<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="PageList.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.PageList"
	Title="Untitled Page" %>

<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../js/JQuery/jquery.json-1.3.min.js" type="text/javascript"></script>
	<script src="../Js/JQuery/jquery.tree.js" type="text/javascript"></script>
	<script src="../Js/PageList.js" type="text/javascript"></script>
	<script src="../Js/JQuery/jquery.autoscroller.js" type="text/javascript"></script>
	
	<script type="text/javascript">
		$(document).ready(function () {
			$("#divPageList").displayPageList();
			$.autoscroll.init({ mod_key: 18 });
			$(".btnClone").click(function (e) {
				if ($(this).attr("disabled") == "disabled") {
					e.preventDefault();
				}
			});
		});
			
    </script>
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				Pages</h3>
		</div>
		
		<asp:HiddenField ID="hdnPageId" runat="server" />
		<div class="AdminPanelContent">
			<div id="divPageList">
				<div class="page_list_table">
					<table width="100%">
						<tr>
							<td>
								<div class="PageTree" id="pageTree" style="float: left;">
								</div>
							</td>
						</tr>
					</table>
					<div>
						<br />
						<asp:Button ID="btnAddPage" runat="server" Text="Add Default Page" OnClick="btnAddPage_Click"
							Width="160px" CssClass="btn" />
						<asp:Button ID="btnAddSpecificPage" runat="server" Text="Add Site Specific Page"
							Width="160px" OnClick="btnAddSpecificPage_Click" CssClass="btn" />
						<br />
						<br />
					</div>
				</div>
				<div class="page_list_buttons_div">
					<div class="page_list_buttons">
						<br />
						<br />
						<input type="button" id="btnMoveUp" value="Up" class="btn btnMoveUp" disabled="disabled" style="width:70px"/>
						<br />
						<br />
						<input type="button" id="btnMoveDown" value="Down" class="btn btnMoveDown" disabled="disabled" style="width:70px" />
						<br />
						<br />
						<input type="button" id="btnMoveRight" value="Right" class="btn btnMoveRight" disabled="disabled" style="width:70px"/>
						<br />
						<br />
						<input type="button" id="btnMoveLeft" value="Left" class="btn btnMoveLeft" disabled="disabled" style="width:70px"/>
						<br />
						<br />
						<asp:Button ID="btnEdit" runat="server" Text="Edit" OnClick="btnEdit_Click" Width="70px"
							CssClass="btn btnEdit" />
						<br/>
						<br/>
						<asp:HyperLink ID="cloneButton" runat="server" disabled="disabled" Text="Clone" Width="40px"
							CssClass="btn btnClone" />
						<br />
						<br />
						<asp:Button ID="btnDelete" OnClientClick="return confirm('Are you sure to delete this page and sub pages and all their content?');"
							runat="server" Text="Delete" OnClick="btnDelete_Click" Width="70px" CssClass="btn btnDelete" />
						<br />
						<br />
						<div id="lblSuccessMessage" class="lblSuccessMessage" style="color:Green; display:none; margin: 0 0 2px 0;padding: 2px 2px 2px 2px; background-position: 2px 2px;border: solid 1px #BD8;">Changes saved successfully..</div>
					</div>
				</div>
				<div class="clear">
				</div>
			</div>
		</div>
	</div>
</asp:Content>
