<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="false" 
  CodeBehind="Rapid.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Rapid.Rapid" 
  Title="Rapid Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
<link rel="stylesheet" type="text/css" href="../../App_Themes/Default/jquery-ui-1.7.2.custom.css" />
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

<script src="../../Js/Vue/vue.min.js" type="text/javascript"></script>
<script src="../../Js/Vuedraggable/Sortable.min.js" type="text/javascript"></script>
<%--<script src="../../Js/Vuedraggable/vuedraggable.umd.min.js" type="text/javascript"></script>--%>
<%--<script src="../../Js/Vuedraggable/vuedraggable.common.js" type="text/javascript"></script>--%>
<script src="../../Js/Vuedraggable/helper.js" type="text/javascript"></script>
<script src="../../Js/Vuedraggable/vuedraggable.js" type="text/javascript"></script>


  	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Rapid</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<!-- Rapid Controls -->

			<div id="startup" class="container rapid-container">
        <root/>
      </div>
      
		</div>

		<link rel="stylesheet" type="text/css" href="../../Js/Rapid/Assets/Styles/ModalStyles.css?v=<%=version%>" />
		<link rel="stylesheet" type="text/css" href="../../Js/Rapid/Assets/Styles/DropDownStyles.css?v=<%=version%>" />
		<link rel="stylesheet" type="text/css" href="../../Js/Rapid/Assets/Styles/SpinnerStyles.css?v=<%=version%>" />
		<link rel="stylesheet" type="text/css" href="../../Js/Rapid/Assets/Styles/Styles.css?v=<%=version%>" />

		<script src="../../Js/Rapid/Data/Constants.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Models/Models.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Models/ModelConverter.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/API/BaseAPI.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/API/APIDataStore.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/API/Mixins/JobApiMixin.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/API/Mixins/TaskApiMixin.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Data/ComponentsDataStore.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Root.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/TabView.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Shared/DropDownList.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Shared/PageList.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Shared/SharedModalsMixin.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Shared/InformationModal.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Shared/ConfirmationModal.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/AddJobModal.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Reports/ReportsTabTile.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Reports/ReportsTab.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/ProductionPush/ProductionPushReportingData.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/ProductionPush/ProductionPushProductionData.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/ProductionPush/ProductionPushTile.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/ProductionPush/ProductionPushTab.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Completed/CompletedJobReportingData.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Completed/CompletedTaskTimeData.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/CleanUp/CleanUpTile.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/CleanUp/CleanUpTab.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Completed/CompletedJobDetailModal.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/Components/Completed/CompletedTab.js?v=<%=version%>"></script>
        <script src="../../Js/Rapid/Components/Shared/Spinner.js?v=<%=version%>"></script>
		<script src="../../Js/Rapid/App.js?v=<%=version%>"></script>
	</div>
</asp:Content>
