<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LabReportDispatch.aspx.cs" Inherits="Design_Lab_LabReportDispatch" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Lab/Popup.ascx" TagName="PopUp" TagPrefix="uc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
   
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Laboratory Help Desk</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Option
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:DropDownList ID="ddlSearchType" runat="server" ClientIDMode="Static" >
                                    <asp:ListItem Value="pli.BarcodeNo" Selected="True">Barcode No.</asp:ListItem>
                                    <asp:ListItem Value="pli.PatientID">UHID No.</asp:ListItem>
                                    <asp:ListItem Value="pm.Pname">Patient Name</asp:ListItem>
                                </asp:DropDownList>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBarcodeNo" data-title="Enter Barcode No." autocomplete="off" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtUHID" data-title="Enter UHID No." autocomplete="off" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlLabDepartment" data-title="Select Department"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" data-title="Select From Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" data-title="Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Test</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlinvestigation" data-title="Select Test"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Center</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCentreAccess"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Doctor</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDoctor"></select>
                        </div>
                        <div class="col-md-8" style="text-align: right">
                         
                            <input type="checkbox" id="chkEmail" style="vertical-align: middle" /><strong style="vertical-align: middle;">Email</strong>&nbsp;
                            <input type="checkbox" id="chksms" style="vertical-align: middle" /><strong style="vertical-align: middle;">SMS</strong>
                              <b>&nbsp;&nbsp;&nbsp;
                               <select id="ddlPatientType" style="width: 80px">
                                   <option value="pli.Type=1">OPD</option>
                                   <option value="pli.Type=2">IPD</option>
                                   <option value="pli.Type=3">Emergency</option>
                                   <option value="" selected="selected">ALL</option>
                               </select>
                    </b>
                        </div>
                    </div>
                     <div class="row">
                            <div class="col-md-3">
                            <label class="pull-left">Patient Mobile</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" id="txtPatientMobile" data-title="Enter Patient Mobile." autocomplete="off" />
                        </div>
                    </div>
                    <div class="row" >
                        <center>
                           <input type="button" onclick="PatientLabSearch('');" value="Search" id="btnsearch" />&nbsp;
                             <input type="checkbox" id="chheader" style="display: none" /><strong style="vertical-align: middle; display: none">Header</strong>
                            <input id="btnPreview" type="button" value="Preview" class="resetbutton" onclick="PrintReport('1')" />&nbsp;
                            <input id="btnprint" type="button" value="Print" class="resetbutton" onclick="PrintReport('0')" />&nbsp;
                            <input id="Button1" type="button" value="Dispatch" class="resetbutton" onclick="DispatchReport('0')" />
                            <input id="Button2" type="button" value="Print Outsource Report" class="resetbutton" onclick="printOutsourceReport('0')" />
                            </center>
                    </div>

                </div>
            </div>
            <div class="row" style="margin-left:50px;">
                <center>
                <div class="col-md-22" style="width:1350px;">
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #CC99FF;" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">New</b>
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: bisque;" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Sample Collected</b>
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #FF0000;" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Sample Rejected</b>
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: White;" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Department Receive</b>
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #FFC0CB;" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Tested</b>
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #90EE90;" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Approved</b>
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #00FFFF;" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Printed</b>
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #44A3AA;" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Dispatched</b>
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #993300;" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Abnormal</b>
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #99a300;" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Critical</b> 
                </div>
                    </center>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Details
                &nbsp;&nbsp;
                  <span style="font-weight: bold; color: red;">Total Record:&nbsp;</span><span id="testcount" style="font-weight: bold; color: red;"></span>
            </div>
            <div id="PagerDiv1" style="display: none; background-color: white; width: 99%; padding-left: 7px;">
            </div>
            <div class="row">
                <div style="overflow: auto; max-height: 320px" id="divSampleDDetails" class="col-md-24">
                    <table style="width: 100%; border-collapse: collapse" id="tb_ItemList" class="GridViewStyle">
                        <tr id="header">
                            <td class="GridViewHeaderStyle" style="width: 30px">S.No.</td>
                            <td class="GridViewHeaderStyle" style="width: 120px">Entry DateTime</td>
                            <td class="GridViewHeaderStyle" style="width: 120px">UHID</td>
                            <td class="GridViewHeaderStyle" style="width: 100px">Barcode No.</td>
                            <td class="GridViewHeaderStyle" style="width: 200px">Patient Name</td>
                            <td class="GridViewHeaderStyle" style="width: 200px">Patient Mobile</td>
                            <td class="GridViewHeaderStyle" style="width: 90px">Age/Sex</td>
                            <td class="GridViewHeaderStyle" style="width: 150px">Booking Centre</td>
                            <td class="GridViewHeaderStyle" style="width: 150px">Dispatch Mode</td>
                            <td class="GridViewHeaderStyle" style="width: 150px">Patient Type</td>
                            <td class="GridViewHeaderStyle" style="width: 150px">Doctor</td>
                            <td class="GridViewHeaderStyle" style="width: 150px">Department</td>
                            <td class="GridViewHeaderStyle" style="width: 150px">Investigation</td>
                            <td class="GridViewHeaderStyle" style="width: 30px"></td>
                            <td class="GridViewHeaderStyle" style="width: 30px">Outsource</td>
                            <td class="GridViewHeaderStyle" style="width: 30px">Attachment</td>
                            <%--<td class="GridViewHeaderStyle" style="width:20px">Remarks</td>--%>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
          <uc1:PopUp id="popupctrl" runat="server" />   
    </div>
    <script type="text/javascript">
        var TestData = "";
        var _PageSize = 100;
        var _PageNo = 0;
        var _StartIndex = 0;
        var _EndIndex = 0;
        var testcount = 0;
        var colorcode1 = '0';
        function getsearchdata() {
            var dataPLO = new Array();
            dataPLO[0] = $('#txtBarcodeNo').val();
            dataPLO[1] = $('#txtUHID').val();
            dataPLO[2] = $('#ddlLabDepartment').val();
            dataPLO[3] = $('#FrmDate').val();
            dataPLO[4] = $('#ToDate').val();
            dataPLO[5] = $('#ddlinvestigation').val();
            dataPLO[6] = $('#ddlCentreAccess').val();
            dataPLO[7] = $('#ddlDoctor').val();
            dataPLO[8] = $('#ddlSearchType').val();
            dataPLO[9] = $('#ddlPatientType').val();
            dataPLO[10] = $('#txtPatientMobile').val();
            return dataPLO;
        }
        function PatientLabSearch(colorcode) {
            colorcode1 = colorcode;
            var searchdata = getsearchdata();
            $('#tb_ItemList tr').slice(1).remove();
            _PageNo = 0;
         // //    $.blockUI();
            $.ajax({
                url: "LabReportDispatch.aspx/SearchPatient",
                data: JSON.stringify({ searchdata: searchdata, colorcode: colorcode, PageNo: _PageNo, PageSize: _PageSize }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    TestData = $.parseJSON(result.d);
                    if (TestData.length == 0) {
                      //    $.unblockUI();
                        modelAlert("No Data Found..!", function () {
                            $('#testcount').html('0');
                            $('#PagerDiv1').html('');
                            $('#PagerDiv1').hide();
                        });
                        return;
                    }
                    else {
                        testcount = parseInt(TestData[0].TotalRecord);
                        $('#testcount').html(testcount);
                        _PageNo = TestData[0].TotalRecord / _PageSize;
                        var barcodeno = "";
                        var dataLength = TestData.length;
                        for (var i = 0; i < TestData.length; i++) {

                            var divcolor = "";
                            var img = "";
                            if (TestData[i].reporttype == "1" && TestData[i].Result_Flag == "1") {
                                var Critical = [];
                                Critical = TestData[i].ctitical;
                                if (Critical != null) {

                                    if (TestData[i].ctitical != "" && TestData[i].ctitical.split("#")[1] == "Critical") {
                                        divcolor = "#99a300";
                                        img = "<img src='../../Images/critical.png' style='width: 24px;' title='Critical Report' />";
                                    }
                                    else if (TestData[i] != "" && TestData[i].ctitical.split("#")[1] == "Abnormal") {
                                        divcolor = "#993300";
                                        //img = "<img src='../../Images/Abnormal.png' style='width: 24px;' title='Abnormal Report' />";
                                        img = "";
                                    }
                                    else {
                                        divcolor = TestData[i].colorcode;
                                        img = "";
                                    }
                                }
                            }
                            else {
                                divcolor = TestData[i].colorcode;
                                img = "";
                            }


                            var mydata = "<tr id='" + TestData[i].Test_ID + "' data-paymentpendingstatus='" + TestData[i].PaymentPendingStatus + "'   style='background-color:" + TestData[i].rowColor + ";'>";
                            if (TestData[i].LogisticStatus != "") {
                                mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "";
                                if (TestData[i].IsUrgent == "1") {
                                    mydata += "<img src='../../Images/Urgent.gif'>";
                                }
                                mydata += "<img src='../../Images/truck.jpg' style='width:24px; height:24px' data-title='Sample Transfered' /></td>";
                                mydata = mydata + img;
                            }
                            else {
                                mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "";
                                if (TestData[i].IsUrgent == "1") {
                                    mydata += "<img src='../../Images/Urgent.gif' data-title='Uregent Test'>";
                                }
                                mydata = mydata + img;
                                mydata += "</td>";
                            }
                            if (barcodeno != TestData[i].BarcodeNo) {
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].EntryDate + '</td>';
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].PatientID + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="td_BarcodeNo"><b>' + TestData[i].BarcodeNo + '</b></td>';
                                mydata += '<td class="GridViewLabItemStyle"><span  data-title=' + TestData[i].PName + ' style="float: left;text-align: left; max-width: 116px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">' + TestData[i].PName + '</span></td>';
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].mobile + '</td>';
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].pinfo + '</td>';
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].centre + '</td>';
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].DispatchMode + '</td>';
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].PatientType + '</td>';
                                mydata += '<td class="GridViewLabItemStyle"><span  data-title=' + TestData[i].DoctorName + ' style="float: left;text-align: left; max-width: 116px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">' + TestData[i].DoctorName + '</span></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                            }
                            mydata += '<td class="GridViewLabItemStyle"><span  data-title=' + TestData[i].Dept + ' style="float: left;text-align: left; max-width: 116px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">' + TestData[i].Dept + '<span></td>';

                            mydata += '<td class="GridViewLabItemStyle"style="background-color:' + divcolor + '">';
                            if (TestData[i].Approved == "1") {
                                mydata += '<a title=ClickToViewResult  onclick=getme("' + TestData[i].Test_ID + '")>' + TestData[i].ItemName + '<a/>';
                            }
                            else {
                                mydata += '<a title=ClickToViewResult  >' + TestData[i].ItemName + '<a/>';
                            }
                            mydata += '  </td>';

                            divcolor = "";
                           
                            mydata += '<td class="GridViewLabItemStyle">';
                            if (TestData[i].Approved == "1") {
                                mydata += '<input type="checkbox" id="mmchk" onchange="checkPaitent(this)" class="mmc ' + TestData[i].LedgerTransactionNo + '" data="' + TestData[i].LedgerTransactionNo + '"/>';
                            }
                           
                            mydata += '</td>';
                            mydata += '<td class="GridViewLabItemStyle">';
                                 if (TestData[i].Approved == "0" && TestData[i].isoutsource == "1" && TestData[i].IsSampleCollected == "S") {
                                     mydata += '<input type="checkbox" id="Outchk" onchange="checkPaitent(this)" class="Outc ' + TestData[i].LedgerTransactionNo + '" data="' + TestData[i].LedgerTransactionNo + '"/>';
                                 }
                                 mydata += '</td>';
                                 mydata += '<td class="GridViewLabItemStyle" style="display:none" id="tdisoutSource">' + TestData[i].isoutsource + '</td>';
                                 mydata += '<td class="GridViewLabItemStyle"  id="tdAttachmentView">' + '<img  src="../../Images/attachment.png" style="border-style: none;width:20px;cursor:pointer;" alt=""  onclick="callViewAttachment(' + "'" + '' + TestData[i].Test_ID + "'" + ');"></a>' + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none" id="tdItemCode">' + TestData[i].ItemCode + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none" id="tdLedgerTransactionNo">' + TestData[i].LedgerTransactionNo + '</td>';
                            mydata += "</tr>";
                            $('#tb_ItemList').append(mydata);
                            $('#divSampleDDetails').customFixedHeader();
                            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                            barcodeno = TestData[i].BarcodeNo;
                        }
                        var myval = "";
                        if (_PageNo > 1 && _PageNo < 50) {

                            for (var j = 0; j < _PageNo; j++) {
                                var me = parseInt(j) + 1;
                                myval += '<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="show(\'' + j + '\');"  >' + me + '</a>';
                            }
                        }
                        else if (_PageNo > 50) {

                            for (var j = 0; j < 50; j++) {
                                var me = parseInt(j) + 1;
                                myval += '<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="show(\'' + j + '\');"  >' + me + '</a>';

                            }
                            myval += '&nbsp;&nbsp;<select onchange="shownextrecord()" id="myddl">';
                            myval += '<option value="Select">Select Page</option>';
                            for (var j = 50; j < _PageNo; j++) {
                                var me = parseInt(j) + 1;
                                myval += '<option value="' + j + '">' + me + '</option>';
                            }
                            myval += "</select>";
                        }
                        $('#PagerDiv1').html(myval);
                        $('#PagerDiv1').show();
                    }

                  //    $.unblockUI();
                },
                error: function (xhr, status) {
                  //    $.unblockUI();
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function PatientLabSearch1(colorcode, pageno) {
            colorcode1 = colorcode;
            var searchdata = getsearchdata();
            $('#tb_ItemList tr').slice(1).remove();
         //    $.blockUI();
            $.ajax({
                url: "LabReportDispatch.aspx/SearchPatient",
                data: JSON.stringify({ searchdata: searchdata, colorcode: colorcode, PageNo: pageno, PageSize: _PageSize }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    TestData = $.parseJSON(result.d);
                    if (TestData.length == 0) {

                      //    $.unblockUI();
                        modelAlert("No Data Found..!");
                        $('#testcount').html('0');
                        return;
                    }
                    else {
                        testcount = parseInt(TestData[0].TotalRecord);
                        $('#testcount').html(testcount);
                        _PageNo = TestData[0].TotalRecord / _PageSize;
                        var barcodeno = "";
                        var dataLength = TestData.length;
                        for (var i = 0; i < TestData.length; i++) {

                            var divcolor = "";
                            var img = "";
                            if (TestData[i].reporttype == "1" && TestData[i].Result_Flag == "1") {
                                var Critical = [];
                                Critical = TestData[i].ctitical;
                                if (Critical != null) {

                                    if (TestData[i].ctitical != "" && TestData[i].ctitical.split("#")[1] == "Critical") {
                                        divcolor = "#99a300";
                                        img = "<img src='../../Images/critical.png' style='width: 24px;' title='Critical Report' />";
                                    }
                                    else if (TestData[i] != "" && TestData[i].ctitical.split("#")[1] == "Abnormal") {
                                        divcolor = "#993300";
                                        //img = "<img src='../../Images/Abnormal.png' style='width: 24px;' title='Abnormal Report' />";
                                        img = "";
                                    }
                                    else {
                                        divcolor = TestData[i].colorcode;
                                        img = "";
                                    }
                                }
                            }
                            else {
                                divcolor = TestData[i].colorcode;
                                img = "";
                            }

                            var mydata = "<tr id='" + TestData[i].Test_ID + "'   style='background-color:" + TestData[i].rowColor + ";'>";
                            if (TestData[i].LogisticStatus != "") {
                                mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "";
                                if (TestData[i].IsUrgent == "1") {
                                    mydata += "<img src='../../Images/Urgent.gif'>";
                                }
                                mydata += "<img src='../../Images/truck.jpg' style='width:24px; height:24px' title='" + TestData[i].LogisticStatus + "' /></td>";
                                mydata += img;
                            }
                            else {
                                mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "";
                                if (TestData[i].IsUrgent == "1") {
                                    mydata += "<img src='../../Images/Urgent.gif' data-title='Uregent Test'>";
                                }
                                mydata += img;
                                mydata += "</td>";
                            }
                            if (barcodeno != TestData[i].BarcodeNo) {
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].EntryDate + '</td>';
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].PatientID + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="td_BarcodeNo"><b>' + TestData[i].BarcodeNo + '</b></td>';
                                mydata += '<td class="GridViewLabItemStyle"><span  data-title=' + TestData[i].PName + ' style="float: left;text-align: left; max-width: 116px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">' + TestData[i].PName + '</span></td>';
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].pinfo + '</td>';
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].centre + '</td>';
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].DispatchMode + '</td>';
                                mydata += '<td class="GridViewLabItemStyle">' + TestData[i].PatientType + '</td>';
                                mydata += '<td class="GridViewLabItemStyle"><span>' + TestData[i].DoctorName + '</span></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                            }
                            mydata += '<td class="GridViewLabItemStyle"><span  data-title=' + TestData[i].Dept + ' style="float: left;text-align: left; max-width: 116px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">' + TestData[i].Dept + '<span></td>';
                            

                            mydata += '<td class="GridViewLabItemStyle"style="background-color:' + divcolor + '">';
                            if (TestData[i].Approved == "1") {
                                mydata += '<a title=ClickToViewResult  onclick=getme("' + TestData[i].Test_ID + '")>' + TestData[i].ItemName + '<a/>';
                            }
                            else {
                                mydata += '<a title=ClickToViewResult  >' + TestData[i].ItemName + '<a/>';
                            }
                            mydata += '  </td>';

                            divcolor = "";

                            mydata += '<td class="GridViewLabItemStyle">';
                            if (TestData[i].Approved == "1") {
                                mydata += '<input type="checkbox" id="mmchk" onchange="checkPaitent(this)" class="mmc ' + TestData[i].LedgerTransactionNo + '" data="' + TestData[i].LedgerTransactionNo + '"/>';
                            }
                           
                            mydata += '</td>';

                            mydata += '<td class="GridViewLabItemStyle">';
                            if (TestData[i].Approved == "0" && TestData[i].isoutsource == "1" && TestData[i].IsSampleCollected == "S") {
                                mydata += '<input type="checkbox" id="Outchk" onchange="checkPaitent(this)" class="Outc ' + TestData[i].LedgerTransactionNo + '" data="' + TestData[i].LedgerTransactionNo + '"/>';
                            }
                            mydata += '</td>';

                            mydata += '<td class="GridViewLabItemStyle" style="display:none" id="tdisoutSource">' + TestData[i].isoutsource + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none" id="tdItemCode">' + TestData[i].ItemCode + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none" id="tdLedgerTransactionNo">' + TestData[i].LedgerTransactionNo + '</td>';
                            mydata += "</tr>";
                            $('#tb_ItemList').append(mydata);
                            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                            $('#divSampleDDetails').customFixedHeader();
                            barcodeno = TestData[i].BarcodeNo;
                        }
                    }
                  //    $.unblockUI();
                },
                error: function (xhr, status) {
                  //    $.unblockUI();

                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        };
        function show(pageno) {

            PatientLabSearch1(colorcode1, pageno);

        }
        //function callViewAttachment(Testid) {
       
        //    fancyviewAttachment(Testid);
        //}

        function callViewAttachment(Testid) {
            serverCall('LabReportDispatch.aspx/isAmountPending', { testID: Testid }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    fancyviewAttachment(Testid);
                else
                    modelAlert(responseData.response);
            });

        }


        function getme(testid) {
            //var url = "../../Design/Lab/CriticalAbnormal.aspx?TestID=" + testid;
            //$('#deltadiv').load(url);
            //$('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
            var paymentpendingstatus = "";
            $('#tb_ItemList tr').each(function () {
                id = $(this).closest("tr").attr("id");
                if (id != "header") {
                        paymentpendingstatus = $(this).closest("tr").data("paymentpendingstatus");
                        if (paymentpendingstatus == "0" && id==testid) {
                            modelAlert("Do not print this patient report.Payment is pending.");
                            return;
                        }
                        else if (paymentpendingstatus == "1" && id == testid) { window.open("CriticalAbnormal.aspx?TestID=" + testid, null, 'left=150, top=90, height=350, width=1100,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no'); }
                    
                }
                });


           
           
        }

        function shownextrecord() {
            var mm = $('#myddl option:selected').val();
            if (mm != "Select") {
                show(mm);
            }
        }
        var $bindDepartment = function (callback) {
            serverCall('DepartmentReceiving.aspx/BindDepartment', {}, function (response) {
                var $ddlLabDepartment = $('#ddlLabDepartment');
                $ddlLabDepartment.bindDropDown({ defaultValue: 'ALL', data: JSON.parse(response), valueField: 'ObservationType_ID', textField: 'Name', isSearchAble: true });
                callback($ddlLabDepartment.val());
            });
        }
        var $bindInvestigation = function (callback) {
            var department = $('#ddlLabDepartment').val();
            serverCall('LabReportDispatch.aspx/BindInvestigation', { Department: department }, function (response) {
                var $ddlinvestigation = $('#ddlinvestigation');
                $ddlinvestigation.bindDropDown({ defaultValue: 'ALL', data: JSON.parse(response), valueField: 'Investigation_id', textField: 'Name', isSearchAble: true });
                callback($ddlinvestigation.val());
            });
        }
        var $bindDoctor = function (callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: "ALL" }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'ALL', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlDoctor.val());
            });
        }
        var $bindCentre = function () {
            serverCall('LabReportDispatch.aspx/BindCentre', {}, function (response) {
                Centre = $('#ddlCentreAccess');
                centrid = '<%=ViewState["CentreID"].ToString()%>'
                Centre.bindDropDown({ defaultValue: 'ALL', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: centrid });
            });
        }
        $(function () {
            $('input').keyup(function () {
                if (event.keyCode == 13) {
                    if ($(this).val() != "") {
                        PatientLabSearch('');
                    }
                }
            });
            $bindDepartment(function () {
                $('#divSampleDDetails').customFixedHeader();
                // alert("vv");
                $bindInvestigation(function () {
                    $bindDoctor(function () {
                        $bindCentre(function () {
                        });
                    });
                });
            });
        });

        function DispatchReport(IsPrev) {
            var testid = "";
            var printid = "";
            var id = "";
            var ledgerNo = "";
            var paymentpendingstatus = "";
            $('#tb_ItemList tr').each(function () {
                id = $(this).closest("tr").attr("id");
                if (id != "header") {
                    if ($(this).closest("tr").find('#mmchk').prop('checked') == true) {

                        paymentpendingstatus = $(this).closest("tr").data("paymentpendingstatus");
                     
                            if (testid == "") {
                                testid += "'" + id + "'";
                            }
                            else {
                                testid += ",'" + id + "'";
                            }
                            printid += id + ",";
                            ledgerNo = $(this).closest("tr").find('#mmchk').attr("data");
                            if (IsPrev == '0')
                                $(this).closest("tr").css('background-color', '#44A3AA;');
                        }
                    
                }
            });
            if (testid == "") {
                modelAlert("Please Select Test To Dispatch");
                return;
            }
            else if    (paymentpendingstatus == "0") {
                modelAlert("Do not print this patient report.Payment is pending.");
                return;
            }
            else {
                var IsEmail = $('#chkEmail').is(':checked') ? 1 : 0;
                var IsSms = $('#chksms').is(':checked') ? 1 : 0;
                serverCall('LabReportDispatch.aspx/DispatchLabReport', { TestID: testid, LedgerNo: ledgerNo, IsEmail: IsEmail, IsSms: IsSms }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        $('.mmc').prop('checked', false);
                        window.open("printlabreport_pdf.aspx?IsPrev=" + IsPrev + "&PHead=0&testid=" + printid);
                    }
                });
            }
        }
        function PrintReport(IsPrev) {
            var testid = "";
            var id = "";
            var paymentpendingstatus = "";
            
            $('#tb_ItemList tr').each(function () {
                id = $(this).closest("tr").attr("id");
                if (id != "header") {
                    if ($(this).closest("tr").find('#mmchk').prop('checked') == true) {

                        paymentpendingstatus = $(this).closest("tr").data("paymentpendingstatus");

                        if (paymentpendingstatus == "1") {
                            testid += id + ",";
                        }


                        if (IsPrev == '0')
                            $(this).closest("tr").css('background-color', '#00FFFF');
                    }
                }
            });


            if (paymentpendingstatus == "0") {
                modelAlert("Do not print this patient report.Payment is pending.");
                return;
            }


            if (testid == "") {
                modelAlert("Please Select Test To Print");
                return;
            }
            if ($('#chheader').prop('checked') == true) {
                window.open("printlabreport_pdf.aspx?IsPrev=" + IsPrev + "&PHead=0&testid=" + testid);
            }
            else {
                window.open("printlabreport_pdf.aspx?IsPrev=" + IsPrev + "&testid=" + testid);
            }
            $('.mmc').prop('checked', false);
        }
        function printOutsourceReport(IsPrev) {
            var testid = "";
            var id = "";
            var labno = "";
            $('#tb_ItemList tr').each(function () {
                id = $(this).closest("tr").attr("id");
                if (id != "header") {
                    if ($(this).closest("tr").find('#Outchk').prop('checked') == true) {
                        testid += $(this).closest('tr').find('#tdItemCode').text() + ",";
                        if (IsPrev == '0')
                            $(this).closest("tr").css('background-color', '#00FFFF');
                        labno = $(this).closest('tr').find('#tdLedgerTransactionNo').text();
                    }
                }
            });
            if (testid == "") {
                modelAlert("Please Select Test To Print");
                return;
            }
            //if ($('#chheader').prop('checked') == true) {
            //    window.open("printlabreport_pdf.aspx?IsPrev=" + IsPrev + "&PHead=0&testid=" + testid);
            //}
            //else {
            window.open("https://report.apollodiagnostics.in/apollo/Cronjob/LabReportView.aspx?LabNo=" + labno + "&TestCode=" + testid + "&InterfaceClient=RMAT");
           // }
            $('.Outc').prop('checked', false);
        }
        
        function checkPaitent(ID) {
            var cls = $(ID).attr("data");
            if ($(ID).prop('checked') == true) {
                $(".mmc").prop("checked", false)
                $("." + cls).prop("checked", true)
            }
        };
    </script>
</asp:Content>
