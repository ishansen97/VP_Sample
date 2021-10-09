<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserProfile.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.User.UserProfile" %>
<script type="text/javascript" src="/Media/37/Js/jquery.stateDropDown.min.js"></script>
<div class="userProfile module" id="divUserProfile" runat="server">
	<!-- Begin update to user profile -->
	<div id="nl" runat="server" visible="false">You must log in to edit profile.</div>
	<div class="formHolder module leftLabel" id="l" runat="server">
		<ul class="formList">
			<li class="sectionBreak module">
				<h3>
					Login Details</h3>
				<p>
					To change your password, please enter your e-mail address, your current password
					and your desired new password and click "Update Login Details".
				</p>
			</li>
			<li id="errLogin" class="errorMessage" style="display: none;">
				<!-- Insert Change Password Error Message Here -->
			</li>
			<li class="module">
				<label class="description">
					E-mail <strong>*</strong>
				</label>
				<div class="inputElements">
					<asp:TextBox ID="txtEmail" runat="server" CssClass="medium"></asp:TextBox>
				</div>
			</li>
			<li class="module">
				<label class="description">
					Old Password <strong>*</strong>
				</label>
				<div class="inputElements">
					<asp:TextBox ID="txtOldPassword" runat="server" CssClass="medium" TextMode="Password"></asp:TextBox>
				</div>
			</li>
			<li class="module">
				<label class="description">
					New Password <strong>*</strong>
				</label>
				<div class="inputElements">
					<asp:TextBox ID="txtNewPassword" runat="server" CssClass="medium" TextMode="Password"></asp:TextBox>
				</div>
			</li>
			<li class="module">
				<label class="description">
					Confirm Password <strong>*</strong>
				</label>
				<div class="inputElements">
					<asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="medium" TextMode="Password"></asp:TextBox>
				</div>
			</li>
			<li class="module buttons">
				<div class="inputElements">
					<asp:Button ID="btnChangeLogin" runat="server" Text="Update Login Details" OnClick="btnChangeLogin_Click"
						CssClass="button changeLoginButton" />
				</div>
			</li>
		</ul>
		<ul class="formList">
			<li class="sectionBreak module">
				<h3>
					Contact Information</h3>
				<p>
					To update any of your contact information, change the information below and click
					"Update Contact Information".
				</p>
			</li>
			<li id="errContact" class="errorMessage" style="display: none;">
				<!-- Insert Change Contact Information Message Here -->
			</li>
			<li class="module">
				<label class="description">
					Name
				</label>
				<div class="inputElements">
					<div class="twoColumn module">
						<div class="column1">
							<asp:TextBox ID="txtFirstName" runat="server" CssClass="medium"></asp:TextBox>
							<label class="description">
								First Name <strong>*</strong>
							</label>
						</div>
						<div class="column2">
							<asp:TextBox ID="txtLastName" runat="server" CssClass="medium"></asp:TextBox>
							<label class="description">
								Last Name <strong>*</strong>
							</label>
						</div>
					</div>
				</div>
				<p class="helper">
					Please enter your first and last name.
				</p>
			</li>
			<li class="module">
				<label class="description">
					Company / Institution <strong>*</strong>
				</label>
				<div class="inputElements module">
					<asp:TextBox ID="txtInstitution" runat="server" CssClass="large"></asp:TextBox>
				</div>
				<p class="helper">
					Please enter the name of the company or institution you work at.
				</p>
			</li>
			<li class="module">
				<label class="description">
					Address
				</label>
				<p class="helper">
					Please enter your address.
				</p>
				<div class="inputElements">
					<div class="oneColumn module">
						<asp:TextBox ID="txtAddressLine1" runat="server" CssClass="large"></asp:TextBox>
						<label class="description">
							Address Line 1 <strong>*</strong>
						</label>
					</div>
					<div class="oneColumn module">
						<asp:TextBox ID="txtAddressLine2" runat="server" CssClass="large"></asp:TextBox>
						<label class="description">
							Address Line 2
						</label>
					</div>
					<div class="twoColumn module">
						<div class="column1">
							<asp:TextBox ID="txtCity" runat="server" CssClass="medium"></asp:TextBox>
							<label class="description">
								City <strong>*</strong>
							</label>
						</div>
						<div class="column2">
							<asp:TextBox ID="txtState" runat="server" CssClass="textbox medium state"></asp:TextBox>
							<label class="description">
								State <strong>*</strong>
							</label>
						</div>
					</div>
					<div class="twoColumn module">
						<div class="column1">
							<asp:TextBox ID="txtPostal" runat="server" CssClass="medium"></asp:TextBox>
							<label class="description">
								Postal Code <strong>*</strong>
							</label>
						</div>
						<div class="column2">
							<asp:DropDownList ID="ddlCountry" runat="server" AppendDataBoundItems="true" CssClass="dropdownList country medium">
								<asp:ListItem Text="" Value=""></asp:ListItem>
							</asp:DropDownList>
							<label class="description">
								Country <strong>*</strong>
							</label>
						</div>
					</div>
				</div>
			</li>
            <li class="module">
				<label class="description">
					Phone Number 
				</label>
				<div class="inputElements module">
					<asp:TextBox ID="phoneNumberTextBox" runat="server" CssClass="large"></asp:TextBox>
				</div>
				<p class="helper">
					Please enter the phone number.
				</p>
			</li>
			<li class="module buttons">
				<div class="inputElements">
					<asp:Button ID="btnUpdateContactInfo" runat="server" Text="Update Contact Information" CssClass="button updateContactInfodButton"
						OnClick="btnUpdateContactInfoField_Click" />
				</div>
			</li>
		</ul>
		<ul class="formList">
			<li class="sectionBreak module">
				<h3>
					Nickname</h3>
				<p>
					Your nickname will be displayed on the site if you use the forum or post comments,
					so please don't user any private data such as an e-mail address or your full name.
					Please select a name you would like to be identified by and click "Set Nickname".
				</p>
			</li>
			<li id="errNickname" class="errorMessage" style="display: none;">
				<!-- Insert Change nickname Message Here -->
			</li>
			<li class="module">
				<label class="description">
					Nickname <strong>*</strong>
				</label>
				<div class="inputElements">
					<asp:TextBox ID="txtNickname" runat="server" CssClass="medium"></asp:TextBox>
				</div>
			</li>
			<li class="module buttons">
				<div class="inputElements">
					<asp:Button ID="btnSetNickname" runat="server" Text="Set Nickname" CssClass="button setNicknameButton"
						OnClick="btnSetNickname_Click" />
				</div>
			</li>
		</ul>
		
		<asp:PlaceHolder ID="phField" runat="server"></asp:PlaceHolder>
		
	</div>
	<div class="leadFormLinkSection">
	    <asp:HyperLink ID="lnkLeadForm" runat="server" Text="Go to lead form" CssClass="leadFormLink"></asp:HyperLink>
	</div>
</div>
<!-- End update to user profile -->
