<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PrebuiltGuidedBrowseIndexSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.PrebuiltGuidedBrowseIndexSettings" %>

<style type="text/css">
		.form-horizontal .control-group{margin-bottom:5px;}
</style>

<div class="form-horizontal">
  <div class="control-group">
    <label class="control-label">Dependent Module</label>
    <asp:DropDownList ID="pageModuleList" runat="server" Width="220px" Style="vertical-align: top;"></asp:DropDownList>
    <asp:HiddenField ID="hdnPageModuleList" runat="server" />
  </div>
  <div class="control-group">
    <label class="control-label">Dependency Type</label>
    <asp:DropDownList ID="providerConditionType" runat="server" Width="220px" Style="vertical-align: top;"></asp:DropDownList>
    <asp:HiddenField ID="hdnProviderConditionType" runat="server" />
  </div>
</div>
