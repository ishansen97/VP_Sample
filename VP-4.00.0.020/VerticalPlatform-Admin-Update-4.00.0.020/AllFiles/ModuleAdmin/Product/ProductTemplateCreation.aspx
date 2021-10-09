<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ProductTemplateCreation.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ProductTemplateCreation"
	EnableEventValidation="false" Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script src="../../Js/Knockout/knockout-2.2.0.js" type="text/javascript"></script>
	<script src="../../Js/ProductTemplateCreation.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $('.help-tooltip').hover(function () {
                $('#tooltip-container').toggle();
            });
        });
    </script>
    <style type="text/css">
        .main-container .main-content .inner-content{position:relative;}
    </style>
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">
					Product Template Creation
				</asp:Label>
                <a href="javascript:;" class="help-tooltip"><img src="../../App_Themes/Default/Images/Help-browser-small.png" alt="help" width="22" height="22" border="0" /></a>
			</h3>
		</div>
		<div class="product-top-container">
			<div class="inline-form-container">
				<asp:FileUpload ID="fuLoadPreExcel" runat="server" />
				<asp:Button ID="btnUploadFile" runat="server" OnClick="btnUploadFile_Click" Text="Submit"
					CssClass="btn" />
				<asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn" OnClick="btnReset_Click" />
			</div>
			<div>

				<asp:Label Text="text" runat="server" class="displayMsg" ID="lblmandatoryFields" runat="server"></asp:Label>.
			</div>
		</div>
		<div class="AdminPanelContent page-content-area productTemplate clearfix">
			<div class="inner clearfix">
				<div class="product-top">
					<div class="tabs-container ">
						<div>
							<div class="menuHorizontal">
								<ul class="menu">
									<li class="first"><a id="lbtnCategories" href="#">Categories</a> </li>
									<li><a id="lbtnProductSpecifications" href="#">Product Specifications</a> </li>
									<li><a id="lbtnSearchGroups" href="#">Search Groups</a> </li>
									<li><a id="lbtnActions" href="#">Actions</a></li>
									<li><a id="lbtnCurrency" href="#">Currency</a></li>
								</ul>
							</div>
							<div class="menu_tab_contents">
								<div id="vwCategory" class="tabDiv lbtnCategories">
									<div class="form-horizontal">
										<div class="control-group">
											<label class="control-label">
												<asp:Literal ID="ltlCategory" runat="server" Text="Category"></asp:Literal></label>
											<div class="controls">
												<asp:TextBox ID="txtCategoryId" runat="server" Width="192px"></asp:TextBox></div>
										</div>
										<div class="control-group">
											<div class="controls">
												<ul class="prefixes" data-bind="{foreach : vm.prefixes}">
													<li>
														<input type="checkbox" data-bind="{checked: $data.checked, attr:{ value: $data.id} }" />
														<label data-bind="text: $data.name">
														</label>
													</li>
												</ul>
											</div>
										</div>
										<div class="form-actions">
											<input type="button" id="btnAddCategory" value="Select Category Columns" class="btn" />
										</div>
									</div>
								</div>
								<div id="vwSpecifications" class="tabDiv lbtnProductSpecifications" data-prefix="Spec">
									<div class="form-horizontal">
										<div class="control-group">
											<span class="control-label">
												<asp:Literal ID="ltlSpecificationName" runat="server" Text="Product Specification"></asp:Literal>
											</span>
											<div class="controls">
												<asp:TextBox ID="txtSpecificationType" runat="server" MaxLength="255" Width="150px"></asp:TextBox>
											</div>
										</div>
										<div class="form-actions">
											<input type="button" id="btnAddSpecificationType" value="Add Specification" class="btn" />
										</div>
									</div>
								</div>
								<div id="vwSearchGroups" class="tabDiv lbtnSearchGroups clearfix" data-prefix="SG"
									data-bind="foreach: vm.searchGroups">
									<div class="chkContainer">
										<input type="checkbox" data-bind="{checked: $data.checked, attr:{ value: $data.id ,disabled:$data.isDisabled} }" />
										<label data-bind="text: $data.name">
										</label>
									</div>
								</div>
								<div id="vwActions" class="tabDiv lbtnActions clearfix" data-prefix="Action" data-bind="foreach: vm.actions">
									<div class="chkContainer">
										<input type="checkbox" data-bind="{checked: $data.checked, attr:{ value: $data.id ,disabled:$data.isDisabled} }" />
										<label data-bind="text: $data.name">
										</label>
									</div>
								</div>
								<div id="vwCurrency" class="tabDiv lbtnCurrency clearfix" data-prefix="Price" data-bind="foreach: currency">
									<div class="chkContainer">
										<input type="checkbox" data-bind="{checked: $data.checked, attr:{ value: $data.id ,disabled:$data.isDisabled} }" />
										<label data-bind="text: $data.name">
										</label>
									</div>
								</div>
								<asp:HiddenField ID="hdfSearchGroups" runat="server" />
								<asp:HiddenField ID="hdfActions" runat="server" />
								<asp:HiddenField ID="hdfCurrency" runat="server" />
								<asp:HiddenField ID="hdfSpecifications" runat="server" />
							</div>
						</div>
					</div>
				</div>
				<div class="product-bottom">
                    <div class="inner clearfix">
					    <div class="inline-form-container">
					        <div class="header clearfix">
					        <h3>Specifications</h3>
					        <input type="checkbox" id="btnSelectSpecifications" data-list="lstSpecifications" value="Specifications"
							         />
							        <label>Select All</label>
					        </div>
						
						    <select id="lstSpecifications" multiple="true" runat="server" data-bind="foreach: vm.checkedSpecifications"
							    size="5">
							    <option data-bind="attr:{disabled:isDisabled} ,text:columnName, value:id "></option>
						    </select>
					    </div>

					    <div class="inline-form-container">
						    <div class="header clearfix">
							    <h3>
								    Search Groups</h3>
							    <input type="checkbox" id="btnSelectSearchGroups" data-list="lstSearchGroups" value="Search Groups" />
							    <label>
								    Select All</label>
						    </div>
						
						    <select id="lstSearchGroups" multiple="true" runat="server" data-bind="foreach: vm.checkedSearchGroups"
							    size="5">
							    <option data-bind="attr:{disabled:isDisabled} ,text:columnName, value:id "></option>
						    </select>
					    </div>
					    <div class="inline-form-container">
						    <div class="header clearfix">
							    <h3>Actions</h3>

							    <input type="checkbox" id="btnSelectActions" data-list="lstActions" value="Actions" />
							    <label>Select All</label>
						    </div>						
						    <select id="lstActions" multiple="true" runat="server" data-bind="foreach: vm.checkedActions"
							    size="5">
							    <option data-bind="attr:{disabled:isDisabled} ,text:columnName, value:id "></option>
						    </select>
					    </div>
					    <div class="inline-form-container">
						    <div class="header clearfix">
						    <h3>Currency</h3>
							    <input type="checkbox" id="btnSelectCurrency" data-list="lstCurrency" value="Currency"/>
							    <label>
								    Select All</label>
						    </div>
						    <select id="lstCurrency" multiple="true" runat="server" data-bind="foreach: vm.checkedCurrency"
							    size="5">
							    <option data-bind="attr:{disabled:isDisabled} ,text:columnName, value:id "></option>
						    </select>
					    </div>
                    </div>
					<div class="form-actions  inline-form-container">
						<input type="button" name="btnRemoveItem" id="btnRemoveItem" class="btn" value="Remove Items" />
						<input type="button" name="btnClear" id="btnClear" class="btn" value="Clear" />
					</div>
					<div class="inline-form-container" style="margin-top: 5px;">
						<asp:Button ID="btnDownloadFile" runat="server" Text="Download Template " class="btn btn-download"
							OnClick="btnDownloadFile_Click" />
					</div>
				</div>
			</div>

            

		</div>
	</div>
    
    <div id="tooltip-container">
        <img src="../../App_Themes/Default/Images/tooltip-tip-grey.png" width="16" height="16" class="tip" />
        <div class="helpText">
		    <p>
			    Please browse and select an existing template and you could customize required columns
			    and download the new template created.</p>
		    <p>
			    You can build a new template from scratch by selecting categories and customizing
			    required columns directly as well.</p>
		    <p>
			    To download a template with mandatory fields only, please click Download Template.</p>
	    </div>
    </div>
</asp:Content>
