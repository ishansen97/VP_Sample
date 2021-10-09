<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddSite.aspx.cs" MasterPageFile="~/MasterPage.Master"
    Inherits="VerticalPlatformAdminWeb.Platform.Site.AddSite" %>

<asp:Content ID="cntProduct" ContentPlaceHolderID="cphContent" runat="server">
    <div class="AdminPanel">
        <div class="AdminPanelHeader">
            <h3>
                <asp:Label ID="lblTitle" runat="server"></asp:Label>
            </h3>
        </div>
        <div class="AdminPanelContent">
            <asp:Panel ID="pnlEditSite" runat="server" Width="100%">
                <div class="form-horizontal">
                    <div class="control-group">
                        <label class="control-label">
                            Site Template</label>
                        <div class="controls">
                            <asp:DropDownList runat="server" ID="ddlNewSiteTemplates">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">
                            Site Category</label>
                        <div class="controls">
                            <asp:DropDownList ID="ddlSiteType" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">
                            <asp:Label ID="lblSiteIdDisplay" runat="server" Text="Site Id"></asp:Label></label>
                        <div class="controls">
                            <asp:Label ID="lblSiteId" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">
                            <asp:Label ID="lblSiteName" runat="server" Text="Site Name"></asp:Label></label>
                        <div class="controls">
                            <asp:TextBox ID="txtSiteName" runat="server" Width="460px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvSiteName" runat="server" ControlToValidate="txtSiteName"
                                ErrorMessage="Please enter site name." ValidationGroup="vg1">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">
                            <asp:Label ID="lblSiteCode" runat="server" Text="Site Code"></asp:Label></label>
                        <div class="controls">
                            <asp:TextBox ID="txtCode" runat="server" Width="460px" MaxLength="10"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvCode" runat="server" ControlToValidate="txtCode"
                                ErrorMessage="Please enter site code." ValidationGroup="vg1">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">
                            <asp:Label ID="lblSiteImage" runat="server" Text="Site Image"></asp:Label></label>
                        <div class="controls">
                            <div class="vendorImg">
                                <asp:Image ID="imgSite" runat="server" Width="100px" Height="60px" />
                            </div>
                            <asp:FileUpload ID="fuSiteImage" runat="server" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">
                            <asp:Label ID="lblMediaUrl" runat="server" Text="Media Url"></asp:Label></label>
                        <div class="controls">
                            <asp:TextBox ID="txtMediaUrl" runat="server" Width="460px"></asp:TextBox>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">
                            Enabled</label>
                        <div class="controls">
                            <asp:CheckBox ID="chkEnabledSite" runat="server" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">
                            Enable Https</label>
                        <div class="controls">
                            <asp:CheckBox ID="enableHttpsCheckbox" runat="server" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">
                            Article Link Image</label>
                        <div class="controls">
                            <asp:FileUpload ID="fuArticleLinkImage" runat="server" />
                        </div>
                    </div>
                    <div class="control-group">
                        <div class="controls">
                            <asp:HyperLink ID="lnkSiteParameter" runat="server" CssClass="aDialog btn">Site Parameters</asp:HyperLink>
                            <asp:HyperLink ID="lnkActionList" runat="server" CssClass="aDialog btn" ToolTip="Set Actions at Site Level">Action List</asp:HyperLink>
                        </div>
                    </div>
                </div>
                <asp:Label ID="lblHTTPHeader" runat="server" Style="font-weight: 700" Text="HTTP Address(es)"></asp:Label>
                <br />
                <asp:GridView ID="gvHttpAliasList" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvHttpAliasList_RowDataBound"
                    OnRowCommand="gvHttpAliasList_RowCommand" CssClass="common_data_grid table table-bordered"
                    Style="width: auto">
                    <Columns>
                        <asp:BoundField HeaderText="ID" DataField="Id" ItemStyle-Width="75px" />
                        <asp:BoundField HeaderText="Http Alias" DataField="HttpAliasName" ItemStyle-Width="350px" />
                        <asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" ItemStyle-Width="75px" />
                        <asp:CheckBoxField HeaderText="Primary" DataField="IsPrimary" ItemStyle-Width="75px" />
                        <asp:TemplateField ItemStyle-Width="50px">
                            <ItemTemplate>
                                <asp:HyperLink ID="lnkEditHttpAlias" runat="server" Text="Edit" CssClass="aDialog grid_icon_link edit"
                                    ToolTip="Edit"></asp:HyperLink>
                                <asp:LinkButton ID="lbtnDeleteHttpAlias" runat="server" CausesValidation="false"
                                    CommandName="DeleteHttpAlias" Text="Delete" CssClass="grid_icon_link delete"
                                    ToolTip="Delete"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle />
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No Http Alias found.
                    </EmptyDataTemplate>
                </asp:GridView>
                <asp:HyperLink ID="lnkAddHttpAlias" runat="server" CssClass="aDialog btn">Add Http Alias</asp:HyperLink>
            </asp:Panel>
            <br />
            <asp:Button ID="btnEditSite" runat="server" OnClick="btnEditSite_Click" Text="Edit"
                CssClass="btn" />
            <asp:Button ID="btnSaveSite" runat="server" OnClick="btnSaveSite_Click" Text="Save"
                ValidationGroup="vg1" CssClass="btn" />
            <asp:Button ID="btnCancelSite" runat="server" OnClick="btnCancelSite_Click" Text="Cancel"
                CssClass="btn" />
            <asp:Label ID="lblError" runat="server"></asp:Label>
        </div>
    </div>
</asp:Content>
