<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ImageManager.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Media.ImageManager" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<link href="../../App_Themes/Default/imgareaselect-default.css" rel="stylesheet"
		type="text/css" />
	<script src="../../Js/ImageManager.js" type="text/javascript"></script>
    <script src="../../Js/jquery.carouFredSel-6.2.1.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.imgareaselect.pack.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.imageListing').carouFredSel({
                auto: false,
                circular: false,
                infinite: false,
                prev: '#prev2',
                next: '#next2',
                pagination: "#pager2",
                mousewheel: true,
                swipe: {
                    onMouse: true,
                    onTouch: true
                }
            });

            var top = $('.imageManagerButtons').offset().top - parseFloat($('.imageManagerButtons').css('margin-top').replace(/auto/, 0));
            $(window).scroll(function (event) {
                var y = $(this).scrollTop();
                if (y >= top) {
                    $('.imageManagerButtons').addClass('imageManagerButtonsFixed');
                } else {
                    $('.imageManagerButtons').removeClass('imageManagerButtonsFixed');
                }
            });
        });
    </script>

<div class="AdminPanel">
	<div class="AdminPanelHeader">
		<h3>
			<asp:Label ID="headerText" runat="server" BackColor="Transparent" Text="Content Image Manager"></asp:Label></h3>
	</div>
	<div class="imageEditor">
        <div class="imageManagerButtons">
			<div class="imageManagerButtonGroup inline-form-container">
				<asp:Button ID="cropButton" runat="server" Text="Crop" OnClick="cropButton_Click" CssClass="cropButton btn" />
				<asp:Button ID="deleteButton" runat="server" Text="Delete" OnClick="deleteButton_Click" CssClass="deleteButton btn" />
			</div>
			<div class="imageManagerButtonGroup inline-form-container">
				<asp:TextBox ID="resizeWidth"  runat="server" Width="50" placeholder="Width"></asp:TextBox>
                <label>x</label>
				<asp:TextBox ID="resizeHeight" runat="server"  Width="50" placeholder="Height"></asp:TextBox>
				<asp:Button ID="resizeButton" runat="server" Text="Resize" OnClick="resizeButton_Click" CssClass="btn"/>
			</div>
			<div class="imageManagerButtonGroup inline-form-container last" >
				<asp:TextBox ID="fileName" runat="server" class="fileName" Width="200" placeholder="Image Name"></asp:TextBox>
				<asp:Button ID="saveButton" runat="server" Text="Save" onclick="saveButton_Click" CssClass="btn" />
				<asp:HyperLink ID="backButton" runat="server" Text="Back" CssClass="btn"></asp:HyperLink>
			</div>
		</div>
		<div class="editArea clearfix" id="scrollbar-area">
            <div class="editCanvasOuter">
			    <div class="editCanvas">
	                
			    </div>
            </div>
            <div class="editedCanvasOuter">
			    <div class="editedCanvas">
				    <img ID="editedImage" alt="Edited Image" src="" runat="server" class="editedImage"/>
		        </div>
            </div>
        </div>
        <div class="imageListingOuter">
		    <div class="imageListing clearfix" id="imageList" runat="server">

		    </div>
             <div class="clearfix"></div>
			<a id="prev2" class="prev" href="#"></a>
			<a id="next2" class="next" href="#"></a>
        </div>
		<asp:HiddenField ID="cropX" runat="server" />
		<asp:HiddenField ID="cropY" runat="server" />
		<asp:HiddenField ID="cropWidth" runat="server" />
		<asp:HiddenField ID="cropHeight" runat="server" />
		<asp:HiddenField ID="editingImgUrl" runat="server" />
		<asp:HiddenField ID="originalImageWidth" runat="server"/>
		<asp:HiddenField ID="originalImageHeight" runat="server" />
	</div>
</div>
</asp:Content>
