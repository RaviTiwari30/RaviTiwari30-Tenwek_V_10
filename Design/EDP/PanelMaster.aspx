<%@ Page Language="C#" AutoEventWireup="true" ValidateRequest="false" MasterPageFile="~/DefaultHome.master" CodeFile="PanelMaster.aspx.cs" Inherits="Design_EDP_PanelMaster" %>

<%@ Register Assembly="DropDownCheckBoxes" Namespace="Saplin.Controls" TagPrefix="asp" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script>
        var $bindBillCurrencyDetails = function () {
            var CountryID = $('#ddlPannelBillCurrency').val();

            serverCall('PanelMaster.aspx/BindCurrencyDetails', { countryID: CountryID }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);
                    $("#txtConversion").val(responseData[0].Selling_Specific);
                }
            });
        }
    </script>

	<style type="text/css">
		div.dd_chk_select {
			width: 100%;
			height: 22px;
			padding-left: 12px;
			font-size: 14px;
			line-height: 1.42857143;
			color: #555;
			background-color: #fff;
			border: 1px solid #ccc;
			border-radius: 4px;
			-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
			box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
			-webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
			-o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
			transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
			border-bottom-color: red !important;
			border-bottom-width: 2px !important;
		}

		div.dd_chk_drop {
			top: 21px;
		}
		.nonPayable-Item {
			background: #9585bf !important;
		}

	</style>


	<div id="Pbody_box_inventory">
		<cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>

		<div class="POuter_Box_Inventory" style="text-align: center;">
			<b>Panel Master</b><br />
			<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
		</div>
		<div class="POuter_Box_Inventory">
			<div class="Purchaseheader">
				Panel Details
			</div>
			<div class="row">
				<div class="col-md-1"></div>
				<div class="col-md-22">
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Panel Name
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtCompanyName" runat="server" CssClass="requiredField" ToolTip="Enter Panel Name" TabIndex="1"></asp:TextBox>
							<asp:Label ID="lblPanelID" runat="server" Visible="false"></asp:Label>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Group Type
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:DropDownList ID="ddlPanelGroup" runat="server"
								ToolTip="Select Group Type" TabIndex="2">
							</asp:DropDownList>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Contact Person
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtContact" runat="server" ToolTip="Enter Contact Person Name" TabIndex="3"></asp:TextBox>
						</div>
					</div>
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Address1
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtAddress1" runat="server"
								ToolTip="Enter Panel Address" TabIndex="4"></asp:TextBox>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Address2
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtAddress2" runat="server"
								ToolTip="Enter Panel Address" TabIndex="5"></asp:TextBox>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Contact No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtMobile" runat="server"
								ToolTip="Enter Contact No." MaxLength="15" TabIndex="6"></asp:TextBox>
							<cc1:FilteredTextBoxExtender ID="ftbMobile" runat="server" FilterType="Numbers" TargetControlID="txtMobile"></cc1:FilteredTextBoxExtender>
						</div>
					</div>
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Phone&nbsp;No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtPhone" runat="server"
								ToolTip="Enter Phone No." MaxLength="15" TabIndex="7"></asp:TextBox>
							<cc1:FilteredTextBoxExtender ID="ftbPhone" runat="server" FilterType="Numbers" TargetControlID="txtPhone"></cc1:FilteredTextBoxExtender>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Email ID
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtEmail" runat="server"
								ToolTip="Enter Email Id" TabIndex="8"></asp:TextBox>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Fax No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtFax" runat="server" ToolTip="Enter Fax no." TabIndex="9"></asp:TextBox>
						</div>
					</div>
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Valid From
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date" TabIndex="10"></asp:TextBox>
							<cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy" runat="server">
							</cc1:CalendarExtender>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Valid To
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
								TabIndex="11"></asp:TextBox>
							<cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="ucToDate" Format="dd-MMM-yyyy" runat="server">
							</cc1:CalendarExtender>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Payment Mode
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:DropDownCheckBoxes ID="ddlPaymentMode" runat="server" AddJQueryReference="True" UseButtons="false" UseSelectAllNode="True" TabIndex="12">
								<Texts SelectBoxCaption="Select" />
							</asp:DropDownCheckBoxes>
						</div>
					</div>
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Refer Rate(OPD)
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:DropDownList ID="ddlPanelCompany" runat="server" TabIndex="13" ToolTip="Select Referring Rate(OPD)">
							</asp:DropDownList>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Refer Rate(IPD)
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:DropDownList ID="ddlPanelIPD" runat="server" TabIndex="14" ToolTip="Select Referring Rate(IPD)">
							</asp:DropDownList>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Credit Limits
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtCreditLimit" runat="server" ToolTip="Enter Credit Limits" TabIndex="15"></asp:TextBox>
							<cc1:FilteredTextBoxExtender ID="ftbCr" runat="server" TargetControlID="txtCreditLimit" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
						</div>
					</div>
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Rate Type
							</label>
							<b class="pull-right">:</b>

						</div>
						<div class="col-md-5">
							<asp:CheckBox ID="chkself" runat="server" Text="SELF (OPD)" OnCheckedChanged="chkself_CheckedChanged" AutoPostBack="True" ToolTip="Check Self Rate(OPD)" />
							<asp:CheckBox ID="chkselfIPD" runat="server" Text="SELF (IPD)" AutoPostBack="True" OnCheckedChanged="chkselfIPD_CheckedChanged" ToolTip="Check Self Rate(IPD)" />

						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Show PrintOut
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:RadioButtonList ID="rblShowPrintOut" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
								<asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
								<asp:ListItem Value="0">No</asp:ListItem>
							</asp:RadioButtonList>
						</div>


						<div class="col-md-3">
							<label class="pull-left">
								Hide Rate
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:RadioButtonList ID="rblHideRate" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
								<asp:ListItem Value="1">Yes</asp:ListItem>
								<asp:ListItem Value="0" Selected="True">No</asp:ListItem>
							</asp:RadioButtonList>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								<asp:CheckBox ID="chkIsServiceTax" runat="server" Text="Is Service Tax Applicable" Visible="false" Width="117px" ToolTip="Check is Service Tax Applicable" />
							</label>

						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtAgreement" Visible="false" runat="server" TextMode="MultiLine" Columns="50" Rows="10" Height="150px"></asp:TextBox>
							<%--  <cc1:HtmlEditorExtender ID="htmleditor" ValidateRequestMode="Disabled" TargetControlID="txtAgreement" runat="server"></cc1:HtmlEditorExtender>--%>
						</div>
					</div>
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Co-Payment On   
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:RadioButtonList ID="rdoCoPaymentType" runat="server" onclick="checkCoPaymentOn()" RepeatDirection="Horizontal" RepeatLayout="Table">
								<asp:ListItem Value="1" Selected="True">On Bill</asp:ListItem>
								<asp:ListItem Value="0">On Service</asp:ListItem>
							</asp:RadioButtonList>
						</div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                Co-Payment In %   
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCoPaymentValue" onlynumber="5" decimalplace="2" max-value="100" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" CssClass="coPayentValue" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">  
                                Rate Currency  
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList runat="server" ID="ddlPanelRateCurrency"></asp:DropDownList>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                <asp:RadioButtonList ID="rbtBillingType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
								<asp:ListItem Value="0" Selected="True">Credit</asp:ListItem>
								<asp:ListItem Value="1">Cash</asp:ListItem>
							</asp:RadioButtonList>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Bill Currency  
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
	                         <asp:DropDownList ID="ddlPannelBillCurrency" runat="server" onchange="$bindBillCurrencyDetails()" ClientIDMode="Static" ToolTip="Select Bill Currency.">
							</asp:DropDownList>
                          </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                CurrencyConv. 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
	                         <asp:TextBox ID="txtConversion" onlynumber="10" decimalplace="4" max-value="999"  runat="server" ToolTip="Enter Currency Conversion" ClientIDMode="Static" TabIndex="15"></asp:TextBox>
                            </div>
                    </div>


                     <div class="row">
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Cover Note
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                        <div class="col-md-5">
                             <asp:RadioButtonList ID="rbtCoverNote" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
								<asp:ListItem Value="0" Selected="True">No</asp:ListItem>
								<asp:ListItem Value="1">Yes</asp:ListItem>
							</asp:RadioButtonList>
	                     </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                               Panel Amount 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPanelAmountLimit" runat="server" ></asp:TextBox>
	                     </div>                         
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Diet Type
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                        <div class="col-md-5">
                             <asp:RadioButtonList ID="rblDietType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
								<asp:ListItem Value="0" Selected="True">Normal</asp:ListItem>
								<asp:ListItem Value="1">Private</asp:ListItem>
							</asp:RadioButtonList>
	                     </div>                        
                    </div>

                    <div class="row">
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Is Smart Card
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                        <div class="col-md-5">
                             <asp:RadioButtonList ID="rblIsSmartCard" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
								<asp:ListItem Value="0" Selected="True">No</asp:ListItem>
								<asp:ListItem Value="1">Yes</asp:ListItem>
							</asp:RadioButtonList>
	                     </div>
                        
                         <div class="col-md-3">
                            <label class="pull-left">
                                <b>Note </b>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <b style="color: red">Co-Payment Payable By Patient.</b>
                        </div>
                        
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; padding-top: 3px">
            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton save" OnClick="btnSave_Click" ToolTip="Click To Save" TabIndex="16" />
            <asp:Button ID="btnUpdate" runat="server" CssClass="ItDoseButton save" OnClick="btnUpdate_Click" Text="Update" ToolTip="Click To Update" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                View Existing Panel Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel&nbsp;Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtpnlname" runat="server" ToolTip="Enter Panel Name To Search"></asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnsearch" runat="server" Text="Search" Width="90px" OnClick="btnsearch_Click" ToolTip="Click To search" CssClass="ItDoseButton" />
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnReport" runat="server" Text="Export To Excel" OnClick="btnReport_Click" ToolTip="Click To Report" CssClass="ItDoseButton" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row"></div>
            <asp:GridView ID="grdPanel" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                OnSelectedIndexChanged="grdPanel_SelectedIndexChanged" AllowPaging="True" OnPageIndexChanging="grdPanel_PageIndexChanging"
                PageSize="6">
                <Columns>
                    <asp:BoundField DataField="Company_Name" HeaderText="Panel Name" ItemStyle-Width="100px" />
                    <asp:BoundField DataField="Add1" HeaderText="Address1" ItemStyle-Width="150px" />
                    <asp:BoundField DataField="Ref_Company" HeaderText="Ref-Rate(IPD) Panel" />
                    <asp:BoundField DataField="Ref_CompanyOPD" HeaderText="Ref-Rate(OPD) Panel" />
                    <asp:BoundField DataField="Contact_Person" HeaderText="Contact Person" ItemStyle-Width="120px" />
                    <asp:BoundField DataField="DateFrom" HeaderText="Date&nbsp;From" ItemStyle-Width="80px" />
                    <asp:BoundField DataField="DateTo" HeaderText="Date&nbsp;To" ItemStyle-Width="80px" />
                    <asp:BoundField DataField="CreditLimit" HeaderText="Credit Limit" />
                     <asp:BoundField DataField="BillCurrencyNotation" HeaderText="Bill Curr." />
                     <asp:BoundField DataField="BillCurrencyConversion" HeaderText="Curr. Conv." />
                    <asp:BoundField DataField="PanelAmountLimit" HeaderText="Panel Amount" />
                    <asp:BoundField DataField="BillingType" HeaderText="Panel Type/Cover Note" ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Service Offered">
                        <ItemTemplate>
                            <button onclick="openServiceOfferedModel('<%# Eval("PanelID") %>','<%# Eval("Company_Name") %>')" type="button">View / Edit Service Offered</button>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                      <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Reduce Item Details">
                        <ItemTemplate>
                            <button onclick="openReduceServiceModel('<%# Eval("PanelID") %>','<%# Eval("Company_Name") %>')" type="button" id="btnopenReduceServiceModel">View / Edit Reduce Item Detail</button>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                    <asp:CommandField ShowSelectButton="True" ItemStyle-HorizontalAlign="Center" HeaderText="Edit" ButtonType="Button" SelectText="Edit" SelectImageUrl="~/Images/edit.png" />
                    <asp:TemplateField Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblPanelId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"PanelID") %>'></asp:Label>
                            <asp:Label ID="lblRef_ID" runat="server" Text='<%# Eval("ReferenceCode") %>'></asp:Label>
                            <asp:Label ID="lblRefID_OPD" runat="server" Text='<%# Eval("ReferenceCodeOPD") %>'></asp:Label>
                            <asp:Label ID="lblAgreement" runat="server" Text='<%# Eval("Agreement") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="GridViewHeaderStyle" />
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <PagerStyle HorizontalAlign="Center" />
            </asp:GridView>

		</div>
	</div>

	<script type="text/javascript" src="../../Scripts/Common.js"></script>
	<script type="text/javascript" src="../../Scripts/jquery.slimscroll.js"></script>
	<script type="text/javascript" src="../../Scripts/chosen.jquery.min.js"></script>
	<script type="text/javascript">
		$(function () {
			$commonJsInit(function () { });
			bindCategory(function (resposne) {
				bindSubCategory(resposne, function () { });
			});
		});

		var openServiceOfferedModel = function (panelID, panelName) {
		    panelID = Number(panelID);
		    var divServiceOfferdModel = $('#divServiceOfferdModel');
		    if (panelID == 1)
		        divServiceOfferdModel.find('#ddlOperationType option[value=3],#ddlOperationType option[value=1]').prop('disabled', true);
		    else
		        divServiceOfferdModel.find('#ddlOperationType option[value=3],#ddlOperationType option[value=1]').prop('disabled', false);

			divServiceOfferdModel.find('.modal-title').attr('panelID', panelID).html('<span style="color:blue">(' + panelName + ')</span>  Service Offered Items');
			divServiceOfferdModel.find('select').val('0').change().trigger('chosen:updated');
			divServiceOfferdModel.find('#divItems').html('');
			divServiceOfferdModel.showModel();
		}

		var closeServiceOfferdModel = function () {
			$('#divServiceOfferdModel').closeModel();
		}
		var openReduceServiceModel = function (panelID, panelName) {
		    panelID = Number(panelID);
		    var divReduceServicePerModel = $('#divReduceServicePerModel');
		    divReduceServicePerModel.find('.modal-title').attr('panelID', panelID).html('<span style="color:blue">(' + panelName + ')</span>  Reduce Service (%)');
		    divReduceServicePerModel.find('#divreducedetails').html('');
		    divReduceServicePerModel.showModel();
		}
		var closeReduceServicePerModel = function () {
		    $('#divList').hide();
		    $('#divReduceServicePerModel').closeModel();
		}

		var checkCoPaymentOn = function () {
			var coPaymentOnValue = $('input[type=radio][name$="rdoCoPaymentType"]:checked').val()
			if (coPaymentOnValue == '1')
				$('.coPayentValue').val('').attr('disabled', false);
			else
				$('.coPayentValue').val('').attr('disabled', true);
		}

		var bindCategory = function (callback) {
			serverCall('Services/PanelMaster.asmx/GetCategoryMaster', {}, function (response) {
				var ddlCategory = $('#ddlCategory');
				ddlCategory.bindDropDown({ data: JSON.parse(response), valueField: 'CategoryID', textField: 'Name', isSearchAble: true });
				callback(ddlCategory.val());
			});
		}


		var bindSubCategory = function (categoryID, callback) {
			$('#divItems').html('');
			$('#ddlOperationType').val(0);
			var data = {
				Type: '',
				CategoryID: categoryID
			};
			serverCall('../common/CommonService.asmx/BindSubCategory', data, function (response) {
				var ddlSubCategory = $('#ddlSubCategory');
				ddlSubCategory.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true });
			});
		}


		var getItems = function (subcategoryID) {
			var data = {
				categoryID: $('#ddlCategory').val(),
				subCategoryID: $('#ddlSubCategory').val(),
				panelID: $('#divServiceOfferdModel').find('.modal-title').attr('panelID'),
				operationType:Number($('#ddlOperationType').val())
			}
			serverCall('Services/PanelMaster.asmx/GetItems', data, function (response) {
			    var responseData = JSON.parse(response);
			    items = responseData.items;
			    var OPDCategoryPercent, IPDCategoryPercent, OPDSubCategoryPercent, IPDSubCategoryPercent = 0;
			    if (responseData.data.length > 0) {
			        OPDCategoryPercent = responseData.data[0].OPDCategory;
			        IPDCategoryPercent = responseData.data[0].IPDCategory;
			        OPDSubCategoryPercent = responseData.data[0].OPDSubCategory;
			        IPDSubCategoryPercent = responseData.data[0].IPDSubCategory;
			    }

			    $('#txtDirectOnCategoryOPD').val(OPDCategoryPercent);
			    $('#txtDirectOnCategoryIPD').val(IPDCategoryPercent);
			    $('#txtDirectOnSubCategoryOPD').val(OPDSubCategoryPercent);
			    $('#txtDirectOnSubCategoryIPD').val(IPDSubCategoryPercent);
				console.log(items);
				var outputPatient = $('#templateItems').parseTemplate(items);
				$('#divItems').html(outputPatient).customFixedHeader();
				if (data.operationType==1)
					$('.percentageRequired').hide();
				else
					$('.percentageRequired').show();

				MarcTooltips.add('#txtOPDPercent,#txtIPDPercent', 'Press Enter To Copy Cell Value To Column.', { onFocus: true, position: 'up', align: 'left' });
			});
		}


		var checkAll = function (checkStatus) {
			$('#tableItems tr #tdItemSelect input[type=checkbox]').prop('checked', checkStatus);
		}

		var itemCheckChanged = function (elem) {
			var panelOperationType = parseInt($('#ddlOperationType').val());
			var row = elem.closest('tr');
			if (panelOperationType == 1)
				$(row).find('input[type = text]').val('')

			$(row).find('input[type = text]').prop('disabled', panelOperationType == 1);
			$(chkAll).prop('checked', ($('#tableItems tr #tdItemSelect input[type=checkbox]').not(':checked').length == 0))
		}

		var onItemPercentChange = function (e) {
			var code = (e.keyCode ? e.keyCode : e.which);
			var cell = $(e.target).closest('td');
			var cellIndex = e.target.parentNode.cellIndex;
			var row = $(e.target).closest('tr');
			var cellID = cell[0].id;

			if (cellID == 'tdOPD')
				row.find('.OPD').val(e.target.value);
			if (cellID == 'tdIPD')
				row.find('.IPD').val(e.target.value);

			if (code == 13) {
				modelConfirmation('Confirmation', 'Copy Cell Value To The Column !!', 'Copy', 'Cancel', function (response) {
					if (response) {
						if (cellID == 'tdOPD' || cellID == 'tdIPD')
							$('#tableItems tr  td:nth-child(' + (cellIndex + 1) + ')').find('input').val(e.target.value).keyup();
						else
							$('#tableItems tr  td:nth-child(' + (e.target.parentNode.parentNode.parentNode.parentNode.parentNode.cellIndex + 1) + ')').find('._patientType tr td:nth-child(' + (cellIndex + 1) + ') input').val(e.target.value);
					}
				});
			}
		}

		var onItemIPDPercentChange = function (e) {
			var code = (e.keyCode ? e.keyCode : e.which);
			var row = $(e.target).closest('tr');
			row.find('.IPD').val(e.target.value);
		}

		var onChangePanelOperationType = function (elem) {
			var row = $(elem).closest('tr');
			if (elem.value == '1')
				$(row).find('#txtOPDPercent,#txtIPDPercent').val(0).attr('disabled', true);
			else
				$(row).find('#txtOPDPercent,#txtIPDPercent').val(0).attr('disabled', false);
		}


		var getServiceItemsDetails = function (callback) {
			var checkedItems = $('#tableItems tr #tdItemSelect input[type=checkbox]:checked');
			var panelID = parseInt($('#divServiceOfferdModel').find('.modal-title').attr('panelID'));
			var categoryID = $.trim($('#ddlCategory').val());
			var subCategoryID = $.trim($('#ddlSubCategory').val());
			if (String.isNullOrEmpty(subCategoryID) || subCategoryID == '0')
				subCategoryID = '';

			var operationType = Number($('#ddlOperationType').val());
			var data = [];
			var isValidated = true;
			var percentOnCategory = {
				OPDPercent: Number($('#txtDirectOnCategoryOPD').val()),
				IPDPercent: Number($('#txtDirectOnCategoryIPD').val())
			};
			var percentOnSubCategory = {
				OPDPercent: Number($('#txtDirectOnSubCategoryOPD').val()),
				IPDPercent: Number($('#txtDirectOnSubCategoryIPD').val())
			};


			checkedItems.each(function (i, item) {
				var row = $(item).closest('tr');
				var itemID = $.trim($(row).find('#tdItemID').text());
				var _patientType = row.find('._patientType');
				if (operationType == 1) {
					data.push({
						panelID: panelID,
						categoryid: categoryID,
						subcategoryid: subCategoryID,
						itemId: itemID,
						percentage: 0,
						IPDPercentage: 0,
						operationType: operationType,
						patientTypeID: 0
					});
				}
				else {
					_patientType.each(function (j, type) {
						var opdDiscountPercent = parseFloat($(type).find('.OPD').val());
						var ipdDiscountPercent = parseFloat($(type).find('.IPD').val());
						var patientTypeID = parseInt(type.id);
						opdDiscountPercent = isNaN(opdDiscountPercent) ? 0 : opdDiscountPercent;
						ipdDiscountPercent = isNaN(ipdDiscountPercent) ? 0 : ipdDiscountPercent;
						data.push({
							panelID: panelID,
							categoryid: categoryID,
							subcategoryid: subCategoryID,
							itemId: itemID,
							percentage: opdDiscountPercent,
							IPDPercentage: ipdDiscountPercent,
							operationType: operationType,
							patientTypeID: patientTypeID
						});
					});
				}

			});
			
			if (operationType==3) {
				var nonPayableItems = $('#tableItems tbody tr input[type=checkbox]:checked').closest('.nonPayable-Item').length;
				if (nonPayableItems > 0) {
					modelConfirmation('Co-Payment Apply Confirmation ?', '<span class="patientInfo">Some Items Are No-Payable</span> <br/>Are You Sure To OverWrite With Co-Payment', 'Yes', 'Cancel', function (status) {
						if (status)
							callback({ panelID: panelID, categoryID: categoryID, subCategoryID: subCategoryID, operationType: operationType, data: data.filter(function (i) { return ((i.percentage > 0 || i.IPDPercentage > 0 || i.operationType == 1)) }), percentOnCategory: percentOnCategory, percentOnSubCategory: percentOnSubCategory, operationType: operationType });
						
					});
				}
				else
					callback({ panelID: panelID, categoryID: categoryID, subCategoryID: subCategoryID, operationType: operationType, data: data.filter(function (i) { return ((i.percentage >= 0 || i.IPDPercentage >= 0 || i.operationType == 1)) }), percentOnCategory: percentOnCategory, percentOnSubCategory: percentOnSubCategory, operationType: operationType });
			}
			else
				callback({ panelID: panelID, categoryID: categoryID, subCategoryID: subCategoryID, operationType: operationType, data: data.filter(function (i) { return ((i.percentage >= 0 || i.IPDPercentage >= 0 || i.operationType == 1)) }), percentOnCategory: percentOnCategory, percentOnSubCategory: percentOnSubCategory, operationType: operationType });


			//if (data.length < 1 && (percentOnCategory.OPDPercent==0 && percentOnCategory.IPDPercent==0 && percentOnSubCategory.OPDPercent==0 && percentOnSubCategory.IPDPercent==0))
			//	modelAlert('Please Select Service Items');
			//else
				//callback({ panelID: panelID, categoryID: categoryID, subCategoryID: subCategoryID, operationType: operationType, data: data.filter(function (i) { return ((i.percentage > 0 || i.IPDPercentage > 0 || i.operationType == 1)) }), percentOnCategory: percentOnCategory, percentOnSubCategory: percentOnSubCategory, operationType: operationType });
		}

		var onPanelOperationTypeChange = function (value) {
			var tableItems = $('#tableItems');
			if (value == 1) {
				tableItems.find('input[type=checkbox]').prop('checked', false);
				tableItems.find('input[type = text]').val('').prop('disabled', true);
			}
			else {
				tableItems.find('input[type=checkbox]').prop('checked', false);
				tableItems.find('input[type = text]').val('').prop('disabled', false);
			}

		}

		var getPanelMaster = function (callback) {
			serverCall('../Common/CommonService.asmx/bindPanel', {}, function (response) {
				var responseData = JSON.parse(response);
				callback(responseData);
			});
		}



		var $saveServiceItemsDetails = function (btnSave) {
			getServiceItemsDetails(function (itemsDetails) {
				$(btnSave).attr('disabled', true).val('Submitting...');
				serverCall('Services/PanelMaster.asmx/SavePanelDiscount', itemsDetails, function (response) {
					var $responseData = JSON.parse(response);
					modelAlert($responseData.response, function () {
						if ($responseData.status) {
							$(btnSave).removeAttr('disabled').val('Save');
							modelConfirmation('Confirmation ?', 'Are You Want To Copy Same To Another Panel', 'Yes Copy To Another Panel', 'Cancel', function (response) {
								if (response) {
									var panelID = parseInt($('#divServiceOfferdModel').find('.modal-title').attr('panelID'));
									var panelName = $('#divServiceOfferdModel').find('.modal-title span').text();
									var divCopyPanelServiceOfferdModel = $('#divCopyPanelServiceOfferdModel');
									divCopyPanelServiceOfferdModel.find('#lblPanelCopyFrom').text(panelName).attr('panelID', panelID);
									getPanelMaster(function (response) {
										var panelMaster = response.filter(function (i) { return (i.PanelID != panelID) });
										$('#ddlCopyToPanel').bindDropDown({ data: panelMaster, valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true });
										$(divCopyPanelServiceOfferdModel).showModel();
									});
								}
							});
						}
						else
							$(btnSave).removeAttr('disabled').val('Save');
					});
				});
			});
		}

		var copyPanelDiscount = function (btnSave) {
			var data = {
				copyType: parseInt($('#ddlCopySubCategory').val()),
				copyFromPanel: parseInt($('#lblPanelCopyFrom').attr('panelID')),
				subCategoryID: $('#ddlSubCategory').val(),
				copyToPanel: parseInt($('#ddlCopyToPanel').val())
			}
			$(btnSave).attr('disabled', true).val('Submitting...');
			serverCall('Services/PanelMaster.asmx/copyPanelDiscount', data, function (response) {
				var $responseData = JSON.parse(response);
				modelAlert($responseData.response, function () {
					$(btnSave).removeAttr('disabled').val('Save');
				});

			});
		}

		function itemSearch() {
			var input, filter, table, tr, td, i;
			input = document.getElementById('txtItemSearch');
			filter = input.value.toUpperCase();
			table = document.getElementById("tableItems");
			tr = table.getElementsByTagName("tr");
			for (i = 0; i < tr.length; i++) {
				td = tr[i].getElementsByTagName('td')[4];
				if (td) {
					if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
						tr[i].style.display = "";
					} else {
						tr[i].style.display = "none";
					}
				}
			}
		}

		var $getReduceDetails = function ()
		{
		    panelid = $('#divReduceServicePerModel').find('.modal-title').attr('panelID');
		    serverCall('Services/PanelMaster.asmx/bindReduceitemdetails', {reduceType:$('#ddlreduce option:selected').text(),panelid:panelid }, function (response) {
		        var responseData = JSON.parse(response);
		        bindDetails(responseData);
		    });
		}
		var bindDetails = function (data) {
		    $('#divList').show();
		    $('#tbReduceitemdetails tbody ').empty();
		    if (data.length > 0) {
		        for (var i = 0; i < data.length; i++) {
		            var j = $('#tbReduceitemdetails tbody tr').length + 1;
		            var row = '<tr>';
		            row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
		            row += '<td id="tdReduceType" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ServiceName + '</td>';
		            row += '<td id="tdReudceSequnce" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SequenceNo + '</td>';
		            row += '<td id="tdReduseper" class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtReduceper" value=' + data[i].Reduce_per + '></td>';
		            row += '<td id="tdReduceRemarks" class="GridViewLabItemStyle" style="text-align: center;"><input type="text"  id="txtRemarks" value=' + data[i].Remarks + '></td>';
		            row += '</tr>';
		            $('#tbReduceitemdetails tbody').append(row);
		        }
		    }
		    else if (data.length == 0 && $('#ddlreduce').val()!=0) {
		        for (var i = 1; i < 5; i++) {
		            var row = '<tr>';
		            row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + i + '</td>';
		            row += '<td id="tdReduceType" class="GridViewLabItemStyle" style="text-align: center;">' + $('#ddlreduce option:selected').text() + '</td>';
		            row += '<td id="tdReudceSequnce" class="GridViewLabItemStyle" style="text-align: center;">' + i + '</td>';
		            row += '<td id="tdReduseper" class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtReduceper"  onlynumber="3" ></td>';
		            row += '<td id="tdReduceRemarks" class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtRemarks" ></td>';
		            row += '</tr>';
		            $('#tbReduceitemdetails tbody').append(row);
		        }
		    }
		}
		var $saveServiceReduceDetails=function (){
		    getServicereducedetails(function (data) {
		        serverCall('Services/PanelMaster.asmx/saveServiceReduceDetails', data, function (response) {
		            var responseData = JSON.parse(response);
		            modelAlert(responseData.response, function () {
		                Clear();
		            });
		        });
		    });
		}
		var Clear = function () {
		    $table = $('#tbReduceitemdetails');
		    $table.each(function (index, row) {
		        $(row).find('input[type=text]').val('');
		    });
		}
		var getServicereducedetails = function (callback) {
		    $table = $('#tbReduceitemdetails tbody tr');
		    serviceReduce = [];
		    var Panelid = $('#divReduceServicePerModel').find('.modal-title').attr('panelID');
		    $table.each(function (index, row) {
		        serviceReduce.push({
		            ReduceType: $(row).find('#tdReduceType').text().trim(),
		            ReudceSequnce: $(row).find('#tdReudceSequnce').text().trim(),
		            Reduceper: $(row).find('#txtReduceper').val(),
		            Remarks: $(row).find('#txtRemarks').val(),
		        });
		    });
		    callback({ serviceReduce: serviceReduce, panelID: Panelid})
		}
	</script>





	<div id="divServiceOfferdModel" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="width:95%">
				<div class="modal-header">
					<button type="button" class="close" onclick="closeServiceOfferdModel()" aria-hidden="true">&times;</button>
					<b class="modal-title">Service Offered Items</b>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-3">
							<label class="pull-left">
								Category Name
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select id="ddlCategory" onchange="bindSubCategory(this.value,function(){})"></select>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Sub Category
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select id="ddlSubCategory" onchange="getItems()"></select>

						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Operation Type
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<select id="ddlOperationType" onchange="getItems()">
								<option value="2">Set Discount </option>
								<option value="3">Set Panel Co-Payment </option>
								<option value="1">Set Panel Non-Payable </option>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="col-md-3 percentageRequired">
							<label class="pull-left">
								On Category
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5 percentageRequired">
							<div style="padding:0px;margin:0px" class="row">
								<div style="padding:0px" class="col-md-12">
									<input type="text"   placeholder="OPD Percent" id="txtDirectOnCategoryOPD" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onlynumber="5" decimalplace="2" max-value="100" />
								</div>
								<div style="padding: 0px;padding-left: 5px;" class="col-md-12">
									<input type="text"   placeholder="IPD Percent" id="txtDirectOnCategoryIPD" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onlynumber="5" decimalplace="2" max-value="100" />
								</div>
							</div>
						</div>
						<div class="col-md-3 percentageRequired">
							<label class="pull-left">
								  On Sub Category
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5 percentageRequired">
							<div style="padding:0px;margin:0px" class="row">
								<div style="padding:0px" class="col-md-12">
									<input type="text"   placeholder="OPD Percent" id="txtDirectOnSubCategoryOPD" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onlynumber="5" decimalplace="2" max-value="100" />
								</div>
								<div style="padding: 0px;padding-left: 5px;" class="col-md-12">
									<input type="text"  placeholder="IPD Percent" id="txtDirectOnSubCategoryIPD" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onlynumber="5" decimalplace="2" max-value="100" />
								</div>
							</div>
						</div>
						<div class="col-md-3">
							<label class="pull-left">
								Search
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						 <div class="chosen-container-single">
							 <div style="padding:0px;z-index:0" class="chosen-search">
								 <input type="text" style="border-radius: 5px;height:22px;" class="chosen-search-input" onkeyup="itemSearch()"  placeholder="Search Items" id="txtItemSearch" />
							</div>
						  </div>
						</div>
					</div>


					<div class="row">
						<div id="divItems" style="height: 300px; max-height: 300px; overflow: auto" class="col-md-24">
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-purple"></button>
					<b style="float:left;margin-top:8px;margin-left:5px">Non-Payable Items</b>


					<span class="pull-left" style="color: red; margin-top:8px;margin-left:20px"><b>Note:Values Are In Percent (%).
					</b></span>
					<button type="button" onclick="$saveServiceItemsDetails(this)" class="save">Save</button>
					<button type="button" onclick="closeServiceOfferdModel()">Close</button>
				</div>
			</div>
		</div>
	</div>

    <div id="divReduceServicePerModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width:50%">
              <div class="modal-header">
                <button type="button" class="close" onclick="closeReduceServicePerModel()" aria-hidden="true">&times;</button>
                  <b class="modal-title">Reduce Serive(%)</b>
              </div>  
                <div class="modal-body">
                    <div class="row">
                     <div class="col-md-5">
                         <label class="pull-left">
                             Reduce Type
                         </label>
                         <b class="pull-right">:</b>
                     </div>   
                        <div class="col-md-8">
                            <select id="ddlreduce" onchange="$getReduceDetails()">
                                <option value="0">Select</option>
                                <option value="1">Surgery</option>
                               <%-- <option value="2">IPDPackage</option>
                                <option value="3">Minor Procedure</option>--%>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                <div id="divList" style="max-height: 163px; max-width:643px; overflow-x: auto;display:none">
                    <table class="FixedHeader" id="tbReduceitemdetails" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 30px;">ReduceType</th>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SequnceType</th>
                                <th class="GridViewHeaderStyle" style="width: 10px;">Reduce_Per</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Remarks</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
                </div>
                <div class="modal-footer">
                   <span class="pull-left" style="color: red; margin-top:8px;margin-left:20px"><b>Note:Values Are In Percent (%).
					</b></span>
                    	<button type="button" onclick="$saveServiceReduceDetails(this)" class="save">Save</button>
					<button type="button" onclick="closeReduceServicePerModel()">Close</button>
                </div>
            </div>
        </div>

    </div>
	<div id="divCopyPanelServiceOfferdModel" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="min-width: 650px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divCopyPanelServiceOfferdModel" aria-hidden="true">&times;</button>
					<b class="modal-title">Copy Panel Service Offerd</b>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-1"></div>
						<div class="col-md-22">
							<div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										Copy Panel Name
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<label id="lblPanelCopyFrom" class="pull-left patientInfo">
										dfdsfs
									</label>

								</div>
							</div>
							<div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										Select  Panel To Copy
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<select id="ddlCopyToPanel"></select>
								</div>
							</div>
							<div style="display:none" class="row">
								<div class="col-md-8">
									<label class="pull-left">
										Copy Type
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<select id="ddlCopySubCategory">
									<%--	<option value="1">Last Changes</option>--%>
										<option value="2">All</option>
									</select>
								</div>
							</div>
						</div>
						<div class="col-md-1"></div>
					</div>
				</div>
				<div class="modal-footer">

					<button type="button" onclick="copyPanelDiscount(this)" class="save">Save</button>
					<button type="button" data-dismiss="divCopyPanelServiceOfferdModel" >Close</button>
				</div>
			</div>
		</div>
	</div>


	<script id="templateItems" type="text/html">  
	  <table  id="tableItems" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
		<thead>
						<#
				   var dataLength=items.length;    #>

				<#if(dataLength>0){#>
			<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width: 10px;" ><input id="chkAll" onchange="checkAll(this.checked)" type="checkbox" /></th>
			<th class="GridViewHeaderStyle" scope="col" >Item Name</th>    
			<th class="GridViewHeaderStyle" scope="col" style="width:50px" >OPD</th> 
			<th class="GridViewHeaderStyle" scope="col" style="width:50px" >IPD</th>    
				 <#}#>

	  <#
					for(var  key in items[0])
						{

						   if(key.indexOf('_PatientType')>-1)
						#>          
						   <th class="GridViewHeaderStyle" scope="col"   style="width:115px" >
								<table  id="PatientType" cellspacing="0" rules="all"  style="width:100%;border-collapse :collapse; border: transparent;">
									 <thead>
										  <tr>
											<th colspan="2" style="max-width:110px;text-align:center !important" class="GridViewHeaderStyle trimText" title="<#=key.split("_")[0]#>" scope="col" ><#=key.split("_")[0]#></th>
										 </tr>
										 <tr>
											<th class="GridViewHeaderStyle" scope="col" >OPD</th>
											<th class="GridViewHeaderStyle" scope="col" >IPD</th>
										 </tr>
									 </thead>
									</table>
						   </th>    
					<#}#>   
						
		</tr>
			</thead>
		<tbody>
				   
			<#
			
				var objRow;
				for(var j=0;j<dataLength;j++)
				{
					objRow = items[j];
				#>          
				<tr id="tr_<#=(j+1)#>"
					
						<#if( objRow.IsPayable==1 && objRow.operationType!=1){#>
							 class="nonPayable-Item"
						<#}#> 
					
					
					>
					<td id="tdItemSelect" style="text-align:center;"><input   onchange="itemCheckChanged(this)" type="checkbox"
						
						<#if( objRow.PercentageSum >0 || (objRow.IsPayable==1 && objRow.operationType==1) ){ #>
							 checked="checked"
							<#}#>   

												



						 /> </td>
					<td style="display:none" id="tdItemID"><#=objRow.ItemID#></td>
					<td style="display:none" id="tdCategoryID"><#=objRow.CategoryID#></td>
					<td style="display:none" id="tdSubCategoryID"><#=objRow.SubCategoryID#></td>
					<td class="trimText" style="max-width:137px" title="<#=objRow.ItemName#>" id="tdItemName"     

					   ><#=objRow.ItemName#> </td>
					
					<td id="tdOPD">
						<input id="txtOPDPercent"  value='<#=objRow.OPDPercent #>'   style="height: 20px; <#= (objRow.operationType==1)?'display:none':'' #>"   <#= (objRow.operationType==1)?'disabled':'' #> 
						
						 class="OPD"   data-title="Press Enter To Copy Cell Value To Column."  type="text" class="ItDoseTextinputNum" onpaste="return false" onkeyup="onItemPercentChange(event)"   onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  onlynumber="5" decimalplace="2" max-value="100"  />
					</td>
					<td id="tdIPD">
						<input id="txtIPDPercent"  value='<#=objRow.IPDPercent #>' style="height: 20px;<#= (objRow.operationType==1)?'display:none':'' #>"  <#= (objRow.operationType==1)?'disabled':'' #>
							
							 class="IPD"   data-title="Press Enter To Copy Cell Value To Column."   type="text" class="ItDoseTextinputNum" onpaste="return false" onkeyup="onItemPercentChange(event)"   onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  onlynumber="5" decimalplace="2" max-value="100"  />
					</td>
					<#
					for(var  key in objRow)
						{
						   if(key.indexOf('_PatientType')>-1)
						#>          
						   <td id="td1">
								 <table  id='<#=key.split("_")[2]#>' class="_patientType" cellspacing="0" rules="all"  style="width:100%;border-collapse :collapse; border: transparent;">
									 <tbody>
										 <tr>
											<td id="td2">
												<input    style="height: 20px; <#= (objRow.operationType==1 || objRow.operationType==3)?'display:none':'' #>"  
													
													id='<#=key#>'  onkeyup="onItemPercentChange(event)"  class="OPD" style="padding:2px"   value='<#=objRow[key].split("#")[0] #>' type="text" class="ItDoseTextinputNum" onpaste="return false" onkeyup="onItemOPDAmountChange(this)"   onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  onlynumber="5" decimalplace="2" max-value="100"/>
											</td>
											<td id="td3">
											   <input style="height: 20px; <#= (objRow.operationType==1 || objRow.operationType==3)?'display:none':'' #>"   
												   
													id='<#=key#>'   onkeyup="onItemPercentChange(event)"  class="IPD" style="padding:2px"   value='<#=objRow[key].split("#")[1]#>' type="text" class="ItDoseTextinputNum" onpaste="return false" onkeyup="onItemOPDAmountChange(this)"   onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  onlynumber="5" decimalplace="2" max-value="100"  />
											</td>
										 </tr>
									 </tbody>
								 </table>
						   </td>
					<#}#>   

				</tr>
			<#}#>   
			 </tbody>         
		 </table>       
	</script>





</asp:Content>
