<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BedManagement.aspx.cs" Inherits="Design_EDP_BedManagement" Title="Untitled Page" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        
        .blinking{
                    animation:blinkingText 1.2s infinite;
                }
                @keyframes blinkingText{
                    0%{     color: #000;    }
                    49%{    color: #000; }
                    60%{    color: transparent; }
                    99%{    color:transparent;  }
                    100%{   color: #000;    }
                }
    </style>
   
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    
    <link href="../../Styles/BedManagement.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/fusioncharts.js"></script>
    <script type="text/javascript" src="../../Scripts/fusioncharts.theme.fint.js"></script>
    <script type="text/javascript">
        function showuploadbox(obj, href, maxh, maxw, w, h, obj) {
            
       
                $.fancybox({
                    maxWidth: maxw,
                    maxHeight: maxh,
                    fitToView: false,
                    width: w,
                    href: href,
                    height: h,
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                });
            
        }

        showLocationManagementModel = function () {
            var HeaderText = "Location Details";

            $('#spnHeader').text(HeaderText);

            $('#divLocationManagementModel').showModel();
        }
        closeLocationManagementModel = function () {
            $('#divLocationManagementModel').hideModel();
        }

        closeLocationManagementDetail = function () {
            $('#divLocationManagementDetail').hideModel();
        }

        showBedManagementModel = function (Type) {
            var HeaderText = "";
            if (Type == 1)
                HeaderText = "Total Bed Details";
            else if (Type == 2)
                HeaderText = "Availlable Bed Details";
            else if (Type == 3)
                HeaderText = "Occupied Bed Details";
            else if (Type == 4)
                HeaderText = "House Keeping Bed Details";
            else if (Type == 5)
                HeaderText = "Today Admission Bed Details";
            else if (Type == 6)
                HeaderText = "Today Discharge Bed Details";
            else if (Type == 15)
                HeaderText = "Advance Room Booking Details";
            else if (Type == 16)
                HeaderText = "Atendent Room Booking Bed Details";
            else if (Type == 21)
                HeaderText = "New Room/Bed Details";

            $('#spnHeader').text(HeaderText);

            $('#divBedManagementModel').showModel();

        }

        closeBedManagementModel = function () {
            $('#divBedManagementModel').hideModel();
        }

        closeBedManagementDetail = function () {
            $('#divBedManagementDetail').hideModel();
        }
    </script>
    <script type="text/javascript">

        function BedDetailsPatient(Type) {
            $.ajax({
                url: "Services/BedManagement.asmx/BedDetailsPatient",
                data: '{SearchType:"' + Type + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != "") {
                        var HeaderText = "";
                        if (Type == 1)
                            HeaderText = "Total Bed Details";
                        else if (Type == 2)
                            HeaderText = "Availlable Bed Details";
                        else if (Type == 3)
                            HeaderText = "Occupied Bed Details";
                        else if (Type == 4)
                            HeaderText = "House Keeping Bed Details";
                        else if (Type == 5)
                            HeaderText = "Today Admission Bed Details";
                        else if (Type == 6)
                            HeaderText = "Today Discharge Bed Details";
                        else if (Type == 15)
                            HeaderText = "Advance Room Booking Details";
                        else if (Type == 16)
                            HeaderText = "Atendent Room Booking Bed Details";
                        else if (Type == 21)
                            HeaderText = "New Room/Bed Details";

                        $('#spnHeaderDetail').text(HeaderText);
                        $('#divBedManagementDetail').showModel();
                    }
                    else {
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">

        function BedManagementSummary() {
            $.ajax({
                url: "Services/BedManagement.asmx/BedManagementSummary",
                data: '{}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != "") {

                        $("#spnDischargeCancelled").text(data[0]["TodayDischargeCancelled"]);
                        $("#spnTotalWard").text(data[0]["TotalWard"]);
                        $("#dvTotalWard").prop('title', data[0]["WardDetail"]);
                        $("#spnTotalFloor").text(data[0]["TotalFloor"]);
                        $("#spnBillCancelled").text(data[0]["TodayBillCancellation"]);
                        $("#spnNewRoom").text(data[0]["TodayNewRoom"]);
                        $("#spnNewPatientAdmit").text(data[0]["TodayNewPatientAdmit"]);
                        $("#spnAdvanceBedBooking").text(data[0]["TodayAdvanceRoomBoking"]);
                        $("#spnBillFinalized").text(data[0]["TodayBillFinalized"]);
                        $("#spnBedClearance").text(data[0]["TodayBedClearnace"]);
                        $("#spnNurseClearance").text(data[0]["TodayNurseClearnace"]);
                        $("#spnBillGenerate").text(data[0]["TodayBillGenerate"]);
                        $("#spnMedicalClearance").text(data[0]["TodayMedClearnace"]);
                        $("#spnDelayedDischarge").text(data[0]["TodayDelayDischarge"]);
                        $("#spnDischargeIntimation").text(data[0]["TodayDisIntimated"]);
                        $("#spnAverageStayPeriod").text(data[0]["AverageStayPeriod"]);
                        $("#spnAvgStayHP").text(data[0]["AverageStayPeriodDetail"].split('#')[0]);
                        $("#spnAvgStayPP").text(data[0]["AverageStayPeriodDetail"].split('#')[1]);
                        $("#spnTodayDischarge").text(data[0]["TodayDischarge"]);
                        $("#spnDischarge").text(data[0]["TodayDischargeDetail"]);
                        $("#spnTodayAdmited").text(data[0]["TodayAdmission"]);
                        $("#spnTotayAdmisssion").text('HP :' + data[0]["TodayAdmission"] + '  PP : 0');
                        $("#spnPendingBedClearance").text(data[0]["PendingRoomClearance"]);
                        $("#spnDetailPendingBedClearance").text(data[0]["PendingRoomClearanceDetail"]);
                        $("#spnTotalInPatient").text(data[0]["OccupiedRoom"]);
                        $("#spnOccupied").text(data[0]["OccupiedRoomDetail"]);
                        $("#spnAvailableBed").text(data[0]["AvailableRoom"]);
                        $("#spnTotalBed").text(data[0]["TotalCapacity"]);
                        $("#spDialsValue").text(data[0]["OccupencyPer"]);

                        FusionCharts.ready(function () {
                            var angularChart = new FusionCharts({
                                "type": "angulargauge",
                                "renderAt": "dangularguage",
                                "width": "245",
                                "height": "196",
                                "dataFormat": "json",
                                "dataSource": {
                                    "chart": {
                                        "caption": "Current Bed Occupency",
                                        "subcaption": "Analysis in %",
                                        "lowerLimit": "0",
                                        "upperLimit": "100",
                                        "theme": "fint"
                                    },
                                    "colorRange": {
                                        "color": [
                                           {
                                               "minValue": "0",
                                               "maxValue": "25",
                                               "code": "#e44a00"
                                           },
                                            {
                                                "minValue": "25",
                                                "maxValue": "50",
                                                "code": "FF00FF"
                                            },
                                           {
                                               "minValue": "50",
                                               "maxValue": "75",
                                               "code": "#f8bd19"
                                           },
                                           {
                                               "minValue": "75",
                                               "maxValue": "100",
                                               "code": "#6baa01"
                                           }
                                        ]
                                    },
                                    "dials": {
                                        "dial": [
                                           {
                                               "value": $("#spDialsValue").text()
                                           }
                                        ]
                                    }
                                }
                            });

                            angularChart.render();

                            var hlinearChart = new FusionCharts({
                                "type": "hlineargauge",
                                "renderAt": "dhlineargauge",
                                "width": "700",
                                "height": "70",
                                "dataFormat": "json",
                                "dataSource": {
                                    "chart": {
                                        "manageresize": "1",
                                        "bgcolor": "FFFFFF",
                                        "bgalpha": "0",
                                        "showborder": "0",
                                        "upperlimit": $("#spnTotalBed").text(),
                                        "lowerlimit": "0",
                                        "gaugeroundradius": "5",
                                        "chartbottommargin": "10",
                                        "ticksbelowgauge": "0",
                                        "showgaugelabels": "1",
                                        "valueabovepointer": "0",
                                        "pointerontop": "0",
                                        "pointerradius": "0",
                                        "theme": "fint"
                                    },
                                    "colorrange": {
                                        "color": [
                                            {
                                                "minvalue": "0",
                                                // "maxvalue": "10",
                                                "maxvalue": $("#spnTotalInPatient").text(),
                                                "label": $("#spnTotalInPatient").text()
                                            },
                                            {
                                                // "minvalue":"10",
                                                // "maxvalue": "15",
                                                "minvalue": $("#spnTotalInPatient").text(),
                                                "maxvalue": parseFloat($("#spnTotalInPatient").text()) + parseFloat($("#spnPendingBedClearance").text()),
                                                "label": $("#spnPendingBedClearance").text()
                                            },
                                            {
                                                // "minvalue": "15",
                                                "minvalue": parseFloat($("#spnTotalInPatient").text()) + parseFloat($("#spnPendingBedClearance").text()),
                                                "maxvalue": parseFloat($("#spnTotalInPatient").text()) + parseFloat($("#spnPendingBedClearance").text()) + parseFloat($("#spnAvailableBed").text()),
                                                "label": $("#spnAvailableBed").text()
                                            }
                                        ]
                                    },
                                    "pointers": {
                                        "pointer": [
                                            {
                                                "value": ""
                                            }
                                        ]
                                    }
                                }
                            });
                            hlinearChart.render();

                        });
                    }
                    else {
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            BedManagementSummary();
            getLocationCount();
            addClickHandler();
            
        });
        function getLocationCount() {
                $.ajax({
                    url: "Services/LocationManagement.asmx/GetLocationCount",
                    data: '{}',
                    type: "POST",
                    async: true,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        

                        var data = jQuery.parseJSON(mydata.d);
                        if (data != "") {

                            $("#spnTotal").text(data[0]["Total"]);
                        }
                    },
                    error: function (err)
                    {
                        alert(err);
                    }

                });
            
        }

        function addClickHandler()
        {
            $("a.blinking").live("click", function (e) {

                $(this).removeClass("blinking");
                var pid = $(this).attr('id');
                var shortcut = $(this).attr('name');
                $.ajax({
                    url: "Services/LocationManagement.asmx/UpdateblinkStatus",
                    data: '{pid:"' + pid + '",shortcut:"' + shortcut + '"}',
                    type: "POST",
                    async: true,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {

                    }
                });
            });
        }
        function BedDetails(Type) {
            $("#txtType").val(Type);
            __doPostBack('ctl00$ContentPlaceHolder1$btnBind', '');
        }
        function LocationDetails() {
            //$("#txtType").val(Type);
            __doPostBack('ctl00$ContentPlaceHolder1$btnBind1', '');
        }
    </script>
    <div id="Pbody_box_inventory" style="width: 1305px;">

        <cc1:ToolkitScriptManager runat="server" ID="scCustom"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content" style="width: 1295px;">
                <div style="text-align: center">
                    <b>Bed Management</b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content" style="text-align: center; vertical-align: middle; width: 1295px;">
                <table width="100%">
                    <tr>
                        <td colspan="7">
                            <div style="height: 80px; width: 1275px; background-color: transparent;">
                                <div style="float: left; margin-left: 10px; text-align: left; font-weight: bold; font-size: 14px;">
                                    <table>
                                        <tr>
                                            <td>HP :
                                            </td>
                                            <td>&nbsp;Hospital Patient</td>
                                        </tr>
                                        <tr>
                                            <td>PP :
                                            </td>
                                            <td>&nbsp;Panel Patient</td>
                                        </tr>
                                    </table>
                                </div>
                                <div style="width: 700px; height: 70px; margin-left: 50px; float: left" id="dhlineargauge">Bed Management Details</div>
                                <div style="float: left; margin-left: 50px; text-align: left;">
                                    <table>
                                        <tr>
                                            <td>
                                                <div style="width: 20px; height: 20px; background-color: #8cba02;"></div>
                                            </td>
                                            <td>&nbsp;Occupied Bed</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="width: 20px; height: 20px; background-color: #f6bd11;"></div>
                                            </td>
                                            <td>&nbsp;Pending Bed Clearance</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="width: 20px; height: 20px; background-color: #ff6650; float: left"></div>
                                            </td>
                                            <td>&nbsp;Available Bed</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>

                    </tr>
                    <tr>
                        <td style="width: 13%;">
                            <div id="dvTotalBed" onclick="BedDetails(1)" class="ShowBedBox">
                                <br />
                                <b>Total Capacity</b>
                                <br />
                                <span id="spnTotalBed" class="spnStyle" style="font-size: 50pt; font-weight: 700"></span>
                            </div>
                        </td>
                        <td style="width: 13%;">
                            <div id="dvAvailableBed" onclick="BedDetails(2)" class="ShowBedBox">
                                <br />
                                <b>Available Bed</b>
                                <br />
                                <span id="spnAvailableBed" class="spnStyle" style="font-size: 50pt; font-weight: 700"></span>
                            </div>
                        </td>
                        <td style="width: 13%;">
                            <div id="dvInPatient" onclick="BedDetails(3)" class="ShowBedBox">
                                <br />
                                <b>Occupied Bed</b>
                                <br />
                                <span id="spnTotalInPatient" class="spnStyle" style="font-size: 50pt; font-weight: 700"></span>
                                <br />
                                <br />
                                <b><span id="spnOccupied" style="font-size: 14pt; color: white;"></span></b>
                            </div>
                        </td>
                        <td style="width: 13%;">
                            <div id="dvPendingBedClearance" onclick="BedDetails(4)" class="ShowBedBox">
                                <br />
                                <b>Housekeeping</b>
                                <br />
                                <span id="spnPendingBedClearance" class="spnStyle" style="font-size: 50pt; font-weight: 700"></span>
                                <br />
                                <br />
                                <b><span id="spnDetailPendingBedClearance" style="font-size: 14pt; color: white;"></span></b>
                            </div>
                        </td>
                        <td style="width: 13%;">
                            <div id="dvTodayAdmited" onclick="BedDetails(5)" class="ShowBedBox">
                                <br />
                                <b>Today Admission</b>
                                <br />
                                <span id="spnTodayAdmited" class="spnStyle" style="font-size: 50pt; font-weight: 700;"></span>
                                <br />
                                <br />
                                <b><span id="spnTotayAdmisssion" style="font-size: 14pt; color: white;"></span></b>
                            </div>
                        </td>
                        <td style="width: 13%;">
                            <div id="dvOutPatient" onclick="BedDetails(6)" class="ShowBedBox">
                                <br />
                                <b>Today Discharge</b>
                                <br />
                                <span id="spnTodayDischarge" class="spnStyle" style="font-size: 50pt; font-weight: 700"></span>
                                <br />
                                <br />
                                <b><span id="spnDischarge" style="font-size: 14pt; color: white;"></span></b>
                            </div>
                        </td>
                        <td style="width: 21%; text-align: left; margin-right: 15px; margin-left: 1%">
                            <div style="border: 1px solid black; width: 251px; height: 199px;" id="dangularguage">Bed Occupency</div>
                        </td>

                    </tr>
                    <tr>
                        <td style="width: 15%;">
                            <div id="dvAverageStayPeriod" class="ShowBedBox">
                                <b>Last 30 Discharge Patient Average Stay Period</b>
                                <br />
                                <span id="spnAverageStayPeriod" class="spnStyle" style="font-size: 20pt; font-weight: bold">5 Hrs 30 Min</span>
                                <br />
                                <b><span id="spnAvgStayHP" style="font-size: 14pt; color: white;"></span>
                                    <br />
                                   <span id="spnAvgStayPP" style="font-size: 14pt; color: white;"></span></b>
                            </div>
                        </td>
                        <td colspan="5" style="width: 71%;">
                            <table>
                                <tr>
                                    <td>
                                        <div id="dvDischargeIntimation" onclick="BedDetailsPatient(1)" class="ShowSmallBox">
                                            <span id="spnDischargeIntimation" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Discharge Intimation
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvDelayedDischarge" onclick="BedDetailsPatient(2)" class="ShowSmallBox">
                                            <span id="spnDelayedDischarge" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Delayed Discharge
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvMedicalClearance" onclick="BedDetailsPatient(3)" class="ShowSmallBox">
                                            <span id="spnMedicalClearance" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Medical Clearance
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvBillGenerate" onclick="BedDetailsPatient(4)" class="ShowSmallBox">
                                            <span id="spnBillGenerate" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Bill Generate
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvNurseClearance" onclick="BedDetailsPatient(5)" class="ShowSmallBox">
                                            <span id="spnNurseClearance" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Nurse Clearance
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvBedClearance" onclick="BedDetailsPatient(6)" class="ShowSmallBox">
                                            <span id="spnBedClearance" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Bed Clearance
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvBillFinalized" onclick="BedDetailsPatient(7)" class="ShowSmallBox">
                                            <span id="spnBillFinalized" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Bill Finalized
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div id="dvAdvanceBedBooking" onclick="BedDetails(15)" class="ShowSmallBox">
                                            <span id="spnAdvanceBedBooking" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Advance Bed Booking
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvNewPatientAdmit" onclick="BedDetailsPatient(8)" class="ShowSmallBox">
                                            <span id="spnNewPatientAdmit" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            New Patient Admit
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvNewRoom" onclick="BedDetails(21)" class="ShowSmallBox">
                                            <span id="spnNewRoom" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            New Room
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvBillCancelled" onclick="BedDetailsPatient(9)" class="ShowSmallBox">
                                            <span id="spnBillCancelled" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Bill Cancelled
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvTotalFloor" onclick="BedDetailsPatient(10)" class="ShowSmallBox">
                                            <span id="spnTotalFloor" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Total Floor
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvTotalWard" onclick="BedDetailsPatient(11)" class="ShowSmallBox">
                                            <span id="spnTotalWard" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Total Ward
                                        </div>
                                    </td>
                                    <td>
                                        <div id="dvDischargeCancelled" onclick="BedDetailsPatient(12)" class="ShowSmallBox">
                                            <span id="spnDischargeCancelled" class="spnStyle" style="font-size: 30pt; font-weight: bold">0</span>
                                            <br />
                                            Discharge Cancelled
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>

                        <td style="width: 14%; text-align: left; margin-right: 10px;">
                            <div id="dvTotal" onclick="LocationDetails()" style="width:251px;Height:199px;text-align:center;" class="ShowBedBox">
                                <br />
                                <b>List Management and Printer </b>
                                <br />
                                <span id="spnTotal" class="spnStyle" style="font-size: 50pt; font-weight: 700"></span>
                                <br />
                                <br />
                                <b><span id="Span1" style="font-size: 14pt; color: white;"> </span></b>
                            </div>
                        </td>

                    </tr>

                    <tr>
                        <td><span id="spDialsValue" style="display: none;"></span>
                            <span id="spPoiterValue" style="display: none;"></span>
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>

                    </tr>
                </table>

            </div>
        </div>
         <div id="divBedManagementDetail" class="modal fade">
                    <div class="modal-dialog">
                        <div class="modal-content" style="width: 90%; min-width: 1200px">
                            <div class="modal-header">
                                <button type="button" class="close" onclick="closeBedManagementDetail()" aria-hidden="true">&times;</button>
                                <b class="modal-title"><span id="spnHeaderDetail"></span></b>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center; max-height: 400px; height: 400px; overflow: auto;">
                                     
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
        <Ajax:UpdatePanel ID="upbed" runat="server">
            <ContentTemplate>
                <div id="divBedManagementModel" class="modal fade">

                    <div class="modal-dialog">
                        <div class="modal-content" style="width: 90%; min-width: 1200px">
                            <div class="modal-header">
                                <button type="button" class="close" onclick="closeBedManagementModel()" aria-hidden="true">&times;</button>
                                <b class="modal-title"><span id="spnHeader"></span></b>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center; max-height: 400px; height: 400px; overflow: auto;">
                                        <asp:Repeater ID="rpFloor" runat="server" OnItemDataBound="rpFloor_ItemDataBound">
                                            <HeaderTemplate>
                                                <table cellspacing="0" style="border-collapse: collapse; width: 100%;">
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr style="text-align: center;">
                                                    <td class="GridViewHeaderStyle">
                                                        <asp:Label ID="lblFloor" Font-Bold="true" runat="server" Text='<%# Eval("Floor")%>' />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: left; background-color: transparent;">
                                                        <asp:Repeater ID="rpBD" runat="server" OnItemDataBound="rpBD_ItemDataBound">
                                                            <HeaderTemplate>
                                                                <table cellspacing="0" style="border-collapse: collapse; width: 100%;">
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td class="GridViewStyle" style="color: #800080; text-align: left; background-color: transparent; width: 150px;">
                                                                        <asp:Label ID="lblRoomType" runat="server" Text='<%# Eval("IPDCaseType_ID")%>' Visible="false" />
                                                                        <div style="width: 100%,height:100%; text-align: center; cursor: <%# Eval("Status") %>;" title='<%# Eval("BedRequests") %>'>
                                                                            <%# Eval("Name")%>
                                                                        </div>
                                                                    </td>
                                                                    <td class="GridViewStyle" style="font-weight: bold; text-align: left;">
                                                                        <asp:DataList ID="dlRoom" runat="server" RepeatDirection="horizontal" RepeatColumns="17">
                                                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="top" />
                                                                            <ItemTemplate>
                                                                                <div class="BedDetailBox" style="background: <%# Eval("StCol") %>;"
                                                                                    title='<%# Eval("PDetails") %>'>
                                                                                </div>
                                                                            </ItemTemplate>
                                                                        </asp:DataList>
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                </table>
                                                            </FooterTemplate>
                                                        </asp:Repeater>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <div class="row">
                                    <div class="col-md-4" style="text-align: center;">
                                        <image src="../../Images/OccupiedBed.jpg"  Width="60px" Height="60px" ToolTip="Occupied Bed" />
                                        <br />
                                        <b>Occupied Bed</b>
                                    </div>
                                    <div class="col-md-4" style="text-align: center;">
                                        <image src="../../Images/AvailableBed.jpg" Width="60px" Height="60px" ToolTip="Available Bed" />
                                        <br />
                                        <b>Available Bed</b>
                                    </div>
                                    <div class="col-md-4" style="text-align: center;">
                                      <image src="../../Images/NurseClearance.jpg" Width="60px" Height="60px" ToolTip="Nurse Clearance" />
                                        <br />
                                        <b>Nurse Clearance</b>
                                    </div>
                                    <div class="col-md-4" style="text-align: center;">
                                        <image src="../../Images/HouseKeeping.jpg" Width="60px" Height="60px" ToolTip="House Keeping" />
                                        <br />
                                        <b>House Keeping</b>
                                    </div>
                                    <div class="col-md-4" style="text-align: center;">
                                       <image src="../../Images/AdvanceRoomBook.jpg" Width="60px" Height="60px" ToolTip="Advance Room Booking" />
                                        <br />
                                        <b>Advance Room Booking</b>
                                    </div>
                                    <div class="col-md-4" style="text-align: center;">
                                        <image src="../../Images/AttendentRoom.jpg" Width="60px" Height="60px" ToolTip="Attendent Room" />
                                        <br />
                                        <b>Attendent Room</b>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
                <div style="display: none;">
                    <asp:TextBox ID="txtType" ClientIDMode="Static" runat="server"></asp:TextBox>
                    <asp:Button ID="btnBind" runat="server" OnClick="btnBind_Click" />
                    <asp:Button ID="btnBind1" runat="server" OnClick="btnBind1_Click" />
                </div>
                <div id="divLocationManagementModel" class="modal fade">

                    <div class="modal-dialog">
                        <div class="modal-content" style="width: 95%; min-width: 1200px">
                            <div class="modal-header">
                                <button type="button" class="close" onclick="closeLocationManagementModel()" aria-hidden="true">&times;</button>
                                <b class="modal-title"><%--<span id="spnHeader"></span>--%>Location Details</b>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center; max-height: 500px; height: 500px; overflow: auto;">
                                        <asp:Repeater ID="rpFloor1" runat="server" OnItemDataBound="rpFloor1_ItemDataBound">
                                            <HeaderTemplate>
                                                <table cellspacing="0" style="border-collapse: collapse; width: 100%;">
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr style="text-align: center;">
                                                    <td class="GridViewHeaderStyle" style="background-color:#487b22;color:white;">
                                                        <asp:Label ID="lblFloor1" Font-Bold="true" runat="server" Text='<%# Eval("Location")%>' />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: left; background-color: transparent;">
                                                        <asp:Repeater ID="rpBD1" runat="server" OnItemDataBound="rpBD1_ItemDataBound" OnItemCommand="list_ItemCommand1">
                                                             <HeaderTemplate>
                                                                <table cellspacing="0" style="border-collapse: collapse; width: 100%;background-color:#f7e489;height:150px;">
                                                                    <tr style="float:left;">
                                                                        
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                    <td class="GridViewStyle" style="color:#f6bd11; text-align: left; background-color: transparent; width: 100%;">
                                                                        <asp:Label ID="lblFloor2" runat="server" Text="" Visible="false" />
                                                                        <div style="width: 100%;height:220px; text-align: center; " > 
                                                                              <div class="" style="background-color:#f6bd11;color:white;height:220px;width:220px;" >
                                                                               <div style="text-align:left;padding:2px;">
                                                                                 <table><tr><td style="margin:0px;">
                                                                                     <%# Eval("PDetails") %>
                                                                                      <br />HD:<%# Eval("HD1")%><br />
                                                                                     Weight:<%# Eval("Weight1")%>     <br />
                                                                                      1st Call:<asp:Label id="lblFirstCall"  runat="server" Text='<%# Eval("FirstCall1")%>' Visible="false" />
                                                                                    
                                                              <asp:DropDownList ID="ddlFirstCall"  AutoPostBack="false" OnItemCreated="RepeaterItemCreated"  runat="server" DataValueField="DoctorId" DataTextField="Name" CssClass="selectbox"></asp:DropDownList> <br />
                                                                                   <asp:LinkButton ID="btnSaveFirstCall" runat="server" class="btn btn-primary" style=" background-color :#8cba02;color:white;background-color:blue;"  CommandArgument='<%#Eval("PatientId") %>' CommandName='<%# Eval("PatientId") %>'>Save Call</asp:LinkButton>
                                                                                    <asp:Label ID="lblStatus" runat="server" Text="Success" ForeColor="Green" Visible="false"  />
                                                                                     <asp:Label ID="lblFlag" runat="server"  Visible="false" />
                                                                        
                                                                                     </td><td style="vertical-align:top;">                                 
                                                                                         <%--<a target="pagecontent" class='<%# Eval("ClassDoctorNoteBlink") %>' id='<%# Eval("PatientId") %>' name="a"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<%# Eval("PatientId") %>','../IPD/DoctorProgressNote.aspx?PatientId=<%# Eval("PatientId") %>&amp;TransactionId=<%# Eval("TransactionID") %>', 1050, 1050, '73%', '90%');" style="color:yellow;" >Doctor Notes</a><br />--%>
                                                                                         <%--<a target="pagecontent" class='<%# Eval("ClassNursingNoteBlink") %>'  id='<%# Eval("PatientId") %>'  name="b"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<%# Eval("PatientId") %>','../IPD/NursingProgress.aspx?PatientId=<%# Eval("PatientId") %>&amp;TransactionId=<%# Eval("TransactionID") %>', 1050, 1050, '73%', '90%');" style="color:yellow;" >Nursing Notes</a><br />--%>
                                                                                         <a target="pagecontent" class='<%# Eval("ClassLabsBlink") %>'  id='<%# Eval("PatientId") %>'  name="c" style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<%# Eval("PatientId") %>','../Lab/ViewLabReportsWard.aspx?PatientId=<%# Eval("PatientId") %>&amp;TransactionId=<%# Eval("TransactionID") %>', 1050, 1050, '73%', '90%');" style="color:yellow;" >Labs</a><br />
                                                                                         <a target="pagecontent" class='<%# Eval("ClassReportsBlink") %>'  id='<%# Eval("PatientId") %>'  name="d"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<%# Eval("PatientId") %>','#', 1050, 1050, '73%', '90%');" style="color:yellow;" >Reports</a><br />
                                                                                         <a target="pagecontent" class='<%# Eval("ClassMedBlink") %>'  id='<%# Eval("PatientId") %>' name="e"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<%# Eval("PatientId") %>','../IPD/PatientRequisitionSearch.aspx?PatientId=<%# Eval("PatientId") %>&amp;TransactionId=<%# Eval("TransactionID") %>', 1050, 1050, '73%', '90%');" style="color:yellow;" >Meds</a><br />
                                                                                         <a target="pagecontent" class='<%# Eval("ClassVitalsBlink") %>' id='<%# Eval("PatientId") %>' name="f"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<%# Eval("PatientId") %>','../IPD/IPD_Patient_ObservationChart.aspx?PatientId=<%# Eval("PatientId") %>&amp;TransactionId=<%# Eval("TransactionID") %>', 1050, 1050, '73%', '90%');" style="color:yellow;" >Vitals</a><br />
                                                                                         <a target="pagecontent" class='<%# Eval("ClassIOBlink") %>'  id='<%# Eval("PatientId") %>'  name="g" style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<%# Eval("PatientId") %>','../IPD/IntakeOutPutChart.aspx?PatientId=<%# Eval("PatientId") %>&amp;TransactionId=<%# Eval("TransactionID") %>', 1050, 1050, '73%', '90%');" style="color:yellow;" >I/O</a><br />
                                                                                         <a target="pagecontent" class='<%# Eval("ClassFlowSheetsBlink") %>'  id='<%# Eval("PatientId") %>'  name="h"  style="cursor: pointer;color:blue;text-decoration: underline;" onClick="showuploadbox('<%# Eval("PatientId") %>','../IPD/FlowSheetView.aspx?PatientId=<%# Eval("PatientId") %>&amp;TransactionId=<%# Eval("TransactionID") %>', 1050, 1050, '73%', '90%');" style="color:yellow;" >FlowSheets</a><br />
                                                                                                 
                                                                                </td></tr></table> 
                                                                                   
                                                                               </div> 

                                                                              </div>  
                                                                        </div>
                                                                    </td>
                                                                    <td class="GridViewStyle" style="font-weight: bold; text-align: left;display:none;">
                                                                        <asp:DataList ID="dlRoom1" runat="server" RepeatDirection="horizontal" RepeatColumns="17">
                                                                            <ItemStyle HorizontalAlign="Center" VerticalAlign="top" />
                                                                            <ItemTemplate>
                                                                                <div class="BedDetailBox" style=""
                                                                                    title='<%# Eval("Location") %>'>
                                                                                </div>
                                                                            </ItemTemplate>
                                                                        </asp:DataList>
                                                                    </td>
                                                                
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                </tr>
                                                                </table>
                                                            </FooterTemplate>
                                                        </asp:Repeater>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                                          </div>
                        </div>
                    </div>

                </div>
                
            </ContentTemplate>
        </Ajax:UpdatePanel>
    </div>
</asp:Content>

