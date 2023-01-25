<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="InvoiceCancelAfterSettelement.aspx.cs" Inherits="Design_Dispatch_InvoiceCancelAfterSettelement" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
     <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
              <b>  Invoice Cancel After Settlement </b><br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
        </div>

        <div class="POuter_Box_Inventory" style=" text-align: center;">
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
                         <asp:TextBox ID="txtInvoice"  runat="server" ClientIDMode="Static" MaxLength="30"  CssClass="requiredField"></asp:TextBox>
                        </div>
                         <div class="col-md-3">
                             <input id="btnSearch" type="button" onclick="panelInvoiceSearch()" value="Search" class="ItDoseButton" style="width: 60px;"  />
                         </div>
                              <div class="col-md-3">
                                  <input type="button" id="btnOldPatient"  class="ItDoseButton"   value="Old Patient"/>
                              </div>
                        <div class="col-md-10"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
           
        </div>
         <div class="POuter_Box_Inventory" id="panelInvoice" style="display:none" >

            <div class="Purchaseheader" >
               Invoice Details
            </div>
             
             <table style="width: 100%">
                 <tr>
                     <td style="width: 20%;text-align:right">Panel Name :&nbsp;</td>
                     <td style="width: 30%;text-align:left"><asp:Label CssClass="ItDoseLabelSp" ID="lblPanelName" runat="server" ClientIDMode="Static"></asp:Label></td>
                     <td style="width: 20%;text-align:right" colspan="2"></td>
                     <td style="width: 30%;text-align:left"<asp:Label ID="lblPanelID" Style="display:none" runat="server" ClientIDMode="Static"></asp:Label></td>
                 </tr>
                
                 <tr>
                     <td style="width: 20%;text-align:right">Invoice Amount :&nbsp;</td>
                     <td style="width: 30%;text-align:left"><asp:Label ID="lblInvoiceAmount" CssClass="ItDoseLabelSp" runat="server" ClientIDMode="Static" ></asp:Label></td>
                     <td style="width: 20%;text-align:right" colspan="2">Received Amount :&nbsp;</td>
                     <td style="width: 30%;text-align:left"><asp:Label ID="lblreceivedAmount" CssClass="ItDoseLabelSp" runat="server"  ClientIDMode="Static"></asp:Label></td>
                 </tr>
                 <tr>
                     <td style="width: 20%;text-align:right">TDS :&nbsp;</td>
                     <td style="width: 30%;text-align:left"><asp:Label ID="lblTDS" runat="server"  CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label></td>
                     <td style="width: 20%;text-align:right" colspan="2">Writeoff :&nbsp;</td>
                     <td style="width: 30%;text-align:left"><asp:Label ID="lblWriteoff" runat="server" CssClass="ItDoseLabelSp"  ClientIDMode="Static"></asp:Label></td>
                 </tr>
                 <tr>
                     <td style="width: 20%;text-align:right">Deduction Amt. :&nbsp;</td>
                     <td style="text-align:left"><asp:Label ID="lblDeducationAmt" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label></td>
                     <td style="width: 20%;text-align:right" colspan="2">Type :&nbsp;</td>
                     <td colspan="2" style="text-align:left"><asp:Label ID="lblPatientType" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label></td>
                 </tr>
             </table>  
            
        
            <div id="divInvoiceDetail" style="max-height: 350px; overflow: auto;">
            </div>
      
             
             <table>
                 <tr>
                     <td style="text-align: right; width: 20%;">Cancel Reason :&nbsp;</td>
                    <td style="text-align: left" colspan="3">
                        <asp:TextBox ID="txtCancelReason" runat="server" Width="540px" MaxLength="100" ClientIDMode="Static" CssClass="requiredField" ></asp:TextBox>
                    </td>
                </tr>
             </table>
            
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

        function hideDetail() {
            $('#divInvoiceDetail').html('');
            $('#divInvoiceDetail,#panelInvoice').hide();
            $("#lblPanelName,#lblInvoiceAmount,#lblreceivedAmount,#lblTDS,#lblWriteoff,#lblDeducationAmt,#lblPatientType").text('');
            
        }

        function panelInvoiceSearch() {
            if ($.trim($("#txtInvoice").val()) == "") {
                $("#spnErrorMsg").text('Please Enter Invoice No.');
                $("#txtInvoice").focus();
                return;
            }

            $.ajax({
                url: "Services/Panel_Invoice.asmx/InvoiceCancelData",
                data: '{InvoiceNo: "' + $("#txtInvoice").val() + '"}',  
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async:false,
                success: function (result) {
                    panelInvoiceData = jQuery.parseJSON(result.d);
                    if (panelInvoiceData != null) {
                        var output = jQuery('#td_InvoiceDetail').parseTemplate(panelInvoiceData);
                        $('#divInvoiceDetail').html(output);
                        $('#divInvoiceDetail,#panelInvoice').show();
                        $("#lblPanelName").text(panelInvoiceData[0]["Company_Name"]);
                        $("#lblInvoiceAmount").text(panelInvoiceData[0]["InvoiceAmount"]);
                        $("#lblreceivedAmount").text(panelInvoiceData[0]["PreReceivedAmount"]);
                        $("#lblTDS").text(panelInvoiceData[0]["PreTDSAmount"]);
                        $("#lblWriteoff").text(panelInvoiceData[0]["PreWriteOffAmount"]);
                        $("#lblDeducationAmt").text(panelInvoiceData[0]["PrededucationAmt"]);
                        $("#lblPatientType").text(panelInvoiceData[0]["PatientType"]);
                        $("#spnErrorMsg").text('');
                       
                    }
                    else {
                        hideDetail();
                        DisplayMsg('MM04', 'spnErrorMsg');
                    }
                    
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'spnErrorMsg');
                }
            });
        }

       
       
    </script>
    <script id="td_InvoiceDetail" type="text/html">
             
   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" 
    style="border-collapse:collapse;width:99%">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">InvoiceNo</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Received Amt.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">TDS Amt.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">WriteOff Amt.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Deduction Amt.</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Invoice Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Entry By</th>
            <th class="GridViewHeaderStyle" scope="col"  style="display:none">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Remove</th>
            
