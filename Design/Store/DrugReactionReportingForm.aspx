<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DrugReactionReportingForm.aspx.cs" Inherits="Design_Store_DrugReactionReportingForm" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
</head>
<body>
    
     <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <style type="text/css">
        .holder {
                position: relative;
            }
            .dropdown {
                width:500px;
                height:120px;
                overflow-y:auto;
                margin-top:25px;
                position: absolute;
                z-index:999;
                border: 1px solid black;
                display: none;
                background-color:white;
                color:black;
            }

            input:focus + .dropdown {
                display: block;
            }
        .deleted {
            display:none;
        }
        .ajax__scroll_none {
    overflow: visible !important;
    z-index: 10000 !important;
}
 
    </style>
    
    <script type="text/javascript">
        function isAlphaNumeric(e) {
            var k;
            document.all ? k = e.keycode : k = e.which;
            return ((k > 47 && k < 58) || (k > 64 && k < 91) || (k > 96 && k < 123) || k == 0 || k == 32);

        }


        function bindPatientInfo() {
            var TransID = '<%=Request.QueryString["TransactionID"]%>';
            // var PID = '<%=Request.QueryString["PID"]%>';
            var PID = '<%=patientid %>';
            if ($("#spanPatInfoID").text() != "") {
                PID = $("#spanPatInfoID").text();
            }
            jQuery.ajax({
                type: "POST",
                url: "DrugReactionReportingForm.aspx/BindPatientInfo",
                data: '{PID:"' + PID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    Newitem = jQuery.parseJSON(response.d);
                    if (Newitem != null) {
                        var dataLength = Newitem.length;

                        var objRow = Newitem[0];
                        if (dataLength > 0) {
                            $('#<%=rdbReportType.ClientID %>').find("input[value='" + objRow.ReportType + "']").prop("checked", true);
                            $('#<%=rdbAnyKnownAllergy.ClientID %>').find("input[value='" + objRow.AnyKnownAllergy + "']").prop("checked", true);
                            $('#<%=rdbPregnancyStatus.ClientID %>').find("input[value='" + objRow.PregnancyStatus + "']").prop("checked", true);
                            $('#<%=rdbSeverityOfReaction.ClientID %>').find("input[value='" + objRow.SeverityOfReaction + "']").prop("checked", true);
                            $('#<%=rdbActionTaken.ClientID %>').find("input[value='" + objRow.ActionTaken + "']").prop("checked", true);
                            $('#<%=rdbOutcome.ClientID %>').find("input[value='" + objRow.Outcome + "']").prop("checked", true);
                            $('#<%=rdbCausalityOfReaction.ClientID %>').find("input[value='" + objRow.CausalityOfReaction + "']").prop("checked", true);
                            if (objRow.AnyKnownAllergy == "Yes") {
                                $('#<%=txtAllergySpecify.ClientID %>').val(objRow.AnyKnownAllerySpecify);

                                $('#<%=txtAllergySpecify.ClientID %>').show();
                            }
                            $('#<%=txtWeight.ClientID %>').val(objRow.Weight);
                            $('#<%=txtHeight.ClientID %>').val(objRow.Height);
                            $('#<%=txtDiagnosis.ClientID %>').val(objRow.Diagnosis);
                            $('#<%=txtDateOfReaction.ClientID %>').val(objRow.OnSetReactionDate1);
                            $('#<%=txtBriefDescription.ClientID %>').val(objRow.Description);
                            $('#<%=txtAnyOtherComment.ClientID %>').val(objRow.Comment);
                            //$('#<%=txtDate.ClientID %>').val(objRow.Date1);
                            $('#StartTime_txtTime').val(objRow.Time);
                            $('#<%=txtEmailAddress.ClientID %>').val(objRow.EmailAddress);
                            $('#<%=txtPhoneNo.ClientID %>').val(objRow.PhoneNo);
                            // $('#<%=txtDesignation.ClientID %>').val(objRow.Designation);

                            $('#spanPatInfoID').text(objRow.ID);
                            bindDrugList();
                        }
                    }


                },
                error: function (xhr, status) {

                }
            });
        }
        function bindDrugList() {
            var TransID = '<%=Request.QueryString["TransactionID"]%>';
            var PID = '';
            if ('<%=Request.QueryString["PID"]%>' != "") {
                PID = '<%=Request.QueryString["PID"]%>';
            }
            else {
                PID = '<%=patientid %>';
            }
            if ($("#spanPatInfoID").text() != "") {
                PID = $("#spanPatInfoID").text();
            }
            jQuery.ajax({
                type: "POST",
                url: "DrugReactionReportingForm.aspx/BindDrugList",
                data: '{PID:"' + PID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    Newitem = jQuery.parseJSON(response.d);
                    if (Newitem != null) {
                        var dataLength = Newitem.length;

                        if (dataLength > 0) {
                            var lastrow = $('#addRow');

                            $("#addRow").remove();

                            for (var j = 0; j < dataLength; j++) {
                                objRow = Newitem[j];

                                var row = '<tr><td class="GridViewLabItemStyle" scope="col" ><span id="spanID" style="display:none;">' + objRow.ID + '</span>' + (parseInt(j) + 1) + '</td>';
                                row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanDrugName">' + objRow.DrugName + '</span><input type="hidden" id="textDrugName' + objRow.ID + '" value="' + objRow.DrugName + '" /></td>';
                                row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanBrandName">' + objRow.BrandName + '</td>';
                                row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanDose">' + objRow.Dose + '</td>';
                                row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanRouteAndFrequency">' + objRow.RouteAndFrequency + '</td>';
                                row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanDateStarted">' + objRow.DateStarted1 + '</td>';
                                row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanDateStopped">' + objRow.DateStopped1 + '</td>';
                                row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanIndication">' + objRow.Indication + '</td>';
                                if (objRow.SuspectedDrug == "1") {
                                    row += '<td class="GridViewLabItemStyle" scope="col" ><input id="chkSuspectedDrug" class="SuspectedDrug1" type="checkbox"  checked /></td>';
                                }
                                else {
                                    row += '<td class="GridViewLabItemStyle" scope="col" ><input id="chkSuspectedDrug" class="SuspectedDrug1"   type="checkbox"   /></td>';
                                }
                                row += '<td class="GridViewLabItemStyle" scope="col" >&nbsp;&nbsp;<img src="../../Images/Delete.gif"  class="link" onclick="editMode(' + objRow.ID + ');" alt="Delete" /></td></tr>';
                                $('#tblDrugList').append(row);
                            }
                            $('#tblDrugList').append(lastrow);

                            $("#tblDrugList").find(".SrNo").text(parseInt(j) + 1);
                            $("#tblDrugList").find(".DrugName").val('');
                            $("#tblDrugList").find(".BrandName").val('');
                            $("#tblDrugList").find(".Dose").val('');
                            $("#tblDrugList").find(".RouteAndFrequency").val('');
                            $('#<%=txtStartDate.ClientID %>').val('');
                            $('#<%=txtStoppedDate.ClientID %>').val('');
                            $("#tblDrugList").find(".Indication").val('');
                            $("#tblDrugList").find(".SuspectedDrug").prop('checked', false);

                        }
                    }


                },
                error: function (xhr, status) {

                }
            });
        }
        function DrugList() {
            var dataDrug = new Array();
            var ObjDrug = new Object();
            jQuery("#tblDrugList tr").each(function () {
                var id = jQuery(this).attr("id");


                var $rowid = jQuery(this).closest("tr");
                var cls = $rowid.attr("class");
                if ((id != "trHeader") && (id != "addRow")) {
                    if ($rowid.find("span[id*=spanDrugName]").text() != "") {
                        ObjDrug.ID = $rowid.find("span[id*=spanID]").text();
                        ObjDrug.DrugName = $rowid.find("span[id*=spanDrugName]").text();
                        ObjDrug.BrandName = $rowid.find("span[id*=spanBrandName]").text();
                        ObjDrug.Dose = $rowid.find("span[id*=spanDose]").text();
                        ObjDrug.RouteAndFrequency = $rowid.find("span[id*=spanRouteAndFrequency]").text();
                        ObjDrug.DateStarted = $rowid.find("span[id*=spanDateStarted]").text();
                        ObjDrug.DateStopped = $rowid.find("span[id*=spanDateStopped]").text();
                        ObjDrug.Indication = $rowid.find("span[id*=spanIndication]").text();
                        // ObjDrug.PatientID = $rowid.find("span[id*=spanPatientID]").text();
                        // ObjDrug.Date = $rowid.find("span[id*=spanDate]").text();
                        if (cls == 'deleted') {
                            ObjDrug.IsDeleted = "1";
                        }
                        else {
                            ObjDrug.IsDeleted = "0";
                        }
                        var chksus = $rowid.find("input[id*=chkSuspectedDrug]").is(":checked");
                        if (chksus == true) {
                            ObjDrug.SuspectedDrug = "1";
                        }
                        else {
                            ObjDrug.SuspectedDrug = "0";
                        }
                        var isvalid = "0";
                        if (ObjDrug.DrugName == "") {
                            isvalid = "DrugName";
                        }
                        if (ObjDrug.BrandName == "") {
                            isvalid = "BrandName";
                        }
                        if (ObjDrug.Dose == "") {
                            isvalid = "Dose";
                        }
                        if (ObjDrug.RouteAndFrequency == "") {
                            isvalid = "RouteAndFrequency";
                        }
                        if (ObjDrug.DateStarted == "") {
                            isvalid = "DateStarted";
                        }
                        if (ObjDrug.DateStopped == "") {
                            isvalid = "DateStopped";
                        }
                        if (ObjDrug.Indication == "") {
                            isvalid = "Indication";
                        }

                        localStorage.setItem("isvalid", isvalid);



                        if ((ObjDrug.DrugName != "") && (ObjDrug.BrandName != "")) {
                            dataDrug.push(ObjDrug);
                        }

                        ObjDrug = new Object();
                    }
                }


            });
            return dataDrug;
        }
        function patientInfo() {
            var dataPat = new Array();
            var ObjPat = new Object();
            ObjPat.ID = $('#spanPatInfoID').text();
            ObjPat.ReportType = $('#<%=rdbReportType.ClientID %> input[type=radio]:checked').val();
            ObjPat.AnyKnownAllergy = $('#<%=rdbAnyKnownAllergy.ClientID %> input[type=radio]:checked').val();
            ObjPat.AnyKnownAllerySpecify = $('#<%=txtAllergySpecify.ClientID %>').val();
            ObjPat.PregnancyStatus = $('#<%=rdbPregnancyStatus.ClientID %> input[type=radio]:checked').val();
            ObjPat.Weight = $('#<%=txtWeight.ClientID %>').val();
            ObjPat.Height = $('#<%=txtHeight.ClientID %>').val();
            ObjPat.Diagnosis = $('#<%=txtDiagnosis.ClientID %>').val();
            ObjPat.OnSetReactionDate = $('#<%=txtDateOfReaction.ClientID %>').val();
            ObjPat.Description = $('#<%=txtBriefDescription.ClientID %>').val();
            ObjPat.SeverityOfReaction = $('#<%=rdbSeverityOfReaction.ClientID %> input[type=radio]:checked').val();
            ObjPat.ActionTaken = $('#<%=rdbActionTaken.ClientID %> input[type=radio]:checked').val();
            ObjPat.Outcome = $('#<%=rdbOutcome.ClientID %> input[type=radio]:checked').val();
            ObjPat.CausalityOfReaction = $('#<%=rdbCausalityOfReaction.ClientID %> input[type=radio]:checked').val();
            ObjPat.Comment = $('#<%=txtAnyOtherComment.ClientID %>').val();
            ObjPat.ReportingPersonName = $('#<%=txtPersonReporting.ClientID %>').val();
            ObjPat.Date = $('#<%=txtDate.ClientID %>').val();
            ObjPat.Time = $('#StartTime_txtTime').val();
            ObjPat.EmailAddress = $('#<%=txtEmailAddress.ClientID %>').val();
            ObjPat.PhoneNo = $('#<%=txtPhoneNo.ClientID %>').val();
            ObjPat.Designation = $('#<%=txtDesignation.ClientID %>').val();
            dataPat.push(ObjPat);



            return dataPat;
        }
        function validate() {
            if (($('#<%=txtWeight.ClientID %>').val() == "") && ($('#<%=txtHeight.ClientID %>').val() == "") && ($('#<%=txtDiagnosis.ClientID %>').val() == "") && ($('#<%=txtBriefDescription.ClientID %>').val() == "") && ($('#<%=txtAnyOtherComment.ClientID %>').val() == "") && ($('#<%=txtEmailAddress.ClientID %>').val() == "") && ($('#<%=txtPhoneNo.ClientID %>').val() == "")) {
                alert("All Fields can not be empty.");
                return false;
            }

        }
        function saveData() {

            if (validate() == false) {
                return false;
            }
            var patInfo = patientInfo();

            localStorage.setItem("isvalid", "0");
            var drugList = DrugList();
            var isvalid = localStorage.getItem("isvalid");
            if (isvalid != "0") {
                alert(isvalid + " can not be empty.");
                return false;
            }
            var DID = '<%=Request.QueryString["DoctorID"]%>';
            var TID = '<%=Request.QueryString["TransactionID"]%>';
            var PID = '';
            if ('<%=Request.QueryString["PID"]%>' != "") {
                PID = '<%=Request.QueryString["PID"]%>';
            }
            else {
                PID = '<%=patientid %>';
            }
            if (drugList != "") {
                serverCall('DrugReactionReportingForm.aspx/SaveData', { DrugList: drugList, PID: PID, TID: TID, DID: DID, PatientInfo: patInfo }, function (response) {
                    var IntakeOutPut = JSON.parse(response);
                    if (IntakeOutPut.status)
                    {
                        modelAlert(IntakeOutPut.response, function (response) {
                            clear();

                        });
                    }
                    else {
                        modelAlert(IntakeOutPut.response);
                        //bindPatientInfo();
                    }
                });

                //$.ajax({
                //    type: "POST",
                //    data: JSON.stringify({ DrugList: drugList, PID: PID, TID: TID, DID: DID, PatientInfo: patInfo }),
                //    url: "DrugReactionReportingForm.aspx/SaveData",
                //    dataType: "json",
                //    contentType: "application/json;charset=UTF-8",
                //    timeout: 120000,
                //    async: false,
                //    success: function (result) {
                //        var IntakeOutPut = (result.d);
                //        if (IntakeOutPut == '1') {
                           


                //        }
                       
                //    },
                //    error: function (xhr, status) {
                //        window.status = status + "\r\n" + xhr.responseText;
                //        $("#lblMsg").text('Error occurred, Please contact administrator');
                //        $('#btnSave').removeProp('disabled');
                //    }

                //});
            }
            else
                alert('Please fill At Least One medicine');

        }

        function clear() {

            $("#<%= rdbReportType.ClientID %> input[type=radio]").prop('checked', false);
            $("#<%= rdbAnyKnownAllergy.ClientID %> input[type=radio]").prop('checked', false);
            $("#<%= rdbPregnancyStatus.ClientID %> input[type=radio]").prop('checked', false);
            $("#<%= rdbSeverityOfReaction.ClientID %> input[type=radio]").prop('checked', false);

            $("#<%= rdbActionTaken.ClientID %> input[type=radio]").prop('checked', false);
            $("#<%= rdbCausalityOfReaction.ClientID %> input[type=radio]").prop('checked', false);
            $("#<%= rdbOutcome.ClientID %> input[type=radio]").prop('checked', false);



            $('#<%=txtWeight.ClientID %>').val("");
            $('#<%=txtHeight.ClientID %>').val("");
            $('#<%=txtDiagnosis.ClientID %>').val("");
            $('#<%=txtDateOfReaction.ClientID %>').val("");
            $('#<%=txtBriefDescription.ClientID %>').val("");
            $('#<%=txtAnyOtherComment.ClientID %>').val("");

            $('#<%=txtEmailAddress.ClientID %>').val("");
            $('#<%=txtPhoneNo.ClientID %>').val("");

            jQuery("#tblDrugList tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                var cls = $rowid.attr("class");
                if ((id != "trHeader") && (id != "addRow")) {
                    jQuery(this).closest("tr").remove();
                } else if (id != "addRow") {
                    $("#tblDrugList").find(".SrNo").text(1);
                }


            });


        }
        function addRow() {
            var lastrow = $('#addRow');

            var srno = $("#tblDrugList").find(".SrNo").text();
            var drugname = $("#txtDrugName").val();
            var brandname = $("#txtBrandName").val();
            var dose = $("#txtDose").val();
            var routeandfrequency = $("#txtRouteAndFrequency").val();
            var datestarted = $('#<%=txtStartDate.ClientID %>').val();
            var datestopped = $('#<%=txtStoppedDate.ClientID %>').val();
            var indication = $("#txtIndication").val();
            var suspecteddrug = $("#chkSuspectedDrug3").is(":checked");

            if (drugname == "") {
                alert("Drug Name can not be left empty.");
                return false;
            }

            if (brandname == "") {
                alert("Brand Name can not be left empty.");
                return false;
            }
            if (dose == "") {
                alert("Dose  can not be left empty.");
                return false;
            }
            if (routeandfrequency == "") {
                alert("RouteAndFrequency can not be left empty.");
                return false;
            }
            if (datestarted == "") {
                alert("StartDate can not be left empty.");
                return false;
            }
            if (datestopped == "") {
                alert("StoppedDate can not be left empty.");
                return false;
            }
            if (indication == "") {
                alert("Indication can not be left empty.");
                return false;
            }

            $("#addRow").remove();
            var row = '<tr><td class="GridViewLabItemStyle" scope="col" ><span id="spanID"></span>' + srno + '</td>';
            row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanDrugName">' + drugname + '</span><input type="hidden" id="txtEditDrugName" class="DrugName" value="' + drugname + '" /></td>';
            row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanBrandName">' + brandname + '</span><input type="hidden" id="txtEditBrandName" class="BrandName" value="' + brandname + '" /></td>';
            row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanDose">' + dose + '</span><input type="hidden" id="txtEditDose" class="Dose" value="' + dose + '" /></td>';
            row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanRouteAndFrequency">' + routeandfrequency + '</span><input type="hidden" id="txtEditRouteAndFrequency" class="RouteAndFrequency" value="' + routeandfrequency + '" /></td>';
            row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanDateStarted">' + datestarted + '</span><input type="hidden" id="txtEditDateStarted" class="DateStarted" value="' + datestarted + '" /></td>';
            row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanDateStopped">' + datestopped + '</span><input type="hidden" id="txtEditDateStopped" class="DateStopped" value="' + datestopped + '" /></td>';
            row += '<td class="GridViewLabItemStyle" scope="col" ><span id="spanIndication">' + indication + '</span><input type="hidden" id="txtEditIndication" class="Indication" value="' + indication + '" /></td>';
            if (suspecteddrug == true) {
                row += '<td class="GridViewLabItemStyle" scope="col" ><input id="chkSuspectedDrug" type="checkbox" class="SuspectedDrug1"   checked /></td>';
            }
            else {
                row += '<td class="GridViewLabItemStyle" scope="col" ><input id="chkSuspectedDrug"  type="checkbox" class="SuspectedDrug1"    /></td>';
            }
            row += '<td class="GridViewLabItemStyle" scope="col" >&nbsp;&nbsp;<img src="../../Images/Delete.gif"  id="txtTableRow' + srno + '" class="link" onclick="editMode1(' + srno + ');" alt="Delete" /></td></tr>';
            $('#tblDrugList').append(row);
            $('#tblDrugList').append(lastrow);

            $("#tblDrugList").find(".SrNo").text((parseInt(srno) + 1));
            $("#txtDrugName").val('');
            $("#txtBrandName").val('');
            $("#txtDose").val('');
            $("#txtRouteAndFrequency").val('');
            $('#<%=txtStartDate.ClientID %>').val('');
            $('#<%=txtStoppedDate.ClientID %>').val('');
            $("#txtIndication").val('');
            $("#chkSuspectedDrug3").prop('checked', false);

        }
        function editMode(id) {
            $("#textDrugName" + id).closest('tr').addClass('deleted');
            window.stop();
        }
        function editMode1(id) {
            $("#txtTableRow" + id).closest('tr').remove();
            window.stop();
        }


        function getDrugName(dn) {
            //alert(dn);
            $("#txtDrugName").val(dn);
            $('.dropdown').hide();
        }
        function search() {
            var key = $('#txtDrugName').val();
            //alert(key);
            jQuery.ajax({
                type: "POST",
                url: "DrugReactionReportingForm.aspx/BindSearch",
                data: '{key:"' + key + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    if ((response.d != null) && (response.d != "")) {
                        Newitem = jQuery.parseJSON(response.d);


                        var str = "<table>";
                        for (var i = 0; i < Newitem.length; i++) {
                            var objrow = Newitem[i];
                            str += "<tr><td><a  onclick='getDrugName(&quot;" + objrow.NAME + "&quot;);'>" + objrow.NAME + "</a></td></tr>";

                        }
                        str += "</table>";
                        $(".dropdown").html(str);
                        $(".dropdown").show();
                    }
                },
                error: function (e) { }
            });
        }

        $(document).ready(function () {

            $("#StartTime_txtTime").prop('disabled', true);
            $('#chkSelectAll').change(function () {
                if ($(this).is(':checked')) {
                    $(".SuspectedDrug1").prop('checked', true);
                }
                else {

                    $(".SuspectedDrug1").prop('checked', false);
                }
            });
            bindPatientInfo();
            //bindDrugList();
            $('#rdbAnyKnownAllergy_1').change(function () {
                if (this.value == 'Yes') {
                    $("#txtAllergySpecify").show();
                }

            });
            $('#rdbAnyKnownAllergy_1').change(function () {
                if (this.value == 'No') {
                    $("#txtAllergySpecify").hide();

                }
            });
        });
        $("form").attr('autocomplete', 'off');
    </script>

    <form id="form1" runat="server" autocomplete="off" >
    <div>
            
