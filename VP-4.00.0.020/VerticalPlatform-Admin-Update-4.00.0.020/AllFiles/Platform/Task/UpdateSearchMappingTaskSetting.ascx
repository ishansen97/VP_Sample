<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UpdateSearchMappingTaskSetting.ascx.cs"
  Inherits="VerticalPlatformAdminWeb.Platform.Task.UpdateSearchMappingTaskSetting" %>

<ul class="common_form_area">
  <li class="common_form_row clearfix">
    <span class="label_span" style="width: 250px;">
      <label>Terms Tokenizer</label></span>
    <span>
      <asp:DropDownList ID="tokenizers" runat="server" Style="padding: 3px;"></asp:DropDownList></span>
  </li>
  <li class="common_form_row clearfix">
    <span class="label_span" style="width: 250px;">
      <label>Enable Synonyms</label></span>
    <span>
      <asp:CheckBox ID="enableSynonyms" runat="server" Enabled="false"/></span>
  </li>
</ul>
