<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
    CodeBehind="MediaSiteManager.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Media.MediaSiteManager" %>

<%@ Register Src="../../ModuleAdmin/MediaPager.ascx" TagName="MediaPager" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
    <script src="../../Js/JQuery/jquery.qtip.js" type="text/javascript"></script>
    <script src="../../Js/MediaSiteManager.js" type="text/javascript"></script>
    <script src="../../Js/JQuery/jquery.MultiFile.js" type="text/javascript"></script>
    <link href="../../App_Themes/Default/mediaSite.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        function DeleteConfirmation() {
            var treeViewData = window["<%=tvMediaSite.ClientID%>" + "_Data"];
            if (treeViewData !== undefined && treeViewData.selectedNodeID.value !== "") {
                var directoryInformation = "";
                var selectedNode = document.getElementById(treeViewData.selectedNodeID.value);
                var path = selectedNode.href.substring(selectedNode.href.lastIndexOf("\\") + 1, selectedNode.href.length - 2);
                while (path.lastIndexOf("*|*") != -1) {
                    path = path.replace("*|*", "\\\\");
                }

                $.ajax({
                    type: "POST",
                    async: false,
                    cache: false,
                    url: VP.AjaxWebServiceUrl + "/GetDirectoryInfo",
                    data: "{'path' : '" + path + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        console.log(msg.d);
                        directoryInformation = msg.d + "\n";
                    }
                });

                return confirm(directoryInformation + "Are you sure you want to delete the selected folder?");
            }

            return false;
        }
    </script>

    <div class="AdminPanel">
        <div class="AdminPanelHeader">
            <h3>
                <asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Media Site</asp:Label>
            </h3>
        </div>
        <div>
            <table class="FileManagerTable" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td class="FileManagerPane" width="20%" style="vertical-align: top;">
                        <asp:TreeView ID="tvMediaSite" runat="server" OnSelectedNodeChanged="tvMediaSite_SelectedNodeChanged"
                            ExpandImageUrl="~/App_Themes/Default/Images/treeview-plus.png" CollapseImageUrl="~/App_Themes/Default/Images/treeview-minus.png"
                            OnTreeNodePopulate="tvMediaSite_TreeNodePopulate" NodeIndent="15" ShowLines="True">
                            <HoverNodeStyle CssClass="site_file_manager_hover" />
                            <SelectedNodeStyle CssClass="site_file_manager_selected" />
                            <Nodes>
                                <asp:TreeNode Text="Media" SelectAction="None" PopulateOnDemand="true" ImageUrl="~/Images/FileManager/ExplorerFolder.gif"></asp:TreeNode>
                            </Nodes>
                        </asp:TreeView>
                    </td>
                    <td class="FileManagerPane" width="80%" style="vertical-align: top;">
                        <table width="100%" class="Breadcrumb">
                            <tr>
                                <td>
                                    <div>
                                        <span>
                                            <span class="YouAreAt" style="opacity: 0.7">Current Folder: </span>
                                            <asp:Label ID="lblFilePath" runat="server" BackColor="Transparent"><span class="YouAreAt" style="opacity:0.7"></span> Media > <span class="YouAreAt">Bio Compare (37)</span></asp:Label>
                                        </span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <div class="MediaSection">
                            <table width="100%">
                                <tr>
                                    <td>
                                        <div class="inline-form-container">
                                            <div class="SearchInfo">Note: Search is case-sensitive.</div>
                                            <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvFileSearch" runat="server" ErrorMessage="Please enter a search text."
                                                ValidationGroup="fileSearchGroup" ControlToValidate="txtSearch">*</asp:RequiredFieldValidator>
                                            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                                                CssClass="btn" ValidationGroup="fileSearchGroup" />
                                            <asp:Button ID="btnViewAll" runat="server" OnClick="btnViewAll_Click" Text="Clear"
                                                Width="66px" CssClass="btn" />
                                        </div>
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Button Text="Files" ID="TabFiles" CssClass="Initial BtnMediaTab MediaTabSelected" runat="server" OnClick="VwFiles_Click" />
                                        <asp:Button Text="Folders" ID="TabFolders" CssClass="Initial BtnMediaTab" runat="server" OnClick="VwFolder_Click" />
                                        <asp:MultiView ID="MainView" runat="server">
                                            <asp:View ID="VwFiles" runat="server">
                                                <table style="width: 100%" class="MediaTabDataTable">
                                                    <tr>
                                                        <td>
                                                            <asp:GridView ID="gvFiles" runat="server" AutoGenerateColumns="False" Width="100%"
                                                                CssClass="common_data_grid table table-bordered" OnRowDataBound="gvFiles_RowDataBound">
                                                                <RowStyle CssClass="DataTableRow ProductListRow" />
                                                                <AlternatingRowStyle CssClass="DataTableRowAlternate ProductListRow" />
                                                                <HeaderStyle CssClass="DataTableRowHeader" />
                                                                <Columns>
                                                                    <asp:TemplateField>
                                                                        <HeaderTemplate>
                                                                            <asp:Label runat="server" ID="lbtnName" Text="Name"></asp:Label>
                                                                        </HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:Label runat="server" Text='<%#Eval("Name") %>'
                                                                                CssClass="LnkFileName"></asp:Label>
                                                                            <span class="hdnPathSpan" title='<%#Eval("Path") %>'></span>
                                                                        </ItemTemplate>
                                                                        <EditItemTemplate>
                                                                            <asp:TextBox ID="txtFileName" Text='<%#Eval("Name")%>' runat="server" />
                                                                        </EditItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField>
                                                                        <HeaderTemplate>
                                                                            <asp:Label runat="server" ID="lbtnDateCreated" Text="Date Created"></asp:Label>
                                                                        </HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblDateCreated" runat="server" Text='<%#Eval("DateCreated") %>'
                                                                                CssClass="LnkDateCreated"></asp:Label>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField>
                                                                        <ItemTemplate>
                                                                            <asp:ImageButton ID="ibtnRename" ImageUrl="~/Images/FileManager/rename.gif" CommandArgument='<%#Container.DisplayIndex%>'
                                                                                OnCommand="ibtnRename_Command" runat="server" />
                                                                        </ItemTemplate>
                                                                        <EditItemTemplate>
                                                                            <asp:ImageButton ID="ibtnRenameOk" ImageUrl="~/Images/FileManager/ok.gif" CommandArgument='<%#Container.DisplayIndex%>'
                                                                                CommandName='<%#Eval("Name")%>' OnCommand="ibtnRenameOk_Command" runat="server" />
                                                                        </EditItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField>
                                                                        <ItemTemplate>
                                                                            <asp:ImageButton ID="ibtnDelete" ImageUrl="~/Images/FileManager/delete.gif" CommandName='<%#Eval("Name")%>'
                                                                                OnCommand="ibtnDelete_Command" OnClientClick='return confirm("Are you sure that you want to delete this file");'
                                                                                runat="server" />
                                                                        </ItemTemplate>
                                                                        <EditItemTemplate>
                                                                            <asp:ImageButton ID="ibtnRenameCancel" ImageUrl="~/Images/FileManager/cancel.gif"
                                                                                OnCommand="ibtnRenameCancel_Command" runat="server" />
                                                                        </EditItemTemplate>
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                            <uc1:MediaPager ID="mediaPager" runat="server" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:View>
                                            <asp:View ID="VwFolder" runat="server">
                                                <table style="width: 100%" class="MediaTabDataTable">
                                                    <tr>
                                                        <td>
                                                            <asp:GridView ID="gvFolders" runat="server" AutoGenerateColumns="False" Width="100%"
                                                                CssClass="common_data_grid table table-bordered" OnRowDataBound="gvFolders_RowDataBound">
                                                                <RowStyle CssClass="DataTableRow ProductListRow" />
                                                                <AlternatingRowStyle CssClass="DataTableRowAlternate ProductListRow" />
                                                                <HeaderStyle CssClass="DataTableRowHeader" />
                                                                <Columns>
                                                                    <asp:TemplateField>
                                                                        <HeaderTemplate>
                                                                            <asp:Label runat="server" ID="lbtnName" Text="Name"></asp:Label>
                                                                        </HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="lbtnFolderName" runat="server" Text='<%#Eval("Name") %>'
                                                                                OnClick="lbtnFolderName_Click" path='<%#Eval("Path") %>'></asp:LinkButton>
                                                                            <span class="hdnPathSpan" title='<%#Eval("Path") %>'></span>
                                                                        </ItemTemplate>
                                                                        <EditItemTemplate>
                                                                            <asp:TextBox ID="txtFileName" Text='<%#Eval("Name")%>' runat="server" />
                                                                        </EditItemTemplate>
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                            </asp:GridView>
                                                            <uc1:MediaPager ID="mediaFolderPager" runat="server" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </asp:View>
                                        </asp:MultiView>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="MediaSection">
                            <table width="100%">
                                <tr>
                                    <td>
                                        <div class="FileManagerPane">
                                            <span class="FieldLabel">Upload Multiple Files
                                            </span>
                                            <div style="margin-bottom: 5px;">
                                                <asp:FileUpload ID="FileUploadMulti" runat="server" class="multi" />
                                                <div class="image_size" style="margin-top: 15px; margin-bottom: 10px">
                                                    Create Standard Image Sizes
							                  <asp:CheckBox ID="chkResizeImage" runat="server" />
                                                </div>
                                                <asp:Button ID="btnUpload" runat="server" OnClick="btnUpload_Click" Text="Upload"
                                                    Width="90px" CssClass="btn upload_button" ValidationGroup="fileUploadGroup" />
                                                <asp:Label ID="lblMaxSize" runat="server" />
                                            </div>
                                        </div>
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="MediaSection">
                            <table width="100%">
                                <tr>
                                    <td width="50%">
                                        <div class="FileManagerPane">
                                            <span class="FieldLabel">Create Media Folders
                                            </span>
                                            <div>
                                                <div class="inline-form-container">
                                                    <asp:TextBox ID="txtFolderName" Style="text-transform: lowercase" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please enter folder name."
                                                        ControlToValidate="txtFolderName" ValidationGroup="createFolderGroup">*</asp:RequiredFieldValidator>
                                                    <asp:Button ID="btnCreateFolder" runat="server" Text="Create" OnClick="btnCreateFolder_Click"
                                                        CssClass="btn" ValidationGroup="createFolderGroup" />
                                                </div>
                                            </div>
                                        </div>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <div class="FileManagerPane FileManagerPaneDelete">
                                            Delete Current Folder
                                            &nbsp;
                                            <span>
                                                <asp:Button ID="btnDeleteFolder" runat="server" Text="Delete" OnClientClick='return DeleteConfirmation();'
                                                    OnClick="btnDeleteFolder_Click" CssClass="btn" />
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