<%--    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/Common.js"></script>--%>
 
        
        
    
    <div id="Pbody_box_inventory">
        
        <cc1:ToolkitScriptManager ID="scrManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>SUSPECTED ADVERSE DRUG REACTION REPORTING FORM</b><br /><span id="spanPatInfoID" runat="server" style="display:none;"></span>
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
        
            <div class="row">
       
         
        <div class="col-md-6">
            <asp:RadioButtonList ID="rdbReportType" runat="server" RepeatDirection="Horizontal" Width="445"
                >
                                                <asp:ListItem Value="Initial Report" >Initial Report</asp:ListItem>
                                          <asp:ListItem Value="Follow Up Report">Follow Up Report</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
            </div>
         
        <div class="col-md-4">
            <asp:TextBox ID="TextBox1" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="Specify"  style="display:none;"/>
            </div>
         </div>
     
    <br /> <br />
     <div class="row">
        <div class="col-md-5">
            <b>ANY KNOWN ALLERY</b>
            </div>
         
        <div class="col-md-6">
            <asp:RadioButtonList ID="rdbAnyKnownAllergy" runat="server" RepeatDirection="Horizontal" Width="445"
                >
                                                <asp:ListItem Value="No" >No</asp:ListItem>
                                          <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
            </div>
         
        <div class="col-md-4">
            <asp:TextBox ID="txtAllergySpecify" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="Specify"  style="display:none;"/>
            </div>
         </div>
            
     <div class="row">
        <div class="col-md-5">
        
            <b>PREGNANCY STATUS</b>
            </div>
         
        <div class="col-md-19">
            <asp:RadioButtonList ID="rdbPregnancyStatus" runat="server" RepeatDirection="Horizontal" Width="100%">
                                                <asp:ListItem Value="Not Applicable" >Not Applicable</asp:ListItem>
                                          <asp:ListItem Value="Not Pregnant">Not Pregnant</asp:ListItem>
                                           <asp:ListItem Value="1st Trimester">1<sup>st</sup> Trimester</asp:ListItem>
                                           <asp:ListItem Value="2nd Trimester">2<sup>nd</sup> Trimester</asp:ListItem>
                                           <asp:ListItem Value="3rd Trimester">3<sup>rd</sup> Trimester</asp:ListItem>
                                      </asp:RadioButtonList>
           
        </div>
         </div>
            
         
     <div class="row">
        <div class="col-md-5">
            <b>WEIGHT<span >(Kg)</span></b>
            </div>
         
        <div class="col-md-6">

                         <asp:TextBox ID="txtWeight" autocomplete="off" runat="server" TabIndex="1"  ClientIDMode="Static"  style="display:inline;width:80px;"  ToolTip="Enter Weight" MaxLength="4" />
             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender17" runat="server" TargetControlID="txtWeight" ValidChars="0987654321/.">
                                </cc1:FilteredTextBoxExtender>
    </div>
         <div class="col-md-5"  >
            <b>HEIGHT<span>(cm)</span></b>
             </div>
         
        <div class="col-md-8">
                         <asp:TextBox ID="txtHeight" autocomplete="off" runat="server" TabIndex="1"  style="display:inline;width:80px;" ClientIDMode="Static"    ToolTip="Enter Height" MaxLength="4"  />
              <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtHeight" ValidChars="0987654321/." />
    </div>
         </div>
    <br /><br />
     <div class="row">
        <div class="col-md-5">
            <b>DIAGNOSIS</b><span style='font-size:11px;'>(what was the patient treated for?)</span>
            </div>
         
        <div class="col-md-19">
            <asp:TextBox runat="server" ID="txtDiagnosis" autocomplete="off" TextMode="MultiLine" Rows="3"  onkeypress="return isAlphaNumeric(event,this.value);"  />
    
            </div>
         </div>
         <div class="row">
                                <div class="col-md-5">
                                    <b> DATE OF ONSET ON REACTION   </b>
                                    
                                </div>
                                <div class="col-md-6">
                                    <asp:TextBox ID="txtDateOfReaction" autocomplete="off" runat="server" Width="120"></asp:TextBox>
                                        
                    <cc1:CalendarExtender ID="calExtenderToDate" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtDateOfReaction"></cc1:CalendarExtender>
                                       </div>
                               </div>
    
     <div class="row">
        <div class="col-md-5">
            <b>BRIEF DESCRIPTION OF REACTION</b>
            </div>
         
        <div class="col-md-19">
            <asp:TextBox runat="server" ID="txtBriefDescription" autocomplete="off" style="width:100%;height:50px;" TextMode="MultiLine" Rows="10"  onkeypress="return isAlphaNumeric(event,this.value);" />
            </div>
         </div>
     </div>
        
        <div class="POuter_Box_Inventory">
     <div class="row">
        <div class="col-md-24">
            <label><b>LIST OF ALL DRUGS USED IN THE LAST 3 MONTHS PRIOR TO REACTION. IF PREGNANT INDICATE DRUGS USED IN 1ST TRIMESTER
                        (include OTC and herbals)</b>
                          </label>
            <table id="tblDrugList" class="FixedTables"  style="width:100%;">
                <tr id="trHeader">
                     <th class="GridViewHeaderStyle" scope="col" >Sr No</th>
                   
                    <th class="GridViewHeaderStyle" scope="col"  >DRUG NAME
                         </th>
                    <th class="GridViewHeaderStyle" scope="col" >BRAND NAME</th>
                    <th class="GridViewHeaderStyle" scope="col" >DOSE</th>
                     <th class="GridViewHeaderStyle" scope="col" >ROUTE AND FREEQUENCY</th>
                     <th class="GridViewHeaderStyle" scope="col" >DATE STARTED</th>
                     <th class="GridViewHeaderStyle" scope="col" >DATE STOPPED</th>
                     <th class="GridViewHeaderStyle" scope="col" >INDICATION</th>
                     <th class="GridViewHeaderStyle" scope="col" ><input type="checkbox" id="chkSelectAll" />TICK SUSPECTED DRUG(S)</th>
                     <th class="GridViewHeaderStyle" scope="col" >Remove</th>
                </tr>
                <tr id="addRow">
                    
                    <td class="GridViewLabItemStyle" scope="col" ><span class="SrNo">1</span></td>
                    <td class="GridViewLabItemStyle  holder" scope="col"  style="margin-top:0px;" ><div class="" style="margin-top:0px;">
                        <input type="text" id="txtDrugName" class="DrugName" style="width:100px;"    onkeyup="search();"    />
                        </div>
                        <div class="dropdown">
                            
                        </div>
                            
                         </td>
                    <td class="GridViewLabItemStyle" scope="col" ><input type="text" id="txtBrandName" class="BrandName"  onkeypress="return isAlphaNumeric(event,this.value);"  /></td>
                    <td class="GridViewLabItemStyle" scope="col" ><input type="text" id="txtDose"  class="Dose" onkeypress="return isAlphaNumeric(event,this.value);"  /></td>
                     <td class="GridViewLabItemStyle" scope="col" ><input type="text" id="txtRouteAndFrequency" class="RouteAndFrequency"  onkeypress="return isAlphaNumeric(event,this.value);"  /></td>
                     <td class="GridViewLabItemStyle" scope="col" >
                                    <asp:TextBox ID="txtStartDate" runat="server"  CssClass="StartDate"  ></asp:TextBox>
                         
                    <cc1:CalendarExtender ID="calExtenderFromDate" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtStartDate"></cc1:CalendarExtender>
                     </td>
                     <td class="GridViewLabItemStyle" scope="col" >
                                    <asp:TextBox ID="txtStoppedDate" runat="server"   CssClass="StoppedDate"  ></asp:TextBox>
                         
                    <cc1:CalendarExtender ID="CalendarExtender2" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtStoppedDate"></cc1:CalendarExtender>
                     </td>
                     <td class="GridViewLabItemStyle" scope="col" ><input type="text" id="txtIndication" class="Indication"  onkeypress="return isAlphaNumeric(event,this.value);"  /></td>
                     <td class="GridViewLabItemStyle" scope="col" ><input type="checkbox" id="chkSuspectedDrug3"  class="SuspectedDrug"  /></td>
                     <td class="GridViewLabItemStyle" scope="col" ></td>
                </tr>
 
            </table>
            
            </div>
         </div>
         <div class="row">
             <div class="col-md-24">
                             <button type="button" value="ADD"  onclick="addRow();">ADD</button>
                 </div>

            </div>
         </div>
            
 
        
        <div class="POuter_Box_Inventory">
     <div class="row">
        <div class="col-md-5">
            <b>SEVERITY OF REACTION</b><br />
            (refer to scale overleaf)
            <asp:RadioButtonList ID="rdbSeverityOfReaction" runat="server" RepeatDirection="Vertical">
                                                <asp:ListItem Value="Mild" >Mild</asp:ListItem>
                                          <asp:ListItem Value="Moderate">Moderate</asp:ListItem>
                                           <asp:ListItem Value="Severe">Severe</asp:ListItem>
                                           <asp:ListItem Value="fatal">Fatal</asp:ListItem>
                                           <asp:ListItem Value="Unknown">Unknown</asp:ListItem>
                                      </asp:RadioButtonList>
           
        </div>
        <div class="col-md-5">
            <b>ACTION TAKEN</b><br />
            
            <asp:RadioButtonList ID="rdbActionTaken" runat="server" RepeatDirection="Vertical">
                                                <asp:ListItem Value="Drug Withdrawn" >Drug Withdrawn</asp:ListItem>
                                          <asp:ListItem Value="Dose Increased">Dose Increased</asp:ListItem>
                                           <asp:ListItem Value="Dose Reduced">Dose Reduced</asp:ListItem>
                                           <asp:ListItem Value="Dose Not Changed">Dose Not Changed</asp:ListItem>
                                           <asp:ListItem Value="Unknown">Unknown</asp:ListItem>
                                      </asp:RadioButtonList>
           
        </div>
         <div class="col-md-8">
            <b>OUTCOME</b><br />
            
            <asp:RadioButtonList ID="rdbOutcome" runat="server" RepeatDirection="Vertical">
                                                <asp:ListItem Value="Recovering/Resolving"  >Recovering/Resolving</asp:ListItem>
                                          <asp:ListItem Value="Recovered/Resolved">Recovered/Resolved</asp:ListItem>
                                           <asp:ListItem Value="Requires or Prolong Hospitalization">Requires or Prolong Hospitalization</asp:ListItem>
                                           <asp:ListItem Value="Causes a Congenital Anomaly">Causes a Congenital Anomaly</asp:ListItem>
                                           <asp:ListItem Value="Requires Intervention To Prevent Permanent Damage">Requires Intervention To Prevent Permanent Damage</asp:ListItem>
                                           <asp:ListItem Value="Unknown">Unknown</asp:ListItem>
                                      </asp:RadioButtonList>
           
        </div>
         <div class="col-md-6">
            <b>CAUSALITY OF REACTION</b><br />
             (refer to scale overleaf)
            
            <asp:RadioButtonList ID="rdbCausalityOfReaction" runat="server" RepeatDirection="Vertical">
                                                <asp:ListItem Value="Certain" >Certain</asp:ListItem>
                                          <asp:ListItem Value="Probable/Likely">Probable/Likely</asp:ListItem>
                                           <asp:ListItem Value="Possible">Possible</asp:ListItem>
                                           <asp:ListItem Value="UnLikely">UnLikely</asp:ListItem>
                                           <asp:ListItem Value="Conditional/UnClassified">Conditional/UnClassified</asp:ListItem>
                                           <asp:ListItem Value="UnAssessable/UnClassifiable">UnAssessable/UnClassifiable</asp:ListItem>
                                      </asp:RadioButtonList>
           
        </div>
        
          </div>
     
     <div class="row">
        <div class="col-md-5">
            <b>ANY OTHER COMMENT</b>
            </div>
         <div class="col-md-19">
            <asp:TextBox runat="server" ID="txtAnyOtherComment" style="width:100%;height:50px;" TextMode="MultiLine" Rows="10" onkeypress="return isAlphaNumeric(event,this.value);"  />
            </div>
         </div>
      <div class="row">
        <div class="col-md-5">
            Name Of Person Reporting 
            </div>
          
        <div class="col-md-6">
           
                                    <asp:TextBox ID="txtPersonReporting" runat="server"  disabled></asp:TextBox>
            
            </div>
          <div class="col-md-5">
                                     DATE 
                                    
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtDate" runat="server"  style="z-index:999;" Enabled="false"></asp:TextBox>
                                       <cc1:CalendarExtender ID="CalendarExtender1" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtDate"></cc1:CalendarExtender>
                    </div>
                                <div class="col-md-5"> <uc2:StartTime ID="StartTime" runat="server" />
                           
                                       </div>
          </div>
