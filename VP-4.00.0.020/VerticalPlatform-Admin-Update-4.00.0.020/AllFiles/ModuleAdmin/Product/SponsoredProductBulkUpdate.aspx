<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
    CodeBehind="SponsoredProductBulkUpdate.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.SponsoredBulkUpdate" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="cntSponsoredBulkUpdate" ContentPlaceHolderID="cphContent" runat="server">
    <style type="text/css">
        .main-container .main-content .radio label {
            padding-left: 0px;
        }

        .table-width-auto {
            width: auto;
            min-width: 500px;
        }

        .required {
            color: red;
            font-size: 15px;
        }

        .visible {
            display: inline;
        }

        .invisible {
            display: none;
        }
    </style>
    <script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
    <script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>


    <script type="text/javascript">
        $(document).ready(function () {

            var selectedVal = $('[id*="defaultStartDate"] option:selected').attr('text');
            if (selectedVal == "Pick a Date") {
                $('[id*="otherStartDate"]').removeClass("invisible");
            } else {
                $('[id*="otherStartDate"]').addClass("invisible");
            }

            selectedVal = $('[id*="defaultEndDate"] option:selected').attr('text');
            if (selectedVal == "Pick a Date") {
                $('[id*="otherEndDate"]').removeClass("invisible");
            } else {
                $('[id*="otherEndDate"]').addClass("invisible");
            }

            $("input.date_picker").each(function () {
                $(this).datepicker('setDate', new Date());
            });

            $("input[id$='otherStartDate']").datepicker(
		        {
		            changeYear: true,
		            minDate: new Date()
		        });
            $("input[id$='otherEndDate']").datepicker(
            {
                changeYear: true,
                minDate: new Date()
            });

            $('[id*="defaultStartDate"]').change(function () {
                var selectedVal = $('[id*="defaultStartDate"] option:selected').attr('text');
                if (selectedVal == "Pick a Date") {
                    $('[id*="otherStartDate"]').removeClass("invisible");
                } else {
                    $('[id*="otherStartDate"]').addClass("invisible");
                }
            });

            $('[id*="defaultEndDate"]').change(function () {
                var selectedVal = $('[id*="defaultEndDate"] option:selected').attr('text');
                if (selectedVal == "Pick a Date") {
                    $('[id*="otherEndDate"]').removeClass("invisible");
                } else {
                    $('[id*="otherEndDate"]').addClass("invisible");
                }
            });
        });


    </script>

    <div class="AdminPanel">
        <div class="AdminPanelHeader">
            <h3>Sponsored Product Bulk Update</h3>
        </div>
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label">Default Start Date </label>
                <div class="controls">
                    <asp:DropDownList ID="defaultStartDate" runat="server" AppendDataBoundItems="true">
                        <asp:ListItem Text="--Select--" Value="-1" Selected="True"></asp:ListItem>
                    </asp:DropDownList>
                    &nbsp;<span class="required invisible">*</span>
                    &nbsp; &nbsp;
                            <asp:TextBox runat="server" ID="otherStartDate" CssClass="date_picker invisible"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="reqStartDate" runat="server" ValidationGroup="productBulkGroup" ControlToValidate="defaultStartDate"
                        ErrorMessage="Invalid start date.<br/>" InitialValue="-1" Display="None"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Default End Date</label>
                <div class="controls">
                    <asp:DropDownList ID="defaultEndDate" runat="server" AppendDataBoundItems="true">
                        <asp:ListItem Text="--Select--" Value="-1" Selected="True"></asp:ListItem>
                    </asp:DropDownList>
                    &nbsp;<span class="required  invisible">*</span>
                    &nbsp; &nbsp;
                            <asp:TextBox runat="server" ID="otherEndDate" CssClass="date_picker invisible"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="reqDefaultEndDate" runat="server" ValidationGroup="productBulkGroup" ControlToValidate="defaultEndDate"
                        ErrorMessage="Invalid end date.<br/>" InitialValue="-1" Display="None"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Default Featured Status</label>
                <div class="controls">
                    <asp:DropDownList ID="defaultFeaturedStatus" runat="server" AppendDataBoundItems="true">
                        <asp:ListItem Text="--Select--" Value="-1"></asp:ListItem>
                    </asp:DropDownList>
                    &nbsp;<span class="required  invisible">*</span>
                    <asp:RequiredFieldValidator ID="reqDefaultFeaturedStatus" runat="server" ValidationGroup="productBulkGroup" ControlToValidate="defaultFeaturedStatus"
                        ErrorMessage="Please select the featured status.<br/>" InitialValue="-1" Display="None"></asp:RequiredFieldValidator>

                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Default Search Rank</label>
                <div class="controls">
                    <asp:TextBox runat="server" ID="defaultSearchRank"></asp:TextBox>
                    &nbsp;<span class="required  invisible">*</span>
                    <asp:RequiredFieldValidator runat="server" ID="reqSearchRank" ValidationGroup="productBulkGroup" ControlToValidate="defaultSearchRank" ErrorMessage="Please enter the default search rank.<br/>" Display="None" />

                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Upload type</label>
                <div class="controls">
                    <asp:DropDownList ID="uploadType" runat="server" AppendDataBoundItems="true">
                        <asp:ListItem Text="--Select--" Value="-1"></asp:ListItem>
                    </asp:DropDownList>
                    &nbsp;<span class="required  invisible">*</span>
                    <asp:RequiredFieldValidator ID="reqUploadType" runat="server" ValidationGroup="productBulkGroup" ControlToValidate="uploadType"
                        ErrorMessage="Please select the upload type.<br/>" InitialValue="-1" Display="None"></asp:RequiredFieldValidator>

                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <asp:FileUpload ID="productExcelUpload" runat="server" />
                    <asp:RequiredFieldValidator runat="server" Display="None" ValidationGroup="productBulkGroup" ControlToValidate="productExcelUpload"
                        ErrorMessage="Select file to process.">
                    </asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <asp:Button ID="btnProcessExcel" runat="server" Text="Process" ValidationGroup="productBulkGroup" OnClick="ProcessExcel_Click"
                        CssClass="btn" />
                    <asp:Button ID="btnCancelProduct" runat="server" OnClick="CancelProduct_Click"
                        Text="Cancel" CssClass="btn" />
                </div>
            </div>

            <asp:HiddenField ID="hdnSourceFileName" runat="server" Value="0" />
            </br>
            </br>
            <div class="control-group">
                <asp:GridView ID="summaryGrid" runat="server" CssClass="table table-bordered table-width-auto">
                </asp:GridView>
                <asp:Label runat="server" ID="confirmSaveMessage" Visible="false"><h6>Do you want to save data ?</h6></asp:Label>
                <asp:Button ID="confirmToProduction" runat="server" Text="Yes" CssClass="btn" Visible="false" OnClick="confirmToProduction_Click" />
                <asp:Button ID="rejectToProduction" runat="server" Text="No" CssClass="btn" Visible="false" OnClick="rejectToProduction_Click" />
                <div id="afterSaveControls">
                    <asp:Label runat="server" ID="saveMessage" Visible="false"><h5>Data Saved Sucessfully</h5></asp:Label>
                    <asp:Button runat="server" ID="downloadExcel" Visible="false" Text="Download Excel" CssClass="btn" OnClick="downloadExcel_Click" />
                </div>
            </div>

        </div>
    </div>
</asp:Content>
