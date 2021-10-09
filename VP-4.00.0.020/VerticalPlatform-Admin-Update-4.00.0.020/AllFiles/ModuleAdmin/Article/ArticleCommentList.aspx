<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ArticleCommentList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ArticleCommentList"
	Title="Untitled Page" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/ArticleCommentList.js" type="text/javascript"></script>
	
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				Article Comments</h3>
		</div>
		<div class="AdminPanelContent">
				<Triggers>
					<asp:AsyncPostBackTrigger ControlID="btnRetrieveComments" />
				</Triggers>
				<ContentTemplate>
					<table>
						<tr>
							<td style="width: 200px">
								<asp:Label ID="lbArticleType" runat="server" Text="Article Type"></asp:Label>
							</td>
							<td style="width: 214px">
								<asp:DropDownList ID="ddlArticleType" runat="server" AutoPostBack="true" AppendDataBoundItems="true"
									OnSelectedIndexChanged="ddlArticleType_SelectedIndexChanged" Width="250px" CssClass="ddlArticleType">
									<asp:ListItem Text="--Select Article Type--" Value=""></asp:ListItem>
								</asp:DropDownList>
							</td>
							<td style="width: 200px">
							</td>
						</tr>
						<tr>
							<td style="width: 200px">
								<asp:Label ID="lbArticleList" runat="server" Text="Article"></asp:Label>
							</td>
							<td style="width: 214px">
								<asp:DropDownList ID="ddlArticleList" runat="server" AutoPostBack="true" AppendDataBoundItems="true"
									Width="250px" CssClass="ddlArticleList">
									<asp:ListItem Text="--Select Article--" Value=""></asp:ListItem>
								</asp:DropDownList>
							</td>
						</tr>
						<tr>
							<td style="width: 200px">
								&nbsp;
							</td>
							<td style="width: 214px">
								&nbsp;
							</td>
						</tr>
					</table>
					<table>
						<tr>
							<td style="width: 200px">
								<asp:CheckBox ID="chkCommentById" runat="server" Text="  Select by ID" Width="150px"
									TextAlign="right"></asp:CheckBox>
							</td>
							<td style="width: 260px">
								<table>
									<tr>
										<td style="width: 150px">
											<asp:Label ID="lblCommentById" runat="server" Text="Comment ID"></asp:Label>
										</td>
										<td style="width: 150px">
											<asp:TextBox ID="txtCommentId" runat="server"></asp:TextBox>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td style="width: 200px">
								<asp:CheckBox ID="chkTimeDuration" runat="server" Text="  Select Time Period" Width="150px"
									TextAlign="right" CssClass="chkTimeDuration"></asp:CheckBox>
							</td>
							<td style="width: 260px">
								<table>
									<tr>
										<td style="width: 150px">
											<asp:Label ID="lblStartDate" runat="server" Text="Start Date"></asp:Label>
										</td>
										<td style="width: 150px">
											<asp:TextBox ID="txtStartDate" runat="server"></asp:TextBox>
										</td>
									</tr>
								</table>
							</td>
							<td style="width: 250px">
								<table>
									<tr>
										<td style="width: 100px">
											<asp:Label ID="lblEndDate" runat="server" Text="End Date"></asp:Label>
										</td>
										<td>
											<asp:TextBox ID="txtEndDate" runat="server"></asp:TextBox>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td style="width: 200px">
								<asp:Button ID="btnRetrieveComments" runat="server" Text="Retrieve Comments" OnClick="btnRetrieveComments_Click"
									OnClientClick="return ValideteCommentList();" CssClass="common_text_button" />
							</td>
						</tr>
					</table>
					<table>
						<tr>
							<td style="width: 714px">
								<div id="divCommentGrid">
								<asp:GridView ID="gvArticleComment" runat="server" AutoGenerateColumns="False" OnRowCommand="gvArticleComment_RowCommand"
									OnRowDataBound="gvArticleComment_RowDataBound">
									<Columns>
										<asp:TemplateField HeaderText="ID" ItemStyle-Width="75px">
											<ItemTemplate>
												<asp:Literal ID="ltrlId" runat="server"></asp:Literal>
											</ItemTemplate>
											<ItemStyle Width="75px" />
										</asp:TemplateField>
										<asp:TemplateField HeaderText="Comment" ItemStyle-Width="500px">
											<ItemTemplate>
												<asp:Literal ID="ltrlComment" runat="server"></asp:Literal>
											</ItemTemplate>
											<ItemStyle Width="500px" />
										</asp:TemplateField>
										<asp:TemplateField HeaderText="Article ID" ItemStyle-Width="75px">
											<ItemTemplate>
												<asp:Literal ID="ltrlArticleId" runat="server"></asp:Literal>
											</ItemTemplate>
											<ItemStyle Width="75px" />
										</asp:TemplateField>
										<asp:TemplateField HeaderText="Article" ItemStyle-Width="500px">
											<ItemTemplate>
												<asp:Literal ID="ltrlArticle" runat="server"></asp:Literal>
											</ItemTemplate>
											<ItemStyle Width="500px" />
										</asp:TemplateField>
										<asp:TemplateField HeaderText="User Id" ItemStyle-Width="75px">
											<ItemTemplate>
												<asp:Literal ID="ltrlUserId" runat="server"></asp:Literal>
											</ItemTemplate>
											<ItemStyle Width="75px" />
										</asp:TemplateField>
										<asp:TemplateField HeaderText="User Email" ItemStyle-Width="500px">
											<ItemTemplate>
												<asp:Literal ID="ltrlUserEmail" runat="server"></asp:Literal>
											</ItemTemplate>
											<ItemStyle Width="500px" />
										</asp:TemplateField>
										<asp:TemplateField HeaderText="User Name" ItemStyle-Width="100px">
											<ItemTemplate>
												<asp:Literal ID="ltrlUserName" runat="server"></asp:Literal>
											</ItemTemplate>
											<ItemStyle Width="100px" />
										</asp:TemplateField>
										<asp:TemplateField HeaderText="Comment Date" ItemStyle-Width="100px">
											<ItemTemplate>
												<asp:Literal ID="ltrlDate" runat="server"></asp:Literal>
											</ItemTemplate>
											<ItemStyle Width="100px" />
										</asp:TemplateField>
										<asp:TemplateField HeaderText="Edit" ItemStyle-Width="75px">
											<ItemTemplate>
												<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog">Edit</asp:HyperLink>
											</ItemTemplate>
										</asp:TemplateField>
										<asp:TemplateField HeaderText="Delete" ItemStyle-Width="75px">
											<ItemTemplate>
												<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteComment" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "Comment.Id") %>'
												OnClientClick="return confirm('Are you sure to delete the article comment?');">
												Delete</asp:LinkButton>
											</ItemTemplate>
											<ItemStyle Width="75px" />
										</asp:TemplateField>
									</Columns>
								</asp:GridView>
								</div>
								<asp:Panel ID="pnlPaging" runat="server">
									<asp:LinkButton ID="lbtnStart" runat="server" OnClick="lbtnStart_Click" CausesValidation="false"><<</asp:LinkButton>
									<asp:LinkButton ID="lbtnPrev" runat="server" OnClick="lbtnPrev_Click" CausesValidation="false"><</asp:LinkButton>
									<asp:Label ID="lblCurrent" runat="server"></asp:Label>
									<asp:LinkButton ID="lbtnNext" runat="server" OnClick="lbtnNext_Click" CausesValidation="false">></asp:LinkButton>
									<asp:LinkButton ID="lbtnEnd" runat="server" OnClick="lbtnEnd_Click" CausesValidation="false">>></asp:LinkButton>
								</asp:Panel>
								<asp:HiddenField ID="hdnCommentId" runat="server" />
								<asp:LinkButton ID="lbtnAddComment" runat="server" Style="display: none">
								Add Comment</asp:LinkButton>
							</td>
						</tr>
					</table>
				</ContentTemplate>
		</div>
	</div>	
</asp:Content>
