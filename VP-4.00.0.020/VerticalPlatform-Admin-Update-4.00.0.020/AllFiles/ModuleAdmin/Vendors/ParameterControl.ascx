<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ParameterControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.ParameterControl" %>
<style type="text/css">
    .form-horizontal .control-group .control-label{width:200px;}
    .form-horizontal .control-group .controls{margin-left:220px;}
</style>
<script type="text/javascript">
    $(document).ready(function () {

        $("[id$=enableRealTimeLead]").change(function () {
            if (this.checked) {
                enableValidators();
            } else {
                disableValidators();
            }
        });

        if ($("[id$=enableRealTimeLead]").attr("checked") == true) {
            enableValidators();
        } else {
            disableValidators();
        }
    });

    function enableValidators() {
        $(".dynamicValidateCtrls").attr("readonly", false);
        ValidatorEnable($("[id$='leadUrlRequiredValidator']")[0], true);
        ValidatorEnable($("[id$='tackingScriptRequiredValidator']")[0], true);
    }

    function disableValidators() {
        $(".dynamicValidateCtrls").attr("readonly", true);
        ValidatorEnable($("[id$='leadUrlRequiredValidator']")[0], false);
        ValidatorEnable($("[id$='tackingScriptRequiredValidator']")[0], false);
    }

</script>
<div class="form-horizontal">
    <h4>Vendor parameters</h4>
    <div class="control-group">
        <label class="control-label">Show Image in Compare Page</label>
        <div class="controls">
            <asp:RadioButtonList ID="rdblShowImage" runat="server" RepeatDirection="Horizontal">
			</asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Show Price Information</label>
        <div class="controls">
            <asp:RadioButtonList ID="rdblShowPrice" runat="server" RepeatDirection="Horizontal">
			</asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label"><asp:Literal ID="ltlShowRequestInformationLink" runat="server" Text="Show Request Information Link"></asp:Literal></label>
        <div class="controls">
            <asp:RadioButtonList ID="rbdlShowRequestInformationLink" runat="server" RepeatDirection="Horizontal">
			</asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Disable All Actions</label>
        <div class="controls">
            <asp:RadioButtonList ID="rdblDisableAllAction" runat="server" RepeatDirection="Horizontal">
			</asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Show Contact Address</label>
        <div class="controls">
            <asp:RadioButtonList ID="rdblShowAddress" runat="server" RepeatDirection="Horizontal">
			</asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Show Contact Email</label>
        <div class="controls">
            <asp:RadioButtonList ID="rdblShowEmail" runat="server" RepeatDirection="Horizontal">
			</asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Show Contact Phone Numbers</label>
        <div class="controls">
            <asp:RadioButtonList ID="rdblShowPhoneNumbers" runat="server" RepeatDirection="Horizontal">
			</asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Show Contact Website</label>
        <div class="controls">
            <asp:RadioButtonList ID="rdblShowWebsite" runat="server" RepeatDirection="Horizontal">
			</asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Disable Featured Status of Products</label>
        <div class="controls">
            <asp:RadioButtonList ID="rbdlDisableFeaturedStatus" runat="server" RepeatDirection="Horizontal">
            </asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Disable Featured Plus Status of Products</label>
        <div class="controls">
            <asp:RadioButtonList ID="rbdDisableFeaturePlusStatus" runat="server" RepeatDirection="Horizontal">
            </asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Show Ask A Question Lead Type</label>
        <div class="controls">
            <asp:RadioButtonList ID="rbnlShowAskAQuestion" runat="server" RepeatDirection="Horizontal">
            </asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Submit Leads for Individual Products
			<br />
			<em>(Affected when the category level leads are enabled)</em>
        </label>
        <div class="controls">
            <asp:CheckBox ID="chkLeadsForIndividualProducts" runat="server" />
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Display International Contact First</label>
        <div class="controls">
            <asp:CheckBox ID="chkInternationalContactFirst" runat="server" />
        </div>
    </div>
    
    <h4>Lead parameters</h4>
    <div class="control-group">
        <label class="control-label">Primary Lead Enabled</label>
        <div class="controls">
            <asp:RadioButtonList ID="rdblEnablePrimaryLead" runat="server" RepeatDirection="Horizontal">
			</asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Show Secondary Lead Button</label>
        <div class="controls">
            <asp:RadioButtonList ID="rdblSecondaryLeadButton" runat="server" RepeatDirection="Horizontal">
			</asp:RadioButtonList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Disable Lead Submission Through Other Vendor Lead Forms</label>
        <div class="controls">
            <asp:CheckBox ID="chkDisableOtherLeadFormSubmits" runat="server" />
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Enable Realtime Vendor API</label>
        <div class="controls">
            <asp:CheckBox ID="enableRealTimeVendorAPI" runat="server" RepeatDirection="Horizontal"></asp:CheckBox>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Enable Click Dimension API</label>
        <div class="controls">
            <asp:CheckBox ID="enableRealTimeLead" runat="server"/>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Vendor Lead URL
        </label>
        <div class="controls">
            <asp:TextBox ID="leadUrl" runat="server" Width="250px" CssClass="dynamicValidateCtrls"></asp:TextBox>
            <asp:RequiredFieldValidator ID="leadUrlRequiredValidator" runat="server" ErrorMessage="Lead url is required." ControlToValidate="leadUrl">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="revleadUrl" runat="server" ErrorMessage="Not a valid url."
                ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=;]*)?" ControlToValidate="leadUrl">*</asp:RegularExpressionValidator>
        </div>
    </div>
     <div class="control-group">
        <label class="control-label">Tracking Script</label>
        <div class="controls">
            <asp:TextBox TextMode="MultiLine" ID="trackScript"  Width="500px" Height="120px"  runat="server"  CssClass="dynamicValidateCtrls"/>
             <asp:RequiredFieldValidator ID="tackingScriptRequiredValidator"  runat="server" ErrorMessage="Script is required." ControlToValidate="trackScript">*</asp:RequiredFieldValidator>
        </div>
    </div>
	  <div class="control-group">
        <label class="control-label">Lead Deployment Report Password</label>
        <div class="controls">
            <asp:TextBox ID="leadReportPassword"  Width="250px"  runat="server"/>
					<asp:RegularExpressionValidator ID="revLeadReportPassword" runat="server" ControlToValidate="leadReportPassword" ErrorMessage="Lead deployment report password not valid. Insert between 6 to 15 valid characters" ValidationExpression="^.{6,15}$" />
        </div>
    </div>
   
</div>
