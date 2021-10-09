<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
    CodeBehind="ProductCompression.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ProductCompression"
    Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
    <script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
    <script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
    <script src="../../Js/ContentPicker.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var options = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "10", excludeParent: true };
            var compressionGroupIdOptions = { siteId: VP.SiteId, type: "ProductCompressionGroup", currentPage: "1", pageSize: "15" };
            var optionsChild = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "10", excludeParentChild: true };


            $("input[type=text][id*=textProductId]").contentPicker(optionsChild);

            $("input[type=text][id*=txtParentProductId]").contentPicker(options);

            $("input[type=text][id*=txtGroupId]").contentPicker(compressionGroupIdOptions);

            $(".existingProduct").hide();

            $("[id*=lnkAddExistingProduct]").click(function () {
                $(".existingProduct").show("slow");
            });

            $("[id*=lnkAddNewProduct]").click(function (e) {
                if ($("[id*=gvGroupProduct] tr").length < 1) {
                    $.notify({ message: "Add a child product" });
                    e.preventDefault();
                }
            });
        });
    </script>
    <div class="AdminPanel">
        <div class="AdminPanelHeader">
            <h3>
                <asp:Label ID="lblTitle" runat="server"></asp:Label>
            </h3>
        </div>
        <div class="AdminPanelContent">
            <h5>Select Child Product</h5>
            <div class="add-button-container">
                <div class="form-horizontal">
                    <div class="control-group">
                            <label class="control-label"><asp:Label ID="lblProductName" runat="server" Text="Product Id"></asp:Label></label>
                            <div class="controls">
                                <asp:TextBox ID="textProductId" runat="server">
                            </asp:TextBox><asp:RequiredFieldValidator ID="rfvProductId" runat="server" ErrorMessage="Add a product id."
                                ControlToValidate="textProductId" ValidationGroup="ProductId">*</asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="cvProductId" runat="server" ErrorMessage="Product id should be an integer."
                                ControlToValidate="textProductId" Operator="DataTypeCheck" Type="Integer" ValidationGroup="ProductId">*</asp:CompareValidator>
                            </div>
                    </div>
                    <div class="control-group">
                            <label class="control-label">Compression Group</label>
                            <div class="controls"><asp:TextBox ID="txtGroupId" runat="server"></asp:TextBox></div>
                    </div>
                     <div class="control-group">
                        <div class="controls">
                            <asp:Button ID="btnAddProduct" runat="server" Text="Add Product" OnClick="btnAddProduct_Click"
                                    ValidationGroup="ProductId" CssClass="btn" />
                        </div>

                     </div>
                </div>
            </div>
            <asp:GridView ID="gvGroupProduct" runat="server" AutoGenerateColumns="False" Width="100%"
                CssClass="common_data_grid table table-bordered" OnRowCommand="gvGroupProduct_RowCommand" OnRowDataBound="gvGroupProduct_RowDataBound"
                DataKeyNames="ProductId">
                <AlternatingRowStyle CssClass="DataTableRowAlternate" />
                <RowStyle CssClass="DataTableRow" />
                <Columns>
                    <asp:BoundField DataField="ProductCompressionGroupId" HeaderText="Product Compression Group Id">
                        <ItemStyle Height="20px" Width="200px"></ItemStyle>
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Product Compression Group">
                        <ItemTemplate>
                            <asp:Label ID="lblProductCompressionGroup" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Product Id" DataField="ProductId">
                        <ItemStyle Height="20px" Width="150px"></ItemStyle>
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Product">
                        <ItemTemplate>
                            <asp:Label ID="lblProduct" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton OnClientClick="return confirm('Are you sure you want to delete this product to compression group relationship?');"
                                ID="lbtnDelete" runat="server" Text="Delete" CommandName="DeleteProductCompressionGroupToProduct"
                                CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

        <h5>Add Parent Product</h5>
        <asp:Button ID="btnAddNewProduct" runat="server" CssClass="btn" 
			Text="Create New Product" onclick="btnAddNewProduct_Click"></asp:Button>
        <asp:HyperLink ID="lnkAddExistingProduct" runat="server" CssClass="btn">Select Existing Product</asp:HyperLink>
        <br />
        <br />
        <div class="existingProduct inline-form-content">
            <asp:TextBox ID="txtParentProductId" runat="server"></asp:TextBox>
            <asp:Button ID="btnSaveProduct" runat="server" Text="Add" OnClick="btnSaveProduct_Click"
                ValidationGroup="ParentProductId" CssClass="btn" />
            <asp:RequiredFieldValidator ID="rfvSaveParentProduct" runat="server" ErrorMessage="Add a parent product id."
                ControlToValidate="txtParentProductId" ValidationGroup="ParentProductId">*</asp:RequiredFieldValidator>
            <asp:CompareValidator ID="cvParentProductId" runat="server" ErrorMessage="Product id should be an integer."
                ControlToValidate="txtParentProductId" Operator="DataTypeCheck" Type="Integer"
                ValidationGroup="ParentProductId">*</asp:CompareValidator>
        </div>
    </div>
</asp:Content>
