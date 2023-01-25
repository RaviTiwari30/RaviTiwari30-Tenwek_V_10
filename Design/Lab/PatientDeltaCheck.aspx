<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientDeltaCheck.aspx.cs" Inherits="Design_Lab_PatientDeltaCheck" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 
    <script type="text/javascript" src="Script/jquery.table2excel.js"></script>

    <script type="text/javascript">

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                   

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }
        function show() {
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'OPD') {
                $("#<%=txtCRNo.ClientID %>").val('').hide();
                $("#<%=lblIPDNo.ClientID %>").hide();
                $("#<%=lblipdcln.ClientID %>").hide();
                $("#<%=txtEmgNum.ClientID %>").val('').hide(); 
                $("#<%=lblEMG.ClientID %>").hide();
                $('#<%=txtMRNo.ClientID%>').attr("disabled", false);
            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'IPD') {
                $("#<%=txtCRNo.ClientID %>").val('').show();
                $("#<%=lblIPDNo.ClientID %>").show();
                $("#<%=lblipdcln.ClientID %>").show();
                $("#<%=txtEmgNum.ClientID %>").val('').hide();
                $("#<%=lblEMG.ClientID %>").hide();
                $('#<%=txtMRNo.ClientID%>').attr("disabled", true);
            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'EMG') {
                $("#<%=txtCRNo.ClientID %>").val('').hide();
                $("#<%=lblIPDNo.ClientID %>").hide();
                $("#<%=lblipdcln.ClientID %>").hide();
                $("#<%=txtEmgNum.ClientID %>").val('').show();
                $("#<%=lblEMG.ClientID %>").show();
                $('#<%=txtMRNo.ClientID%>').attr("disabled", true);
            }
            if ($('#<%=rdbLabType.ClientID %> input[type=radio]:checked').val() == 'ALL') {
                $("#<%=txtCRNo.ClientID %>").val('').show();
                $("#<%=lblIPDNo.ClientID %>").show();
                $("#<%=lblipdcln.ClientID %>").show();
                $("#<%=txtEmgNum.ClientID %>").val('').show();
                $("#<%=lblEMG.ClientID %>").show();
                $('#<%=txtMRNo.ClientID%>').attr("disabled", false);
            }
        }

        
        function MyFun() {
            var f = ""; var t = "";
            GetDateDetails(f, t);
        }

        var len = 0;

        function GetDateDetails(fromDate, ToDate) {
            

            var from = $("#<%=FrmDate.ClientID%>").val();
            var to = $("#<%=ToDate.ClientID%>").val();
            var PatientID = $('#<%=txtMRNo.ClientID%>').val();
            var IPDNo = $('#<%=txtCRNo.ClientID%>').val();
            var departmentID = $("#<%=ddlDepartment.ClientID%>").val();
            var emg = $("#<%=txtEmgNum.ClientID %>").val();
            var type = $("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val();

            if (PatientID == "" && IPDNo == "" && emg == "") {
                alert("Please enter UHID or IPD No. or EMG No.");
                $("#btnSearch").val("Search");
                $("#btnSearch").attr("disabled", false);
                return false;
            }
            if (type == "OPD") {
                if (PatientID == "") {
                    alert("Enter UHID");
                    $("#btnSearch").val("Search");
                    $("#btnSearch").attr("disabled", false);
                    return false;
                }
            }
            else if (type == "IPD") {
                if (IPDNo == "") {
                    alert("Enter IPDNo.");
                    $("#btnSearch").val("Search");
                    $("#btnSearch").attr("disabled", false);
                    return false;
                }
                else {
                    PatientID = GetPatientID(IPDNo);
                    if (PatientID == "") {
                        alert("IPD No. not valid");
                        $("#btnSearch").val("Search");
                        $("#btnSearch").attr("disabled", false);
                        return false;
                    }
                }
            }
            else if (type == "EMG") {
                if (emg == "") {
                    alert("Enter EMGNo.");
                    $("#btnSearch").val("Search");
                    $("#btnSearch").attr("disabled", false);
                    return false;
                }
                else {
                    PatientID = GetPatientIDByEmg(emg);
                    if (PatientID == "") {
                        alert("EMG No. not valid");
                        $("#btnSearch").val("Search");
                        $("#btnSearch").attr("disabled", false);
                        return false;
                    }
                }
            }

       
            serverCall('PatientDeltaCheck.aspx/GetDateDetails', { FromDate: from, ToDate: to, PatientID: PatientID }, function (response) {
                var resData = JSON.parse(response);

                $("#divReport").show();
                $("#divPharmacyReport").hide();
                $("#divPharmacyEMGReport").hide();
                len = resData[0].Count;

                $('#tblDeltaReport').find('td,th').remove();
                $('#tblDeltaReport tbody').find('td,th,tr').remove();

                if (len == 2 || len == 1) {
                    $("#tblDeltaReport").css("width", "500px");
                }
                else if (len == 3) {
                    $("#tblDeltaReport").css("width", "700px");
                }
                else if (len == 4 || len == 5) {
                    $("#tblDeltaReport").css("width", "900px");
                }
                else if (len == 7 || len == 8 || len == 9) {
                    $("#tblDeltaReport").css("width", "1300px");
                }
                else if (len == 10) {
                    $("#tblDeltaReport").css("width", "1500px");
                }
                else {
                    $("#tblDeltaReport").css("width", "1500px");
                }


                if (len > 0) {
                    for (i = 0; i < len; i++) {
                        var f = resData[0]["Date_" + i + ""];
                        if (i == 0) {
                            $("#tblDeltaReport thead tr").append('<th style="background-color:#3278b5;color:#fff;z-index:500;top:0;" class="headcol myHeader">Parameter Name</th><th style="background-color:#3278b5;color:#fff;width:100px;position:sticky;top:0;" class="long myHeader">Range</th><th style="background-color:#3278b5;color:#fff;position:sticky;top:0;width:200px;" class="long myHeader">' + f + '</th>');
                        }
                        else {
                            $("#tblDeltaReport thead tr").append('<th style="background-color:#3278b5;color:#fff;width:200px;position:sticky;top:0;" class="long myHeader">' + f + '</th>');
                        }
                    }
                    GetTest(PatientID, departmentID);
                }
                else {
                    alert("Record not found");
                    $("#btnSearch").val("Search");
                    $("#btnSearch").attr("disabled", false);
                }
            });
           



            // $.ajax({
            //var DateDetails = {
            //    url: "PatientDeltaCheck.aspx/GetDateDetails",
            //    data: '{FromDate:"' + from + '",ToDate:"' + to + '",PatientID:"' + PatientID + '"}',
            //    type: "POST",
            //    async: false,
            //    dataType: "json",
            //    contentType: "application/json; charset=utf-8",
            //    beforeSend: function () {
            //        // setting a timeout
            //        //$(placeholder).addClass('loading');
            //        $("#loading").show();
            //    },
            //    success: function (result) {
            //        var resData = $.parseJSON(result.d);
            //        $("#divReport").show();
            //        len = resData[0].Count;
            //        //var data = resData[0].Table1;
            //        //var columns = addAllColumnHeaders(data);
            //        $('#tblDeltaReport').find('td,th').remove();
            //        $('#tblDeltaReport tbody').find('td,th,tr').remove();

            //        if (len > 0) {


            //            for (i = 0; i < len; i++) {
            //                var f = resData[0]["Date_" + i + ""];
            //                if (i == 0) {
            //                    $("#tblDeltaReport thead tr").append('<th style="background-color:#3278b5;color:#fff;" class="headcol myHeader">Parameter Name</th><th style="background-color:#3278b5;color:#fff;width:100px;position:sticky;top:0;" class="long myHeader">Range</th><th style="background-color:#3278b5;color:#fff;position:sticky;top:0;" class="long myHeader">' + f + '</th>');
            //                }
            //                else {
            //                    $("#tblDeltaReport thead tr").append('<th style="background-color:#3278b5;color:#fff;width:200px;position:sticky;top:0;" class="long myHeader">' + f + '</th>');
            //                }
            //            }
            //            GetTest(PatientID, departmentID);
            //        }
            //        else {
            //            alert("Record not found");
            //            $("#btnSearch").val("Search");
            //            $("#btnSearch").attr("disabled", false);
            //        }
            //    }
            //    //});
            //};
            //jQuery.ajax(DateDetails);
        }

        function GetPatientID(IPDNo) {
            var PID = "";
            $.ajax({
                url: "PatientDeltaCheck.aspx/GetPatientID",
                data: '{IPDNo:"' + IPDNo + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    var resData = $.parseJSON(result.d);
                    for (i = 0; i < resData.length; i++) {
                        PID = resData[i].PatientID;
                    }
                }
            });

            return PID;
        }

        function GetPatientIDByEmg(EMG) {
            var PID = "";
            $.ajax({
                url: "PatientDeltaCheck.aspx/GetPatientIDByEMGNum",
                data: '{EMG:"' + EMG + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    var resData = $.parseJSON(result.d);
                    for (i = 0; i < resData.length; i++) {
                        PID = resData[i].PatientID;
                    }
                }
            });

            return PID;
        }

        function GetTest(patientID, departmentID) {
            var from = $("#<%=FrmDate.ClientID%>").val();
            var to = $("#<%=ToDate.ClientID%>").val();
            var Type = $("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val();

            $.ajax({
                url: "PatientDeltaCheck.aspx/GetAllTest",
                data: '{fromDate:"' + from + '",ToDate:"' + to + '",PatientID:"' + patientID + '",Department:"' + departmentID + '",TYPE:"' + Type + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    var resData = $.parseJSON(result.d);
                    $("#divReport").show();

                    //for (i = 0; i < len; i++) {
                    //    $("#tblDeltaReport tbody tr").append('<th></th>');
                    //}
                    
                    var d = "";
                    for (i = 0; i < resData.length; i++) {
                        var department = resData[i].DEPARTMENT;
                        var investigationName = resData[i].InvestigationName;
                        if (department != "") {
                            if (d != department) {

                                var rr = "<tr><td style='font-weight:bold;' class='headcol'>" + department + "</td>";
                                for (var j = 0; j <= len; j++) {
                                    rr += "<td class='long' style='height:20px;'></td>";
                                }
                                rr += "</tr>";
                                $("#tblDeltaReport tbody").append(rr);

                                var rr1 = "<tr><td style='font-weight:bold;padding-left:20px;' class='headcol'>" + investigationName + "</td>";
                                for (var j = 0; j <= len; j++) {
                                    rr1 += "<td class='long' style='height:20px;'></td>";
                                }
                                rr1 += "</tr>";
                                $("#tblDeltaReport tbody").append(rr1);

                                //$("#tblDeltaReport tbody").append("<tr><td style='font-weight:bold;' class='' colspan=" + len + ">" + department + "</td></tr>");
                               // $("#tblDeltaReport tbody").append("<tr><td style='font-weight:bold;' class='' colspan=" + len + ">" + investigationName + "</td></tr>");
                                var v = GetValue(resData[i].Date, resData[i].PARAM_NAME, resData[i].DEPARTMENT, patientID);
                                
                                if (v != "") {
                                    var row3 = "";
                                    row3 = "<tr><td class='headcol' style='padding-left:40px;'>" + resData[i].PARAM_NAME + "</td><td class='long' style='height:20px;'>" + resData[i].Range + "</td>";

                                    $('#tblDeltaReport th').each(function () {
                                        if ($(this).text() == "Parameter Name") {
                                        }
                                        else if ($(this).text() == "Range") {
                                        }
                                        else {
                                            if ($(this).text() == resData[i].Date) {
                                                row3 += "<td class='long' style='height:20px;'>" + v + "</td>";
                                            }
                                            else {
                                                row3 += "<td class='long' style='height:20px;'></td>";
                                            }
                                        }
                                    });

                                    row3 += "</tr>";
                                    $("#tblDeltaReport tbody").append(row3);
                                    // $("#tblDeltaReport tbody").append("<tr><td>" + resData[i].PARAM_NAME + "</td><td>" + v + "</td></tr>");
                                }
                                else {
                                    var row4 = "";
                                    row4 = "<tr><td class='headcol' style='padding-left:40px;'>" + resData[i].PARAM_NAME + "</td><td class='long' style='height:20px;'>" + resData[i].Range + "</td>";

                                    $('#tblDeltaReport th').each(function () {
                                        if ($(this).text() == "Parameter Name") {
                                        }
                                        else if ($(this).text() == "Range") {
                                        }
                                        else {
                                            if ($(this).text() == resData[i].Date) {
                                                row4 += "<td class='long' style='height:20px;'>" + v + "</td>";
                                            }
                                            else {
                                                row4 += "<td class='long' style='height:20px;'></td>";
                                            }
                                        }
                                    });

                                    row4 += "</tr>";
                                    $("#tblDeltaReport tbody").append(row4);
                                    //$("#tblDeltaReport tbody").append("<tr><td>" + resData[i].PARAM_NAME + "</td></tr>");
                                }
                                d = department;
                            }
                            else {
                                var v = GetValue(resData[i].Date, resData[i].PARAM_NAME, resData[i].DEPARTMENT, patientID);
                                if (v != "") {
                                    var row = "";
                                    row = "<tr><td class='headcol' style='padding-left:40px;'>" + resData[i].PARAM_NAME + "</td><td class='long' style='height:20px;'>" + resData[i].Range + "</td>";

                                    $('#tblDeltaReport th').each(function () {
                                        if ($(this).text() == "Parameter Name") {
                                        }
                                        else if ($(this).text() == "Range") {
                                        }
                                        else {
                                            if ($(this).text() == resData[i].Date) {
                                                row += "<td class='long' style='height:20px;'>" + v + "</td>";
                                            }
                                            else {
                                                row += "<td class='long' style='height:20px;'></td>";
                                            }
                                        }
                                    });

                                    row += "</tr>";
                                    $("#tblDeltaReport tbody").append(row);

                                    // $("#tblDeltaReport tbody").append("<tr><td>" + resData[i].PARAM_NAME + "</td><td>" + v + "</td></tr>");
                                }
                                else {
                                    var row2 = "";
                                    row2 = "<tr><td class='headcol' style='padding-left:40px;'>" + resData[i].PARAM_NAME + "</td><td class='long' style='height:20px;'>" + resData[i].Range + "</td>";

                                    $('#tblDeltaReport th').each(function () {
                                        if ($(this).text() == "Parameter Name") {
                                        }
                                        else if ($(this).text() == "Range") {
                                        }
                                        else {
                                            if ($(this).text() == resData[i].Date) {
                                                row2 += "<td class='long' style='height:20px;'>" + v + "</td>";
                                            }
                                            else {
                                                row2 += "<td class='long' style='height:20px;'></td>";
                                            }
                                        }
                                    });

                                    row2 += "</tr>";
                                    $("#tblDeltaReport tbody").append(row2);
                                    //$("#tblDeltaReport tbody").append("<tr><td>" + resData[i].PARAM_NAME + "</td></tr>");
                                }
                            }
                        }
                    }
                }
                
            });
        }

        function GetValue(date, paramname, Department, patientID) {
            var value = "";
            $.ajax({
                url: "PatientDeltaCheck.aspx/GetValue",
                data: '{Date:"' + date + '",ParamName:"' + paramname + '",department:"' + Department + '",PatientID:"' + patientID + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    var resData = $.parseJSON(result.d);

                    //for (i = 0; i < resData.length; i++) {
                    //    value = resData[0].Value;
                    //}
                    value = resData[0].Value;
                }
            });

            return value;
        }

        function addAllColumnHeaders(myList) {
            var columnSet = [];
            var headerTr$ = $('<tr/>');
            for (var i = 0; i < myList.length; i++) {
                var rowHash = myList[i];
                for (var key in rowHash) {
                    if ($.inArray(key, columnSet) == -1) {

                        columnSet.push(key);
                        headerTr$.append($('<th/>').html(key));

                    }
                }
            }
            $("#av").append(headerTr$);

            return columnSet;
        }

    </script>
    <style type="text/css">
        #tblDeltaReport,#tblPharmacyReport,#tblPharmacyEMG {
            /*border:1px solid #000000;*/
            width:100%;
        }
            #tblDeltaReport tr,#tblPharmacyReport tr,#tblPharmacyEMG tr {
                border:1px solid #000000;
            }
                #tblDeltaReport tr td,#tblPharmacyReport tr td,#tblPharmacyEMG tr td {
                    border:1px solid #000000;
                    font-size:11px;
                }
                 #tblDeltaReport tr th,#tblPharmacyReport tr th,#tblPharmacyEMG tr th {
                    border:1px solid #000000;
                    font-size:11px;
                }

    .headcol {
  /*position: absolute;*/
  position:sticky;
  width: 23.4em;
  left: 0;
  top: auto;
  border-top-width: 1px;
  /*only relevant for first row*/
  /*margin-top: -1px;*/
  /*compensate for top border*/
  width:400px;/*314px*/
  box-shadow:1px 1px 5px 0px #676565;
  z-index:100;
  background-color:white;
}
    /*.headcol:before {
  content: 'Row ';
}*/

