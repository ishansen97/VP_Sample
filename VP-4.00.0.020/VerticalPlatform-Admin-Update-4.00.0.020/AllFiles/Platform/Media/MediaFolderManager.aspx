<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="MediaFolderManager.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Media.MediaFolderManager" %>

<%@ Register Src="../../ModuleAdmin/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="cntAppThemeFileManager" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery.MultiFile.js" type="text/javascript"></script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Media Folder</asp:Label>
			</h3>
		</div>
		<table class="FileManagerTable" width="100%">
			<tr class="FileManagerHeader">
				<td width="20%">
					Folders
				</td>
				<td width="80%">
					Upload Multiple Files
				</td>
			</tr>
			<tr>
				<td class="FileManagerPane1" width="25%" valign="top">
                    <div class="inline-form-container">
					    <asp:TextBox ID="txtNewFolder" runat="server" Width="94px"></asp:TextBox>
					    <asp:Button ID="btnNewFolder" runat="server" Text="Create" OnClick="btnNewFolder_Click"
						    Width="90px" CssClass="btn" ValidationGroup="createFolderGroup" />
                        <asp:RequiredFieldValidator ID="rfvNewFolder" runat="server" ErrorMessage="Please enter folder name."
						    ValidationGroup="createFolderGroup" ControlToValidate="txtNewFolder">*</asp:RequiredFieldValidator>
                    </div>
				</td>
				<td class="FileManagerPane1">
					<div class="fileManagerPanelDiv">
						<asp:FileUpload ID="FileUploadMulti" runat="server" class="multi" />
						<asp:Button ID="btnUpload" runat="server" OnClick="btnUpload_Click" Text="Upload"
							Width="90px" CssClass="btn upload_button" ValidationGroup="fileUploadGroup" />
						<asp:Label ID="lblMaxSize" runat="server" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="FileManagerPane" valign="top">
					<asp:TreeView CssClass="treeview_main" ID="tvMediaFolder" runat="server" OnSelectedNodeChanged="tvMediaFolder_SelectedNodeChanged"
						ExpandImageUrl="~/App_Themes/Default/Images/treeview-plus.png" CollapseImageUrl="~/App_Themes/Default/Images/treeview-minus.png"
						NodeStyle-ImageUrl="~/App_Themes/Default/Images/treeview-closed.png" ShowLines="true" OnTreeNodePopulate="tvMediaFolder_TreeNodePopulate">
						<ParentNodeStyle Font-Bold="False" />
						<HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
						<SelectedNodeStyle Font-Underline="False" HorizontalPadding="0px" VerticalPadding="0px"
							CssClass="treeView_selected" />
						<Nodes>
							<asp:TreeNode Text="Media" SelectAction="None" PopulateOnDemand="true" ImageUrl="~/Images/FileManager/ExplorerFolder.gif">
							</asp:TreeNode>
						</Nodes>
						<NodeStyle Font-Names="Tahoma" HorizontalPadding="2px" NodeSpacing="0px" VerticalPadding="2px" />
					</asp:TreeView>
					<br />
					<asp:Button ID="btnDeleteFolder" runat="server" Text="Delete" OnClick="btnDeleteFolder_Click"
						OnClientClick="return confirm(&quot;Are you sure that you want to delete this folder and content of it&quot;);"
						Width="90px" CssClass="btn" />
					<br />
				</td>
				<td class="FileManagerPane" valign="top">
					<table width="100%">
						<tr>
							<td style="height: 40px;" height="40">
                                <div class="inline-form-container">
								<asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
								<asp:RequiredFieldValidator ID="rfvFileSearch" runat="server" ErrorMessage="Please enter a search text."
									ValidationGroup="fileSearchGroup" ControlToValidate="txtSearch">*</asp:RequiredFieldValidator>
								<asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn"
									ValidationGroup="fileSearchGroup" OnClick="btnSearch_Click" />
								<asp:Button ID="btnViewAll" runat="server" Text="All" Width="66px" CssClass="btn"
									OnClick="btnViewAll_Click" />
                                </div>
							</td>
						</tr>
						<tr>
							<td class="FileManagerPane" valign="top">
								<asp:Label ID="lblPath" runat="server"></asp:Label>
								<br />
								<br />
								<asp:GridView ID="gvFiles" runat="server" AutoGenerateColumns="False" Width="100%"
									CssClass="common_data_grid" onrowdatabound="gvFiles_RowDataBound">
									<Columns>
										<asp:TemplateField HeaderText="File Name">
											<ItemTemplate>
												<%#Eval("Name") %>
											</ItemTemplate>
											<EditItemTemplate>
												<asp:TextBox ID="txtFileName" runat="server" Text='<%# Eval("Name") %>' />
											</EditItemTemplate>
										</asp:TemplateField>
										<asp:TemplateField>
											<ItemTemplate>
												<asp:ImageButton ID="ibtnRename" runat="server" CommandArgument='<%#Container.DisplayIndex%>'
													ImageUrl="~/Images/FileManager/edit_content.png" OnCommand="ibtnRename_Command" ToolTip="Rename File" />
											</ItemTemplate>
											<EditItemTemplate>
												<asp:ImageButton ID="ibtnRenameOk" runat="server" CommandName='<%#Eval("Name")%>'
													CommandArgument='<%#Container.DisplayIndex%>' ImageUrl="~/Images/FileManager/notify_ok.png"
													OnCommand="ibtnRenameOk_Command" ToolTip="Ok Rename" />
											</EditItemTemplate>
										</asp:TemplateField>
										<asp:TemplateField>
											<EditItemTemplate>
												<asp:ImageButton ID="ibtnRenameCancel" runat="server" ImageUrl="~/Images/FileManager/cancel.png"
													OnCommand="ibtnRenameCancel_Command" ToolTip="Cancel Rename" />
											</EditItemTemplate>
											<ItemTemplate>
												<asp:ImageButton ID="ibtnDelete" runat="server" CommandName='<%#Eval("Name")%>' ImageUrl="~/Images/FileManager/delete_row.png"
													OnClientClick="return confirm(&quot;Are you sure that you want to delete this file&quot;);"
													OnCommand="ibtnDelete_Command" ToolTip="Delete File" />
											</ItemTemplate>
										</asp:TemplateField>
										<asp:TemplateField>
											<ItemTemplate>
												<asp:LinkButton ID="lbtnDownload" runat="server" CommandName='<%#Eval("Name")%>'
													CommandArgument='<%#Container.DisplayIndex%>' OnCommand="lbtnDownload_Command" CssClass="grid_icon_link download" ToolTip="Download">Download</asp:LinkButton>
											</ItemTemplate>
										</asp:TemplateField>
									</Columns>
									<EmptyDataTemplate>
										No files found.
									</EmptyDataTemplate>
								</asp:GridView>
								<uc1:Pager ID="mediaPager" runat="server" />
								&nbsp;
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</asp:Content>
