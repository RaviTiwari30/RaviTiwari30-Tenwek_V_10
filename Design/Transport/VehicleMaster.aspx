<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="VehicleMaster.aspx.cs" Inherits="Design_Transport_VehicleMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            vehicleDetail();
        });
        function saveVehicleDetail() {
            if (chkCondition() == true) {
                $.ajax({
                    type: "POST",
                    url: "Services/Transport.asmx/saveVehicle",
                    data: '{VehicleNo:"' + $.trim($("#txtVehicleNo").val()) + '",VehicleName:"' + $("#txtVehicleName").val() + '",ModelNo:"' + $("#txtModelNo").val() + '",LastReading:"' + $("#txtLastReading").val() + '",RcNo:"' + $("#txtRcno").val() + '",TaxDepositDate:"' + $("#txtLicenceDate").val() + '",AveragePerLtrs:"' + $("#txtAvgfrom").val() + '",InsuranceNo:"' + $("#txtInsuranceNo").val() + '",InsuranceExpiryDate:"' + $("#txtInsuranceExpiry").val() + '",Model:"' + $("#ddlModel").val() + '",VehicleType:"' + $("#ddlVehicleType").val() + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {

                        if (response.d == "1") {
                            vehicleDetail();
                            clear();
                            DisplayMsg('MM01', 'lblErrormsg');
                        }
                        else if (response.d == "2") {
                            $("#lblErrormsg").text('Vehicle No. already exist');
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblErrormsg');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }
        function updateVehicle() {
            if (chkCondition() == true) {
                $.ajax({
                    type: "POST",
                    url: "Services/Transport.asmx/updateVehicle",
                    data: '{VehicleNo:"' + $.trim($("#txtVehicleNo").val()) + '",VehicleName:"' + $("#txtVehicleName").val() + '",ModelNo:"' + $("#txtModelNo").val() + '",LastReading:"' + $("#txtLastReading").val() + '",RcNo:"' + $("#txtRcno").val() + '",TaxDepositDate:"' + $("#txtLicenceDate").val() + '",AveragePerLtrs:"' + $("#txtAvgfrom").val() + '",IsActive:"' + $("input[type:radio]:checked").val() + '",ID:"' + $("#spnvehicleID").text() + '",InsuranceNo:"' + $("#txtInsuranceNo").val() + '",InsuranceExpiryDate:"' + $("#txtInsuranceExpiry").val() + '",Model:"' + $("#ddlModel").val() + '",VehicleType:"' + $("#ddlVehicleType").val() + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        if (response.d == "1") {
                            vehicleDetail();
                            cancelVehicle();
                            DisplayMsg('MM02', 'lblErrormsg');
                        }
                        else if (response.d == "2") {
                            $("#lblErrormsg").text('Vehicle No. already exist');
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblErrormsg');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }
        function chkCondition() {
            var con = 0;
            if ($.trim($("#txtVehicleNo").val()) == "") {
                $("#lblErrormsg").text('Please Enter Vehicle No.');
                $("#txtVehicleNo").focus();
                con = 1;
                return false;
            }
            if ($.trim($("#txtVehicleName").val()) == "") {
                $("#lblErrormsg").text('Please Enter Vehicle Name');
                $("#txtVehicleName").focus();
                con = 1;
                return false;
            }
            if ($.trim($("#txtLastReading").val()) == "") {
                $("#lblErrormsg").text('Please Enter Last Reading');
                $("#txtLastReading").focus();
                con = 1;
                return false;
            }
            if ($.trim($("#txtModelNo").val()) == "") {
                $("#lblErrormsg").text('Please Enter Model No.');
                $("#txtModelNo").focus();
                con = 1;
                return false;
            }
            if ($.trim($("#txtRcno").val()) == "") {
                $("#lblErrormsg").text('Please Enter RC No.');
                $("#txtRcno").focus();
                con = 1;
                return false;
            }
            if ($.trim($("#txtLicenceDate").val()) == "") {
                $("#lblErrormsg").text('Please Select Road Tax Deposit Date');
                $("#txtLicenceDate").focus();
                con = 1;
                return false;
            }
            if ($.trim($("#txtInsuranceNo").val()) == "") {
                $("#lblErrormsg").text('Please Enter Insurance No.');
                $("#txtInsuranceNo").focus();
                con = 1;
                return false;
            }
            if ($.trim($("#txtInsuranceExpiry").val()) == "") {
                $("#lblErrormsg").text('Please Select Insurance Expiry Date');
                $("#txtInsuranceExpiry").focus();
                con = 1;
                return false;
            }
            if ($.trim($("#txtAvgfrom").val()) == "") {
                $("#lblErrormsg").text('Please Enter Average Per Ltrs.');
                $("#txtAvgfrom").focus();
                con = 1;
                return false;
            }
            return true;
        }
        function saveVehicle() {
            if ($("#btnSave").val() == "Save") {
                saveVehicleDetail();
            }
            else {
                updateVehicle();
            }
        }
        function cancelVehicle() {
            $("input[type=text], textarea").val('');
            $("#btnSave").val('Save');
            $("#btnCancel").hide();
            $("#rdoActive").prop('checked', true);
            $("#lblErrormsg").text('');
            $("#ddlVehicleType").val("Normal");
            $("#ddlModel").val("Petrol");
        }
        function clear() {
            $("input[type=text], textarea").val('');
            $("#rdoAct(ive").prop('checked', true);
            $("#ddlModel").val("Petrol");
            $("#ddlVehicleType").val("Normal");
        }
        function vehicleDetail() {
            $('#lblErrormsg').text('');
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/bindVehicleDetail",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    Vehicle = jQuery.parseJSON(response.d);
                    if (Vehicle != null) {
                        var output = $('#tb_Vehicle').parseTemplate(Vehicle);
                        $('#VehicleOutput').html(output);
                        $('#VehicleOutput').show();
                    }
                    else {
                        DisplayMsg('MM04', 'lblErrormsg');
                        $('#VehicleOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function editVehicle(rowid) {
            $("#lblErrormsg").text('');
            $("#btnCancel").show();
            $("#btnSave").val('Update');
            var ID = $(rowid).closest('tr').find('#tdID').text();
            $("#spnvehicleID").text(ID);
            $("#txtVehicleNo").val($(rowid).closest('tr').find('#tdVehicleNo').text());
            $("#txtVehicleName").val($(rowid).closest('tr').find('#tdVehicleName').text());
            $("#txtLastReading").val($(rowid).closest('tr').find('#tdLastReading').text());
            $("#txtModelNo").val($(rowid).closest('tr').find('#tdModelNo').text());
            $("#txtRcno").val($(rowid).closest('tr').find('#tdRcNo').text());
            $("#txtAvgfrom").val($(rowid).closest('tr').find('#tdAveragePerLtrs').text());
            $("#txtLicenceDate").val($(rowid).closest('tr').find('#tdTaxDepositDate').text());

            $("#txtInsuranceNo").val($(rowid).closest('tr').find('#tdInsuranceNo').text());
            $("#txtInsuranceExpiry").val($(rowid).closest('tr').find('#tdInsuranceExpiryDate').text());
            if ($(rowid).closest('tr').find('#tdIsActive').text() == "Active")
                $("#rdoActive").prop('checked', true);
            else
                $("#rdoDeActive").prop('checked', true);
            $("#ddlModel").val($(rowid).closest("tr").find("#tdModel").text());
            $("#ddlVehicleType").val($(rowid).closest("tr").find("#tdType").text());
        }
        function checkInDateChanged(sender, args) {
            var checkInDate = sender.get_selectedDate();

            var checkOutDateExtender = $find("CheckOutdateExtender");
            var checkOutdate = checkOutDateExtender.get_selectedDate();
            if (checkOutdate == null || checkOutdate < checkInDate) {
                checkOutdate = new Date(checkInDate.setDate(checkInDate.getDate() + 1));
                checkOutDateExtender.set_selectedDate(checkOutdate);
            }
        }
        $(document).ready(function () {
            $("#txtAvgfrom").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
                strLen = $(this).val().length;
                strVal = $(this).val();
                hasDec = false;
                e = (e) ? e : (window.event) ? event : null;
                if (e) {
                    var charCode = (e.charCode) ? e.charCode :
                                    ((e.keyCode) ? e.keyCode :
                                    ((e.which) ? e.which : 0));
                    if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '.');
                            if (hasDec)
                                return false;
                        }
                    }
                }
            });
        });
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Vehicle Master<br />
            </b>
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
                                Vehicle No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtVehicleNo" maxlength="20" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Vehicle Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtVehicleName" maxlength="50" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Vehicle Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlVehicleType" title="Select Vehicle Type" class="requiredField">
                                <option selected="selected">Normal</option>
                                <option>Ambulance</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Model Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlModel" runat="server" ClientIDMode="Static" CssClass="requiredField" ToolTip="Select Type of Model">
                                <asp:ListItem Text="Petrol" Value="Petrol" Selected="True" />
                                <asp:ListItem Text="Diesel" Value="Diesel" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Last Reading
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtLastReading" maxlength="10" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Model No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtModelNo" maxlength="50" class="requiredField" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                RC No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtRcno" maxlength="50" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Last Inspection Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLicenceDate" runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                            <cc1:CalendarExtender ID="calLicenceDate" BehaviorID="CheckOutdateExtender" runat="server" TargetControlID="txtLicenceDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Insurance No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtInsuranceNo" maxlength="50" class="requiredField" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Ins. Expiry Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInsuranceExpiry" runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                            <cc1:CalendarExtender ID="calInsurance" runat="server" TargetControlID="txtInsuranceExpiry" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Average Per Ltrs.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtAvgfrom" maxlength="10" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IsActive
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="rdoActive" type="radio" name="con" value="1" checked="checked" />Active
                    <input id="rdoDeActive" type="radio" name="con" value="0" />DeActive
                            <span id="spnvehicleID" style="display: none"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <input type="button" id="btnSave" class="ItDoseButton" value="Save" onclick="saveVehicle()" />
                            <input type="button" id="btnCancel" class="ItDoseButton" value="Cancel" style="display: none" onclick="cancelVehicle()" />
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Vehicle Record
            </div>
            <table style="width: 100%">
                <tr>
                    <td style="text-align: center">
                        <div id="VehicleOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
                   <script id="tb_Vehicle" type="text/html">
                       <table cellspacing="0" rules="all" border="1"
                           style="width: 100%; border-collapse: collapse;">
                           <tr id="Header">
                               <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Vehicle No.</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Type</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Vehicle Name</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 120px;">Last Reading</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Model No.</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Rc No.</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Last Inspection Date</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Insurance No.</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Insurance Expiry Date</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Avg.Per Ltrs.</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Model</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">IsActive</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 30px;">Edit</th>
                               <th class="GridViewHeaderStyle" scope="col" style="width: 40px; display: none">ID</th>
                           </tr>
                           <#       
     
        var objRow;   
        for(var j=0;j<Vehicle.length;j++)
        {       
        objRow = Vehicle[j];
        #>
            

                    <tr id="<#=j+1#>"> 
                                                 
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdVehicleNo"  style="width:200px;text-align:center" ><#=objRow.VehicleNo#></td>
                        <td class="GridViewLabItemStyle" id="tdType"  style="width:50px;text-align:center" ><#=objRow.VehicleType#></td>
                    <td class="GridViewLabItemStyle" id="tdVehicleName"  style="width:200px;text-align:center" ><#=objRow.VehicleName#></td>
                                      <td class="GridViewLabItemStyle" id="tdLastReading"  style="width:120px;text-align:center" ><#=objRow.LastReading#></td>
                          <td class="GridViewLabItemStyle" id="tdModelNo"  style="width:100px;text-align:center" ><#=objRow.ModelNo#></td>

                    <td class="GridViewLabItemStyle" id="tdRcNo"  style="width:200px;text-align:center" ><#=objRow.RcNo#></td>
                    <td class="GridViewLabItemStyle" id="tdTaxDepositDate"  style="width:100px;text-align:center" ><#=objRow.TaxDepositDate#></td>
                                            <td class="GridViewLabItemStyle" id="tdInsuranceNo"  style="width:200px;text-align:center" ><#=objRow.InsuranceNo#></td>
                    <td class="GridViewLabItemStyle" id="tdInsuranceExpiryDate"  style="width:200px;text-align:center" ><#=objRow.InsuranceExpiryDate#></td>

                     <td class="GridViewLabItemStyle" id="tdAveragePerLtrs"  style="width:100px;text-align:center" ><#=objRow.AveragePerLtrs#></td>
                        <td class="GridViewLabItemStyle" id="tdModel"  style="width:100px;text-align:center" ><#=objRow.Model#></td>
                        <td class="GridViewLabItemStyle" id="tdIsActive"  style="width:100px;text-align:center" ><#=objRow.IsActive#></td>
                   <td class="GridViewLabItemStyle"   style="width:100px;text-align:center" >
                       <input type="button"  value="Edit" class="ItDoseButton" onclick="editVehicle(this)" />

                   </td>
 <td class="GridViewLabItemStyle" id="tdID" style="width:40px;display:none"><#=objRow.ID#></td>
                        
                    </tr>            
        <#}        
        #>     
                       </table>
                   </script>

</asp:Content>