.long {
 
}
#divReport,#divPharmacyReport,#divPharmacyEMGReport {
  /*width: 500px;*/
  overflow-x: scroll;
  /*margin-left: 23em;*/
  overflow-y: visible;
  padding: 0;
  height:375px;
}
        #tblDeltaReport,#tblPharmacyReport,#tblPharmacyEMG {
            width:1500px;
        }

      /*body { height: 1000px; }*/
    </style>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Delta Search</b>
            <br />
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbLabType" runat="server" RepeatDirection="Horizontal"
                                onclick="show();">
                                <asp:ListItem Text="OPD" Value="OPD" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                                <asp:ListItem Text="EMG" Value="EMG"></asp:ListItem>
                                <asp:ListItem Text="All" Value="ALL"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblIPDNo" Text="IPD No." runat="server" Style="display: none"></asp:Label>
                            </label>
                            <b id="lblipdcln" style="display: none;" runat="server" class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCRNo" runat="server" MaxLength="10" ToolTip="Enter IPD No."
                                TabIndex="2" Style="display: none" />
                            <%--<cc1:FilteredTextBoxExtender ID="ftbtxtCRNo" runat="server" TargetControlID="txtCRNo">
                                
                            </cc1:FilteredTextBoxExtender>--%>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblEMG" Text="EMG No." runat="server" Style="display: none"></asp:Label>
                            </label>
                            <b id="B1" style="display: none;" runat="server" class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmgNum" runat="server" Style="display: none" ToolTip="Enter EMG No." MaxLength="30"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRNo" runat="server" TabIndex="1" ToolTip="Enter UHID"
                                MaxLength="20" />
                        </div>
                      <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="FrmDate" runat="server" TabIndex="11" ToolTip="Select From Date" onchange="ChkDate();"
                                ClientIDMode="Static"></asp:TextBox>
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
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" TabIndex="12" onchange="ChkDate();"
                                ToolTip="Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate"> </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Depatment</label>
                        <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" >
                            <asp:DropDownList ID="ddlDepartment" class="ddlDepartment  chosen-select" runat="server">
                            </asp:DropDownList>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">Source</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbSource" runat="server" RepeatDirection="Horizontal" onclick="showDiv();">
                                <asp:ListItem Text="Lab" Value="Lab" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Pharmacy" Value="Pharmacy"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                     </div>
                    <div class="row">
						 <div class="col-md-11">
						 </div>
						  <div class="col-md-2">
								 <input type="button" value="Search" id="btnSearch" class="ItDoseButton" />
						 </div>
						  <div class="col-md-11">
						 </div>
					  </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-24" id="divReportData">
                            <center>
                            <input type="image" src="../../Images/excelexport.gif" id="btnExport" title="Export to Excel" value="Export to Excel" style="height:22px;width:28px;margin-bottom:20px;cursor:pointer;display:none;" />
                                <input type="image" src="../../Images/excelexport.gif" id="btnPharmacyExport" title="Export to Excel" value="Export to Excel" style="height:22px;width:28px;margin-bottom:20px;cursor:pointer;display:none;"  />
                                </center>
                            <div id="divReport" style="display:none;" class="">
                                <table id="tblDeltaReport" class="table2excel" data-tableName="Test Table 1">
                                    <thead id="av">
                                        <tr>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                            <div id="divPharmacyReport" style="display:none;">
                                <table id="tblPharmacyReport">
                                    <thead id="theading">
                                        <tr>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                            <div id="divPharmacyEMGReport" style="display:none;">
                                <table id="tblPharmacyEMG">
                                    <thead id="theadEMG">
                                        <tr></tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
     
    <script type="text/javascript">
