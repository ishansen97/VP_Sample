<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PopupWindow.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.PopupWindow" %>
<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript">
    
    var itemSelected;
      function onAddSpec() 
      {
      }
    
    </script>
</head>
<body>
    <form id="form1" runat="server">
    
    
<div>
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
    </div>
    <div>
		<asp:LinkButton ID="lbtnpopup" runat="server" onclick="lbtnpopup_Click">Global Specs</asp:LinkButton>
		<ajaxtoolkit:modalpopupextender ID="MPE" runat="server" OnLoad = "CallpopupWindow"
    TargetControlID = "lbtnpopup"   
     PopupControlID="Panel1"
    BackgroundCssClass="modalBackground" 
    DropShadow="true" 
    
    CancelControlID="btnCancel" 
    PopupDragHandleControlID="pnlAddedSpecs"
    />
    
	<asp:Panel ID="Panel1" runat="server" CssClass ="modalPopup">
	
		<asp:GridView ID="gvListItems" runat="server" AutoGenerateColumns="False">
			<Columns>
				<asp:BoundField DataField="id" HeaderText="Category ID" />
				<asp:BoundField DataField="Name" HeaderText="Name" />
				<asp:TemplateField>
					<ItemTemplate>
						<asp:CheckBox ID="chkGetItem" runat="server" />
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
		</asp:GridView>
	
	<asp:Button ID="btnNewSpec" runat="server" Text="New Specification Type" 
		Width="158px" onclick="btnNewSpec_Click"/>
&nbsp;
	<asp:Button ID="btnCancel" runat="server" Text="Cancel" />
	</asp:Panel>
	
	<asp:Panel ID="pnlAddedSpecs" runat="server">
		<asp:GridView ID="gvNewSpecs" runat="server" AutoGenerateColumns="False">
			<Columns>
				<asp:BoundField DataField="id" HeaderText="Category ID" />
				<asp:BoundField DataField="Name" HeaderText="Name" />
			</Columns>
		</asp:GridView>
	</asp:Panel>
	
	</div>
	
	
	
	</form>
</body>
</html>
