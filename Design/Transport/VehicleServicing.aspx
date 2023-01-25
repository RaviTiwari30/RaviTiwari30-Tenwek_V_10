<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="VehicleServicing.aspx.cs" Inherits="Design_Transport_VehicleServicing" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        $(document).ready(function () {
            $('#SpnCurrentServiceDate,#txtCurServiceDate,#SpnNextServiceDate,#txtNextServiceDate,#SpnLitreDot').show();
            $('#rblServiceMaintenance').change(function () {
                if ($('#rblServiceMaintenance').find(":checked").val() == "1") {
                    $('#SpnCurrentServiceDate,#txtCurServiceDate,#SpnNextServiceDate,#txtNextServiceDate,#SpnLitreDot').show();
                    $('#SpnFuelDate,#txtFuelDate,#SpnMaintenanceDate,#txtMaintenanceDate,#SpnLitre,#txtLetter').hide();
                }
                if ($('#rblServiceMaintenance').find(":checked").val() == "2") {
                    $('#SpnMaintenanceDate,#txtMaintenanceDate').show();
                    $('#SpnCurrentServiceDate,#txtCurServiceDate,#SpnNextServiceDate,#txtNextServiceDate,#SpnFuelDate,#txtFuelDate,#SpnLitre,#txtLetter,#SpnLitreDot').hide();

                }
                if ($('#rblServiceMaintenance').find(":checked").val() == "3") {
                    $('#SpnFuelDate,#txtFuelDate,#SpnLitre,#txtLetter,#SpnLitreDot').show();
                    $('#SpnCurrentServiceDate,#txtCurServiceDate,#SpnNextServiceDate,#txtNextServiceDate,#SpnMaintenanceDate,#txtMaintenanceDate').hide();

                }

                $("#divVehicleService").hide();
                $("#divServiceResult").hide();
                $('#lblErrorMsg').text('');
                $("#btnSave").val('Save');
                $("#btnCancel").hide();
                clearControls();
            });
        });
        $(document).ready(function () {
            bindVehicle();
            $("#txtRemarks").keypress(function (e) {
                var keynum
                var keychar
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                //List of special characters you want to restrict

                if (keychar == "~" || keychar == "!" || keychar == "^" || keychar == "*" || keychar == "+" || keychar == "=" || keychar == "{" || keychar == "}" || keychar == "|" || keychar == ";" || keychar == "'" || keychar == "/" || keychar == "`") {
                    return false;
                }
                else {
                    return true;
                }
            });
            $("#txtAmount,#txtLetter").keypress(function (e) {

                var charCode = (e.which) ? e.which : e.keyCode;

                if ((charCode != 46 || $(this).val().indexOf('.') != -1) && ((charCode < 48 || charCode > 57) && (charCode != 0 && charCode != 8))) {
                    e.preventDefault();
                }

                var text = $(this).val();

                if ((text.indexOf('.') != -1) &&
                  (text.substring(text.indexOf('.')).length > 2) &&
                  (charCode != 0 && charCode != 8) &&
                  ($(this)[0].selectionStart >= text.length - 2)) {
                    e.preventDefault();
                }
            });
            $("#ddlVehicle").change(function () {
                bindServicingDetail();
            });
            
            // Save ServiceMaintenance
            $("#btnSave").click(function () {
                $("#lblErrorMsg").text("");
                if ($("#btnSave").val() == "Save") {
                    SaveServiceMaintenance();
                }
                else if ($("#btnSave").val() == "Update"){

                    UpdateServiceMaintenance();
                }
             
                    });
            
                });
            
        function SaveServiceMaintenance() {
            if (validate() == true) {

                $("#btnSave").val("Submitting...");
                $("#btnSave").attr("disabled", true);

                var IsService;
                if ($('#rblServiceMaintenance').find(":checked").val() == "1") {
                    IsService = 0;
                }
                if ($('#rblServiceMaintenance').find(":checked").val() == "2") {
                    IsService = 1;
                }
                if ($('#rblServiceMaintenance').find(":checked").val() != "3") {
                    $.ajax({
                        url: "Services/Transport.asmx/saveService",
                        data: '{ID:"' + $("#ddlVehicle").val() + '",CurrentDate:"' + $.trim($("#txtCurServiceDate").val()) + '",NextDate:"' + $.trim($("#txtNextServiceDate").val()) + '",Remarks:"' + $.trim($("#txtRemarks").val()) + '",IsService:"' + IsService + '", DriverID:"' + $("#ddlDriver").val() + '",MaintenanceDate:"' + $.trim($("#txtMaintenanceDate").val()) + '",Amount:"' + $.trim($("#txtAmount").val()) + '"}',
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {
                                bindServicingDetail();
                                $("#btnSave").val("Save");
                                $("#btnSave").attr("disabled", false);
                                clearControls();
                                //DisplayMsg("MM01", "lblErrorMsg");
                                modelAlert('Record Saved Successfully!');
                            }
                            else {
                                $("#btnSave").val("Save");
                                $("#btnSave").attr("disabled", false);
                                //DisplayMsg("MM05", "lblErrorMsg");
                                modelAlert('Error occurred, Please contact administrator');
                            }
                        },
                        error: function (xhr, status) {
                            //DisplayMsg("MM05", "lblErrorMsg");
                            modelAlert('Error occurred, Please contact administrator');
                        }
                    });
                }
                // save fuel Entry
                if ($('#rblServiceMaintenance').find(":checked").val() == "3") {

                    $.ajax({
                        url: "Services/Transport.asmx/saveFuelEntry",
                        data: '{VehicleID:"' + $("#ddlVehicle").val() + '",DriverID:"' + $("#ddlDriver").val() + '",Amount:"' + $("#txtAmount").val() + '",Letter:"' + $.trim($("#txtLetter").val()) + '",Remarks:"' + $.trim($("#txtRemarks").val()) + '",FuelDate:"'+($("#txtFuelDate").val())+'"}',
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {
                                $("#btnSave").val("Save");
                                $("#btnSave").attr("disabled", false);
                                clearControls();
                                //DisplayMsg("MM01", "lblErrorMsg");
                                modelAlert('Record Saved Successfully!');
                            }
                            else {
                                $("#btnSave").val("Save");
                                $("#btnSave").attr("disabled", false);
                                //DisplayMsg("MM05", "lblErrorMsg");
                                modelAlert('Error occurred, Please contact administrator');
                            }
                        },
                        error: function (xhr, status) {
                            //DisplayMsg("MM05", "lblErrorMsg");
                            modelAlert('Error occurred, Please contact administrator');
                        }
                    });
                }
            }
        }
        function bindServicingDetail() {

            if ($("#ddlVehicle").val() == "0") {
                $("#divVehicleService").html("");
                $("#divServiceResult,#divVehicleService").hide();
                modelAlert('No Record Found');
                return;
            }
            else {
                $("#divServiceResult").show();
            }
        }
                function ShowResult() {
            var IsService;
            if ($('#rblServiceMaintenance').find(":checked").val() == "1") {
                IsService = 0;
            }
            if ($('#rblServiceMaintenance').find(":checked").val() == "2") {
                IsService = 1;
            }
            if ($('#rblServiceMaintenance').find(":checked").val() != "3") {
                $.ajax({
                    url: "Services/Transport.asmx/bindServicingDetail",
                    data: '{ID:"' + $("#ddlVehicle").val() + '",CurServiceDate: "' + $("#txtFromDate").val() + '", NextServiceDate: "' + $("#txtToDate").val() + '",IsService:"' + IsService + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        VehicleService = $.parseJSON(result.d);

                        if (VehicleService != null && VehicleService != "0") {
                            var HtmlOutput = $("#scriptService").parseTemplate(VehicleService);
                            $("#divVehicleService,").html(HtmlOutput);
                            $("#divServiceResult,#divVehicleService").show();
                        }
                        else {
                            $("#divVehicleService").html("");
                            $("#divVehicleService").hide();
                            $('#lblErrorMsg').text('No Record Found');
                        }
                    },
                    error: function (xhr, status) {
                    }

                });
            }
            if ($('#rblServiceMaintenance').find(":checked").val() == "3") {
                
                $.ajax({
                    url: "Services/Transport.asmx/bindFuelEntry",
                    data: '{ID:"' + $("#ddlVehicle").val() + '",FromDate:"' + $("#txtFromDate").val() + '",ToDate:"' + $("#txtToDate").val()+ '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        fuelEntry = $.parseJSON(result.d);
                        
                        if (fuelEntry != null && fuelEntry != "0") {
                          
                            var HtmlOutput = $("#scriptfuel").parseTemplate(fuelEntry);
                            $("#divVehicleService,").html(HtmlOutput);
                            $("#divServiceResult,#divVehicleService").show();
                        }
                        else {
                            $("#divVehicleService").html("");
                            $("#divVehicleService").hide();
                            $('#lblErrorMsg').text('No Record Found');
                        }
                    },
                    error: function (xhr, status) {
                    }

                });
            }
        }
        function bindVehicle() {
            $.ajax({
                url: "Services/Transport.asmx/bindVehicle1",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        var Vehicle = $.parseJSON(result.d);
                        $("#ddlVehicle").append($("<option></option>").val("0").html("Select"));
                        for (var i = 0; i < Vehicle.length; i++) {
                            $("#ddlVehicle").append($("<option></option>").val(Vehicle[i].Id).html(Vehicle[i].Name));
                        }
                    }
                    else {
                        $("#ddlVehicle").append($("<option></option>").val("0").html("--No Data--"));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
    
        function clearControls() {
           $("#ddlVehicle").val("0");
            $("#ddlDriver").val("0");
            //$("#txtCurServiceDate").val("");
            //$("#txtNextServiceDate").val("");
            //$("#txtMaintenanceDate").val("");
            $("#txtAmount").val("");
            $("#txtLetter").val("");
            $("#txtRemarks").val("");
        }
        function HideData()
        {
            $('#divVehicleService').hide();
            $('#lblErrorMsg').text('');
        }
        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblErrorMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblErrorMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }
        function validate() {
            if ($('#rblServiceMaintenance').find(":checked").val() == "1") {
                if ($("#txtCurServiceDate").val() == "") {
                    $("#txtCurServiceDate").focus();
                    $("#lblErrorMsg").text("Select Current Service Date");
                    return false;
                }

                if ($("#txtNextServiceDate").val() == "") {
                    $("#txtNextServiceDate").focus();
                    $("#lblErrorMsg").text("Select Next Service Date");
                    return false;
                }
            }
            if ($('#rblServiceMaintenance').find(":checked").val() == "2") {
                if ($("#txtMaintenanceDate").val() == "") {
                    $("#txtMaintenanceDate").focus();
                    $("#lblErrorMsg").text("Select Maintenance Date ");
                    return false;
                }
                if ($("#txtRemarks").val() == "") {
                    $("#txtRemarks").focus();
                    $("#lblErrorMsg").text(" Enter Remark");
                    return false;
                }
            }
            if ($('#rblServiceMaintenance').find(":checked").val() == "3") {
                if ($("#txtLetter").val() == "") {
                    $("#txtLetter").focus();
                    $("#lblErrorMsg").text("Select Litre");
                    return false;
                }
                if ($("#txtRemarks").val() == "") {
                    $("#txtRemarks").focus();
                    $("#lblErrorMsg").text(" Enter Remark");
                    return false;
                }
            }
            if ($("#ddlVehicle").val() == "0") {
                $("#ddlVehicle").focus();
                $("#lblErrorMsg").text("Select Vehicle");
                return false;
            }
            if ($("#ddlDriver").val() == "0") {
                $("#ddlDriver").focus();
                $("#lblErrorMsg").text("Select Driver");
                return false;

            }
            if ($("#txtAmount").val() == "") {
                $("#txtAmount").focus();
                $("#lblErrorMsg").text(" Enter Amount");
                return false;
            }
            return true;
        }
        
    </script>
    <script type="text/javascript">
        // editService
        function editServiceMaintenance(rowid) {
            $("#lblErrormsg").text('');
            $("#btnCancel").show();
            $("#btnSave").val('Update');
            if ($('#rblServiceMaintenance').find(":checked").val() == "1") {
                $('#lblEditID').text ($(rowid).closest('tr').find('#tdID').text());
                $("#ddlVehicle").val($(rowid).closest("tr").find("#tdVehicleID").text());
                $("#ddlDriver").val($(rowid).closest('tr').find('#tdDriverID').text());
                $("#txtCurServiceDate").val($(rowid).closest('tr').find('#tdCurServiceDate').text());
                $("#txtNextServiceDate").val($(rowid).closest('tr').find('#tdNextServiceDate').text());
                $("#txtRemarks").val($(rowid).closest('tr').find('#tdRemarks').text());
                $("#txtAmount").val($(rowid).closest('tr').find('#tdAmount').text());
            }
            if ($('#rblServiceMaintenance').find(":checked").val() == "2") {
                $('#lblEditID').text($(rowid).closest('tr').find('#tdID').text());
                $("#ddlVehicle").val($(rowid).closest("tr").find("#tdVehicleID").text());
                $("#ddlDriver").val($(rowid).closest('tr').find('#tdDriverID').text());
                $("#txtMaintenanceDate").val($(rowid).closest('tr').find('#tdMaintenanceDate').text());
                $("#txtRemarks").val($(rowid).closest('tr').find('#tdRemarks').text());
                $("#txtAmount").val($(rowid).closest('tr').find('#tdAmount').text());
            }
            if ($('#rblServiceMaintenance').find(":checked").val() == "3") {
                $('#lblEditID').text($(rowid).closest('tr').find('#tdid').text());
                $("#ddlVehicle").val($(rowid).closest("tr").find("#tdVehicleid").text());
                $("#ddlDriver").val($(rowid).closest('tr').find('#tddriverid').text());
                $("#txtLetter").val($(rowid).closest('tr').find('#tdLetter').text());
                $("#txtRemarks").val($(rowid).closest('tr').find('#tdremark').text());
                $("#txtAmount").val($(rowid).closest('tr').find('#tdamount').text());
            }

        }
        function CancelServiceMaintenance() {
            //$("input[type=text], textarea").val('');
            $("#btnSave").val('Save');
            $("#btnCancel").hide();
            clearControls();
            $("#lblErrormsg").text('');
            //$("#ddlDriver").val("Select");
            // $("#ddlVehicle").val("Select");
        }
        function UpdateServiceMaintenance() {
            
            if ($('#rblServiceMaintenance').find(":checked").val() != "3") {
                var CurrentServiceDate;
                var NextServiceDate;
                var MaintenceDate;
                if ($('#rblServiceMaintenance').find(":checked").val() == "1") {

                    CurrentServiceDate = $("#txtCurServiceDate").val();
                    NextServiceDate = $("#txtNextServiceDate").val();
                    MaintenanceDate = "0001-01-01 00:00";
                }
                else if ($('#rblServiceMaintenance').find(":checked").val() == "2") {
                    CurrentServiceDate = "0001-01-01 00:00";
                    NextServiceDate = "0001-01-01 00:00";
                    MaintenanceDate=($("#txtMaintenanceDate").val());
                }
                    $.ajax({
                        url: "Services/Transport.asmx/UpdateServiceMaintenance",
                        data: '{ID:"' + $("#lblEditID").text() + '",VehicleID:"' + $("#ddlVehicle").val() + '",CurServiceDate:"' + CurrentServiceDate + '",NextServiceDate:"' + NextServiceDate + '",Remarks:"' + $.trim($("#txtRemarks").val()) + '",DriverID:"' + $("#ddlDriver").val() + '",MaintenanceDate:"' + MaintenanceDate + '",Amount:"' + $.trim($("#txtAmount").val()) + '"}',
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            
                            if (result.d == "1") {
                                
                                ShowResult();
                                $("#btnSave").val("Save");
                                $("#btnSave").attr("disabled", false);
                                clearControls();
                                $("#btnCancel").hide();
                                $('#lblErrorMsg').text('Record Updated Successfully');
                            }
                            else {
                                $("#btnSave").val("Update");
                                $("#btnSave").attr("disabled", false);
                                // DisplayMsg("MM05", "lblErrorMsg");
                                modelAlert('Error occurred, Please contact administrator');
                            }
                        },
                        error: function (xhr, status) {
                            // DisplayMsg("MM05", "lblErrorMsg");
                            modelAlert('Error occurred, Please contact administrator');
                            $("#btnSave").val("Update");
                            $("#btnSave").attr("disabled", false);
                           //var err = eval("(" + xhr.responseText + ")");
                          //alert(err.Message);
                        }
                        
                    });
            }
            if ($('#rblServiceMaintenance').find(":checked").val() == "3") {
                
                $.ajax({
                    
                    url: "Services/Transport.asmx/UpdatefuelEntry",
                    data: '{ID:"' + $("#lblEditID").text() + '",VehicleID:"' + $("#ddlVehicle").val() + '",DriverID:"' + $("#ddlDriver").val() + '",Letter:"' + $("#txtLetter").val() + '",Remark:"' + $.trim($("#txtRemarks").val()) + '",TotalAmount:"' + $.trim($("#txtAmount").val()) + '", FuelDate:"'+($("#txtFuelDate").val())+'"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {

                        if (result.d == "1") {

                            ShowResult();
                            $("#btnSave").val("Save");
                            $("#btnSave").attr("disabled", false);
                            clearControls();
                            $("#btnCancel").hide();
                            $('#lblErrorMsg').text('Record Updated Successfully');
                        }
                        else {
                            $("#btnSave").val("Update");
                            $("#btnSave").attr("disabled", false);
                            //  DisplayMsg("MM05", "lblErrorMsg");
                            modelAlert('Error occurred, Please contact administrator');
                        }
                    },
                    error: function (xhr, status) {
                        //DisplayMsg("MM05", "lblErrorMsg");
                        modelAlert('Error occurred, Please contact administrator');
                        $("#btnSave").val("Update");
                        $("#btnSave").attr("disabled", false);
                        //var err = eval("(" + xhr.responseText + ")");
                        //alert(err.Message);
                    }

                });

            }
          }
            
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div class="body_box_inventory">
        <div  style="text-align: center;">
            <b><span id="lblHeader" style="font-weight: bold;">Vehicle Servicing </span></b>
            <br />
            <span id="lblErrorMsg" class="ItDoseLblError"></span>
        </div>
        <div style="height:20px;"></div>
        <div class="POuter_Box_Inventory" >
            <div  style="text-align:center;top:100px;">
                <b>
                    Vehicle Servicing Detail
                </b>
            </div>
            <%--<div class="Purchaseheader"  >
                Vehicle Servicing Detail
            </div>--%>
        </div>  

 <div class="POuter_Box_Inventory">
  <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-24" style="text-align:center;">                         
                             <asp:RadioButtonList ID="rblServiceMaintenance" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" AutoPostBack="false"> 
                                <asp:ListItem Text="Service" Selected="True" Value="1" ></asp:ListItem>
                                <asp:ListItem Text="Maintenance"  Value="2"></asp:ListItem>
                                <asp:ListItem Text="Fuel Entry" Value="3"></asp:ListItem>
                            </asp:RadioButtonList>
                             <asp:label id="lblEditID" runat="server" ClientIDMode="Static" style="display:none"></asp:label>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


  <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                         
                            Vehicle
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">
                           <select id="ddlVehicle" style="width: 156px;" title="Select Vehicle" onchange="HideData()" class="requiredField"></select>
                        </div>                        
                        <div class="col-md-3">                          
                            <asp:Label ID="lblDriver" runat="server" Text="Driver" ClientIDMode="Static"></asp:Label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left"> 
                             <select id="ddlDriver" style="width: 156px;" title="Select Driver" runat="server" clientidmode="Static" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">                           
                          
                            
                            Amount
                            
                                                
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">                                                         
                            <asp:TextBox ID="txtAmount" runat="server" Width="150px" ClientIDMode="static" class="requiredField" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


    <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-3">                                                     
                             <span id="SpnCurrentServiceDate" class="pull-left" style="display:none;">Service Date</span>   
                             <span id="SpnFuelDate" class="pull-left" style="display:none;">Fuel Date</span>   
                             <span id="SpnMaintenanceDate" class="pull-left" style="display:none;">Maintenance Date</span>  
                            <b class="pull-right">:</b>
                        </div>
                <div class="col-md-5"  style="text-align:left">
                     <asp:TextBox ID="txtCurServiceDate" runat="server" Width="150px" ClientIDMode="static" ToolTip="Click To Select Current Service Date" style="display:none;"   CssClass="requiredField" />
                     <asp:TextBox ID="txtMaintenanceDate" runat="server" Width="150px" ClientIDMode="static" ToolTip="Click To Select  Maintenance Date" style="display:none;"    CssClass="requiredField" />   
                     <asp:TextBox ID="txtFuelDate" runat="server" Width="150px" ClientIDMode="static" ToolTip="Click To Select  Fule Entry Date" style="display:none;"   CssClass="requiredField" />                    
                    <cc1:CalendarExtender ID="clCurrent" runat="server" TargetControlID="txtCurServiceDate" Format="dd-MMM-yyyy" />
                    <cc1:CalendarExtender ID="clMaintenance" runat="server" TargetControlID="txtMaintenanceDate" Format="dd-MMM-yyyy" />
                    <cc1:CalendarExtender ID="clFuelDate" runat="server" TargetControlID="txtFuelDate" Format="dd-MMM-yyyy" />
                </div>                        
                        <div class="col-md-3">    
                              <span id="SpnNextServiceDate" class="pull-left" style="display:none;">Next Service Date</span>             
                              <span id="SpnLitre" class="pull-left" style="display:none;">Litre</span>  
                            <b class="pull-right">   <span id="SpnLitreDot" class="pull-left" style="display:none;">:</span>     </b>
                        </div>
                        <div class="col-md-5"  style="text-align:left"> 
                              <asp:TextBox ID="txtNextServiceDate" runat="server" Width="150px" ClientIDMode="static" ToolTip="Select Next Service Date" style="display:none;"   CssClass="requiredField" />
                            <cc1:CalendarExtender ID="clNext" runat="server" TargetControlID="txtNextServiceDate" Format="dd-MMM-yyyy"  />
                             <asp:TextBox ID="txtLetter" runat="server" Width="150px" ClientIDMode="static" style="display:none;"   CssClass="requiredField" />
                        </div>
                        <div class="col-md-3">                           
                            <span id="Span1" class="pull-left">Remark</span>                
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="text-align:left">                            
                               <textarea id="txtRemarks" style="width: 200px; height: 50px; resize: none;" cols="1" rows="1" title="Enter Remarks" maxlength="500"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>



        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSave" class="ItDoseButton" value="Save" />
             <input type="button" id="btnCancel" class="ItDoseButton" value="Cancel" style="display:none" onclick="CancelServiceMaintenance()" />
        </div>
        <div class="POuter_Box_Inventory" id="divServiceResult" style="display: none;max-height:400px;">
            <div class="Purchaseheader">
                Vehicle Services 
            </div>
            
                   <table width="60%">
        <tr>
            <td style=" text-align: right;">From Date&nbsp;:&nbsp;</td>
                        <td style=" text-align: left;">
                            <asp:TextBox ID="txtFromDate" runat="server" Width="150px" ClientIDMode="static" onchange="ChkDate();" ToolTip="Click To Select Current Service Date"  />
                            <cc1:CalendarExtender ID="FromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                            
                        </td>
                        <td style=" text-align: right;">To Date&nbsp;:&nbsp;</td>
                        <td style=" text-align: left;">
                            <asp:TextBox ID="txtToDate" runat="server" Width="150px" ClientIDMode="static" onchange="ChkDate();" ToolTip="Select Next Service Date" />
                            <cc1:CalendarExtender ID="ToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                            
                        </td>
            <td> <input type="button" id="btnSearch" value="Search" class="ItDoseButton" onclick="ShowResult() " /></td>
        </tr>
    </table>
            <div>


            <div id="divVehicleService" style="overflow:auto;">
            </div>
       
        </div>
    </div>