<div class="row">
        <div class="col-md-5">
            E-Mail Address 
            </div>
          
        <div class="col-md-6">
           
                                    <asp:TextBox ID="txtEmailAddress" runat="server" ></asp:TextBox>
            
            </div>
          <div class="col-md-5">
                                     Phone No     
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="txtPhoneNo" runat="server"  style="z-index:0;"  MaxLength="10" ></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtPhoneNo" ValidChars="0987654321" />
                                       </div>
    </div>
            <div class="row">
        <div class="col-md-5">
            Designation 
            </div>
          
        <div class="col-md-6">
           
                                    <asp:TextBox ID="txtDesignation" runat="server"  onkeypress="return isAlphaNumeric(event,this.value);" Enabled="false" ></asp:TextBox>
            
            </div>
          <div class="col-md-5">
                                    <label class="pull-left">    </label>
                                    
                                </div>
                                <div class="col-md-8">
                                    
                                       
                                       </div>
          </div>
</div>
          <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                           
                        </div>
                        <div class="col-md-5">
                            
                        </div>
                        <div class="col-md-3">
                           <%--<asp:Button ID="btnSave" runat="server"  autocomplete="off" CssClass="save" Text="Save" OnClientClick="return saveData();" ClientIDMode="Static"  /> 
                          --%>
                            
                            <input type="button" class="save" onclick="saveData();" value="Save" />

                        </div>
                        
                        
                        <div class="col-md-3">
                           
                        </div>
                        <div class="col-md-3">
                                   </div>
                        
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:GridView ID="grdPhysical" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" OnRowDataBound="grdPhysical_RowDataBound" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientName" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date1") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Time">
                            <ItemTemplate>
                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPID" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Entry By">
                            <ItemTemplate>
                                <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("ReportingPersonName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"   />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CausesValidation="false" CommandName='<%#Eval("PatientID") %>' CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Delete">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit1" AlternateText="Edit" CausesValidation="false" CommandName='Del' CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/Delete.gif" runat="server" />
                                <asp:Label ID="lblID1" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit2" AlternateText="Edit" CausesValidation="false" CommandName='Print' CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/print.gif" runat="server" />
                                <asp:Label ID="lblID12" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div id="divModal" class="modal fade">
                    <div class="modal-dialog modal-sm"" >
                        <div class="modal-content">
                            <div class="modal-header">
                                <b class="modal-title">Success Message</b> <button type="button" class="close"  onclick="$('#divModal').hide();">&times;</button>
                            </div>
                            <div class="modal-body"  style="width:200px;height:60px;">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                        <span id="spanMsg"></span><br /><br />
                                        <button type="button"  onclick="$('#divModal').hide();">OK</button>
                                    </div>
                                </div>
                                                                        </div>
                            <div class="modal-footer">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
    </div>
        
    </form>
</body>
</html>
