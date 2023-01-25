<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="Drivermaster.aspx.cs" Inherits="Design_Transport_Drivermaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <script type="text/javascript" src="../../Scripts/Message.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        driverDetail();
    });
    function saveDriverDetail() {
        if (chkCondition() == true) {
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/saveDriver",
                data: '{Name:"' + $.trim($("#txtName").val()) + '",LicenceNo:"' + $("#txtLicenceNo").val() + '",FatherName:"' + $("#txtFName").val() + '",ContactNo:"' + $("#txtMobile").val() + '",Address:"' + $("#txtAddress").val() + '",LicenceExpiryDate:"' + $("#txtLicenceDate").val() + '",Remark:"' + $("#txtRemark").val() + '",LicenseType:"' + $("#ddlLicenseType").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    if (response.d == "1") {
                        driverDetail();
                        clear();
                        DisplayMsg('MM01', 'lblErrormsg');
                    }
                    else if (response.d == "2") {
                        $("#lblErrormsg").text('License No. already exist');
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
        if ($.trim($("#txtName").val()) == "") {
            $("#lblErrormsg").text('Please Enter Name');
            $("#txtName").focus();
            con = 1;
            return false;
        }
        if ($.trim($("#txtLicenceNo").val()) == "") {
            $("#lblErrormsg").text('Please Enter License No.');
            $("#txtLicenceNo").focus();
            con = 1;
            return false;
        }
        if ($("#txtLicenceDate").val() == "") {
            $("#lblErrormsg").text('Please Enter License Expiry Date');
            $("#txtLicenceDate").focus();
            con = 1;
            return false;
        }
        if ($.trim($("#txtMobile").val()) == "") {
            $("#lblErrormsg").text('Please Enter Contact No.');
            $("#txtMobile").focus();
            con = 1;
            return false;
        }
        if ($.trim($("#txtAddress").val()) == "") {
            $("#lblErrormsg").text('Please Enter Address');
            $("#txtAddress").focus();
            con = 1;
            return false;
        }
        return true;
    }
    function updateDriver() {
        if (chkCondition() == true) {

            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/updateDriver",
                data: '{Name:"' + $.trim($("#txtName").val()) + '",LicenceNo:"' + $("#txtLicenceNo").val() + '",FatherName:"' + $("#txtFName").val() + '",ContactNo:"' + $("#txtMobile").val() + '",Address:"' + $("#txtAddress").val() + '",LicenceExpiryDate:"' + $("#txtLicenceDate").val() + '",Remark:"' + $("#txtRemark").val() + '",IsActive:"' + $("input[type:radio]:checked").val() + '",ID:"' + $("#driverID").text() + '",LicenseType:"' + $("#ddlLicenseType").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    if (response.d == "1") {
                        driverDetail();
                        cancelDriver();
                        DisplayMsg('MM02', 'lblErrormsg');
                    }
                    else if (response.d == "2") {
                        $("#lblErrormsg").text('License No. already exist');
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
    }
    function saveDriver() {
        if ($("#btnSave").val() == "Save") {
            saveDriverDetail();
        }
        else {
            updateDriver();
        }
    }
    function cancelDriver() {
        $("input[type=text], textarea").val('');
        $("#btnSave").val('Save');
        $("#btnCancel").hide();
        $("#rdoActive").prop('checked', true);
        $("#lblErrormsg").text('');
    }
    function clear() {
        $("input[type=text], textarea").val('');
        $("input[type=text], textarea").val('');
        $("#ddlLicenseType").val('');

        $("#rdoActive").prop('checked', true);
    }
    function driverDetail() {
        $('#lblErrormsg').text('');

        $.ajax({
            type: "POST",
            url: "Services/Transport.asmx/bindDriverDetail",
            data: '{}',
            dataType: "json",
            contentType: "application/json;charset=UTF-8",
            async: false,
            success: function (response) {
                driver = jQuery.parseJSON(response.d);
                if (driver != null) {
                    var output = $('#tb_Driver').parseTemplate(driver);
                    $('#driverOutput').html(output);
                    $('#driverOutput').show();
                }
                else {
                    DisplayMsg('MM04', 'lblErrormsg');
                    $('#driverOutput').hide();
                }
            },
            error: function (xhr, status) {
                DisplayMsg('MM05', 'lblErrormsg');
                window.status = status + "\r\n" + xhr.responseText;

            }

        });
    }

    function editDriver(rowid) {
        $("#lblErrormsg").text('');
        $("#btnCancel").show();
        $("#btnSave").val('Update');
        var ID = $(rowid).closest('tr').find('#tdID').text();
        $("#driverID").text(ID);
        $("#txtName").val($(rowid).closest('tr').find('#tdName').text());
        $("#txtLicenceNo").val($(rowid).closest('tr').find('#tdLicenceNo').text());
        $("#txtFName").val($(rowid).closest('tr').find('#tdFatherName').text());
        $("#txtLicenceDate").val($(rowid).closest('tr').find('#tdExpiryDate').text());
        $("#txtMobile").val($(rowid).closest('tr').find('#tdMobile').text());
        $("#txtAddress").val($(rowid).closest('tr').find('#tdAddress').text());
        $("#txtRemark").val($(rowid).closest('tr').find('#tdRemarks').text());
        $("#ddlLicenseType").val($(rowid).closest('tr').find('#tdLicenseType').text());

        //$find("checkInDateChanged").set_selectedDate(null);

        $("[id*=cal]").val($(rowid).closest('tr').find('#tdExpiryDate').text());
        // $find("checkInDateChanged").set_selectedDate($("[id*=cal]").val());


        if ($(rowid).closest('tr').find('#tdIsActive').text() == "Active")
            $("#rdoActive").prop('checked', true);
        else
            $("#rdoDeActive").prop('checked', true);
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
        $("#txtMobile").keypress(function (e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
                $("#errmsgMobile").html("Digits Only").show().fadeOut("slow");
                return false;
            }
        });
        var MaxLength = 100;
        $('#txtAddress,#txtRemark').keypress(function (e) {
            if ($(this).val().length >= MaxLength) {
                if (e.keyCode != 8) {
                    e.preventDefault();
                }
            }
        });
        $('#txtAddress,#txtRemark').bind('paste', function (e) {
            e.preventDefault();
        });

        bindCentre();
    });

    var bindCentre = function () {
        var ddlCentre = $('#ddlCentre');
        CentreID='<%=Util.GetString(ViewState["CentreID"]) %>';
        serverCall('../common/CommonService.asmx/BindCentre', {}, function (response) {
            var responseData = JSON.parse(response);
            ddlCentre.bindDropDown({ data: responseData, valueField: 'CentreID', textField: 'CentreName', isSearchAble: false, selectedValue: CentreID });

        });
    }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Driver Master</b><br />
            <span id="lblErrormsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Driver Detail
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                         <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <select id="ddlCentre"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtName" maxlength="50" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                License No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtLicenceNo" maxlength="50" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               Next Of kin
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtFName" maxlength="50" class="requiredField" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                License Expiry
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLicenceDate" runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                            <cc1:CalendarExtender ID="cal" BehaviorID="checkInDateChanged" runat="server" TargetControlID="txtLicenceDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Contact No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtMobile" maxlength="15" class="requiredField" /><span id="errmsgMobile" class="ItDoseLblError"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtAddress" maxlength="100" class="requiredField"></textarea>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Remark
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtRemark" maxlength="100" class="requiredField"></textarea>
                        </div>


                         <div class="col-md-3">
                            <label class="pull-left">
                                License Type 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlLicenseType" class="requiredField">
                                <option value="" >Select</option>                               
                                <option value="A" >A</option>
                                <option value="B">B</option>
                                <option value="C">C</option>
                                <option value="D">D</option>
                                <option value="E">E</option>
                                <option value="F">F</option>


                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                IsActive
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="rdoActive" type="radio" name="con" value="1" checked="checked">Active
                    <input id="rdoDeActive" type="radio" name="con" value="0">DeActive
                            <span id="driverID" style="display: none"></span>
                        </div>
                       
                    </div>
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <input type="button" id="btnSave" class="ItDoseButton" value="Save" onclick="saveDriver()" />
                            <input type="button" id="btnCancel" class="ItDoseButton" value="Cancel" style="display: none" onclick="cancelDriver()" />
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;" id="driverRecord">
            <div class="Purchaseheader">
                Driver Record
            </div>
            <table style="width: 100%">
                <tr>
                    <td style="text-align: center">
                        <div id="driverOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
          <script id="tb_Driver" type="text/html">
    <table  cellspacing="0" rules="all" border="1" 
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Next Of kin</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">License Type</th>
            
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">License No.</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Expiry Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Address</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Contact No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">IsActive</th>
           <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Edit</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none"></th>
		</tr>
        <#       
     
        var objRow;   
        for(var j=0;j<driver.length;j++)
        {       
        objRow = driver[j];
        #>
            

                    <tr id="<#=j+1#>"> 
                                                 
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdName"  style="width:200px;text-align:center" ><#=objRow.Name#></td>
                    <td class="GridViewLabItemStyle" id="tdFatherName"  style="width:200px;text-align:center" ><#=objRow.FatherName#></td>
                    <td class="GridViewLabItemStyle" id="tdLicenseType"  style="width:200px;text-align:center" ><#=objRow.LicenseType#></td>
                         
                    <td class="GridViewLabItemStyle" id="tdLicenceNo"  style="width:100px;text-align:center" ><#=objRow.LicenceNo#></td>
                    <td class="GridViewLabItemStyle" id="tdExpiryDate"  style="width:120px;text-align:center" ><#=objRow.ExpiryDate#></td>
                    <td class="GridViewLabItemStyle" id="tdAddress"  style="width:200px;text-align:center" ><#=objRow.Address#></td>
                    <td class="GridViewLabItemStyle" id="tdMobile"  style="width:100px;text-align:center" ><#=objRow.Mobile#></td>
                    <td class="GridViewLabItemStyle" id="tdIsActive"  style="width:100px;text-align:center" ><#=objRow.IsActive#></td>
                   <td class="GridViewLabItemStyle"   style="width:100px;text-align:center" >
                       <input type="button"  value="Edit" class="ItDoseButton" onclick="editDriver(this)" />

                   </td>
 <td class="GridViewLabItemStyle" id="tdID" style="width:40px;display:none"><#=objRow.ID#></td>
<td class="GridViewLabItemStyle" id="tdRemarks" style="width:40px;display:none"><#=objRow.Remark#></td>
                        
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>

</asp:Content>