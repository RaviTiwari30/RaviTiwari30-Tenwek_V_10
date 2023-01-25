<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewMedicationOrder.aspx.cs" Inherits="Design_IPD_ViewMedicationOrder" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Lab Result</title>
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Common.js" type="text/javascript"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js" type="text/javascript"></script>
    <link href="../../Styles/jquery-ui.css" rel="stylesheet" />


</head>
<body>

    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
    <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>

    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

            <div style="text-align: center;">
                <div class="row">
                    <div class="col-md-18" style="font-weight: bolder; font-size: 15px;">
                        Medication Administration Record
                    </div>
                    <div class="col-md-6">
                        <button id="btnOutsideMedicine" onclick="bindOutsideMedicine()" type="button" style="box-shadow: none;"><b style="margin-left: 4px; font-size: 12px">Outside Medicine</b> </button>
                        <a id="various2" style="display: none">Ajax</a>
                    </div>
                </div>
            </div>
                

                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" ClientIDMode="Static" Style="display: none"></asp:TextBox>

                <span id="spnPanelID" style="display: none"></span>
                <span id="spnTransactionID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnPatientID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnRoom_ID" style="display: none"></span>
                <span id="spnIPD_CaseTypeID" style="display: none"></span>
                <span id="spnReferenceCodeIPD" style="display: none"></span>
                <span id="spnPatientType" style="display: none"></span>
                <span id="spnScheduleChargeID" style="display: none"></span>
                <span id="spnGender" style="display: none"></span>
                <span id="spnPatientTypeID" style="display: none"></span>
                <span id="spnMembershipNo" style="display: none"></span>
                <span id="spnage" style="display: none;"></span>
                <span id="spnAdmitdate" style="display: none;"></span>



                <span id="spnCurrentDate" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnPreviousDate" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnNextDate" runat="server" clientidmode="Static" style="display: none"></span>

            </div>

            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-19">
                    <div class="row">
                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color: #f2f2009e; height: 10px; width: 26px;" />
                        </div>
                        <div class="col-md-5">Pending Indent</div>
                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color: #05593e9e; height: 10px; width: 23px" />
                        </div>
                        <div class="col-md-5">Indent Done</div>

                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color: #95f2009e; height: 10px; width: 23px" />
                        </div>
                        <div class="col-md-5">Transfered To Ward</div>
                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color: #5939059e; height: 10px; width: 23px" />
                        </div>
                        <div class="col-md-5">Medicine Discontinued</div>

                            <%-- <div class="col-md-1"><input type="button" onclick="GetFilteredData('Transfered To Ward')" class="circle" style="background-color:#95f2009e;height:10px;width:23px" /> </div>
                            <div class="col-md-5">Transfered To Ward</div>
                             <div class="col-md-1"><input type="button" onclick="GetFilteredData('Medicine Discontinued')" class="circle" style="background-color:#5939059e;height:10px;width:23px" /> </div>
                            <div class="col-md-5">Medicine Discontinued</div>
                             <div class="col-md-1"><input type="button" onclick="GetFilteredData('Indent Done')" class="circle" style="background-color:#05593e9e;height:10px;width:23px"/></div>
                            <div class="col-md-5">Indent Done</div>
                             <div class="col-md-1"><input type="button" onclick="GetFilteredData('Pending Indent')" class="circle" style="background-color:#f2f2009e;height:10px;width:26px;" /></div>
                            <div class="col-md-5">Pending Indent</div>--%>
                        </div>
                          <div class="row">
                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color: #99f7f79e; height: 10px; width: 26px;" />
                        </div>
                        <div class="col-md-5">Indent Need Approval</div>
                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color: #eb81819e; height: 10px; width: 23px" />
                        </div>
                        <div class="col-md-5">Indent Rejected</div>

                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color:#8989899e; height: 10px; width: 23px" />
                        </div>
                        <div class="col-md-5">Completed</div>

                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color: #ea2ce49e; height: 10px; width: 26px;" />
                        </div>
                        <div class="col-md-5">PRN Medicine</div>


                    </div>
                    <div class="row">
                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color: red; height: 10px; width: 23px" />
                        </div>
                        <div class="col-md-5">Missed</div>
                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color: green; height: 10px; width: 23px" />
                        </div>
                        <div class="col-md-5">On Time(within 1 Hour)</div>
                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color: #750ab8; height: 10px; width: 23px" />
                        </div>
                        <div class="col-md-5">Late(More than 1 Hr. after scheduled Time)</div>
                        <div class="col-md-1">
                            <input type="button" class="circle" style="background-color: black; height: 10px; width: 26px;" />
                        </div>
                        <div class="col-md-5">Up Coming</div>
                    </div>

                </div>
                <div class="col-md-5">
                    <div class="row">
                        <div class="col-md-10">
                            <input type="button" id="btnPrevious" value="Previous" onclick="GetPreviousDatedata()" style="float: right" />

                    </div>
                    <div class="col-md-6">
                        ...
                    </div>
                    <div class="col-md-8">
                        <input type="button" id="btnNext" value="Next" onclick="GetNextDateData()" style="float: left; margin-left: -28px;" />
                    </div>  
                        </div>

                    <div class="row" style="display: none">
                        <input type="checkbox" id="chkSelect" onclick="GetColorData()" checked="checked" />
                        <label for="chkIsColorIndication">Get Color Indication</label>
                    </div>
                    <div class="row">
                        <div class="col-md-1" style="margin-left: -20px;">
                            <input type="button" class="circle" style="background-color: #f5e5ab; height: 10px; width: 26px;" />
                        </div>
                        <div class="col-md-23" style="margin-left: 30px;">Emg Pending Indent</div>
                    </div>
                </div>

            </div>
        </div>


        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Medication  Details
            </div>

                <div id="DivMedOrderData" style="max-height: 400px; overflow-y: auto; overflow-x: auto;">
                </div>


            </div>

        </div>


        <div class="modal fade" id="ModelGiveMedicne">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 1200px;">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeGiveMedModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Model</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <label id="lblMOrderId" style="display: none"></label>
                            <label id="lblMItemId" style="display: none"></label>
                           
                            <div class="col-md-3">Medicine name :</div>
                            <div class="col-md-5">
                                  <label id="lblMItemName"></label>
                            
                            </div>

                            <div class="col-md-3">Dose Date :</div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtSelectDate" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required" ReadOnly="true"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtSelectDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-5">Dose Time :</div>
                            <div class="col-md-3">
                                <input type="text" id="txtStartTime" class="ItDoseTextinputText txtTime required" style="z-index: 10000001" disabled="disabled" />

                            </div>

                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                Dose :
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtMDose" class="form-control btn-sm required" style="float: left;" disabled="disabled" />
                            </div>
                            <div class="col-md-3">
                                Route :
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtMRoute" class="form-control btn-sm required" style="float: left;" disabled="disabled" />
                            </div>
                            <div class="col-md-5">
                                Frequency (Hrs./Day) :
                            </div>
                            <div class="col-md-3">
                                <input type="text" id="txtMFrequency" class="form-control btn-sm required" style="float: left;"  disabled="disabled"/>
                            </div>


                        </div>


                        <div class="row">
                            <%--<div class="col-md-3">
                                Qty. :
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtMQty" class="form-control btn-sm required" style="float: left;" onkeypress="return isNumber(event)" maxlength="4" autocomplete="off" />

                            </div>--%>

                            

                            <div class="col-md-3">
                                Is Given :                           
                            </div>
                            <div class="col-md-5">
                                <input type="checkbox" id="chkMIsGiven" name="chkMIsGiven" checked="checked" onclick="txtRemarkReq()"  />

                            </div>

                            <div class="col-md-3">
                                Remark :                           
                            </div>
                            <div class="col-md-13">

                                <textarea id="txtMRemark" class="form-control btn-sm" cols="10" rows="1"></textarea>
                            </div>


                        </div>

                        <div class="row">
                             <div class="col-md-3">
                                Primary Nurse:                           
                            </div>
                            <div class="col-md-5">
                                 <label id="lblMPrimaryNurseId" style="color:blue;font-weight:bolder;display:none"></label>
                                <label id="lblMPrimaryNurse" style="color:blue;font-weight:bolder"></label>
                            </div>
                             <div class="col-md-3">
                               Current Doctor/Nurse:                           
                            </div>
                            <div class="col-md-5">
                                 <label id="lblMPrimaryDoctor" style="color:blue;font-weight:bolder"></label>
                            </div>
                        </div>


                    </div>
                    <div class="modal-footer">
                        <input type="button" id="btnSave" onclick="Save()" value="Save" style="padding: 2px 5px; border: 1px solid transparent; font-size: 14px;" />
                    </div>
                </div>

            </div>
        </div>

        <div class="modal fade" id="myModal">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeRestartModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Medication Details Date Wise</h4>
                    </div>
                    <div class="modal-body">

                        <div id="DivOrderDetails" style="max-height: 400px; overflow-y: auto; overflow-x: hidden;">

                            <table id="tblMedicationGiven" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                                <thead>
                                    <tr>
                                        <td class="GridViewHeaderStyle">SNo.</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                        <td class="GridViewHeaderStyle">Route </td>
                                        <td class="GridViewHeaderStyle">Dose </td>
                                        <td class="GridViewHeaderStyle">Date </td>
                                        <td class="GridViewHeaderStyle">Time </td>
                                        <td class="GridViewHeaderStyle">Frequency </td>
                                        <td class="GridViewHeaderStyle">Is Given. </td>
                                        <td class="GridViewHeaderStyle">Remark. </td>
                                        <td class="GridViewHeaderStyle">Pri. Nurse </td>
                                         <td class="GridViewHeaderStyle">Given By </td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>



                        </div>


                    </div>
                    <div class="modal-footer">
                    </div>
                </div>

            </div>
        </div>



        <div class="modal fade" id="DoseMissingModel">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeMissingModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Medication Status Wise</h4>
                        <div class="row">
                            <div class="col-md-1">
                                <input type="button" class="circle" style="background-color: red; height: 10px; width: 23px" />
                            </div>
                            <div class="col-md-2">Missed</div>
                            <div class="col-md-1">
                                <input type="button" class="circle" style="background-color: green; height: 10px; width: 23px" />
                            </div>
                            <div class="col-md-6">On Time(within 1 Hour)</div>
                            <div class="col-md-1">
                                <input type="button" class="circle" style="background-color: orange; height: 10px; width: 23px" />
                            </div>
                            <div class="col-md-9">Late(After 1 hour before next time)</div>
                            <div class="col-md-1">
                                <input type="button" class="circle" style="background-color: white; height: 10px; width: 26px; color: black; border: solid" />
                            </div>
                            <div class="col-md-2">Pending</div>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <label id="lblOrderIdMiss" style="display: none"></label>
                            <label id="lblFrequencyMiss" style="display: none"></label>

                            <div class="col-md-3">
                                Date :
                            </div>
                             <div class="col-md-5">
                                <asp:TextBox ID="txtdateMissing" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                                <cc1:CalendarExtender ID="calMiss" runat="server" TargetControlID="txtdateMissing" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <input type="button" id="btnSearchMiss" onclick="SearchMissData()" value="Search" />
                            </div>
                        </div>


                        <div class="row" id="DoseMissingData" style="max-height: 400px; overflow-y: auto; overflow-x: hidden;">
                             
                        </div>


                    </div>
                    <div class="modal-footer">
                    </div>
                </div>

            </div>
        </div>






    </form>

    <script type="text/javascript">




        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }



        $(document).ready(function () {

            BindPatientDetail();
            GetColorData();
            txtRemarkReq();
        });

        function GetColorData() {
            var IsSelect = $('#chkSelect').is(":checked");
             
            if (IsSelect) {
                GetOrderData($('#spnPatientID').text(), $("#spnTransactionID").text(), $("#spnCurrentDate").text(), 0, "", 1);
            } else {
                GetOrderData($('#spnPatientID').text(), $("#spnTransactionID").text(), $("#spnCurrentDate").text(), 0, "", 0);
            }
        }

        var bindOutsideMedicine = function () {
            var patientID = '<%=Util.GetString(Request.QueryString["PatientId"])%>';
            var TID = '<%=Util.GetString(Request.QueryString["TID"])%>';
               // if (!String.isNullOrEmpty(patientID)) {
            $("#various2").attr('href', '../CPOE/MedicationRecordNew.aspx?PID=' + patientID +' &amp;TID= ' + TID);
               $("#various2").fancybox({
                   maxWidth: 1360,
                   maxHeight: 1400,
                   fitToView: false,
                   width: '100%',
                   height: '100%',
                   autoSize: false,
                   closeClick: false,
                   openEffect: 'none',
                   closeEffect: 'none',
                   'type': 'iframe'
               });
               $("#various2").trigger('click');
               // }
               //  else {
               //      modelAlert('No Previous Visit History Found !!!');
               // }
           }

        function GetNextDateData() {

            var IsSelect = $('#chkSelect').is(":checked");

            if (IsSelect) {
                GetOrderData($('#spnPatientID').text(), $("#spnTransactionID").text(), $("#spnNextDate").text(), 1, "", 1);

            } else {
                GetOrderData($('#spnPatientID').text(), $("#spnTransactionID").text(), $("#spnNextDate").text(), 1, "", 0);

            }
            
        }

        function GetPreviousDatedata() {

            var IsSelect = $('#chkSelect').is(":checked");

            if (IsSelect) {
                GetOrderData($('#spnPatientID').text(), $("#spnTransactionID").text(), $("#spnPreviousDate").text(), 0, "", 1);

            } else {
                GetOrderData($('#spnPatientID').text(), $("#spnTransactionID").text(), $("#spnPreviousDate").text(), 0, "", 0);

            }

           
        }



        function GetFilteredData(Status) {
            var IsSelect = $('#chkSelect').is(":checked");

            if (IsSelect) {
                GetOrderData($('#spnPatientID').text(), $("#spnTransactionID").text(), $("#spnCurrentDate").text(), 2, Status, 1);

            } else {
                GetOrderData($('#spnPatientID').text(), $("#spnTransactionID").text(), $("#spnCurrentDate").text(), 2, Status, 0);

            }

        }

        function BindPatientDetail() {
            $('#spnPanelID,#spnIPD_CaseTypeID,#spnReferenceCodeIPD,#spnReferenceCodeIPD,#spnReferenceCodeIPD,#spnScheduleChargeID,#spnPatientType,#spnGender,#spnPatientTypeID,#spnMembershipNo,#spnRoom_ID,#spnage,#spnAdmitdate').text('');
            jQuery.ajax({
                url: "Services/IPDLabPrescription.asmx/BindPatientDetails",
                data: '{TID:"' + $('#spnTransactionID').text() + '",PID:"' + $('#spnPatientID').text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = jQuery.parseJSON(result.d);
                    if (data != "") {
                        $('#spnPanelID').text(data[0].PanelID);
                        $('#spnPatientID').text(data[0].PatientID);

                        $('#spnIPD_CaseTypeID').text(data[0].IPDCaseTypeID);

                        $('#spnReferenceCodeIPD').text(data[0].ReferenceCode);
                        $('#spnScheduleChargeID').text(data[0].ScheduleChargeID);
                        $('#spnPatientType').text(data[0].PatientType);
                        $('#spnGender').text(data[0].Gender);
                        $('#spnPatientTypeID').text(data[0].PatientTypeID);
                        $('#spnMembershipNo').text(data[0].MemberShipCardNo);
                        $('#spnRoom_ID').text(data[0].RoomID);
                        $('#spnage').text(data[0].Age);
                        $('#spnAdmitdate').text(data[0].Dateofadmit);
                    }
                },
                error: function (xhr, status) {
                }
            });
        }




        function GetOrderData(Pid, Tid, FromDate, IsNext, Status, IsWithIndication) {
             
            serverCall('ViewMedicationOrder.aspx/GetOrderTable', { PatientId: Pid, Status: Status, TransactionId: Tid, FromDate: FromDate, IsNext: IsNext, IsWithIndication: IsWithIndication }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    data = GetData.data;
                    $('#DivMedOrderData').empty();
                    $('#DivMissedNotification').empty();

                    $('#DivMedOrderData').append(data);
                    $('#DivMissedNotification').append(GetData.Notdata);
                    $("#spnNextDate").text(GetData.NextDate);
                    $("#spnPreviousDate").text(GetData.PreviousDate)
                } else {
                    modelAlert(GetData.data);
                    $("#spnNextDate").text(GetData.NextDate);
                    $("#spnPreviousDate").text(GetData.PreviousDate)
                }

                $('#DivMedOrderData').show();

            });
        }

        var openRestartModel = function (id, orDate) {

            var Orid = $(id).closest('tr').find("#tdOrId").text();
            GetMedicationData(Orid, orDate);


            $("#myModal").showModel();
        }

        var $closeRestartModel = function () {
            $('#tblMedicationGiven tbody').empty();
            $("#myModal").hideModel();

        }



        function GetMedicationData(OrderID, orDate) {

            serverCall('ViewMedicationOrder.aspx/GetMedicationData', { OrderID: OrderID, OrderDate: orDate }, function (response) {
                console.log(response)

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    data = GetData.data;
                    $('#tblMedicationGiven tbody').empty();
                    $.each(data, function (i, item) {

                        var rows = "";
                        rows += '<tr>';
                        rows += '<td class="GridViewLabItemStyle" >' + (++i) + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbItemName">' + item.ItemName + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbRoute">' + item.Route + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbDose">' + item.Dose + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbDoseDate">' + item.DoseDate + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbDoseTime">' + item.DoseTime + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbFrequency">' + item.Frequency + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbIsGivenView">' + item.IsGivenView + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbRemark">' + item.Remark + '</td>';
                        rows += '<td class="GridViewLabItemStyle"  id="tbPrimaryNurse">' + item.PrimaryNurse + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbGivenBy">' + item.GivenBy + '</td>';
                     
                        
                        rows += '</tr>';


                        $('#tblMedicationGiven tbody').append(rows);
                    });

                }
                else {
                    $closeRestartModel();
                    modelAlert("No data Avilable.");

                }
                $('#tblMedicationGiven').show();

            });
        }



    </script>

    <script type="text/javascript">




        function ClearModelData() {
            $("#lblMOrderId").text("");

            $("#txtMDose").val("");
            $("#txtMRoute").val("");
            $("#txtMFrequency").val("");

            $("#lblMItemId").text("");
            $("#lblMItemName").text("");
            //$("#txtMQty").val("");
            $("#txtMRemark").val("");

        }

        var Save = function () {

            var IsGiven = 0;
            if ($('#chkMIsGiven').is(':checked')) {
                txtRemarkReq();
                IsGiven = 1;
            }
            if (IsGiven == 0) {
                if ($("#txtMRemark").val() == "" || $("#txtMRemark").val() == null) {
                    txtRemarkReq();
                    modelAlert("Enetr Remark");                    
                    return false;
                }
            }
            var data = {


                OrderId: $("#lblMOrderId").text(),
                Date: $("#txtSelectDate").val(),
                Time: $("#txtStartTime").val(),
                Dose: $("#txtMDose").val(),
                Route: $("#txtMRoute").val(),
                Frequency: $("#txtMFrequency").val(),
                PId: $("#spnPatientID").text(),
                Tid: $("#spnTransactionID").text(),
                ItemId: $("#lblMItemId").text(),
                ItemName: $("#lblMItemName").text(),
                Qty: 0,
                Remark: $("#txtMRemark").val(),
                IsGiven: IsGiven,
                PrimaryNurse:$("#lblMPrimaryNurse").text(),                
                PrimaryNurseId:$("#lblMPrimaryNurseId").text()
                    
            }

            if (data.OrderId == "") {
                modelAlert("Error Occured! Contact to administrator .");
                return false;
            }
            if (data.DoseTime == "") {
                modelAlert("Please Select  Time");
                return false;
            }
            if (data.Route == "") {
                modelAlert("Please Enter Route");
                return false;
            }
            if (data.Frequency == "") {
                modelAlert("Please Enter  Frequency");
                return false;
            }

            if (data.Dose == 0 || data.Dose == "" || data.Dose == undefined || data.Dose == null) {
                modelAlert("Enter Valid Dose");
                return false;
            }
            


            serverCall('ViewMedicationOrder.aspx/Medication', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {                       
                        GetColorData();
                        $closeGiveMedModel();

                    }
                });
            });
        }



        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }


        var openGiveMedModel = function (id) {

            var Orid = $(id).closest('tr').find("#tdOrId").text();
            var ItemId = $(id).closest('tr').find("#tdItemId").text();
            var ItemName = $(id).closest('tr').find("#tdMedicineName").text();
            var Route = $(id).closest('tr').find("#tdRoute").text();
            var Dose = $(id).closest('tr').find("#tdDose").text();
            var Frequency = $(id).closest('tr').find("#tdFrequency").text();
           
            $("#txtMFrequency").val(Frequency);

            $("#lblMOrderId").text(Orid);
            $("#lblMItemId").text(ItemId);
            $("#lblMItemName").text(ItemName);


            //var minutesToAdd = 0;
            //var currentDate = new Date();
            //var futureDate = new Date(currentDate.getTime() + minutesToAdd * 60000);
            //var now = futureDate;
            //var hours = now.getHours();
            //var minutes = now.getMinutes();
            //var ampm = hours >= 12 ? 'pm' : 'am';
            //hours = hours % 12;
            //hours = hours ? hours : 12;
            //minutes = minutes < 10 ? '0' + minutes : minutes;
            //var timewithampm = hours + ':' + (minutes) + ' ' + ampm;
             
            serverCall('ViewMedicationOrder.aspx/GetNowTime', {}, function (response) {
                var responseData = JSON.parse(response);
                $("#txtStartTime").val(responseData.time)
            });
             
            $("#txtMDose").val(Dose);
            $("#txtMRoute").val(Route);
            GetPrimaryNurse(Orid);
            $("#ModelGiveMedicne").showModel();
        }

        var $closeGiveMedModel = function () {
            ClearModelData();
            $("#ModelGiveMedicne").hideModel();

        }


        var openMissingModel = function (id) {

            var Orid = $(id).closest('tr').find("#tdOrId").text();
            var Frequency = $(id).closest('tr').find("#tdFrequency").text();

            GetMissingData(Orid, '', Frequency)
            $("#lblOrderIdMiss").text(Orid);
            $("#lblFrequencyMiss").text(Frequency);
            $("#DoseMissingModel").showModel();
        }

        var $closeMissingModel = function () {
            $('#tblMedicationGiven tbody').empty();
            $("#DoseMissingModel").hideModel();

        }

       
         

        function SearchMissData() {
             

             GetMissingData($("#lblOrderIdMiss").text(), $("#txtdateMissing").val(), $("#lblFrequencyMiss").text())
        }

        function GetMissingData(Id, Date, Freq) {

            serverCall('ViewMedicationOrder.aspx/GetMissingData', { OrderId: Id, Date: Date,Frequency:Freq }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    data = GetData.data;
                    $('#DoseMissingData').empty();
                     
                    $('#DoseMissingData').append(data);
                     
                }  

                $('#DoseMissingData').show();

            });
        }


        function txtRemarkReq() {

            var IsGiven = 0;
            if ($('#chkMIsGiven').is(':checked')) {
                $("#txtMRemark").removeClass("required");
                IsGiven = 1;
            }
            if (IsGiven == 0) {
                if ($("#txtMRemark").val() == "" || $("#txtMRemark").val() == null) {
                    
                    $("#txtMRemark").addClass("required");
                    return false;
                }
            }
        }





        function DiscontinueOrder(Id) {

            var Orid = $(Id).closest('tr').find("#tdOrId").text();

            modelConfirmation('Confirmation!!!', 'Are You Sure You Want To Discontinue The Order', 'Continue', 'Close', function (response) {
                if (response) {
                    serverCall('ViewMedicationOrder.aspx/DiscontinueOrder', { Id: Orid }, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData.status) {
                            modelAlert(responseData.response, function () {
                                GetColorData();
                            });
                        }
                        else { modelAlert(responseData.response); }
                    });
                }
            });
        }


        function GetPrimaryNurse(Id) {
 

            serverCall('ViewMedicationOrder.aspx/GetPrimaryNurse', { OrderId: Id }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    
                    $("#lblMPrimaryNurseId").text(responseData.NurseID);
                    $("#lblMPrimaryNurse").text(responseData.response);
                    $("#lblMPrimaryDoctor").text(responseData.CurrentDoctor);
                     
                } else {
                    $("#lblMPrimaryNurseId").text(responseData.NurseID);
                    $("#lblMPrimaryNurse").text(responseData.response);
                    $("#lblMPrimaryDoctor").text(responseData.CurrentDoctor);
                }
                 

            });
        }

    </script>



</body>
</html>


