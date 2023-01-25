<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DispatchCancel.aspx.cs" Inherits="Design_Dispatch_DispatchCancel" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Panel Invoice Cancel </b>
            <br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Invoice No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInvoice" runat="server" Width="95%" ClientIDMode="Static" MaxLength="30" CssClass="requiredField"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <input id="btnSearch" type="button" onclick="panelInvoiceSearch()" value="Search" class="ItDoseButton" style="width: 60px;" />
                        </div>
                        <div class="col-md-3">
                            <input type="button" id="btnOldPatient" class="ItDoseButton" value="Old Patient" />
                        </div>
                        <div class="col-md-10"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

        </div>
        <div id="divData" style="display: none">
            
            <div class="POuter_Box_Inventory" style="text-align: center;">
                 <div class="row">
                    <div class="col-md-2"></div>
                    <div class="col-md-20">
                        <div id="divInvoiceDetail" style="max-height: 350px; overflow: auto;">
                        </div>
                    </div>
                     <div class="col-md-2"></div>
                </div>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center; display: none" id="divCancel">
                 <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-20">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Cancel Reason 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-16">
                              <asp:TextBox ID="txtCancelReason" runat="server" MaxLength="100" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                             <span id="spnType" style="display: none"></span><span id="spnPanelInvoiceNo" style="display: none"></span>
                        </div>
                        <div class="col-md-4">
                             <input type="button" class="ItDoseButton" id="btnSave" value="Cancel Invoice" onclick="cancelDispatch()" />
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="col-md-3"></div>
            </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $("#txtInvoice").focus();

            showPatientSearchPopUpModel = function () {
                $('#divPatientSearchPopUpModel').showModel();
            }
            closePatientSearchPopUpModel = function () {
                $('#divPatientSearchPopUpModel').hideModel();
            }

            $bindPanel(function () { });
        });

        var $bindPanel = function (callback) {
            serverCall('../Common/CommonService.asmx/bindPanelRoleWisePanelGroupWise', { Type: 2 }, function (response) {
                var $ddlPanel = $('#ddlPanel');
                $ddlPanel.bindDropDown({ defaultValue: 'ALL', data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true });
            });
        }
    </script>


    <script type="text/javascript">

        function panelInvoiceSearch() {
            if ($.trim($("#txtInvoice").val()) == "") {
                $("#spnErrorMsg").text('Please Enter Invoice No.');
                $("#txtInvoice").focus();
                return;
            }
            $("#spnErrorMsg").text('');
            ////$.blockUI({ message: 'Please Wait.....\n<img src="../../Images/loadingAnim.gif" />' });
            $('#divInvoiceDetail').html('');
            $.ajax({
                url: "Services/Panel_Invoice.asmx/dispatchCancelData",
                data: '{InvoiceNo: "' + $.trim($("#txtInvoice").val()) + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    dispatchData = (result.d);
                    if (dispatchData == "1") {
                        $("#divCancel,#divData").show();
                        $("#txtCancelReason").focus();
                        dispatchAllData();

                    }

                    else {
                        $("#divCancel").hide();
                        $("#spnErrorMsg").text('This Invoice No. Already Settled/ Cancelled');
                    }

                    //$.unblockUI();
                },
                error: function (xhr, status) {
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    //$.unblockUI();
                }
            });
        }
    </script>

    <script type="text/javascript">
        function dispatchAllData() {
            $.ajax({
                url: "Services/Panel_Invoice.asmx/dispatchData",
                data: '{InvoiceNo: "' + $.trim($("#txtInvoice").val()) + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    panelInvoiceData = jQuery.parseJSON(result.d);
                    if (panelInvoiceData != null) {
                        var output = jQuery('#td_InvoiceDetail').parseTemplate(panelInvoiceData);
                        $('#divInvoiceDetail').html(output);
                        $('#divInvoiceDetail').show();
                        $("#spnType").text(panelInvoiceData[0].Type);

                        $("#spnPanelInvoiceNo").text(panelInvoiceData[0].PanelinvoiceNo);
                    }

                },
                error: function (xhr, status) {
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                    $("#spnType,#spnPanelInvoiceNo").text('');
                    //$.unblockUI();
                }
            });
        }
    </script>
    <script id="td_InvoiceDetail" type="text/html">
   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" style="border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Bill No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Type</th>
			<th class="GridViewHeaderStyle" scope="col"  style="width:200px;" >Panel Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Panel Amount</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Dispatch Date</th>

        </tr>
                   <#
                          var invoiceLength=panelInvoiceData.length;
                          window.status="Total Records Found :"+ invoiceLength;
                          var objRow; 
                          for(var k=0;k<invoiceLength;k++)
                           {                 
                              objRow = panelInvoiceData[k];   
                    #>
        <tr>
            <td class="GridViewLabItemStyle"><#=k+1#></td>
            <td id="tdPatientID"  class="GridViewLabItemStyle" style="width:100px"><#=objRow.PatientID#></td>
            <td id="tdBillNo" style="text-align:center"  class="GridViewLabItemStyle"><#=objRow.BillNo#></td>
            <td id="tdType" style="width:100px;text-align:center"  class="GridViewLabItemStyle"><#=objRow.Type#></td>
            <td id="tdInvoiceNo" style="text-align:center;display:none"  class="GridViewLabItemStyle"><#=objRow.PanelinvoiceNo#></td>
                      
            <#
            if(k>0)
              {
                if(panelInvoiceData[k].PanelID!=panelInvoiceData[k-1].PanelID)
                {#>
                             <td class="GridViewLabItemStyle"    style="text-align:center" ><#=objRow.Company_Name#></td>

                <#}
                else
                {#>
               <td class="GridViewLabItemStyle"   style="text-align:center" >&nbsp;</td>
                <#}
              }
            else
                {#>
                <td class="GridViewLabItemStyle"   style="text-align:center" ><#=objRow.Company_Name#></td>
                <#}
                #>
            <td id="tdPanelAmount"  class="GridViewLabItemStyle" style="text-align:center"><#=objRow.PanelAmount#></td>
               <#
               if(k>0)
              {
                if(panelInvoiceData[k].DispatchDate!=panelInvoiceData[k-1].DispatchDate)
                {#>
                             <td class="GridViewLabItemStyle"    style="text-align:center" ><#=objRow.DispatchDate#></td>

                <#}
                else
                {#>
               <td class="GridViewLabItemStyle"   style="text-align:center" >&nbsp;</td>
                <#}
              }
            else
                {#>
                <td class="GridViewLabItemStyle"   style="text-align:center" ><#=objRow.DispatchDate#></td>
                <#}
                #>
      </tr>
      <#}#>
  </table>    
  </script> 
    <script type="text/javascript">
        function cancelDispatch() {
            if ($.trim($("#txtCancelReason").val()) == "") {
                $("#spnErrorMsg").text('Please Enter Cancel Reason');
                $("#txtCancelReason").focus();
                return;
            }
            var PanelInvoiceNo = $.trim($("#spnPanelInvoiceNo").text());
            var type = $.trim($("#spnType").text());
            if ((PanelInvoiceNo != "") && (type != "")) {
                $("#btnSave").val('Submitting....').attr('disabled', 'disabled');
                //$.blockUI({ message: 'Please Wait.....\n<img src="../../Images/loadingAnim.gif" />' });
                $.ajax({
                    url: "Services/Panel_Invoice.asmx/dispatchCancel",
                    data: '{InvoiceNo: "' + PanelInvoiceNo + '",cancelReason:"' + $.trim($("#txtCancelReason").val()) + '",type:"' + type + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        dispatch = (result.d);
                        if (dispatch == 1) {
                            $("#spnErrorMsg").text('Record Saved Successfully');
                            $("#divCancel,#divData").hide();
                            $("#txtCancelReason,#txtInvoice").val('');
                            $("#txtInvoice").focus();
                            modelAlert('Record Saved Successfully');
                        }
                        else {
                            $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                            modelAlert('Error occurred, Please contact administrator');
                        }
                        //$.unblockUI();
                        $("#btnSave").val('Cancel Invoice').removeAttr('disabled');
                    },
                    error: function (xhr, status) {
                        $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                        //$.unblockUI();
                        $("#btnSave").val('Cancel Invoice').removeAttr('disabled');
                        modelAlert('Error occurred, Please contact administrator');
                    }
                });
            }

            else {
                $("#spnErrorMsg").text('Error occurred, Please contact administrator');

            }
        }
    </script>
    <script type="text/javascript">
        $('#btnOldPatient').click(function (e) {
            showPatientSearchPopUpModel();
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
                url: "Services/Panel_Invoice.asmx/oldPatientSearch",
                data: '{PatientID:"' + $.trim($("#txtSearchPatientID").val()) + '",PName:"' + $.trim($("#txtPatientFName").val()) + '",LName:"' + $.trim($("#txtPatientLname").val()) + '",ContactNo:"' + $.trim($("#txtPhone").val()) + '",Address:"' + $.trim($("#txtSearchAddress").val()) + '",FromDate:"' + $.trim($("#txtFDSearch").val()) + '",ToDate:"' + $.trim($("#txtTDSearch").val()) + '",invoiceSetellment:"' + 0 + '",PanelID:"' + $('#ddlPanel').val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    OldPatient = jQuery.parseJSON(response.d);
                    if (OldPatient != null) {
                        _PageCount = OldPatient.length / _PageSize;
                        showPage('0');
                    }
                    else {
                        $("#spnErrorMsg").text('Record Not Found');
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
        //function pageLoad(sender, args) {
        //    if (!args.get_isPartialLoad()) {
        //        $addHandler(document, "keydown", onKeyDown);
        //    }
        //}
        function bindPatientDetail(rowid) {
            var PanelInvoiceNo = $(rowid).closest('tr').find('#tdPanelInvoiceNo').text();
            $('#txtInvoice').val(PanelInvoiceNo);
            panelInvoiceSearch();
            clearPatientDetail();
            closePatientSearchPopUpModel(function () { });
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

        }
    </script>
    <script id="tb_OldPatient" type="text/html">
    <table  id="tablePatient" cellspacing="0" rules="all" border="1" style="border-collapse:collapse; ">
        <thead>
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Select</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Panel Invoice No.</th>
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
                        <tr id="Tr2" >                            
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
    <div id="divPatientSearchPopUpModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 1100px">
                <div class="modal-header">
                    <button type="button" class="close" onclick="closePatientSearchPopUpModel()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Old Patient Search</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24" style="text-align: center;">
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">UHID </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <input type="text" id="txtSearchPatientID" title="Enter UHID" maxlength="20"  />
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Contact No.</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <input type="text" id="txtPhone" title="Enter Contact No." maxlength="15" />
                                     
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">First Name </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <input type="text" id="txtPatientFName" title="Enter First Name" maxlength="100" />
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Last Name </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <input type="text" id="txtPatientLname" title="Enter Last Name" maxlength="100" />
                                </div>
                            </div>

                             <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">Address </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <input type="text" id="txtSearchAddress" title="Enter Address" maxlength="50" />
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Panel </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <select id="ddlPanel"></select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">From Date </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtFDSearch" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="txtFDSearch" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">To Date </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtTDSearch" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date " ></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="txtTDSearch" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </div>
                            </div>
                            <div style="text-align: center" class="row">
                                <input type="button" id="btnView" value="Search" class="ItDoseButton" title="Click to Search" onclick="oldPatientSearch()" />
                            </div>
                            <div style="height: 150px" class="row">
                                <div id="PatientOutput" class="col-md-24">
                                </div>

                            </div>

                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="row">
                        <button type="button" onclick="closePatientSearchPopUpModel()">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

