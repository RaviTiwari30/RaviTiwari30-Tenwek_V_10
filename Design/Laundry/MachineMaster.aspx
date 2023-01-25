<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MachineMaster.aspx.cs" Inherits="Design_Laundry_MachineMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral,
 PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Machine Master</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static">
            </asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Machine Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMachineName" ClientIDMode="Static" runat="server" MaxLength="50" CssClass="requiredField"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Machine Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlMachineType" ClientIDMode="Static" runat="server" CssClass="requiredField">
                                <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Washing" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Dryer" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Ironing" Value="3"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Capacity
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCapacity" runat="server" ClientIDMode="Static" MaxLength="50"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Running Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRunningTime" ClientIDMode="Static" runat="server" MaxLength="5">
                            </asp:TextBox><em><span style="color: #0000ff; font-size: 7.5pt">(Type&nbsp;A&nbsp;or&nbsp;P&nbsp;to&nbsp;switch&nbsp;AM/PM)</span></em>
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtRunningTime" AcceptAMPM="True">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtRunningTime"
                                ControlExtender="masTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Per Batch Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRunningTimePerBatch" ClientIDMode="Static" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Purchase Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPurchaseDate" ClientIDMode="Static" runat="server" MaxLength="50"></asp:TextBox>
                            <cc1:CalendarExtender ID="calPurchaseDate" runat="server" TargetControlID="txtPurchaseDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Maintenance Per Month
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMaintenancePerMonth" ClientIDMode="Static" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input type="hidden" id="txtID" />
                            <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="saveMachine()" />
                            <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" onclick="updateMachine()" style="display:none;" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <table id="machineTable" style="width: 100%; text-align: center"></table>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            bindMachineDetail();
        });
        function fillForm(id)
        {
            
            var $rowid = jQuery(id).closest("tr");
            $("#<%=txtMachineName.ClientID%>").val($rowid.find('span.MachineName').text());
            $("#<%=ddlMachineType.ClientID%>").val( $rowid.find('span.MachineTypeID').text() );
            $("#<%=txtCapacity.ClientID%>").val($rowid.find('span.Capacity').text());
            $("#<%=txtRunningTime.ClientID%>").val($rowid.find('span.RunningTime').text());
            $("#<%=txtRunningTimePerBatch.ClientID%>").val($rowid.find('span.PerBatchTime').text());
            $("#<%=txtPurchaseDate.ClientID%>").val($rowid.find('span.PurchaseDate').text());
            $("#<%=txtMaintenancePerMonth.ClientID%>").val($rowid.find('span.MaintenancePerMonth').text());
            $("#txtID").val($rowid.find('span.ID').text());
            $("#btnSave").hide();
            $("#btnUpdate").show();

            
        }
        function updateMachine() {
            if ($.trim($("#txtID").val()) == "") {
                $("#lblMsg").text('Please Select Machine .');
                return;
            }
            
            if ($.trim($("#txtMachineName").val()) == "") {
                $("#lblMsg").text('Please Enter Machine Name');
                $("#txtMachineName").focus();
                return;
            }
            if ($.trim($("#ddlMachineType").val()) == "0") {
                $("#lblMsg").text('Please Select Machine Type');
                $("#ddlMachineType").focus();
                return;
            }
            $.ajax({
                url: "Services/LaundryService.asmx/updateMachineMaster",
                data: '{ID:"' + $("#txtID").val() + '",MachineName:"' + $.trim($("#txtMachineName").val()) + '",MachineType:"' + $("#ddlMachineType option:selected").text() + '",MachineTypeID:"' + $("#ddlMachineType").val() + '",Capacity:"' + $.trim($("#txtCapacity").val()) + '",RunningTime:"' + $.trim($("#txtRunningTime").val()) + '",RunningTimePerBatch:"' + $.trim($("#txtRunningTimePerBatch").val()) + '",PurchaseDate:"' + $.trim($("#txtPurchaseDate").val()) + '",MaintenancePerMonth:"' + $.trim($("#txtMaintenancePerMonth").val()) + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    if (mydata.d == "1") {
                        $("#lblMsg").text('Record Saved Successfully');
                        clearControl();
                        bindMachineDetail();
                    }
                    else {
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                    }
                },
                error: function (xhr, status) {
                    $("#lblMsg").text('Error occurred, Please contact administrator');
                }
            });
        }


        function saveMachine() {
            if ($.trim($("#txtMachineName").val()) == "") {
                $("#lblMsg").text('Please Enter Machine Name');
                $("#txtMachineName").focus();
                return;
            }
            if ($.trim($("#ddlMachineType").val()) == "0") {
                $("#lblMsg").text('Please Select Machine Type');
                $("#ddlMachineType").focus();
                return;
            }
            $.ajax({
                url: "Services/LaundryService.asmx/machineMaster",
                data: '{MachineName:"' + $.trim($("#txtMachineName").val()) + '",MachineType:"' + $("#ddlMachineType option:selected").text() + '",MachineTypeID:"' + $("#ddlMachineType").val() + '",Capacity:"' + $.trim($("#txtCapacity").val()) + '",RunningTime:"' + $.trim($("#txtRunningTime").val()) + '",RunningTimePerBatch:"' + $.trim($("#txtRunningTimePerBatch").val()) + '",PurchaseDate:"' + $.trim($("#txtPurchaseDate").val()) + '",MaintenancePerMonth:"' + $.trim($("#txtMaintenancePerMonth").val()) + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    if (mydata.d == "1") {
                        $("#lblMsg").text('Record Saved Successfully');
                        clearControl();
                        bindMachineDetail();
                    }
                    else {
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                    }
                },
                error: function (xhr, status) {
                    $("#lblMsg").text('Error occurred, Please contact administrator');
                }
            });
        }
        function clearControl() {
            $("input[type='text']").val('');
            $("#ddlMachineType").get(0).selectedIndex = 0;
        }
    </script>
    <script type="text/javascript">
        function bindMachineDetail() {
            $.ajax({
                url: "Services/LaundryService.asmx/bindMachineMaster",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == null) {
                        alert('No Record Found');
                        return;
                    }
                    else {
                        $('#machineTable').empty();
                        $('#machineTable').append(CreateTableView(result.d, 'GridViewStyle', true));

                    }
                },
                error: function (xhr, status) {
                    return false;
                }
            });
        }
        function CreateTableView(objArray, theme, enableHeader) {
            // set optional theme parameter
            if (theme === undefined) {
                theme = 'mediumTable'; //default theme
            }

            if (enableHeader === undefined) {
                enableHeader = true; //default enable headers
            }

            // If the returned data is an object do nothing, else try to parse
            var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;

            var str = '<table class="GridViewStyle" style="width:100%;text-align:center" >';

            // table head
            if (enableHeader) {
                str += '<thead><tr>';
                for (var index in array[0]) {
                    if (index != "ID" && index != "MachineTypeID") {
                        str += '<th class="GridViewHeaderStyle" scope="col">' + index + '</th>';
                    }
                }
                str += '<th class="GridViewHeaderStyle" scope="col">Edit</th>';

                str += '</tr></thead>';
            }
            // table body
            str += '<tbody>';
            for (var i = 0; i < array.length; i++) {
                str += (i % 2 == 0) ? '<tr class="alt">' : '<tr>';
                for (var index in array[i]) {
                    if (index == "ID") {
                        str += '<td style="display:none;" class="GridViewItemStyle "><span class="ID">' + array[i][index] + '</span></td>';
                    }
                    else
                    {
                        if (index == "MachineTypeID") {
                            str += '<td style="display:none;" class="GridViewItemStyle "><span class="MachineTypeID">' + array[i][index] + '</span></td>';
                        }
                        else {

                            str += '<td class="GridViewItemStyle "><span class="' + index + '">' + array[i][index] + '</span></td>';
                        }
                    }

                }

                str += '<td class="GridViewItemStyle"><img src="../../Images/edit.png" alt="Edit"  style="border: 0px solid #FFFFFF;" onclick="fillForm(this);" width="15px" height="15px" /></td>';

                str += '</tr>';
            }
            str += '</tbody>'
            str += '</table>';
            return str;
        }    </script>
</asp:Content>

