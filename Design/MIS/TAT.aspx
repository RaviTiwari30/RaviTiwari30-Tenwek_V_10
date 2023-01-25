<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TAT.aspx.cs" Inherits="Design_MIS_TAT" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="sc" runat="server">
    </Ajax:ScriptManager>
    <%--   <script type="text/javascript"  src="../../Scripts/gviz-api.js"></script>
    <script type="text/javascript" src="../../Scripts/jsapi.js"></script>--%>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <script type="text/javascript" src="../../Scripts/moment.min.js"></script>
    <script type="text/javascript">
        google.load('visualization', '1', { packages: ['corechart'] });
        google.load('visualization', '1', { packages: ['table'] });
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            var tablewidth = $(window).width() - 20;
            var Leftwidth = 140;
            var RightWidth = tablewidth - 150;
            $('#MainTable').css('width', tablewidth);
            $('#tdLeft').css('width', Leftwidth);
            $('#tdRight').css('width', RightWidth);
            $('#Revenue_OPD').click(function () {

                hide_Graph();
                //$('#Revenue_OPD_Area').show();
                $('#Datetable').show();
                var Type = $("#rdoType input[type='radio']:checked").val();
                //  alert(Type);
                if (Type == "2")
                    Revenue_OPD_Investigation($('#txtFromDate').val(), $('#txtToDate').val());
                else
                    Revenue_OPD_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());
            });
        });
        function ChkDate(oldValue, newValue) {
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
                        getDate();
                        $('#txtFromDate').val(oldValue);
                    }
                    else if ($('#Revenue_OPD_Area').is(':visible')) {
                        var Type = $("#rdoType input[type='radio']:checked").val();
                        if (Type == "2")
                            Revenue_OPD_Investigation($('#txtFromDate').val(), $('#txtToDate').val());
                        else
                            Revenue_OPD_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());
                    }
                }
            });
        }
        function ChkDate1(oldValue, newValue) {
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
                        getDate();
                        $('#txtToDate').val(oldValue);
                    }
                    else if ($('#Revenue_OPD_Area').is(':visible')) {
                        var Type = $("#rdoType input[type='radio']:checked").val();
                        if (Type == "2")
                            Revenue_OPD_Investigation($('#txtFromDate').val(), $('#txtToDate').val());
                        else
                            Revenue_OPD_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());
                    }
                }
            });
        }
        function hide_Graph() {
            $('#Revenue_OPD_Area').hide();
        }
        function Revenue_OPD_DoctorWise(FromDate, ToDate) {
            $.ajax({
                url: "Services/mis.asmx/TAT_Appointment",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' +<%=Session["CentreID"].ToString()%> +'" }',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'UHID');
                        dataTable.addColumn('string', 'PName');
                        dataTable.addColumn('string', 'Age');
                        dataTable.addColumn('string', 'Sex');
                        dataTable.addColumn('string', 'AppDate');
                        dataTable.addColumn('string', 'AppTime');
                        dataTable.addColumn('string', 'ConfirmDate& Time');
                        dataTable.addColumn('string', 'Triage Time');
                        dataTable.addColumn('string', 'TAT');
                        dataTable.addColumn('string', 'Call Time');
                        dataTable.addColumn('string', 'TAT');
                        dataTable.addColumn('string', 'In Time');
                        dataTable.addColumn('string', 'TAT');
                        dataTable.addColumn('string', 'View Time');
                        dataTable.addColumn('string', 'TAT')
                        dataTable.addColumn('string', 'Out Time');
                        dataTable.addColumn('string', 'TAT');
                        dataTable.addColumn('string', 'Total TAT');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].PatientID);
                            dataTable.setCell(i, 1, mis_data[i].PName);
                            dataTable.setCell(i, 2, mis_data[i].Age);
                            dataTable.setCell(i, 3, mis_data[i].Sex);
                            dataTable.setCell(i, 4, mis_data[i].AppDate);
                            dataTable.setCell(i, 5, mis_data[i].AppTime);
                            dataTable.setCell(i, 6, mis_data[i].ConformDate);
                            dataTable.setCell(i, 7, mis_data[i].TempRoomUpdateDate);
                            dataTable.setCell(i, 8, mis_data[i].Diff1);

                            dataTable.setCell(i, 9, mis_data[i].CallDateTime);
                            dataTable.setCell(i, 10, mis_data[i].Diff2);

                            dataTable.setCell(i, 11, mis_data[i].InDateTime);
                            dataTable.setCell(i, 12, mis_data[i].Diff3);

                            dataTable.setCell(i, 13, mis_data[i].ViewDateTime);
                            dataTable.setCell(i, 14, mis_data[i].Diff4);

                            dataTable.setCell(i, 15, mis_data[i].OutDateTime);
                            dataTable.setCell(i, 16, mis_data[i].Diff5);

                            dataTable.setCell(i, 17, mis_data[i].TAT);
                        }

                        var table = new google.visualization.Table(document.getElementById('Revenue_OPD_Area'));

                        var formatter = new google.visualization.TableBarFormat({ width: 120 });
                        formatter.format(dataTable, 1); // Apply formatter to second column

                        //                        var formatter2 = new google.visualization.TableBarFormat({width: 120});
                        //                        formatter2.format(dataTable, 2); // Apply formatter to second column

                        table.draw(dataTable, { allowHtml: true, showRowNumber: true });
                        $('#Revenue_OPD_Area').show();
                    }
                    else
                        $('#Revenue_OPD_Area').hide();
                }
            });
        }

        function Revenue_OPD_Investigation(FromDate, ToDate) {
            $.ajax({
                url: "Services/mis.asmx/TAT_Investigation",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' +<%=Session["CentreID"].ToString()%> + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {


                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'UHID');
                        dataTable.addColumn('string', 'Patient Name');
                        dataTable.addColumn('string', 'Age');
                        dataTable.addColumn('string', 'Sex');
                        dataTable.addColumn('string', 'Address');
                        dataTable.addColumn('string', 'LabNo');
                        dataTable.addColumn('string', 'Serial No.');
                        dataTable.addColumn('string', 'Investigation Name');
                        dataTable.addColumn('string', 'Dispatch');
                        dataTable.addColumn('string', 'DispatchMode');
                        dataTable.addColumn('string', 'Order Date');
                        dataTable.addColumn('string', 'Order Time');
                        dataTable.addColumn('string', 'In Date');
                        dataTable.addColumn('string', 'In Time');
                        dataTable.addColumn('string', 'Sample Date');
                        dataTable.addColumn('string', 'Sample Time');
                        dataTable.addColumn('string', 'Result Date');
                        dataTable.addColumn('string', 'Result Time');
                        dataTable.addColumn('string', 'Approved Date');
                        dataTable.addColumn('string', 'Approved Time')
                        dataTable.addColumn('string', 'DisPatch Date');
                        dataTable.addColumn('string', 'DisPatch Time');
                        dataTable.addColumn('string', 'TAT');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].MRNo);
                            dataTable.setCell(i, 1, mis_data[i].PatientName);
                            dataTable.setCell(i, 2, mis_data[i].Age);
                            dataTable.setCell(i, 3, mis_data[i].Gender);
                            dataTable.setCell(i, 4, mis_data[i].Address);
                            dataTable.setCell(i, 5, mis_data[i].LabNo);
                            dataTable.setCell(i, 6, mis_data[i].SerialNo);
                            dataTable.setCell(i, 7, mis_data[i].InvestigationName);
                            dataTable.setCell(i, 8, mis_data[i].Dispatch);
                            dataTable.setCell(i, 9, mis_data[i].DispatchMode);

                            dataTable.setCell(i, 10, mis_data[i].PrescribedDate);
                            dataTable.setCell(i, 11, mis_data[i].PrescribedTime);

                            dataTable.setCell(i, 12, mis_data[i].InDate);
                            dataTable.setCell(i, 13, mis_data[i].InTime);
                            dataTable.setCell(i, 14, mis_data[i].SampleDate);
                            dataTable.setCell(i, 15, mis_data[i].SampleTime);
                            dataTable.setCell(i, 16, mis_data[i].ResultDate);
                            dataTable.setCell(i, 17, mis_data[i].ResultTime);
                            dataTable.setCell(i, 18, mis_data[i].ApprovedDate);
                            dataTable.setCell(i, 19, mis_data[i].ApprovedTime);
                            dataTable.setCell(i, 20, mis_data[i].DisPatchDate);
                            dataTable.setCell(i, 21, mis_data[i].DisPatchTime);
                            dataTable.setCell(i, 22, mis_data[i].TAT);
                        }

                        var table = new google.visualization.Table(document.getElementById('Revenue_OPD_Area'));

                        var formatter = new google.visualization.TableBarFormat({ width: 120 });
                        formatter.format(dataTable, 1); // Apply formatter to second column

                        //                        var formatter2 = new google.visualization.TableBarFormat({width: 120});
                        //                        formatter2.format(dataTable, 2); // Apply formatter to second column

                        var cssName = {                           
                                fontName: 'Arial',
                                fontSize: 8,
                                bold: true                         
                        };

                        var options = { 'showRowNumber': true, 'allowHtml': true, 'textStyle': cssName };

                        table.draw(dataTable, options);

                        $('#Revenue_OPD_Area').show();
                    }
                    else
                        $('#Revenue_OPD_Area').hide();
                }
            });
        }

        //jQuery(function ($) {
        //    var h = window.innerHeight;
        //    $('[id$=div_Doctor]').on('scroll', function () {
        //        if ($(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight) {
        //            $('[id$=div_Doctor]').scrollTop(0)
        //        }
        //    })
        //});
        window.setInterval(function () {
            var Type = $("#rdoType input[type='radio']:checked").val();
            //  alert(Type);
            if (Type == "2")
                Revenue_OPD_Investigation($('#txtFromDate').val(), $('#txtToDate').val());
            else
                Revenue_OPD_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());
        }, 60000);
    </script>


    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" >
            <div style="text-align: center;">
                <b>Patient OPD TAT Analysis</b>
                <div class="Purchaseheader">
                    TAT Analysis
                </div>
            </div>
            <table style="vertical-align: top; width: 100%" id="Datetable">
                <tr style="background-color: white">
                                <td style="width: 10%">                                   

                                </td>
                                <td style="width: 40%">From Date
                                        <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                            Width="100px" onFocus="(this.name=this.value)" onchange="ChkDate(this.name,this.value)"></asp:TextBox>
                                    <cc1:CalendarExtender ID="Fromdatecal" runat="server" Animated="true" Format="dd-MMM-yyyy"
                                        TargetControlID="txtFromDate">
                                    </cc1:CalendarExtender>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; To Date
                                    <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                        Width="100px" onFocus="(this.name=this.value)" onchange="ChkDate1(this.name,this.value)"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Animated="true" Format="dd-MMM-yyyy"
                                        TargetControlID="txtToDate">
                                    </cc1:CalendarExtender>
                                </td>
                                <td style="width: 30%">
                                    <asp:RadioButtonList ID="rdoType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                        <asp:ListItem Selected="True" Value="1">Appointment TAT</asp:ListItem>
                                        <asp:ListItem Value="2">Investigation TAT</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                                <td style="width: 20%">
                                    <%--<span id="Revenue_OPD" class="ItDoseButton">Calculate</span>--%>
                                    <input type="button" value="Search" id="Revenue_OPD" class="ItDoseButton" />

                                </td>
                            </tr>                       
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="width: 100%; overflow: auto; max-height: 400px;">
                <div id="Revenue_OPD_Area">
                </div>
            </div>
        </div>
    </div>
</asp:Content>

