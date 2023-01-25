<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedicineOrders.aspx.cs" Inherits="Design_IPD_MedicineOrders" %>

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

    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div style="font-weight: bolder; font-size: 15px">
                    Active Medication
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
            </div>

            <div class="POuter_Box_Inventory">

                <div class="row">

                    <div class="col-md-3">
                        <label class="pull-left">From Date</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static" TabIndex="1"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">To Date</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Click To Select To Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                </div>


                <div class="row">

                    <div class="col-md-24" style="text-align: center;">

                        <input type="button" id="btnSearch" value="Search" onclick="GetOrderData()" />
                    </div>

                </div>


            </div>




            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Order  Details
                </div>

                <div id="LabOutput" style="max-height: 400px; overflow-y: auto; overflow-x: hidden;">
                    <table id="tblOrderData" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                        <thead>
                            <tr>
                                <td class="GridViewHeaderStyle">SN.</td>
                                <td class="GridViewHeaderStyle">Item Name</td>
                                <td class="GridViewHeaderStyle">Start Date Time</td>
                                <td class="GridViewHeaderStyle">Stop Date Time</td>
                                <td class="GridViewHeaderStyle">Requested Qty. </td>
                                <td class="GridViewHeaderStyle">Recived Qty. </td>
                                <td class="GridViewHeaderStyle">Given Qty. </td>
                                <td class="GridViewHeaderStyle">Remaining Qty. </td>

                                <td class="GridViewHeaderStyle">Status</td>
                                <td class="GridViewHeaderStyle">Action </td>

                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>

                </div>


            </div>

        </div>


        <div class="modal fade" id="myModal">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeRestartModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Model</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <label id="lblMOrderId" style="display: none"></label>
                            <label id="lblMItemId" style="display: none"></label>
                            <label id="lblMItemName" style="display: none"></label>

                            <div class="col-md-3">Dose Date :</div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtSelectDate" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtSelectDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">Dose Time :</div>
                            <div class="col-md-5">
                                <input type="text" id="txtStartTime" class="ItDoseTextinputText txtTime required" style="z-index: 10000001" />

                            </div>

                            <div class="col-md-4">Remaining Qty :</div>
                            <div class="col-md-4">
                                <label id="lblRemaingQty" style="display:none"></label>
                                 <label id="lblRemaingQtyDisplay"></label>

                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                Route :
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtMRoute" class="form-control btn-sm required" style="float: left;" />
                            </div>
                            <div class="col-md-3">
                                Frequency :
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtMFrequency" class="form-control btn-sm required" style="float: left;" />
                            </div>
                            <div class="col-md-3">
                                Dose :
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtMDose" class="form-control btn-sm required" style="float: left;" />
                            </div>

                        </div>


                        <div class="row">
                            <div class="col-md-3">
                                Qty. :
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtMQty" class="form-control btn-sm required" style="float: left;" onkeypress="return isNumber(event)" maxlength="4" autocomplete="off" />

                            </div>
                            <div class="col-md-3">
                                Remark :                           
                            </div>
                            <div class="col-md-13">

                                <textarea id="txtMRemark" class="form-control btn-sm required" cols="10" rows="1"></textarea>
                            </div>


                        </div>


                    </div>
                    <div class="modal-footer">
                        <input type="button" id="btnSave" onclick="Save()" value="Save" style="padding: 2px 5px; border: 1px solid transparent; font-size: 14px;" />
                    </div>
                </div>

            </div>
        </div>


    </form>

    <script type="text/javascript">


        function ClearModelData() {
            $("#lblMOrderId").text("");
          
            $("#txtMDose").val("");
            $("#txtMRoute").val("");
            $("#txtMFrequency").val("");

            $("#lblMItemId").text("");
            $("#lblMItemName").text("");
            $("#txtMQty").val("");
          $("#txtMRemark").val("");
          $("#lblRemaingQty").text("");
            $("#lblRemaingQtyDisplay").text("");
        }

        var Save = function () {
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
                Qty: $("#txtMQty").val(),
                Remark: $("#txtMRemark").val(),
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

            var remQty =  $("#lblRemaingQty").text();

            if (parseInt(remQty)< parseInt(data.Qty)) {
                modelAlert("Medicine Not Available");
                return false;
            }

            if (data.Dose == 0 || data.Dose == "" || data.Dose == undefined || data.Dose == null) {
                modelAlert("Enter Valid Dose");
                return false;
            }
            if (data.Qty == 0 || data.Qty == "" || data.Qty == undefined || data.Qty == null) {
                modelAlert("Enter Valid Qty.");
                return false;
            }
            if (data.Remark == "" || data.Remark == undefined) {
                modelAlert("Enter Remark.");
                return false;
            }


            serverCall('MedicineOrders.aspx/Medication', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        GetOrderData()
                        $closeRestartModel();

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


        var openRestartModel = function (id) {

            var Orid = $(id).closest('tr').find("#tbOrderID").text();
            var RemaingQty = $(id).closest('tr').find("#tbRemainingQty").text();
            var RemaingQtyDis = $(id).closest('tr').find("#tbRemainingQtyDis").text();

            var ItemId = $(id).closest('tr').find("#tbItemId").text();
            var ItemName = $(id).closest('tr').find("#tbItemName").text();


            $("#lblMOrderId").text(Orid);
            $("#lblMItemId").text(ItemId);
            $("#lblMItemName").text(ItemName);
            $("#lblRemaingQty").text(RemaingQty);
            $("#lblRemaingQtyDisplay").text(RemaingQtyDis);


            $("#myModal").showModel();
        }

        var $closeRestartModel = function () {
            ClearModelData();
            $("#myModal").hideModel();

        }



        $(document).ready(function () {

            BindPatientDetail();

            $('.txtTime').timepicker({
                timeFormat: 'h:mm p',
                interval: 1,
                minTime: '00:01',
                maxTime: '11:59pm',
                defaultTime: '00:01',
                startTime: '00:01',
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });

        });


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




        function GetOrderData() {

            serverCall('MedicineOrders.aspx/GetOrderData', { PatientId: $('#spnPatientID').text(), TransactionId: $("#spnTransactionID").text(), FromDate: $("#ucFromDate").val(), ToDate: $("#ucToDate").val() }, function (response) {
                console.log(response)

                var GetData = JSON.parse(response);

                if (GetData.status) {
                    data = GetData.data;
                    $('#tblOrderData tbody').empty();
                    $.each(data, function (i, item) {

                        var CanGiveMed = "";

                        if (item.CanGiveMedicne==0) {
                            CanGiveMed = "display:none;";
                        }
                        var rows = "";
                        rows += '<tr>';
                        rows += '<td class="GridViewLabItemStyle" >' + (++i) + '</td>';
                        rows += '<td class="GridViewLabItemStyle" style="display:none" id="tbPatientId">' + item.PatientId + '</td>';
                        rows += '<td class="GridViewLabItemStyle" style="display:none" id="tbOrderID">' + item.OrId + '</td>';
                        rows += '<td class="GridViewLabItemStyle" style="display:none" id="tbIndentNo">' + item.IndentNo + '</td>';

                        rows += '<td class="GridViewLabItemStyle" style="display:none" id="tbItemId">' + item.ItemId + '</td>';
                        rows += '<td class="GridViewLabItemStyle"  id="tbItemName">' + item.ItemName + '</td>';
                        rows += '<td class="GridViewLabItemStyle"  id="tbStartDate">' + item.StartDateTime + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbStopDate">' + item.StopDateTime + '</td>';
                        rows += '<td class="GridViewLabItemStyle"  id="tbRequestedQty">' + item.RequestedQty + '</td>';
                        rows += '<td class="GridViewLabItemStyle"  id="tbRecivedQty">' + item.RecivedQty + '</td>';
                        rows += '<td class="GridViewLabItemStyle"  id="tbGivenQty" style="display:none">' + item.GivenQty + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbGivenQtyDis">' + item.GivenQtyToDisplay + '</td>';
                        rows += '<td class="GridViewLabItemStyle"  id="tbRemainingQty" style="display:none">' + item.RemainingQty + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbRemainingQtyDis" >' + item.RemainingQtyDisplay + '</td>';

                        rows += '<td class="GridViewLabItemStyle"  id="tbStatus">' + item.Status + '</td>';
                        rows += '<td class="GridViewLabItemStyle" >  <div id="btnOpenPopup" onclick="openRestartModel(this)" style='+CanGiveMed+'> <img style="float: left; margin: 4px;" src="../../Images/Addnew.png" /></div> </td>';

                        rows += '</tr>';


                        $('#tblOrderData tbody').append(rows);
                    });

                }

                $('#tblOrderData').show();

            });
        }



    </script>

</body>
</html>