</div>

      <script type="text/html" id="scriptService">
          <table class="FixedTables" cellspacing="0" rules="all" border="1" style="border-collapse: collapse;" border="1">
             <# var objRow1; 
              objRow1=VehicleService[0];
                #>
            <tr> 
                         
                <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;display:none;">ID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;display:none;">VehicleID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px; ">Vehicle No</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Vehicle Name</th>
                <th class="GridViewHeaderStyle" scope="col" <# if(objRow1.IsService=="1"){#>style="Display:none;width: 150px;"<#}  #>  >Current Service Date</th>
                <th class="GridViewHeaderStyle" scope="col" <#if(objRow1.IsService=="1"){#>style="Display:none; width: 150px;"<#} #> >Next Service Date   </th>
                 <th class="GridViewHeaderStyle" scope="col" <#if(objRow1.IsService=="0"){#> style="Display:none;width: 150px;"<#} #> >Maintenance Date   </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Driver</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Amount</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Remarks</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px; display:none">IsService</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px; display:none">DriverID</th> 
               
                 <th class="GridViewHeaderStyle" scope="col" style="width: 80px; ">Edit</th>                             
            </tr>
            <#
                var dataLength=VehicleService.length;
		        window.status="Total Records Found :"+ dataLength;
		        var objRow;   
		        for(var j=0;j<dataLength;j++)
		        {
                    objRow=VehicleService[j];
                    
            #>
                    <tr<#if(objRow.IsApproved=="0" && objRow.IsCancel=="0"){#>style="background-color:LightBlue;"<#} else { if(objRow.IsCancel=="1"){#>style="background-color:LightPink;" <#  }   if(objRow.IsApproved=="1"){#> style="background-color:Green;"  <#   } } #> >                       
                        <td class="GridViewLabItemStyle" style="width:20px;text-align:center;"> <#=j+1#>&nbsp;&nbsp;</td> 
                        <td class="GridViewLabItemStyle" id="tdID"  style="width:100px;text-align:center;display:none;" ><#=objRow.ID#></td>
                        <td class="GridViewLabItemStyle" id="tdVehicleID"  style="width:100px;text-align:center;display:none;" ><#=objRow.VehicleID#></td>
                        <td class="GridViewLabItemStyle" id="tdVehicleNo"  style="width:100px;text-align:left;" ><#=objRow.VehicleNo#></td>
                        <td class="GridViewLabItemStyle" id="tdVehicleName" style="width:100px;text-align:center; "><#=objRow.VehicleName#></td>    
					    <td class="GridViewLabItemStyle" id="tdCurServiceDate"  <# if(objRow1.IsService=="1"){#>style="Display:none;width: 150px;"<#}  #>><#=objRow.CurServiceDate#></td>
					    <td class="GridViewLabItemStyle" id="tdNextServiceDate" <#if(objRow1.IsService=="1"){#>style="Display:none; width: 150px;"<#} #>><#=objRow.NextServiceDate#></td>
                        <td class="GridViewLabItemStyle" id="tdMaintenanceDate" <#if(objRow1.IsService=="0"){#> style="Display:none;width: 150px;"<#} #>><#=objRow.MaintenanceDate#></td>
                        <td class="GridViewLabItemStyle" id="tdDriver" style="width:150px; text-align:center;"><#=objRow.Driver#></td>
                         <td class="GridViewLabItemStyle" id="tdAmount" style="width:80px; text-align:center;"><#=objRow.Amount#></td>
					    <td class="GridViewLabItemStyle" id="tdRemarks" style="width:150px;text-align:center"><#=objRow.Remarks#></td>
                        <td class="GridViewLabItemStyle" id="tdIsService" style="width:100px;text-align:center; display:none"><#=objRow.IsService#></td>
                        <td class="GridViewLabItemStyle" id="tdDriverID" style="width:100px;text-align:center; display:none"><#=objRow.DriverID#></td>
                        
                         <td class="GridViewLabItemStyle"   style="width:80px;text-align:center" >
                       <input type="button"  value="Edit" class="ItDoseButton" onclick="editServiceMaintenance(this)" />

                   </td>
                    </tr>                           
            <#    
                }                
            #>
        </table>
          </script>
                <script type="text/html" id="scriptfuel">

           <table class="FixedTables" cellspacing="0" rules="all" border="1" style="border-collapse: collapse;" border="1">
              
                <tr>
                 <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;display:none;">ID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;display:none;">VehicleID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px; ">Vehicle No</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Vehicle Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Purchase By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Letter</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Remarks</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Amount</th>  
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px; display:none">DriverID</th> 
                  <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Fuel Date</th>
                   <th class="GridViewHeaderStyle" scope="col" style="width:100px; "> Edit</th>   
               </tr>
               
                   <#
                var dataLen=fuelEntry.length;
		        window.status="Total Records Found :"+ dataLen;
		        var objRow;   
		        for(var k=0;k<dataLen;k++)
		        {
                    objRow=fuelEntry[k];
                 #>
                   <tr>  
                   <td class="GridViewLabItemStyle" style="width:20px; text-align:center"><#=k+1#></td>
                   <td class="GridViewLabItemStyle" id="tdid" style="width:100px; text-align:center; display:none;"><#=objRow.ID#></td>
                        <td class="GridViewLabItemStyle" id="tdVehicleid" style="width:100px; text-align:center; display:none;"><#=objRow.VehicleID#></td>
                        <td class="GridViewLabItemStyle" id="tdVehicle" style="width:100px; text-align:center"><#=objRow.VehicleNo#></td>
                        <td class="GridViewLabItemStyle" id="tdVehiclename" style="width:100px; text-align:center"><#=objRow.VehicleName#></td>
                        <td class="GridViewLabItemStyle" id="tdDriverName" style="width:150px; text-align:center"><#=objRow.Driver#></td>
                        <td class="GridViewLabItemStyle" id="tdLetter" style="width:100px; text-align:center"><#=objRow.Letter#></td>
                        <td class="GridViewLabItemStyle" id="tdremark" style="width:150px; text-align:center"><#=objRow.Remark#></td>
                        <td class="GridViewLabItemStyle" id="tdamount" style="width:100px; text-align:center"><#=objRow.TotalAmount#></td>
                        <td class="GridViewLabItemStyle" id="tddriverid" style="width:100px; text-align:center; display:none;" ><#=objRow.DriverID#></td>
                        <td class="GridViewLabItemStyle" id="tdfueldate" style="width:100px; text-align:center"><#=objRow.FuelDate#></td>
                     <td class="GridViewLabItemStyle"   style="width:80px;text-align:center" >
                       <input type="button"  value="Edit" class="ItDoseButton" onclick="editServiceMaintenance(this)" />

                   </td>
               </tr>
                    <#
                    }
                    #>
           </table>
         
    </script>
</asp:Content>