</tr>
       <#
              var invoiceLength=panelInvoiceData.length;
              window.status="Total Records Found :"+ invoiceLength;
              var objRow; 
              for(var k=0;k<invoiceLength;k++)
               {                 
                  objRow = panelInvoiceData[k];   
        #>
                    <tr id="<#=objRow.InvoiceNo#>">
<td class="GridViewLabItemStyle"><#=k+1#></td>

<td id="tdInvoiceNo"  class="GridViewLabItemStyle"><#=objRow.invoiceNo#></td>
<td id="tdReceivedAmt"  class="GridViewLabItemStyle" style="width:160px;text-align:right"><#=objRow.ReceivedAmount#></td>
<td id="tdTDS"  class="GridViewLabItemStyle" style="width:150px;text-align:right"><#=objRow.TDSAmount#></td>
<td id="tdWriteOff"  class="GridViewLabItemStyle" style="width:150px;text-align:right"><#=objRow.writeOff#></td>
<td id="tdDeduction"  class="GridViewLabItemStyle" style="width:150px;text-align:right"><#=objRow.DeducationAmt#></td>
<td id="tdInvoiceDate"  class="GridViewLabItemStyle" style="width:120px;text-align:center"><#=objRow.invoiceDate#></td>
<td id="tdEntryBy"  class="GridViewLabItemStyle" style="width:200px;text-align:center"><#=objRow.EntryBy#></td>
<td  id="tdID" class="GridViewLabItemStyle" style="display:none"><#=objRow.ID#></td>
<td id="tdRemove" class="GridViewLabItemStyle" style="text-align:center;cursor:pointer"><img id="view" src="../../Images/Delete.gif" onclick="InvoiceCancel(this);" /></td>


</tr>
            <#}#>
     </table>    
    </script>    
         
         <script  type="text/javascript">
             function InvoiceCancel(rowID) {
                 if ($("#<%=txtCancelReason.ClientID %>").val() == "") {
                     modelAlert('Please Enter Cancel Reason');
                     $("#<%=txtCancelReason.ClientID %>").focus();
                     return;
                 }
                 var con = 0;
                 var Ok = confirm('Are You Sure ?');
                 if (!Ok) {
                     con = 1;
                     return;
                 }
                 if (con == "0") {
                     $("#spnErrorMsg").text('');
                     var accID = $(rowID).closest('tr').find('#tdID').text();
                     var receivedAmt = $(rowID).closest('tr').find('#tdReceivedAmt').text();
                     var writeOffAmt = $(rowID).closest('tr').find('#tdWriteOff').text();
                     var TDSAmt = $(rowID).closest('tr').find('#tdTDS').text();
                     var decAmt = $(rowID).closest('tr').find('#tdDeduction').text();
                     var invoiceNo = $(rowID).closest('tr').find('#tdInvoiceNo').text();
                     var Type = $("#lblPatientType").text();
                     $.ajax({
                         url: "Services/Panel_Invoice.asmx/InvoiceCancel",
                         data: '{InvoiceNo: "' + invoiceNo + '",ID: "' + accID + '",receivedAmt: "' + receivedAmt + '",tdsAmt: "' + TDSAmt + '",writeOff: "' + writeOffAmt + '",decAmt: "' + decAmt + '",cancelReason:"' + $("#txtCancelReason").val() + '",Type:"' + Type + '"}',
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         timeout: 120000,
                         dataType: "json",
                         success: function (result) {

                             if (result.d != 0) {
                                 panelInvoiceSearch();
                                 $("#txtCancelReason").val('');
                                 DisplayMsg('MM01', 'spnErrorMsg');
                             }
                             else {
                                 DisplayMsg('MM05', 'spnErrorMsg');
                             }
                         },
                         error: function (xhr, status) {
                             DisplayMsg('MM05', 'spnErrorMsg');
                         }
                     });
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
                data: '{PatientID:"' + $.trim($("#txtSearchPatientID").val()) + '",PName:"' + $.trim($("#txtPatientFName").val()) + '",LName:"' + $.trim($("#txtPatientLname").val()) + '",ContactNo:"' + $.trim($("#txtPhone").val()) + '",Address:"' + $.trim($("#txtSearchAddress").val()) + '",FromDate:"' + $.trim($("#txtFDSearch").val()) + '",ToDate:"' + $.trim($("#txtTDSearch").val()) + '",invoiceSetellment:"' + 2 + '",PanelID:"' + $('#ddlPanel').val() + '" }',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    OldPatient = jQuery.parseJSON(response.d);
                    if (OldPatient != null) {
                        _PageCount = OldPatient.length / _PageSize;
                        showPage('0');
                    }
                    else {
                        DisplayMsg('MM04', 'spnOldPatient');
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
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($('#OldPatientSearchPopUp').length > 0) {
                    $('#OldPatientSearchPopUp').animate({ top: -500 }, 500);
                    clearPatientDetail();
                }
            }
        };
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
            $("#PatientDetails").css("background-color", "");
        }
        </script>
        <script id="tb_OldPatient" type="text/html">
    <table  id="tablePatient" cellspacing="0" rules="all" border="1" border-collapse:collapse; ">
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
            <th class="GridViewHeaderStyle" scope="col" style=" display:none">Email</th>
            <th class="GridViewHeaderStyle" scope="col" style=" display:none">Country</th>
            <th class="GridViewHeaderStyle" scope="col" style=" display:none">City</th>
            <th class="GridViewHeaderStyle" scope="col" style=" display:none">DOB</th>
            <th class="GridViewHeaderStyle" scope="col" style=" display:none">Relation</th>
            <th class="GridViewHeaderStyle" scope="col" style=" display:none">RelationName</th>
            <th class="GridViewHeaderStyle" scope="col" style=" display:none">PanelID</th>
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
                        <td class="GridViewLabItemStyle" id="tdEmailID" style="display:none"><#=objRow.Email#></td>
                        <td class="GridViewLabItemStyle" id="tdCountry" style="display:none"><#=objRow.Country#></td>
                        <td class="GridViewLabItemStyle" id="tdCity" style="display:none"><#=objRow.City#></td>
                        <td class="GridViewLabItemStyle" id="tdDOB" style="display:none"><#=objRow.DOB#></td>
                        <td class="GridViewLabItemStyle" id="tdRelation" style="display:none"><#=objRow.Relation#></td>
                        <td class="GridViewLabItemStyle" id="tdRelationName" style="display:none"><#=objRow.RelationName#></td>
                        <td class="GridViewLabItemStyle" id="tdOldPatientPanelID" style="display:none"><#=objRow.PanelID#></td>
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

