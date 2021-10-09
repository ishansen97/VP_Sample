<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VideoPlaylistSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.VideoPlaylistSettings" %>

<style type="text/css">
    .video-popup {
        position: absolute;
        background: white;
        display: none;
        top: 20%;
    }

    .video-popup-body {
        margin-top: 20px;
        padding: 5px;
    }

    .span-validation-msg {
        color: red;
        visibility: visible;
    }

    .video-popup-lable {
        width: 120px;
    }

    .video-popup-body .controls input {
        float: left;
    }

    .video-popup-overlay {
        display: block;
        position: absolute;
        left: 0;
        top: 0;
        height: 100%;
        width: 100%;
        z-index: 99;
        background: rgba(75,79,79,0.68);
        overflow-x: hidden;
    }

</style>

<script type="text/javascript">
    $(document).ready(function () {
        let videoPopup = new VideoPopup();
        $("#btnAddNewVideo").click(videoPopup.loadPopup);
        enableAutoPlayback();
        $("[id*=EnableAutoPlayChkBox]").change(enableAutoPlayback);
    });

    var VideoPopup = function () {
        let popup = $("#divVideoAddPopup");
        let closeBtn = popup.find(".close-popup");
        closeBtn.click(function() {
            popup.hide();
            loadPopupOverlay(popup,false);
            resetValidations();
        });

        let loadPopup = function () {
            popup.show();
            loadPopupOverlay(popup,true);
        }

        return {
            loadPopup: loadPopup
        };
    }

    function loadPopupOverlay(popup, show) {
        let parenDiv = popup.parents(".dialog_content_outer");
        let videoOverlay = $("#videoOverlay");

        if (videoOverlay.length > 0) {
            videoOverlay.remove();
        }

        let overlay = "<div id='videoOverlay' class='video-popup-overlay'>'" +
            "</div>";

        videoOverlay = $(overlay);
        parenDiv.append(videoOverlay);

        if (show) {
            parenDiv.css("position","relative");
            videoOverlay.show();
        }
        else {
            parenDiv.css("position", "unset");
            videoOverlay.hide();
        }
           
    }

    function validateVideoAddBtn() {
        resetValidations();
        let txtVideoName = $("input[type=text][id*=VideoNameTxtBox]");
        let txtVideoId = $("input[type=text][id*=VideoIdTxtBox]");
        let txtVideoThumbnailLink = $("input[type=text][id*=VideoThumbnailLinkTxtBox]");

        let validated = true;

        if (!txtVideoName.val()) {
            showError(txtVideoName,"Enter Video Name");
            validated = false;
        }

        if (!txtVideoId.val()) {
            showError(txtVideoId, "Enter Video Id");
            validated = false;
        }

        if (!txtVideoThumbnailLink.val()) {
            showError(txtVideoThumbnailLink, "Enter Video Thumbnail link");
            validated = false;
        }

        if (!validated)
            event.stopPropagation();

        return validated;
    }

    function showError(el,message) {
        el.siblings(".span-validation-msg").html(message);
    }

    function resetValidations() {
        $(".span-validation-msg").html("");
    }

    function enableAutoPlayback() {
        let isEnabled = $("[id*=EnableAutoPlayChkBox]").is(":checked");

        $("input[type=text][id*=AutoPlayTimeoutTxtBox]").attr("disabled", !isEnabled);
        $("input[type=text][id*=AutoPlayTextTxtBox]").attr("disabled", !isEnabled);
    }

</script>


<div class="form-horizontal">
    <div class="control-group">
        <label class="control-label">Autoplay Next Video</label>
        <div class="controls">
            <asp:CheckBox ID="EnableAutoPlayChkBox" runat="server"/>
            <asp:HiddenField ID="EnableAutoPlayHdn" runat="server" />
        </div>
        <label class="control-label"></label>
        <label class="control-label">Next Video Timeout</label>
        <div class="controls">
            <asp:TextBox ID="AutoPlayTimeoutTxtBox" runat="server"  Width="220px" Text="10">
            </asp:TextBox>
            <asp:HiddenField ID="AutoPlayTimeoutHdn" runat="server" />
        </div>
        <label class="control-label">Next Video Text Message</label>
        <div class="controls">
            <asp:TextBox ID="AutoPlayTextTxtBox" runat="server" Width="220px" Text="Next video will play in 10 seconds">
            </asp:TextBox>
            <asp:HiddenField ID="AutoPlayTextHdn" runat="server" />
        </div>
        <label class="control-label">Player Id</label>
        <div class="controls">
            <asp:TextBox ID="PlayerIdTxtBox" runat="server" Width="220px" Text="rJdqBIjfl">
            </asp:TextBox>
            <asp:HiddenField ID="PlayerIdHdn" runat="server" />
        </div>
        
        <div class="common_form_row clearfix group_row">
            <div class="control-label">
                Video Play List
            </div>
            <div class="controls">
                <input type="button" id="btnAddNewVideo" class="common_text_button" value="Add Video"/>
                <asp:HiddenField ID="VideoPlayListVideoListHdn" runat="server" />
                <div class="common_form_row_div clearfix" style="clear:both">
                    <asp:ListBox ID="VideoListListBox" runat="server" Height="70px" Width="220px" AppendDataBoundItems="true"></asp:ListBox>
                </div>
                <div class="common_form_row_div clearfix">
                    <asp:Button ID="RemoveVideoBtn" runat="server"
                                Text="Remove" CssClass="common_text_button" OnClick="RemoveVideoBtn_Click" />
                    <asp:Button ID="UpVideoBtn" runat="server" Text="Move Up" CssClass="common_text_button" OnClick="UpVideoBtn_Click" />
                    <asp:Button ID="DownVideoBtn" runat="server" Text="Move Down"
                                CssClass="common_text_button" OnClick="DownVideoBtn_Click" />
                    <asp:HiddenField ID="VideoListHdn" runat="server" />
                </div>
            </div>
        </div>
    </div>
</div>


<div id="divVideoAddPopup" class="contentPickerPopUp video-popup">
    <div class="contentPickerSite clearfix">
        <h3 style=" width: 100%;">Add New Video</h3>
    </div>
    <div class="video-popup-body">
        <div class="form-horizontal">
            <div class="control-group" style="margin-bottom: 0;">
                <label class="control-label video-popup-lable">Video Name</label>
                <div class="controls">
                    <asp:TextBox ID="VideoNameTxtBox" runat="server"  Width="200px">
                    </asp:TextBox>
                    <span class="span-validation-msg"></span>
                </div>
                <label class="control-label video-popup-lable">Video Id</label>
                <div class="controls">
                    <asp:TextBox ID="VideoIdTxtBox" runat="server" Width="200px">
                    </asp:TextBox>
                    <span class="span-validation-msg"></span>
                </div>
                <label class="control-label video-popup-lable">Video Thumbnail Link</label>
                <div class="controls">
                    <asp:TextBox ID="VideoThumbnailLinkTxtBox" runat="server"  Width="200px">
                    </asp:TextBox>
                    <span class="span-validation-msg"></span>
                </div>
            </div>
        </div>
    </div>
    <div style="padding: 5px;border-top: solid 1px #dddddd;background: #f3f3f3;">
        <div class="dialog_buttons_inner">
            <asp:Button ID="VideoAddBtn" runat="server" Text="Add Video"
                        CssClass="btn" OnClick="VideoAddBtn_Click" OnClientClick="return  validateVideoAddBtn();"/>
            <input type="button" class="btn close-popup" value="Cancel"/>
        </div>
    </div>
</div>




