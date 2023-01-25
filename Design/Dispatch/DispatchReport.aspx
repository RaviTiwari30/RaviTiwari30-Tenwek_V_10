<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DispatchReport.aspx.cs" Inherits="Design_EDP_DispatchReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>--%>
    <script type="text/javascript">
        $(document).ready(function () {
            checkType();
            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });
            $('#<%=hdnCurrency.ClientID %>').val(<%=Resources.Resource.BaseCurrencyID %>);
            $bindPanel(function () { });
        });

        $('#btnOldPatient').click(function (e) {
            showPatientSearchPopUpModel();
            $('#PatientDetails').css({ "background-color": "#ccc" });
            $('#txtSearchPatientID').focus();
            getDate();
        });

        $(function () {
            showPatientSearchPopUpModel = function () {
                $('#divPatientSearchPopUpModel').showModel();
            }

            closePatientSearchPopUpModel = function () {
                $('#divPatientSearchPopUpModel').hideModel();
            }
        });

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#btnReport').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnReport').removeAttr('disabled');
                    }
                }
            });
        }
        function ChangeCurrency(ctrl) {
            var _CurrencyId = '';
            if (ctrl == undefined) {
                _CurrencyId = '<%=Resources.Resource.BaseCurrencyID %>';
                $('#<%=hdnCurrency.ClientID %>').val(_CurrencyId);
            }
            if (ctrl != undefined) {
                _CurrencyId = $('#' + ctrl.id + '').val();
                $('#<%=hdnCurrency.ClientID %>').val(_CurrencyId);
            }
        }
    </script>

    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <asp:HiddenField ID="hdnCurrency" Value="" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Panel Claim Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
				<div class="col-md-22">                    
                    <div style="display:none">
                    <div class="row">
                        <div class="col-md-3">
							<label class="pull-left">
								From Disp. Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							<asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select From Date" TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtFromDate_CalendarExtender" runat="server" TargetControlID="txtFromDate"
                                 Format="dd-MMM-yyyy" ClearTime="true"></cc1:CalendarExtender>						
						</div>
                        <div class="col-md-3">
							<label class="pull-left">
								To Dispatch Date
							</label>
							<b class="pull-right">:</b>
						</div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtToDate_CalendarExtender" runat="server" TargetControlID="txtToDate"
                                 Format="dd-MMM-yyyy" ClearTime="true"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
								Panel
							</label>
							<b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanelCompany" ClientIDMode="Static" runat="server" ToolTip="Select Panel" TabIndex="3"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                         <div class="col-md-3">
							<label class="pull-left">
								Type
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
                            <asp:RadioButtonList ID="rdoType" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" onchange="checkType()" >
                                <asp:ListItem Text="OPD" Value="OPD"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                                <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                             </asp:RadioButtonList>
                        </div>
                        <div class="col-md-5">
                             <table style="width: 100%; border-collapse: collapse">
                                <tr style="display:none">                    
                                    <td style="text-align: right; width: 19%;" id="tdIPD"><span style="display: none;">IPD No. :&nbsp;</span></td>
                                    <td style="text-align: left; width: 30%" id="tdIPDno">
                                        <asp:TextBox ID="txtIPDNo" runat="server" ClientIDMode="Static" Width="130px" MaxLength="10" Style="display: none;"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="ftbIPD" runat="server" TargetControlID="txtIPDNo" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                    </td>                    
                                </tr>              
                                <tr id="trIPD" style="display:none">
                                    <td style="text-align: right; width: 13%;">Report Type :&nbsp;
                                    </td>
                                    <td style="text-align: left; width: 30%">                        
                                    </td>
                                    <td style="text-align: right; width: 19%;">Folder No. :&nbsp;
                                    </td>
                                    <td class="left-align">                        
                                    </td>                     
                                </tr>             
                                <tr style="display:none">
                                    <td style="text-align: left; padding-left:9%;padding-bottom:20px;" valign="top" colspan="6">
                                        <label id="lblcurr">Currency Type:</label>
                                        <input type="radio" id="rdbcedi" onclick="return ChangeCurrency(this);" checked="checked" name="Curr" value="<%=Resources.Resource.BaseCurrencyID %>" /><%=Resources.Resource.BaseCurrencyNotation %>&nbsp;
                                       <%--<input type="radio" id="rdbusd" onclick="return ChangeCurrency(this);" name="Curr" value="<%=Resources.Resource.OtherCurrencyId %>" /><%=Resources.Resource.OtherCurrencyNotation %>--%>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
							<label class="pull-left">
								Invoice No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
                            <asp:TextBox ID="txtInvoiceNo" ClientIDMode="Static" runat="server" MaxLength="30"></asp:TextBox>
                        </div>
                       <div class="col-md-3">
							<label class="pull-left">
								Dispatch No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
                            <asp:TextBox ID="txtDispatchNo" ClientIDMode="Static" runat="server"  MaxLength="5"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbDis" runat="server" TargetControlID="txtDispatchNo" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </div>                        
                         <div class="col-md-3">
							<label class="pull-left">
								Report Type
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
                            <asp:RadioButtonList ID="rdoReportType" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table">
                                <asp:ListItem Selected="True" Text="Detailed" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Summary" Value="2"></asp:ListItem>                           
                             </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                       <div class="col-md-3">
							<label class="pull-left">
								UHID No.
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
                            <asp:TextBox ID="txtUHID" ClientIDMode="Static" runat="server" MaxLength="30"></asp:TextBox>
                        </div>
                         <div class="col-md-3">
							<label class="pull-left">
								Report Format
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
                                <asp:RadioButtonList ID="rdoFormat" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" RepeatLayout="Table">
                                    <asp:ListItem Selected="True" Text="PDF" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Excel" Value="2"></asp:ListItem>
                                </asp:RadioButtonList>
                        </div>                        
						<div class="col-md-3">
                             <asp:CheckBox ID="chkDiagnosis" runat="server" Text="Diagnosis Print" ClientIDMode="Static" Checked="true" />
                        </div>
                        <div class="col-md-3">
                             <asp:CheckBox ID="chkPolicyno" runat="server" Text="Print Policy" ClientIDMode="Static" Checked="true" />
                        </div>
                        <div class="col-md-2">
                            <input type="button" id="btnOldPatient" class="ItDoseButton" value="Old Patient" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnReport" value="Report" class="ItDoseButton" onclick="dispatchReport()" />
        </div>
    </div>

         <div id="divPatientSearchPopUpModel" class="modal fade">
          <div class="modal-dialog">
               <div class="modal-content" style="width: 1100px">
                     <div class="modal-header">
                                <button type="button" class="close" onclick="closePatientSearchPopUpModel()" aria-hidden="true">&times;</button>
                                	<h4 class="modal-title">Old Patient Search</h4>
                            </div>
                     <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;overflow: auto;">
                                        <div class="row">
					                         <div  class="col-md-4">
						                          <label class="pull-left">  Folder No.</label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                 <input type="text" id="txtSearchPatientID"  title="Enter Folder No." maxlength="20" />
					                         </div>
                                            <div  class="col-md-4">
						                          <label class="pull-left">Panel</label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                <select id="ddlPanel"></select>
					                         </div>                                            
                                        </div>
                                    <div style="display:none">
                                         <div class="row">
                                              <div  class="col-md-4">
						                          <label class="pull-left">  First Name </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                 <input type="text" id="txtPatientFName" title="Enter First Name" maxlength="20"/>
					                         </div>
					                         <div  class="col-md-4">
						                          <label class="pull-left">  Last Name </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                <input type="text" id="txtPatientLname"  title="Enter Last Name" maxlength="20"/>
					                         </div>                                            
                                        </div>
                                        <div class="row">
                                             <div  class="col-md-4">
						                          <label class="pull-left">  Contact No. </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                 <input type="text" id="txtPhone" title="Enter Contact No." maxlength="15""/>
					                         </div>
					                         <div  class="col-md-4">
						                          <label class="pull-left">  Address </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                <input type="text" id="txtSearchAddress"  title="Enter Address" maxlength="50"/>
					                         </div>                                             
                                        </div>
                                     </div>
                                        <div class="row">
					                         <div  class="col-md-4">
						                          <label class="pull-left">  From Date </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">
                                                <asp:TextBox ID="txtFDSearch" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static"></asp:TextBox>
							                    <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="txtFDSearch" Format="dd-MMM-yyyy">
							                    </cc1:CalendarExtender>
					                         </div>
                                             <div  class="col-md-4">
						                          <label class="pull-left">To Date </label>
						                          <b class="pull-right">:</b>
					                         </div>
					                         <div  class="col-md-8">    
							                    <asp:TextBox ID="txtTDSearch" runat="server"   ClientIDMode="Static" ToolTip="Click To Select To Date " ></asp:TextBox>
							                    <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="txtTDSearch" Format="dd-MMM-yyyy">
							                    </cc1:CalendarExtender>
					                         </div>
                                        </div>
                                        <div style="text-align:center" class="row">
					                       <input type="button" id="btnView" value="Search" class="ItDoseButton" title="Click to Search"   onclick ="oldPatientSearch()"/>   
				                        </div>
				                        <div style="height:150px"  class="row">
					                        <div id="PatientOutput" class="col-md-24">
					                        </div>
				                        </div>               
	                                    </div>

                                </div>
                            </div>
                     <div class="modal-footer">
                                <div class="row">
                                    <button type="button"  onclick="closePatientSearchPopUpModel()">Close</button>
                                </div>
                     </div>
                </div>
           </div>
     </div>


    <script type="text/javascript">
        function checkType() {
            if ($("#rdoType input[type:radio]:checked").val() == "IPD") {
                $("#tdIPD").show();
                $("#tdIPDno").show();
                $("#tdIPD1,#tdIPDno1").show();
                $("#txtIPDNo").removeAttr("disabled");
                $('#rdoFormat').attr("disabled", "disabled");
            }
            else {
                $("#tdIPD").show();
                $("#txtIPDNo").val('');
                $("#tdIPD1,#tdIPDno1").hide();
                $('#rdoFormat').removeAttr("disabled");
                $("#txtIPDNo").attr("disabled", "disabled");
            }
        }

        function dispatchReport() {
            var Diagnosis = "";
            var Policy = "";
            $("#lblMsg").text('');

            //if ($("#rdoType input[type:radio]:checked").val() == "OPD") {

            if (($("#ddlPanelCompany").val() == "0") && ($.trim($("#txtDispatchNo").val()) == "") && ($.trim($("#txtInvoiceNo").val()) == "") && ($.trim($("#txtUHID").val()) == "")) {
                $("#lblMsg").text('Please Enter Any One Search Criteria');
                $("#txtDispatchNo").focus();
                return;
            }
            else if ($("#rdoReportType input[type:radio]:checked").val() == "1") {
                if ($('#chkDiagnosis').is(':checked')) {
                    Diagnosis = 1;
                }
                else {
                    Diagnosis = 0;
                }
                if ($('#chkPolicyno').is(':checked')) {
                    Policy = 1;
                }
                else {
                    Policy = 0;
                }

                $.ajax({
                    url: "DispatchReport.aspx/dispatchReport",
                    data: '{PanelID:"' + $("#ddlPanelCompany").val() + '",DispatchNo:"' + $("#txtDispatchNo").val() + '",InvoiceNo:"' + $("#txtInvoiceNo").val() + '",UHID:"' + $("#txtUHID").val() + '",fromDate:"' + $("#txtFromDate").val() + '", toDate:"' + $("#txtToDate").val() + '",Format:"' + $("#rdoFormat input[type:radio]:checked").val() + '",Diagnosis:"' + Diagnosis + '",Policy:"' + Policy + '",type:"' + $("#rdoType input[type='radio']:checked").val() + '",CurrencyId:"' + $('#<%=hdnCurrency.ClientID %>').val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        var Data = (result.d);
                        if (Data == "1") {
                            if ($("#rdoFormat input[type:radio]:checked").val() == '1')
                                window.open('../common/Commonreport.aspx');
                            else
                                window.open('../common/ExportToExcel.aspx');
                        }
                        else {
                            $("#lblMsg").text("Record Not Found");
                        }
                    },
                    error: function (xhr, status) {

                    }
                });
            }
            else if ($("#rdoReportType input[type:radio]:checked").val() == "2") {
                if ($('#chkDiagnosis').is(':checked')) {
                    Diagnosis = 1;
                }
                else {
                    Diagnosis = 0;
                }
                if ($('#chkPolicyno').is(':checked')) {
                    Policy = 1;
                }
                else {
                    Policy = 0;
                }
                $.ajax({
                    url: "DispatchReport.aspx/dispatchReportSummary",
                    data: '{PanelID:"' + $("#ddlPanelCompany").val() + '",DispatchNo:"' + $("#txtDispatchNo").val() + '",InvoiceNo:"' + $("#txtInvoiceNo").val() + '",UHID:"' + $("#txtUHID").val() + '",fromDate:"' + $("#txtFromDate").val() + '", toDate:"' + $("#txtToDate").val() + '",Format:"' + $("#rdoFormat input[type:radio]:checked").val() + '",Diagnosis:"' + Diagnosis + '",Policy:"' + Policy + '",type:"' + $("#rdoType input[type='radio']:checked").val() + '",CurrencyId:"' + $('#<%=hdnCurrency.ClientID %>').val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        var Data = (result.d);
                        if (Data == "1") {
                            if ($("#rdoFormat input[type:radio]:checked").val() == '1')
                                window.open('../common/Commonreport.aspx');
                            else
                                window.open('../common/ExportToExcel.aspx');
                        }
                    },
                    error: function (xhr, status) {

                    }

                });
            }
            else {
                $("#<%=lblMsg.ClientID%>").text('Please Select Proper Report Type');
            }

            //}
            //else {
            //    if ($("#txtIPDNo").val() != "") {
            //        if ($('#rdoReportType input[type:radio]:checked').val() == "1") {
            //            detailedBillIPD($("#txtIPDNo").val());
            //        }
            //        else if ($('#rdoReportType input[type:radio]:checked').val() == "2") {
            //            summaryBillIPD($("#txtIPDNo").val());
            //        }
            //        else {
            //            detailedBillIPD($("#spnIPDNo").text());
            //            summaryBillIPD($("#txtIPDNo").val());
            //        }
            //    }
            //    else {
            //        $("#lblMsg").text('Please Enter IPD No.');
            //        $("#txtIPDNo").focus();
            //    }
            //}
}
    </script>
    <script type="text/javascript">
        function detailedBillIPD(TransactionID) {
            $.ajax({
                url: "Services/Panel_Invoice.asmx/IPDDetailedBill",
                data: '{TransactionID:"' + TransactionID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Data = (result.d);
                    window.open('../common/CommonCrystalReportViewer.aspx');
                },
                error: function (xhr, status) {

                }

            });
        }
    </script>
    <script type="text/javascript">
        function summaryBillIPD(TransactionID) {
            $.ajax({
                url: "Services/Panel_Invoice.asmx/IPDSummaryBill",
                data: '{TransactionID:"' + TransactionID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Data = (result.d);

                    window.open('../common/CommonCrystalReportViewer.aspx');
                },
                error: function (xhr, status) {

                }

            });
        }
    </script>
    		<script id="tb_OldPatient" type="text/html">
	                <table  id="tablePatient" cellspacing="0" rules="all" border="1" style="border-collapse:collapse; ">
		            <thead>
		            <tr id="Tr1">
			            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Select</th>
			            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Panel Invoice No.</th>
			            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">First Name</th>
			            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Last Name</th>
			            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th>
			            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Age</th>
			            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Sex</th>
			            <th class="GridViewHeaderStyle" scope="col" style="width:116px;">Date</th>
			            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Address</th>
			            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Contact&nbsp;No.</th>
		   
		            </tr>
			            </thead>
		            <tbody>
		            <#     
			 
			              var dataLength=OldPatient.length;
		            if(_EndIndex>dataLength)
			            {           
			               _EndIndex=dataLength;
			            }
		            for(var j=_StartIndex;j<_EndIndex;j++)
			            {           
	               var objRow = OldPatient[j];
		            #>
						            <tr id="Tr2" onclick="bindPatientDetail(this);">                            
						            <td class="GridViewLabItemStyle"  style="width:60px; font:bold; font-size:16px">
					                   <input type="button"  onclick="bindPatientDetail(this);" style="cursor:pointer;" value="Select" />  
						            </td>                                                    
						            <td  class="GridViewLabItemStyle" id="tdPanelInvoiceNo"  style="width:200px;"><#=objRow.PanelInvoiceNo#></td>
						            <td class="GridViewLabItemStyle" id="tdPFirstName" style="width:140px;"><#=objRow.PFirstName#></td>
						            <td class="GridViewLabItemStyle" id="tdPLastName" style="width:140px;"><#=objRow.PLastName#></td>
						            <td class="GridViewLabItemStyle" id="td1"  style="width:100px;"><#=objRow.MRNo#></td>
						            <td class="GridViewLabItemStyle" id="tdAge" style="width:70px;"><#=objRow.Age#></td>
						            <td class="GridViewLabItemStyle" id="tdGender" style="width:80px;"><#=objRow.Gender#></td>
						            <td class="GridViewLabItemStyle" id="tdDate" style="width:116px;"><#=objRow.Date#></td>
						            <td class="GridViewLabItemStyle" id="tdHouseNo"  style="width:200px;"><#=objRow.SubHouseNo#></td>
						            <td class="GridViewLabItemStyle" id="tdContactNo" style="width:80px;"><#=objRow.ContactNo#></td>
						
							              </tr>            
		            <#}        
		            #>
			            </tbody>      
	             </table>  
	             <table id="tablePatientCount" style="border-collapse:collapse;">
	               <tr>
               <# if(_PageCount>4) {
	             for(var j=0;j<_PageCount;j++){ #>
	             <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
	             <#}         
               }
            #>

	             </tr>
	 
	             </table>  
	            </script>

    		<script type="text/javascript">
    		    $('#btnOldPatient').click(function (e) {
    		        showPatientSearchPopUpModel();
    		        $('#PatientDetails').css({ "background-color": "#ccc" });
    		        $('#txtSearchPatientID').focus();
    		        getDate();
    		    });
    		    function getDate() {
    		        $.ajax({
    		            url: "../Common/CommonService.asmx/getDate",
    		            data: '{}',
    		            type: "POST",
    		            dataType: "json",
    		            contentType: "application/json; charset=utf-8",
    		            success: function (mydata) {
    		                var data = mydata.d;
    		                $('#txtTDSearch,#txtFDSearch').val(data);
    		            }
    		        });
    		    }
    		    var _PageSize = 4;
    		    var _PageNo = 0;
    		    var OldPatient = "";
    		    function oldPatientSearch() {
    		        $('#btnView').attr('disabled', 'disabled');
    		        $('#spnOldPatient').text('');
    		        $.ajax({
    		            type: "POST",
    		            url: "../Dispatch/Services/Panel_Invoice.asmx/oldPatientSearch",
    		            data: '{PatientID:"' + $.trim($("#txtSearchPatientID").val()) + '",PName:"' + $.trim($("#txtPatientFName").val()) + '",LName:"' + $.trim($("#txtPatientLname").val()) + '",ContactNo:"' + $.trim($("#txtPhone").val()) + '",Address:"' + $.trim($("#txtSearchAddress").val()) + '",FromDate:"' + $.trim($("#txtFDSearch").val()) + '",ToDate:"' + $.trim($("#txtTDSearch").val()) + '",invoiceSetellment:"' + 1 + '",PanelID:"' + $('#ddlPanel').val() + '"}',
    		            dataType: "json",
    		            contentType: "application/json;charset=UTF-8",
    		            success: function (response) {
    		                OldPatient = jQuery.parseJSON(response.d);
    		                if (OldPatient != null) {
    		                    _PageCount = OldPatient.length / _PageSize;
    		                    showPage('0');
    		                }
    		                else {
    		                    $("#spnOldPatient").text('Record Not Found');
    		                    $('#PatientOutput').hide();
    		                    $('#btnView').removeAttr('disabled');
    		                }
    		            },
    		            error: function (xhr, status) {
    		                $('#btnView').removeAttr('disabled');
    		            }
    		        });
    		    }
    		    function showPage(_strPage) {
    		        _StartIndex = (_strPage * _PageSize);
    		        _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
    		        var outputPatient = $('#tb_OldPatient').parseTemplate(OldPatient);
    		        $('#PatientOutput').html(outputPatient);
    		        $('#PatientOutput').show();
    		        $('#btnView').attr('disabled', false);
    		        $('#tablePatient tr').bind('mouseenter mouseleave', function () {
    		            $(this).toggleClass('hover');

    		        });
    		        $('#tablePatientCount td').bind('mouseenter mouseleave', function () {
    		            $(this).toggleClass('Counthover');
    		        });
    		    }
    		    function pageLoad(sender, args) {
    		        if (!args.get_isPartialLoad()) {
    		            // $addHandler(document, "keydown", onKeyDown);
    		        }
    		    };
    		    function bindPatientDetail(rowid) {
    		        var PanelInvoiceNo = $(rowid).closest('tr').find('#tdPanelInvoiceNo').text();
    		        $('#txtInvoiceNo').val(PanelInvoiceNo);
    		        closePatientSearchPopUpModel();
    		       // panelInvoiceSearch();
    		        clearPatientDetail();
    		    }
    		    function ChkDate() {
    		        $.ajax({
    		            url: "../Common/CommonService.asmx/CompareDate",
    		            data: '{DateFrom:"' + $('#txtFDSearch').val() + '",DateTo:"' + $('#txtTDSearch').val() + '"}',
    		            type: "POST",
    		            dataType: "json",
    		            contentType: "application/json; charset=utf-8",
    		            success: function (mydata) {
    		                var data = mydata.d;
    		                if (data == false) {
    		                    $('#spnOldPatient').text('To date can not be less than from date!');
    		                    $('#btnView').attr('disabled', 'disabled');
    		                }
    		                else {
    		                    $('#spnOldPatient').text('');
    		                    $('#btnView').removeAttr('disabled');
    		                }
    		            }
    		        });
    		    }
    		    function clearPatientDetail() {
    		        $('#txtSearchPatientID,#txtPatientFName,#txtPatientLname,#txtPhone,#txtSearchAddress,#txtIPDNo,#txtActIPDNo').val('');
    		        $('#PatientOutput').hide();
    		        $('#tablePatient,#spnOldPatient').html('');
    		        $("#PatientDetails").css("background-color", "");
    		    }   		 

		</script>

     <script type="text/javascript">
           var $bindPanel = function (callback) {
    		            serverCall('../Common/CommonService.asmx/bindPanel', {}, function (response) {
    		                var $ddlParentPanel = $('#ddlPanel');
    		                $ddlParentPanel.bindDropDown({ defaultValue: 'ALL', data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true });
    		                // $("#ddlPanel option[value='1']").chosen('destroy').remove().chosen();
    		            });
                    }
       </script>

</asp:Content>

