<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.Master"
	CodeBehind="VpFileManager.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.VpFileManager" %>

<asp:Content ID="cntAppThemeFileManager" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">App Theme</asp:Label>
			</h3>
		</div>
		<table class="FileManagerTable" width="100%">
			<tr class="FileManagerHeader">
				<td width="20%">
					Folders
				</td>
				<td width="80%">
					Files
				</td>
			</tr>
			<tr>
				<td class="FileManagerPane1" width="25%">
					<asp:TextBox ID="txtNewFolder" runat="server" Width="94px"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvNewFolder" runat="server" ErrorMessage="Please enter folder name." ValidationGroup="createFolderGroup" ControlToValidate="txtNewFolder">*</asp:RequiredFieldValidator>
					<asp:Button ID="btnNewFolder" runat="server" Text="Create" OnClick="btnNewFolder_Click"
						Width="90px" CssClass="common_text_button" ValidationGroup="createFolderGroup"/>
				</td>
				<td class="FileManagerPane1">
					<asp:FileUpload ID="fuToAppData" runat="server" />
					<asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" ErrorMessage="Please select a file." ValidationGroup="fileUploadGroup" ControlToValidate="fuToAppData">*</asp:RequiredFieldValidator>
					<asp:Button ID="btnUpload" runat="server" OnClick="btnUpload_Click" Text="Upload"
						Width="90px" CssClass="common_text_button" ValidationGroup="fileUploadGroup"/>
					<input type="hidden" id="hdnIsExistFile" value="" runat="server" />
				</td>
			</tr>
			<tr>
				<td class="FileManagerPane" valign="top">
					<asp:TreeView CssClass="treeview_main" ID="tvFolders" runat="server" OnSelectedNodeChanged="tvFolders_SelectedNodeChanged"
						ExpandImageUrl="~/App_Themes/Default/Images/treeview-plus.png" CollapseImageUrl="~/App_Themes/Default/Images/treeview-minus.png"
						NodeStyle-ImageUrl="~/App_Themes/Default/Images/treeview-closed.png" ShowLines="true">
						<ParentNodeStyle Font-Bold="False" />
						<HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
						<SelectedNodeStyle Font-Underline="False" HorizontalPadding="0px" VerticalPadding="0px"
							CssClass="treeView_selected" />
						<Nodes>
						</Nodes>
						<NodeStyle Font-Names="Tahoma" HorizontalPadding="2px" NodeSpacing="0px" VerticalPadding="2px" />
					</asp:TreeView>
					<br />
					<asp:Button ID="btnDeleteFolder" runat="server" Text="Delete" OnClick="btnDeleteFolder_Click"
						OnClientClick="return confirm(&quot;Are you sure that you want to delete this folder and content of it&quot;);"
						Width="90px" CssClass="common_text_button" />
					<br />
					<asp:LinkButton ID="lbtnExpandAll" runat="server" OnClick="lbtnExpandAll_Click">Expand 
					Tree</asp:LinkButton>
					<asp:LinkButton ID="lbtnCollapseAll" runat="server" OnClick="lbtnCollapseAll_Click">Collapse Tree</asp:LinkButton>
				</td>
				<td class="FileManagerPane" valign="top">
					<asp:Label ID="lblPath" runat="server"></asp:Label>
					<br />
					<br />
					<asp:GridView ID="gvFiles" runat="server" AutoGenerateColumns="False" Width="100%"
						CssClass="common_data_grid">
						<Columns>
							<asp:TemplateField HeaderText="File Name">
								<ItemTemplate>
									<asp:Literal ID="ltlFileName" runat="server" Text='<%#Eval("Name") %>'></asp:Literal>
								</ItemTemplate>
								<EditItemTemplate>
									<asp:TextBox ID="txtFileName" runat="server" Text='<%# Eval("Name") %>' />
								</EditItemTemplate>
							</asp:TemplateField>
							<asp:TemplateField>
								<EditItemTemplate>
									<asp:ImageButton ID="ibtnRenameOk" runat="server" CommandName='<%#Eval("FullName")%>'
										CommandArgument='<%#Container.DisplayIndex%>' ImageUrl="~/Images/FileManager/ok.gif"
										OnCommand="ibtnRenameOk_Command" ToolTip="Ok Rename" />
								</EditItemTemplate>
								<ItemTemplate>
									<asp:ImageButton ID="ibtnRename" runat="server" CommandArgument='<%#Container.DisplayIndex%>'
										ImageUrl="~/Images/FileManager/rename.gif" OnCommand="ibtnRename_Command" ToolTip="Rename File" />
								</ItemTemplate>
							</asp:TemplateField>
							<asp:TemplateField>
								<EditItemTemplate>
									<asp:ImageButton ID="ibtnRenameCancel" runat="server" ImageUrl="~/Images/FileManager/cancel.gif"
										OnCommand="ibtnRenameCancel_Command" ToolTip="Cancel Rename" />
								</EditItemTemplate>
								<ItemTemplate>
									<asp:ImageButton ID="ibtnDelete" runat="server" CommandName='<%#Eval("FullName")%>'
										ImageUrl="~/Images/FileManager/delete.gif" OnClientClick="return confirm(&quot;Are you sure that you want to delete this file&quot;);"
										OnCommand="ibtnDelete_Command" ToolTip="Delete File" />
								</ItemTemplate>
							</asp:TemplateField>
							<asp:TemplateField>
								<ItemTemplate>
									<asp:LinkButton ID="lbtnDownload" runat="server" CommandName='<%#Eval("FullName")%>'
										CommandArgument='<%#Container.DisplayIndex%>' OnCommand="lbtnDownload_Command">Download</asp:LinkButton>
								</ItemTemplate>
							</asp:TemplateField>
						</Columns>
					</asp:GridView>
				</td>
			</tr>
		</table>
	</div>
</asp:Content>