/*************************************Export to excel****************************************************************/
        $("#btnExport").click(function (e) {
            e.preventDefault();
            $("#tblDeltaReport").table2excel({
                filename: "Lab.xls"
                //preserveColors: true
            });
        }); 

        $("#btnPharmacyExport").click(function (e) {
            e.preventDefault();
            var type = $("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val();
            if (type == "IPD") {
                $("#tblPharmacyReport").table2excel({
                    filename: "PharmacyIPD.xls"
                    //preserveColors: true
                });
            }
            else if (type == "EMG") {
                $("#tblPharmacyEMG").table2excel({
                    filename: "PharmacyEMG.xls"
                    //preserveColors: true
                });
            }
        });

        //$(function () {
            //$(".exportToExcel").click(function (e) {
            //    var table = $(this).prev('.table2excel');
            //    alert(table.length);
            //    if (table && table.length) {
            //        var preserveColors = (table.hasClass('table2excel_with_colors') ? true : false);
            //       // var preserveColors = true;
            //        $(table).table2excel({
            //            exclude: ".noExl",
            //            name: "Excel Document Name",
            //            filename: "myFileName" + new Date().toISOString().replace(/[\-\:\.]/g, "") + ".xls",
            //            fileext: ".xls",
            //            exclude_img: true,
            //            exclude_links: true,
            //            exclude_inputs: true,
            //            preserveColors: preserveColors
            //        });
            //    }
            //});

        //});

/*****************************END**********************************************************************/

        $("#btnSearch").click(function (e) {
           // e.preventDefault();
            
            if ($("#<%=rbSource.ClientID %> input[type=radio]:checked").val() == 'Lab') {
                $("#btnExport").show();
                $("#btnPharmacyExport").hide();
                MyFun();
            }
            else if ($("#<%=rbSource.ClientID %> input[type=radio]:checked").val() == 'Pharmacy') {
                var type = $("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val();
                if (type == "IPD") {
                    $("#btnExport").hide();
                    $("#btnPharmacyExport").show();
                    GetPharmacyDateDetails();
                }
                else if (type == "EMG") {
                    $("#btnExport").hide();
                    $("#btnPharmacyExport").show();
                    GetPharmacyEMGDateHeaders();
                }
            }
        });

        function showDiv() {
            if ($("#<%=rbSource.ClientID %> input[type=radio]:checked").val() == 'Lab') {
                $("#btnExport").show();
                $("#btnPharmacyExport").hide();
                $("#divReport").show();
                $("#divPharmacyReport").hide();
            }
            else if ($("#<%=rbSource.ClientID %> input[type=radio]:checked").val() == 'Pharmacy') {
                $("#btnExport").hide();
                $("#btnPharmacyExport").show();
                $("#divReport").hide();
                $("#divPharmacyReport").show();
            }
        }

        //function moveScroll() {
        //    var scroll = $(window).scrollTop();
        //    var anchor_top = $("#tblDeltaReport").offset().top;
        //    var anchor_bottom = $("#bottom_anchor").offset().top;
        //    if (scroll > anchor_top && scroll < anchor_bottom) {
        //        clone_table = $("#clone");
        //        if (clone_table.length == 0) {
        //            clone_table = $("#tblDeltaReport").clone();
        //            clone_table.attr('id', 'clone');
        //            clone_table.css({
        //                position: 'fixed',
        //                'pointer-events': 'none',
        //                top: 0
        //            });
        //            clone_table.width($("#tblDeltaReport").width());
        //            $("#divReport").append(clone_table);
        //            $("#clone").css({ visibility: 'hidden' });
        //            $("#clone thead").css({ 'visibility': 'visible', 'pointer-events': 'auto' });
        //        }
        //    } else {
        //        $("#clone").remove();
        //    }
        //}

        $(document).ready(function () {
           // $(window).scroll(moveScroll);
        });

/********************************************Pharmacy start***********************************************************************************/
        var lengt = 0;
        function GetPharmacyDateDetails() {
            var from = $("#<%=FrmDate.ClientID%>").val();
              var to = $("#<%=ToDate.ClientID%>").val();
              var type = $("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val();


              serverCall('PatientDeltaCheck.aspx/GetPharmacyDateDetails', { FromDate: from, ToDate: to }, function (response) {
                  var resData = JSON.parse(response);

                  $("#divReport").hide();
                  $("#divPharmacyReport").show();
                  $("#divPharmacyEMGReport").hide();

                  lengt = resData[0].Count;

                  $('#tblPharmacyReport').find('td,th').remove();
                  $('#tblPharmacyReport tbody').find('td,th,tr').remove();

                  if (lengt == 2 || lengt == 1) {
                      $("#tblPharmacyReport").css("width", "500px");
                  }
                  else if (lengt == 3) {
                      $("#tblPharmacyReport").css("width", "700px");
                  }
                  else if (lengt == 4 || lengt == 5) {
                      $("#tblPharmacyReport").css("width", "900px");
                  }
                  else if (lengt == 7 || lengt == 8 || lengt == 9) {
                      $("#tblPharmacyReport").css("width", "1300px");
                  }
                  else if (lengt == 10) {
                      $("#tblPharmacyReport").css("width", "1500px");
                  }
                  else {
                      $("#tblPharmacyReport").css("width", "1500px");
                  }

                  if (lengt > 0) {
                      for (i = 0; i < lengt; i++) {
                          var f = resData[0]["Date_" + i + ""];
                          if (i == 0) {
                              $("#tblPharmacyReport thead tr").append('<th style="background-color:#3278b5;color:#fff;z-index:500;top:0;" class="headcol myHeader">Item Name</th><th style="background-color:#3278b5;color:#fff;position:sticky;top:0;width:200px;" class="long myHeader">' + f + '</th>');
                          }
                          else {
                              $("#tblPharmacyReport thead tr").append('<th style="background-color:#3278b5;color:#fff;width:200px;position:sticky;top:0;" class="long myHeader">' + f + '</th>');
                          }
                      }
                      //GetTest(PatientID, departmentID);
                      GetPharmacyItemName();
                  }
                  else {
                      alert("Record not found");
                      $("#btnSearch").val("Search");
                      $("#btnSearch").attr("disabled", false);
                  }
              });
        }

        function GetPharmacyItemName() {
            var from = $("#<%=FrmDate.ClientID%>").val();
            var to = $("#<%=ToDate.ClientID%>").val();

            serverCall('PatientDeltaCheck.aspx/GetPharmacyItemName', { FromDate: from, ToDate: to }, function (response) {
                var resData = JSON.parse(response);
                $("#divPharmacyReport").show();

                for (i = 0; i < resData.length; i++) {

                    //var v = GetPharmacyQty(resData[i].DATE, resData[i].ItemID, resData[i].TransactionID, resData[i].ID);
                    var row = "";
                    row = "<tr><td class='headcol' style=''>" + resData[i].ItemName + "</td>";

                    $('#tblPharmacyReport th').each(function () {
                        if ($(this).text() == "Item Name") {
                        }
                        else {
                            var v = GetPharmacyQty($(this).text(), resData[i].ItemID, resData[i].TransactionID, resData[i].ID);
                            if (v != null) {//$(this).text() == resData[i].DATE
                                row += "<td class='long' style='height:20px;'>" + v + "</td>";
                            }
                            else {
                                row += "<td class='long' style='height:20px;'>0</td>";
                            }
                        }
                    });

                    row += "</tr>";
                    $("#tblPharmacyReport tbody").append(row);
                }

            });
        }

        function GetPharmacyQty(date, itemID, transactionId, id) {
            var value = "";
            $.ajax({
                url: "PatientDeltaCheck.aspx/GetPharmacyIPDQty",
                data: '{Date:"' + date + '",ItemID:"' + itemID + '",TransactionID:"' + transactionId + '",ID:"' + id + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    var resData = $.parseJSON(result.d);
                    value = resData[0].Qty;
                }
            });
            return value;
        }
/********************************************Pharmacy END***********************************************************************************/

/********************************************Pharmacy EMG start***********************************************************************************/
        var lengthh = 0;
        function GetPharmacyEMGDateHeaders() {
            var from = $("#<%=FrmDate.ClientID%>").val();
            var to = $("#<%=ToDate.ClientID%>").val();

            serverCall('PatientDeltaCheck.aspx/GetPharmacyEMGDateDetails', { FromDate: from, ToDate: to }, function (response) {
                var resData = JSON.parse(response);

                $("#divReport").hide();
                $("#divPharmacyReport").hide();
                $("#divPharmacyEMGReport").show();

                lengthh = resData[0].Count;

                if (lengthh == 2 || lengthh == 1) {
                    $("#tblPharmacyEMG").css("width", "500px");
                }
                else if (lengthh == 3) {
                    $("#tblPharmacyEMG").css("width", "700px");
                }
                else if (lengthh == 4 || lengthh == 5) {
                    $("#tblPharmacyEMG").css("width", "900px");
                }
                else if (lengthh == 7 || lengthh == 8 || lengthh == 9) {
                    $("#tblPharmacyEMG").css("width", "1300px");
                }
                else if (lengthh == 10) {
                    $("#tblPharmacyEMG").css("width", "1500px");
                }
                else {
                    $("#tblPharmacyEMG").css("width", "2000px");
                }

                $('#tblPharmacyEMG').find('td,th').remove();
                $('#tblPharmacyEMG tbody').find('td,th,tr').remove();

                if (lengthh > 0) {
                    for (i = 0; i < lengthh; i++) {
                        var f = resData[0]["Date_" + i + ""];
                        if (typeof f != 'undefined') {
                            if (i == 0) {
                                $("#tblPharmacyEMG thead tr").append('<th style="background-color:#3278b5;color:#fff;z-index:500;top:0;" class="headcol myHeader">ItemName</th><th style="background-color:#3278b5;color:#fff;position:sticky;top:0;width:200px;" class="long myHeader">' + f + '</th>');
                            }
                            else {
                                $("#tblPharmacyEMG thead tr").append('<th style="background-color:#3278b5;color:#fff;width:200px;position:sticky;top:0;" class="long myHeader">' + f + '</th>');
                            }
                        }
                    }
                    GetPharmacyEMGItemName();
                }
                else {
                    alert("Record not found");
                    $("#btnSearch").val("Search");
                    $("#btnSearch").attr("disabled", false);
                }
            });
        }

        function GetPharmacyEMGItemName() {
            var from = $("#<%=FrmDate.ClientID%>").val();
            var to = $("#<%=ToDate.ClientID%>").val();

            serverCall('PatientDeltaCheck.aspx/GetPharmacyEMGItemName', { FromDate: from, ToDate: to }, function (response) {
                var resData = JSON.parse(response);
                $("#divPharmacyEMGReport").show();

                for (i = 0; i < resData.length; i++) {

                    var days = resData[i].Days;
                    var row = "";
                    row = "<tr><td class='headcol' style=''>" + resData[i].MedicineName + "</td>";

                    var ctr = 1; var dose = 0;
                    $('#tblPharmacyEMG th').each(function () {
                        var v = GetPharmacyEMGQty($(this).text(), resData[i].Medicine_ID);

                        if ($(this).text() == "ItemName") {
                        }
                        else {
                            
                            if (v != null && v > 0) {//$(this).text() == resData[i].DATE
                                row += "<td class='long' style='height:20px;'>" + v + "</td>";
                                dose = v;
                            }
                            else {
                                if (days == 0 || days == 1) {
                                    row += "<td class='long' style='height:20px;'>0</td>";
                                }
                                else {
                                    if (ctr > days - 1) {
                                        row += "<td class='long' style='height:20px;'>0</td>";
                                    }
                                    else {
                                        row += "<td class='long' style='height:20px;'>" + dose + "</td>";
                                    }
                                    ctr++;
                                }
                            }
                        }
                    });

                    row += "</tr>";
                    $("#tblPharmacyEMG tbody").append(row);
                }

            });
        }
 
        function GetPharmacyEMGQty(date, itemID) {
            var value = "0";
            $.ajax({
                url: "PatientDeltaCheck.aspx/GetPharmacyEMGQty",
                data: '{Date:"' + date + '",ItemID:"' + itemID + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    var resData = $.parseJSON(result.d);
                    if (resData.length > 0) {
                        value = resData[0].Qty;
                    }
                }
            });
            return value;
        }
    </script>
</asp:Content>

