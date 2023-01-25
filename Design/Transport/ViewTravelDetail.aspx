<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="ViewTravelDetail.aspx.cs" Inherits="Design_Transport_EditTravelDetail" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            bindPurpose();
            bindVehicle();
            bindDriver();
        });
        function travelingDetail() {
            $("#lblErrormsg").text('');
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/travelingDetail",
                data: '{DriverID:"' + $.trim($("#ddlDriver").val()) + '",VehicleID:"' + $.trim($("#ddlVehicle").val()) + '",Purpose:"' + $.trim($("#ddlPurpose").val()) + '",DepartureDate:"' + $.trim($("#txtDepartureDate").val()) + '",ArrivalDate:"' + $.trim($("#txtArrivalDate").val()) + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    traveling = jQuery.parseJSON(response.d);
                    if (traveling != null) {
                        var output = $('#tb_traveling').parseTemplate(traveling);
                        $('#travelingOutput').html(output);
                        $('#travelingOutput').show();
                    }
                    else {
                        DisplayMsg('MM04', 'lblErrormsg');
                        $('#travelingOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
        function bindPurpose() {
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/bindPurpose",
                data: '{}',
                dataType: "json",
                async: false,
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    Purpose = jQuery.parseJSON(response.d);
                    if (Purpose != null) {
                        $("#ddlPurpose").append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Purpose.length; i++) {
                            $("#ddlPurpose").append($("<option></option>").val(Purpose[i].Id).html(Purpose[i].Purpose));
                        }
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function bindVehicle() {
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/vehicle",
                data: '{}',
                dataType: "json",
                async: false,
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    Vehicle = jQuery.parseJSON(response.d);
                    if (Vehicle != null) {
                        $("#ddlVehicle").append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Vehicle.length; i++) {
                            $("#ddlVehicle").append($("<option></option>").val(Vehicle[i].Id).html(Vehicle[i].Name));
                        }
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function bindDriver() {
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/driver",
                data: '{}',
                dataType: "json",
                async: false,
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    Driver = jQuery.parseJSON(response.d);
                    if (Driver != null) {
                        $("#ddlDriver").append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Driver.length; i++) {
                            $("#ddlDriver").append($("<option></option>").val(Driver[i].Id).html(Driver[i].Name));
                        }
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
       
    </script>
    <script type="text/javascript" >
        $(document).ready(function () {
            $('#txtDepartureDate').change(function () {
                ChkDate();
            });
            $('#txtArrivalDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {

            $.ajax({

                url: "CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtDepartureDate').val() + '",DateTo:"' + $('#txtArrivalDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblErrormsg').text('Arrival Date can not be less than Departure Date');
                        $('#btnSearch').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblErrormsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }
       
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Traveling Detail</b>
            <br />
            <span id="lblErrormsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Driver
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDriver"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Vehicle
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlVehicle"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Purpose
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlPurpose"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Departure Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDepartureDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Arrival Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtArrivalDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calArrDate" runat="server" TargetControlID="txtArrivalDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSearch" class="ItDoseButton" value="Search" onclick="travelingDetail()" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table style="width: 100%">
                <tr>
                    <td style="text-align: center">
                        <div id="travelingOutput" style="max-height: 400px; overflow-x: auto;">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
     <script id="tb_traveling" type="text/html">
    <table  cellspacing="0" rules="all" border="1" 
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Departure Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Departure Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Arrival Date</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Arrival Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Vehicle Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Vehicle No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Driver Name</th>
           <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Opening</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Closing</th>
		</tr>
        <#       
        var objRow;   
        for(var j=0;j<traveling.length;j++)
        {       
        objRow = traveling[j];
        #>
                    <tr id="<#=j+1#>">                         
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdDepartureDate"  style="width:90px;text-align:center" ><#=objRow.DepartureDate#></td>
                    <td class="GridViewLabItemStyle" id="tdDepartureTime"  style="width:90px;text-align:center" ><#=objRow.DepartureTime#></td>
                    <td class="GridViewLabItemStyle" id="tdArrivalDate"  style="width:90px;text-align:center" ><#=objRow.ArrivalDate#></td>
                    <td class="GridViewLabItemStyle" id="tdArrivalTime"  style="width:90px;text-align:center" ><#=objRow.ArrivalTime#></td>
                    <td class="GridViewLabItemStyle" id="tdVehicleName"  style="width:160px;text-align:center" ><#=objRow.VehicleName#></td>
                    <td class="GridViewLabItemStyle" id="tdVehicleNo"  style="width:100px;text-align:center" ><#=objRow.VehicleNo#></td>
                    <td class="GridViewLabItemStyle" id="tdDriverName"  style="width:160px;text-align:center" ><#=objRow.DriverName#></td>
                    <td class="GridViewLabItemStyle" id="tdOpening"  style="width:60px;text-align:center" ><#=objRow.Opening#></td>
                    <td class="GridViewLabItemStyle" id="tdClosing"  style="width:60px;text-align:center" ><#=objRow.Closing#></td>
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>
</asp:Content>
