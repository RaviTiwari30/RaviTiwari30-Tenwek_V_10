<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Summary.aspx.cs" Inherits="Design_MIS_Summary" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript"  src="../../Scripts/jquery.tablednd.js"></script>
   <%-- <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>--%>
    
    <script type="text/javascript">
        function GetCenter() {
            $("#ddlCentre option").remove();
            $.ajax({
                url: "Services/mis.asmx/BindMISCenter",
                data: '{UserID:"' + $('#lblUserID').text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    Center = jQuery.parseJSON(result.d);
                    if (Center.length == 0) {
                        $("#ddlCentre").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < Center.length; i++) {
                            $("#ddlCentre").append($("<option></option>").val(Center[i].CentreID).html(Center[i].CentreName));
                        }
                        $("#ddlCentre").val('<%=GetGlobalResourceObject("Resource", "DefaultCentreID") %>');
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    $("#ddlCentre").attr("disabled", false);
                }
            });
        }
        </script>
    <script type="text/javascript" >
        $(document).ready(function () {
            if ($('#lblUserSettingAvail').text() == "0") {
                LoadDefaultSetting();
            }
            GetCenter();
        });
        function LoadDefaultSetting() {
            $('#td_0').append('<div id="OPD_Detail" ></div>');
            $('#td_0').append('<div id="OPD_Patient_visitwise"></div>');
            $('#td_0').append('<div id="BillingDetail"></div>');
            $('#td_0').append('<div id="Admission"></div>');
            $('#td_0').append('<div id="Discount"></div>');
            //$('#td_0').append('<div id="HR_Detail"></div>');
            $('#td_0').append('<div id="Surgery_Doctorwise_Detail"></div>');
            $('#td_0').append('<div id="CategoryWiseRevenue"></div>');

            $('#td_1').append('<div id="Doctor_appointment" ></div>');
            $('#td_1').append('<div id="BedDetail" ></div>');
            $('#td_1').append('<div id="UserWiseCollection"></div>');
            $('#td_1').append('<div id="Purchase_Detail"></div>');
            $('#td_1').append('<div id="Store_Detail"></div>');
            $('#td_1').append('<div id="Surgery_Detail"></div>');
            $('#td_1').append('<div id="OPD_Procedure_Detail"></div>');
            $('#td_1').append('<div id="Emergency_Detail"></div>');
            $('#td_1').append('<div id="SubCategoryWiseRevenue"></div>');
        }
        function ClearDefaultSetting() {
            $('#OPD_Detail,#OPD_Patient_visitwise,#BillingDetail,#Admission,#Discount,#HR_Detail,#Surgery_Doctorwise_Detail,#CategoryWiseRevenue,#Doctor_appointment,#BedDetail,#UserWiseCollection,#Purchase_Detail,#Store_Detail,#Surgery_Detail,#OPD_Procedure_Detail,#Emergency_Detail,#SubCategoryWiseRevenue').html('');
        }
        $(function () {
            $("#dialog").dialog({
                width: 600,
                autoOpen: false,
                show: {
                    effect: "blind",
                    duration: 1000
                },
                hide: {
                    effect: "explode",
                    duration: 1000
                }
            });

            $("#imgSetting").click(function () {
                $.ajax({
                    url: "Services/mis.asmx/Load_mis_tab",
                    data: '{UserSettingAvail:"' + $('#lblUserSettingAvail').text() + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {

                        var mis_data = jQuery.parseJSON(mydata.d);
                        if (mis_data.length > 0) {


                            var table1 = '<table  width="100%" id="mis_table1" border="3" bordercolor="#2C5A8B"   cellspacing="2" cellpadding="2">';
                            var table2 = '<table width="100%" id="mis_table2" border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">';
                            var a1 = 0;
                            var a2 = 1;
                            var visibleStatus = '';
                            for (var i = 0; i < mis_data.length; i++) {


                                if (mis_data[i].IsVisible == "1") {
                                    visibleStatus = 'checked="checked"';
                                }
                                else {
                                    visibleStatus = '';
                                }

                                if (mis_data[i].ColumnNo == "0") {

                                    table1 += '<tr class="row-' + a1 + '">';
                                    table1 += '<td   colspan="1" style="cursor: move;color:black;font-weight:bold;" class="right"><input type="checkbox" style="cursor: pointer;" id="chk1" ' + visibleStatus + '/>' + mis_data[i].Title + '<span style="display:none" id="MasterID">' + mis_data[i].ID + '</span><span style="display:none" id="row">' + mis_data[i].RowNo + '</span><span style="display:none" id="column">' + mis_data[i].ColumnNo + '</span></td>';
                                    table1 += '</tr>';
                                    a1 = a1 + 1;
                                    if (a1 > 2) {
                                        a1 = 1;
                                    }
                                }
                                else {
                                    table2 += '<tr class="row-' + a2 + '">';
                                    table2 += '<td colspan="1" style="cursor: move;color:black;font-weight:bold;" class="right"><input type="checkbox" style="cursor: pointer;" id="chk2" ' + visibleStatus + '/>' + mis_data[i].Title + '<span style="display:none" id="MasterID">' + mis_data[i].ID + '</span><span style="display:none" id="row">' + mis_data[i].RowNo + '</span><span style="display:none" id="column">' + mis_data[i].ColumnNo + '</span></td>';
                                    table2 += '</tr>';
                                    a2 = a2 + 1;
                                    if (a2 > 2) {
                                        a2 = 1;
                                    }
                                }

                            }
                            table1 += '</table>';
                            table2 += '</table>';

                            ///merge both table
                            var table = '<table  id="mis_table" border="3"   cellspacing="2" cellpadding="2"><tr><td valign="top" width="300" class="right" style="cursor: move;color:White;font-weight:bold;"> ' + table1 + ' </td><td  valign="top"  width="300" class="right" style="cursor: move;color:White;font-weight:bold;"> ' + table2 + ' </td></tr></table>';
                            table += '<div style="width:100%;text-align:center"> <input type="button" id="btnReset" onclick="ResetSetting()" value="Reset"/>&nbsp;&nbsp;<input type="button" id="btnSaveSetting" onclick="SaveSetting()" value="Save"/></div>';

                            $('#dialog').html(table);
                            $("#dialog").dialog("open");
                        }
                    }

                });

       
                $('#mis_table1').tableDnD({
                    onDrop: function (table, row) {
                    },
                    dragHandle: ".dragHandle"
                });
                $("#mis_table2").tableDnD({
                    onDragClass: "GridViewDragItemStyle",
                    onDragStart: function (table, row) {

                    }
                });

            });


        });

        function ResetSetting() {
            DeleteUserSetting($('#lblUserID').text());
            alert('Setting Reset Successfully');
            $("#dialog").dialog('close');

            $('#lblUserSettingAvail').text('0')
            $('#td_0').html('');
            $('#td_1').html('');
            LoadDefaultSetting();
        }
        function SaveSetting() {
            DeleteUserSetting($('#lblUserID').text());
            var i = 0;
            $('#mis_table1 tr td').each(function () {

                if ($(this).find('input[type=checkbox]').is(':checked')) {
                    //$(this).find('#row').text()
                    InsertUserSetting(i, $(this).find('#column').text(), $(this).find('#MasterID').text(), $('#lblUserID').text(), 1);

                }
                else {
                    InsertUserSetting(i, $(this).find('#column').text(), $(this).find('#MasterID').text(), $('#lblUserID').text(), 0);

                }
                i = i + 1;

            });
            i = 0;
            $('#mis_table2 tr td').each(function () {

                if ($(this).find('input[type=checkbox]').is(':checked')) {
                    InsertUserSetting(i, $(this).find('#column').text(), $(this).find('#MasterID').text(), $('#lblUserID').text(), 1);
                }
                else {
                    InsertUserSetting(i, $(this).find('#column').text(), $(this).find('#MasterID').text(), $('#lblUserID').text(), 0);
                }
                i = i + 1;
            });



            alert('Setting Save Successfully');
            $("#dialog").dialog('close');

            $('#lblUserSettingAvail').text('1')
            $('#td_0').html('');
            $('#td_1').html('');
        }

        function InsertUserSetting(RowNo, ColumnNo, MasterID, UserID, IsVisible) {

            $.ajax({
                url: "Services/mis.asmx/InsertUserSetting",
                data: '{RowNo:"' + RowNo + '",ColumnNo:"' + ColumnNo + '",MasterID:"' + MasterID + '",UserID:"' + UserID + '",IsVisible:"' + IsVisible + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    //alert(data);
                },
                error: function (error) {
                    alert('error; ' + eval(error));
                }
            });

        }
        function DeleteUserSetting(UserID) {

            $.ajax({
                url: "Services/mis.asmx/DeleteUserSetting",
                data: '{UserID:"' + UserID + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    //alert(data);
                },
                error: function (error) {
                    alert('error; ' + eval(error));
                }
            });

        }
      
    </script>
    <script type="text/javascript" >
        $(document).ready(function () {


            $('#txtFromDate').change(function () {
                ChkDate();
            });

            $('#txtToDate').change(function () {
                ChkDate();
            });

        });

       

        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {                       
                        alert('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }

        function btnSearch_onclick() {
            ClearDefaultSetting();
            $(document).ready(function () {
                $("#dialog").dialog('close');
                if ($('#lblUserSettingAvail').text() == "0") {
                    // // $.blockUI();
                    OPD($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    OPD_VisitWise($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    Doctor_appointment($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    BillingDetail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    BedDetail($("#ddlCentre").val());
                    Admission($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    Discount($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    UserWiseCollection($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    //HR_Detail($('#txtFromDate').val(), $('#txtToDate').val());
                    Purchase_Detail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    Store_Detail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    Surgery_Detail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    Surgery_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    OPD_Procedure_Detail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    Emergency_Detail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                    CategoryAndSubCategoryWiseRevenue($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val(),1);
                    CategoryAndSubCategoryWiseRevenue($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val(), 2);


                    $.unblockUI();
                }
                else {
                   // // // $.blockUI();

                    $.ajax({

                        url: "Services/mis.asmx/Load_mis_tab",
                        data: '{UserSettingAvail:"' + $('#lblUserSettingAvail').text() + '"}',
                        type: "POST",
                        async: false,
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        success: function (mydata) {

                            var mis_data = jQuery.parseJSON(mydata.d);
                            if (mis_data.length > 0) {

                                for (var i = 0; i < mis_data.length; i++) {
                                    if (mis_data[i].IsVisible == "1") {
                                        //create div
                                        if (mis_data[i].ColumnNo == "0") {
                                            $('#td_0').append('<div id="' + mis_data[i].Div_ID + '"></div>');
                                        } else {
                                            $('#td_1').append('<div id="' + mis_data[i].Div_ID + '"></div>');
                                        }
                                        if (mis_data[i].ID == "1") {
                                            OPD($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        } if (mis_data[i].ID == "2") {
                                            Doctor_appointment($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        } if (mis_data[i].ID == "3") {
                                            OPD_VisitWise($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        } if (mis_data[i].ID == "4") {
                                            BedDetail($("#ddlCentre").val());
                                        } if (mis_data[i].ID == "5") {
                                            BillingDetail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        } if (mis_data[i].ID == "6") {
                                            UserWiseCollection($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        } if (mis_data[i].ID == "7") {
                                            Admission($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        } if (mis_data[i].ID == "8") {
                                            Purchase_Detail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        } if (mis_data[i].ID == "9") {
                                            Discount($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        } if (mis_data[i].ID == "10") {
                                            Store_Detail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        } //if (mis_data[i].ID == "11") {
                                           // HR_Detail($('#txtFromDate').val(), $('#txtToDate').val());
                                    //} 
                                    if (mis_data[i].ID == "12") {
                                            Surgery_Detail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        } 
                                        if (mis_data[i].ID == "13") {
                                            Surgery_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        }
                                        if (mis_data[i].ID == "14") {
                                            OPD_Procedure_Detail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        }
                                        if (mis_data[i].ID == "15") {
                                            Emergency_Detail($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val());
                                        }
                                        if (mis_data[i].ID == "16") {
                                            CategoryAndSubCategoryWiseRevenue($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val(), 1);
                                        }
                                        if (mis_data[i].ID == "17") {
                                            CategoryAndSubCategoryWiseRevenue($('#txtFromDate').val(), $('#txtToDate').val(), $("#ddlCentre").val(), 2);
                                        }




                                    }
                                }

                            }
                        }
                    });
                }

            });
            $.unblockUI();
        }

        function OPD(FromDate, ToDate, CentreID) {
            $.ajax({
                url: "Services/mis.asmx/OPD",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table width="100%" border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody >               <tr >' +
                                '<td  colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;"> OPD </td>' +
                                '<td  style="background-color:#2C5A8B;color:White;font-weight:bold;">Patient</td>' +

                            '</tr>';

                        var a = 2;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + ' ">' +
                                '<td width="50%">' + mis_data[i].Status + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].Count + '</td>' +

                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#OPD_Detail').html(table);
                    }
                }
            });
        }
        function Doctor_appointment(FromDate, ToDate, CentreID) {
            $.ajax({
                url: "Services/mis.asmx/Doctor_appointment",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {
                        //alert(mis_data);
                        var table = '<table width="100%"  border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;"> OPD Patient (Doctor Wise)</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Patient</td>' +

                            '</tr>';

                        var a = 2;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="50%">' + mis_data[i].Doctor + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].PCount + '</td>' +

                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#Doctor_appointment').html(table);
                    }
                }
            });
        }

        //Devendra
        function CategoryAndSubCategoryWiseRevenue(FromDate, ToDate, CentreID, Type) {
            var HeaderValue = "";
            if (Number(Type) == 1)
                HeaderValue = "Sub Category";
            else
                HeaderValue = "Category";
            $.ajax({
                url: "Services/mis.asmx/CategoryAndSubCategoryWiseRevenue",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + Number(CentreID) + '",type:' + Number(Type) + '}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {
                        //alert(mis_data);
                        var table = '<table width="100%"  border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;">' + HeaderValue + ' Wise Revenue</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">OPD</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Emergency</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">IPD</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Total</td>' +
                            '</tr>';

                        var a = 2;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="52%">' + mis_data[i].DetailValue + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].OPDNetItemAmt + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].EMGNetItemAmt + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].IPDNetItemAmt + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].TotalNetItemAmt + '</td>' +
                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        if(Number(Type) ==1)
                            $('#SubCategoryWiseRevenue').html(table);
                        else
                            $('#CategoryWiseRevenue').html(table);
                    }
                }
            });
        }

        function Emergency_Detail(FromDate, ToDate, CentreID) {

            $.ajax({
                url: "Services/mis.asmx/EmergencyRevenue",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + Number(CentreID) + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table width="100%" border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;">Emergency Patient Detail</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Value</td>' +
                            '</tr>';

                        var a = 2;
                        var Caption = "";
                        var Amount = 0;
                        for (var i = 0; i < 4; i++) {
                            if (i == 0) {
                                Caption = "Total Cases";
                                Amount = mis_data[0].NoOfCases;
                            }
                            if (i == 1) {
                                Caption = "Total Revenue within Sellected Period";
                                Amount = mis_data[0].NetAmt;
                            }
                            if (i == 2) {
                                Caption = "Collection Against Revenue till " + mis_data[0].CollectionDate;
                                Amount = mis_data[0].Collection;
                            }
                            if (i == 3) {
                                Caption = "Outstanding Against Revenue till " + mis_data[0].CollectionDate;
                                Amount = mis_data[0].Outstanding;
                            }

                            table += '<tr class="row-' + a + '">' +
                                '<td width="70%">' + Caption + '</td>' +
                                '<td width="15%" class="right">' + Amount + '</td>' +
                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#Emergency_Detail').html(table);

                    }
                }
            });

        }

        function OPD_VisitWise(FromDate, ToDate, CentreID) {

            $.ajax({
                url: "Services/mis.asmx/OPD_VisitWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table width="100%" border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;"> OPD Patient (Visit Wise)</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Male</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Female</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Total</td>' +
                            '</tr>';

                        var a = 1;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="50%">' + mis_data[i].Name + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].Male + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].Female + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].Total + '</td>' +
                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#OPD_Patient_visitwise').html(table);
                    }
                }
            });

        }

        function BillingDetail(FromDate, ToDate, CentreID) {

            $.ajax({
                url: "Services/mis.asmx/BillingDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table width="100%" border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;"> Billing</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Patient</td>' +

                            '</tr>';

                        var a = 1;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="50%">' + mis_data[i].Status + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].Count + '</td>' +

                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#BillingDetail').html(table);
                    }
                }
            });

        }

        function Admission(FromDate, ToDate, CentreID) {

            $.ajax({
                url: "Services/mis.asmx/Admission",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {
                        
                        //alert(mis_data);
                        var table = '<table border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;"> Admission (Ward Type wise)</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Admission</td>' +

                            '</tr>';

                        var a = 1;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="50%">' + mis_data[i].RoomType + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].Admission + '</td>' +

                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#Admission').html(table);
                    }
                }
            });

        }
        function UserWiseCollection(FromDate, ToDate, CentreID) {

            $.ajax({
                url: "Services/mis.asmx/UserWiseCollection",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table width="100%" border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;">Cash Collection (User Wise)</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Amount</td>' +

                            '</tr>';

                        var a = 2;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="50%">' + mis_data[i].NAME + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].Amount + '</td>' +

                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#UserWiseCollection').html(table);
                    }
                }
            });

        }


        function BedDetail(CentreID) {

            $.ajax({
                url: "Services/mis.asmx/BedDetail",
                data: '{CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;">Current Bed Details Status</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Total Bed</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Available Bed</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Occupied Bed</td>' +
                            '</tr>';

                        var a = 2;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="50%">' + mis_data[i].RoomType + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].TotalBed + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].AvailableBed + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].OccupiedBed + '</td>' +
                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#BedDetail').html(table);
                    }
                }
            });

        }

        function Discount(FromDate, ToDate, CentreID) {

            $.ajax({
                url: "Services/mis.asmx/Discount",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table width="100%" border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;"> Discount Details</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Amount</td>' +

                            '</tr>';

                        var a = 1;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="50%">' + mis_data[i].TypeOfTnx + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].Discount + '</td>' +

                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#Discount').html(table);
                    }
                }
            });

        }
        function HR_Detail(FromDate, ToDate) {

            $.ajax({
                url: "Services/mis.asmx/HR_Detail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table width="100%" border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td  class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;"> Human Resource</td>' +
                                '<td  class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;"></td>' +

                            '</tr>';

                        var a = 1;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="80%">' + mis_data[i].HR + '</td>' +
                                '<td width="20%" class="right">' + mis_data[i].EmpCount + '</td>' +

                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#HR_Detail').html(table);
                    }
                }
            });

        }

        function Purchase_Detail(FromDate, ToDate, CentreID) {

            $.ajax({
                url: "Services/mis.asmx/Purchase_Detail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table width="100%" border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;"> Purchase</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;"></td>' +

                            '</tr>';

                        var a = 2;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="80%">' + mis_data[i].Status + '</td>' +
                                '<td width="20%" class="right">' + mis_data[i].Count + '</td>' +

                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#Purchase_Detail').html(table);
                    }
                }
            });

        }
        function Store_Detail(FromDate, ToDate, CentreID) {

            $.ajax({
                url: "Services/mis.asmx/Store_Detail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table width="100%" border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;"> Store</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;"></td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Amount</td>' +
                            '</tr>';

                        var a = 1;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="50%">' + mis_data[i].Status + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].Count + '</td>' +
                                '<td width="12%" class="right">' + mis_data[i].Amount + '</td>' +
                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#Store_Detail').html(table);
                    }
                }
            });

        }
        function Surgery_Detail(FromDate, ToDate, CentreID) {

            $.ajax({
                url: "Services/mis.asmx/Surgery_Detail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2"   >' +
                        '<tbody >               <tr >' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;">Top 5 IPD Surgery</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;"></td>' +

                            '</tr>';

                        var a = 2;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="90%">' + mis_data[i].SurgeryName + '</td>' +
                                '<td width="10%" class="right">' + mis_data[i].quantity + '</td>' +

                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#Surgery_Detail').html(table);
                    }
                }
            });

        }
        function Surgery_DoctorWise(FromDate, ToDate, CentreID) {

            $.ajax({
                url: "Services/mis.asmx/Surgery_DoctorWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;">Surgery Doctor Wise</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;"></td>' +

                            '</tr>';

                        var a = 2;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="80%">' + mis_data[i].Doctor + '</td>' +
                                '<td width="20%" class="right">' + mis_data[i].Surgery + '</td>' +

                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#Surgery_Doctorwise_Detail').html(table);
                         
                    }
                }
            });

        }
        function OPD_Procedure_Detail(FromDate, ToDate, CentreID) {

            $.ajax({
                url: "Services/mis.asmx/OPD_Procedure",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + CentreID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        //alert(mis_data);
                        var table = '<table width="100%" border="3" bordercolor="#2C5A8B"  cellspacing="2" cellpadding="2">' +
                        '<tbody>               <tr>' +
                                '<td class="form-title" colspan="1" style="background-color:#2C5A8B;color:White;font-weight:bold;">OPD Procedure Doctor Wise</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Qty</td>' +
                                '<td class="right" style="background-color:#2C5A8B;color:White;font-weight:bold;">Amount</td>' +
                            '</tr>';

                        var a = 2;
                        for (var i = 0; i < mis_data.length; i++) {
                            table += '<tr class="row-' + a + '">' +
                                '<td width="70%">' + mis_data[i].Doctor + '</td>' +
                                '<td width="15%" class="right">' + mis_data[i].OPDProcedure + '</td>' +
                                '<td width="15%" class="right">' + mis_data[i].Amount + '</td>' +
                             '</tr>';
                            a = a + 1;
                            if (a > 2) {
                                a = 1;
                            }
                        }
                        table += '</tbody>' +
                    '</table><br/>';

                        $('#OPD_Procedure_Detail').html(table);

                    }
                }
            });

        }
    </script>
    <Ajax:ScriptManager ID="sc" runat="server">
    </Ajax:ScriptManager>
    <asp:Label ID="lblUserID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
    <asp:Label ID="lblUserSettingAvail" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
    <div id="Pbody_box_inventory">
        <div id="dialog" title="Setting" style="display: none;">
            <table class="width:100" id="mis_table" cellspacing="1">
                <tr>
                    <td>
                        1
                    </td>
                    <td>
                       
                    </td>
                </tr>
                <tr>
                    <td>
                        2
                    </td>
                    <td>
                       
                    </td>
                </tr>
                <tr>
                    <td>
                        3
                    </td>
                    <td>
                       
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                 <div class="col-md-3">
                      <label class="pull-left bold">Center Name </label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                     <select id="ddlCentre"  name="D1"></select>
                </div>
                <div class="col-md-2">
                      <label class="pull-left bold">From Date </label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="Fromdatecal" runat="server" Animated="true" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                      <label class="pull-left bold">To Date </label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                 <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"></asp:TextBox>
                 <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Animated="true" Format="dd-MMM-yyyy" TargetControlID="txtToDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                     <input type="button" class="ItDoseButton" id="btnSearch" value="Search" onclick="return btnSearch_onclick()" />&nbsp;
                </div>
                <div class="col-md-2">
                        <img id="imgSetting" style="cursor: pointer" src="../../Images/setting.png" width="20px" alt="Setting" />
                </div>
            </div>
            <div class="row col-md-24">
                  <div class="Purchaseheader">Summary</div>
                <div class="row">
                    <div id="td_0" class="col-md-12"></div>
                    <div id="td_1" class="col-md-12"></div>
                </div>
            </div>

           <%-- <table class="width100" cellspacing="1">
                <tbody>
                    
                    <tr>
                        <td class="form-title"  colspan="3">
                            
                        </td>
                    </tr>
                     <tr>
                         <td class="form-title" colspan="3">&nbsp;</td>
                         </tr>
                    <tr style="vertical-align:top;  " >
                      <td style="width:50%; padding-left:10px;  " id="td_0">
                        </td>
                        <td>&nbsp;</td>
                        <td style="width:50%;padding-right:10px; " id="td_1">
                        </td>
                    </tr>
                </tbody>
            </table>--%>
            <div>
            </div>
        </div>
    </div>
</asp:Content>
