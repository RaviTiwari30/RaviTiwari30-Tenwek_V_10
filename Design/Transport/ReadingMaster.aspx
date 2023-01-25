<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="ReadingMaster.aspx.cs" Inherits="Design_Transport_ReadingMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="uc1" TagName="Time" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <script type="text/javascript">
        $(document).ready(function () {
            $('.numbersOnly').keyup(function () {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });
            binVehicle();
            $("#btnSave").hide();
            $("#divReadingHeader,#tblReadingDetails").hide();

            $("#rblType input[type='radio']").change(function () {
                $("#lblErrormsg").text("");
                if ($(this).val() == "1") {
                    $("#divReadingHeader,#tblReadingDetails,#trKMBasis").show();
                    $("#trRangeBasis").hide();                    
                }
                else if ($(this).val() == "2") {
                    $("#divReadingHeader,#tblReadingDetails,#trRangeBasis").show();
                    $("#trKMBasis").hide();
                }
                else if ($(this).val() == "3") {
                    $("#divReadingHeader,#tblReadingDetails,#trRangeBasis,#trKMBasis").show();
                }
            });

            $("#btnAdd").bind("click", function () {
                $("#lblErrormsg").text('');
                    AddVehicleDetail();               
            });

            $("#btnSave").bind("click", function () {
                $("#lblErrormsg").text('');
                SaveVehicleReading();
            });

            $("#ddlVehicle").change("click", function () {
                $("#lblErrormsg").text('');
                bindVehicleReading();
            });

        });


        function bindVehicleReading() {
            $('#PnlReadingDetail').hide();
            $("#lblErrormsg").text('');
            var VehicleID = $("#ddlVehicle").val();
            $.ajax({
                url: "Services/Transport.asmx/GetVehicleReading",
                data: '{VehicleID:"' + VehicleID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    ReadingDetail = $.parseJSON(result.d);
                    if (ReadingDetail != null) {
                        var ReadingDetailOutPut = $('#ReadingDetail').parseTemplate(ReadingDetail);
                        $('#Div_ReadingDetail').html(ReadingDetailOutPut);
                        $('#Div_ReadingDetail,#ReadingDetail,#tb_ReadingDetailSearch,#PnlReadingDetail').show();
                    }
                    else {
                        $('#Div_ReadingDetail,#Div_ReadingDetail,#tb_ReadingDetailSearch,#PnlReadingDetail').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function AddVehicleDetail() {
            var type;
            if ($("#ddlVehicle").val() == "0") {
                $("#lblErrormsg").text("Please Select Vehicle");
                return;
            }
            var Vehicle = $.trim($("#ddlVehicle  option:selected").text());
            var VehicleID = $.trim($("#ddlVehicle").val());
            if ($("#rblType input[value='1']").is(":checked")) {            // KM Basis
                type = "KM Basis";
               
                var Rate = parseFloat($("#txtRatePerKM").val());
                if (Rate == 0 || isNaN(Rate)) {
                    $("#lblErrormsg").text("Please Enter Rate");
                    return;
                }
                var ReadingTypeID = $("#rblType").find("input:radio:checked").val();
                if ($("#KMBasis_tbSelected tr").length < 3) {
                    $('#KMBasis_tbSelected').css('display', 'block');
                    $('#KMBasis_tbSelected').append('<tr><td class="GridViewLabItemStyle" align="left"><span id="Vehicle">' + Vehicle + '</span><span id="VehicleID"  style="display:none">' + VehicleID + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="Rate">' + Rate + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="ReadingType">' + type + '</span><span id="ReadingTypeID"  style="display:none">' + ReadingTypeID + '</span></td><td class="GridViewLabItemStyle"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');

                    if ($("#KMBasis_tbSelected tr").length > 2) {
                        $('#PnlReadingDetail,#KMBasis_tbSelected').show();
                        $("#rblType input[type='radio']").attr("disabled", true);
                        $("#ddlVehicle,#txtRatePerKM").attr("disabled", true);
                        $("#txtRatePerKM").val(0);
                        $("#btnSave").show();
                    }
                }
            }

            else if ($("#rblType input[value='2']").is(":checked")) {       // Range Basis
                type = "Range Basis";
                //------ Range Basis ------
                var RangeFrom = parseFloat($("#txtRangeFrom").val());
                var RangeTo = parseFloat($("#txtRangeTo").val());
                var Rate = 0;
                if (RangeFrom <= RangeTo) {

                    Rate = parseFloat($("#txtRatePerRange").val());
                    if (Rate == 0 || isNaN(Rate)) {
                        $("#lblErrormsg").text("Please Enter Amount for Range " + RangeFrom + " To " + RangeTo + " KM");
                        return;
                    }

                }
                else {
                    $("#lblErrormsg").text("Please Enter Proper Range");
                    return;

                }

                var ReadingTypeID = $("#rblType").find("input:radio:checked").val();                            
                if (CheckDuplicate_RangeBasis(RangeFrom, RangeTo)) {
                    $("#lblErrormsg").text('Range Already Added');
                    return;
                }

                $('#RangeBasis_tbSelected').css('display', 'block');
                $('#RangeBasis_tbSelected').append('<tr><td class="GridViewLabItemStyle" align="left"><span id="Vehicle">' + Vehicle + '</span><span id="VehicleID"  style="display:none">' + VehicleID + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="RangeFrom">' + RangeFrom + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="RangeTo">' + RangeTo + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="Rate">' + Rate + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="ReadingType">' + type + '</span><span id="ReadingTypeID"  style="display:none">' + ReadingTypeID + '</span></td><td class="GridViewLabItemStyle"><img id="imgRemove" onclick="RemoveRowsRangeBasis(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');

                if ($("#RangeBasis_tbSelected tr").length > 2) {
                    $('#PnlReadingDetail,#RangeBasis_tbSelected').show();
                    $("#rblType input[type='radio']").attr("disabled", true);
                    $("#ddlVehicle,#txtRatePerKM").attr("disabled", true);
                    $("#txtRatePerRange").val(0);
                    $("#txtRangeFrom").val(0);
                    $("#txtRangeTo").val(0);
                    $("#btnSave").show();
                }
                //-------Range Basis End ------
               
            }
            else if ($("#rblType input[value='3']").is(":checked")) {       // Both KM & Range Basis
                type = "KM & Range Basis";

                //----- KM Basis----
                if ($("#KMBasis_tbSelected tr").length < 3)
                {
                    var Rate = parseFloat($("#txtRatePerKM").val());
                    if (Rate == 0 || isNaN(Rate)) {
                        $("#lblErrormsg").text("Please Enter Rate");
                        return;
                    }
                    var ReadingTypeID = $("#rblType").find("input:radio:checked").val();
                    $('#KMBasis_tbSelected').css('display', 'block');
                    $('#KMBasis_tbSelected').append('<tr><td class="GridViewLabItemStyle" align="left"><span id="Vehicle">' + Vehicle + '</span><span id="VehicleID"  style="display:none">' + VehicleID + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="Rate">' + Rate + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="ReadingType">' + type + '</span><span id="ReadingTypeID"  style="display:none">' + ReadingTypeID + '</span></td><td class="GridViewLabItemStyle"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');

                    if ($("#KMBasis_tbSelected tr").length > 2) {
                        $('#PnlReadingDetail,#KMBasis_tbSelected').show();
                        $("#rblType input[type='radio']").attr("disabled", true);
                        $("#ddlVehicle,#txtRatePerKM").attr("disabled", true);
                        $("#txtRatePerKM").val(0);
                        $("#btnSave").show();
                    }
                }
                //------ KM Basis End ---------

                //------ Range Basis ------

                var RangeFrom = parseFloat($("#txtRangeFrom").val());
                var RangeTo = parseFloat($("#txtRangeTo").val());
                var Rate = 0;
                if (RangeFrom <= RangeTo) {

                        Rate = parseFloat($("#txtRatePerRange").val());
                        if (Rate == 0 || isNaN(Rate)) {
                            $("#lblErrormsg").text("Please Enter Amount for Range " + RangeFrom + " To " + RangeTo + " KM");
                            return;
                        }
                }
                else {
                    $("#lblErrormsg").text("Please Enter Proper Range");
                    return;

                }

                if (CheckDuplicate_RangeBasis(RangeFrom, RangeTo)) {
                    $("#lblErrormsg").text('Range Already Added');
                    return;
                }
                var ReadingTypeID = $("#rblType").find("input:radio:checked").val();

                $('#RangeBasis_tbSelected').css('display', 'block');
                $('#RangeBasis_tbSelected').append('<tr><td class="GridViewLabItemStyle" align="left"><span id="Vehicle">' + Vehicle + '</span><span id="VehicleID"  style="display:none">' + VehicleID + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="RangeFrom">' + RangeFrom + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="RangeTo">' + RangeTo + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="Rate">' + Rate + '</span></td><td class="GridViewLabItemStyle" align="left"><span id="ReadingType">' + type + '</span><span id="ReadingTypeID"  style="display:none">' + ReadingTypeID + '</span></td><td class="GridViewLabItemStyle"><img id="imgRemove" onclick="RemoveRowsRangeBasis(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');

                if ($("#RangeBasis_tbSelected tr").length > 2) {
                    $('#PnlReadingDetail,#RangeBasis_tbSelected').show();
                    $("#rblType input[type='radio']").attr("disabled", true);
                    $("#txtRatePerRange").val(0);
                    $("#txtRangeFrom").val(0);
                    $("#txtRangeTo").val(0);
                    $("#btnSave").show();
                }
                
                //-------Range Basis End ------

            }
        }

            function CheckDuplicate_RangeBasis(RangeFrom,RangeTo) {
                var count = 0;
                var contents = {};
                $('#RangeBasis_tbSelected tr:not(#RangeBasis_Header)').each(function () {
                    var id = $(this).attr("id");
                    if ($(this).attr("id") != "RangeBasis_Header1") {
                        var $rowid = $(this).closest("tr");

                        minRange = Number($rowid.find("#RangeFrom").text()).toFixed(2);
                        maxRange = Number($rowid.find("#RangeTo").text()).toFixed(2);

                        if ((minRange >= RangeFrom && minRange <= RangeTo) ||
         (maxRange >= RangeFrom && maxRange <= RangeTo) ||
         (RangeFrom >= minRange && RangeFrom <= maxRange)) {
                            alert("Range is overlapping.");
                            count = count + 1;
                        }
                    }
                });
                if (count == 0) 
                    return false;
                else 
                    return true;
            }

            function SaveVehicleReading() {
                $('#btnSave').attr('disabled', true).val("Submitting...");
                var resultKM_Basis = KM_Basis();
                var resultRange_Basis = Range_Basis();          
                var VehicleID = $("#ddlVehicle").val();
                $.ajax({
                    url: "Services/Transport.asmx/SaveVehicleReading",
                    data: JSON.stringify({ KM_basis: resultKM_Basis, Range_Basis: resultRange_Basis, VehicleID: VehicleID }),
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: "120000",
                    dataType: "json",
                    success: function (result) {
                        OutPut = result.d;
                        if (result.d == "1") {
                            $("#lblErrormsg").text('Record Saved Successfully');
                            alert('Record Saved Successfully ');
                            clearDetail();
                            bindVehicleReading();
                        }
                        else {
                            $("#lblErrormsg").text('Error occurred, Please contact administrator');
                            $('#btnSave').attr('disabled', true).val("Save");
                        }
                    },
                    error: function (xhr, status) {
                        $("#lblErrormsg").text('Error occurred, Please contact administrator');
                        $('#btnSave').attr('disabled', true).val("Save");
                    }
                });

            }

            function KM_Basis() {
                var dataKM = new Array();
                var ObjKM = new Object();
                $("#KMBasis_tbSelected tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "KMBasis_Header" && id != "KMBasis_Header1") {
                        ObjKM.VehicleID         = $rowid.find("#VehicleID").text();
                        ObjKM.ReadingTypeID     = $rowid.find("#ReadingTypeID").text();
                        ObjKM.RatePerKM         = Number($rowid.find("#Rate").text()).toFixed(2);
                        ObjKM.RangeFrom         = Number(0).toFixed(2);
                        ObjKM.RangeTo           = Number(0).toFixed(2);
                        ObjKM.RangeAmount       = Number(0).toFixed(2);
                        dataKM.push(ObjKM);
                        ObjKM = new Object();
                    }
                });
                return dataKM;
            }
            function Range_Basis() {
                var dataRange = new Array();
                var ObjRange = new Object();
                $("#RangeBasis_tbSelected tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "RangeBasis_Header" && id != "RangeBasis_Header1") {
                        ObjRange.VehicleID      = $rowid.find("#VehicleID").text();
                        ObjRange.ReadingTypeID  = $rowid.find("#ReadingTypeID").text();
                        ObjRange.RatePerKM      = Number(0).toFixed(2);
                        ObjRange.RangeFrom      = Number($rowid.find("#RangeFrom").text()).toFixed(2);
                        ObjRange.RangeTo        = Number($rowid.find("#RangeTo").text()).toFixed(2);
                        ObjRange.RangeAmount    = Number($rowid.find("#Rate").text()).toFixed(2);
                        dataRange.push(ObjRange);
                        ObjRange = new Object();
                    }
                });
                return dataRange;
            }
            function binVehicle() {
                var vehicleCon = 0;
                if ($('#rdoIn').is(':checked'))
                    vehicleCon = 1;
                $('#lblErrormsg').text('');
                $("#ddlVehicle option").remove();
                $.ajax({
                    type: "POST",
                    url: "Services/Transport.asmx/bindVehicle1",
                    data: '{}', //Status: "' + vehicleCon + '"
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
            function RemoveRows(rowid) {
                $("#spnErrorMsg").text('');
                $(rowid).closest('tr').remove();
                if ($('#KMBasis_tbSelected tr:not(#KMBasis_Header)').length == 1) {
                    $('#KMBasis_tbSelected').hide();              
                    $("#txtRatePerKM").val(0);
                }
                if ($("#rblType input[value='1']").is(":checked")) {
                    if ($('#KMBasis_tbSelected tr:not(#KMBasis_Header)').length == 1) {
                        $("#rblType input[type='radio']").attr("disabled", false);
                        $("#ddlVehicle,#txtRatePerKM").attr("disabled", false);
                        //$("#ddlVehicle").prop('selectedIndex', 0);
                        $("#btnSave").hide();
                    }
                }

                if ($("#rblType input[value='3']").is(":checked")) {
                    if ($('#KMBasis_tbSelected tr:not(#KMBasis_Header)').length == 1 && $('#RangeBasis_tbSelected tr:not(#RangeBasis_Header)').length == 1) {
                        $("#rblType input[type='radio']").attr("disabled", false);
                        $("#ddlVehicle,#txtRatePerKM").attr("disabled", false);
                        $("#ddlVehicle").prop('selectedIndex', 0);
                        $("#btnSave").hide();
                    }
                }
            }
            function RemoveRowsRangeBasis(rowid) {
                $("#spnErrorMsg").text('');
                $(rowid).closest('tr').remove();
                if ($('#RangeBasis_tbSelected tr:not(#RangeBasis_Header)').length == 1) {
                    $('#RangeBasis_tbSelected').hide();              
                }
                if ($('#KMBasis_tbSelected tr:not(#KMBasis_Header)').length == 1 && $('#RangeBasis_tbSelected tr:not(#RangeBasis_Header)').length == 1) {
                    $("#rblType input[type='radio']").attr("disabled", false);
                    $("#ddlVehicle,#txtRatePerKM").attr("disabled", false);
                    //$("#ddlVehicle").prop('selectedIndex', 0);
                    $("#btnSave").hide();
                }
            }



            function checkForSecondDecimal(sender, e) {
                formatBox = document.getElementById(sender.id);
                strLen = sender.value.length;
                strVal = sender.value;
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
                return true;
            }
            function ValidateDecimal() {
                var DigitsAfterDecimal = 2;
                var val = $("#txtRatePerKM").val();          
                var valIndex = val.indexOf(".");
                if (valIndex > "0") {
                    if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Please Enter Valid Rate, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");

                        $("#txtRatePerKM").val($("#txtRatePerKM").val().substring(0, ($("#txtRatePerKM").val().length - 1)))
                        return false;
                    }
                }
            }
            function ValidateDecimal_Range() {
                var DigitsAfterDecimal = 2;
                var val = $("#txtRatePerRange").val();
                var valIndex = val.indexOf(".");
                if (valIndex > "0") {
                    if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Please Enter Valid Amount, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");

                        $("#txtRatePerRange").val($("#txtRatePerRange").val().substring(0, ($("#txtRatePerRange").val().length - 1)))
                        return false;
                    }
                }
            }
            function validatedot() {
                ValidateDecimal();
                ValidateDecimal_Range();
                if (($("#txtRatePerKM").val().charAt(0) == ".")) {
                    $("#txtRatePerKM").val('');
                    return false;
                }
                if (($("#txtRatePerRange").val().charAt(0) == ".")) {
                    $("#txtRatePerRange").val('');
                    return false;
                }
                return true;
            }
            function clearDetail() {
                $('#tb_RangeSearch,#KMBasis_tbSelected,#RangeBasis_tbSelected').hide();              
                $('#KMBasis_tbSelected tr').has('td').remove();
                $('#RangeBasis_tbSelected tr').has('td').remove();
                $("#rblType input[type='radio']").attr("disabled", false);
                $("#ddlVehicle,#txtRatePerKM").attr("disabled", false);
                $("#ddlVehicle").prop('selectedIndex', 0);
                $("#rblType input[type='radio']").attr('checked', false);
                $("#PnlReadingDetail").hide();
                $('#btnSave').attr('disabled', false).val("Save");
                $("#btnSave,#divReadingHeader,#tblReadingDetails,#trKMBasis,#trRangeBasis").hide();
            }

    </script>
   
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Reading Master</b><br />
            <span id="lblErrormsg" class="ItDoseLblError"></span>
            <br />
           
        </div>


        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
       <div class="POuter_Box_Inventory" id="divRequestDetail" style="text-align: center;">
            <div class="Purchaseheader">
                Reading Master
            </div>
            <div>
                <table style="width: 100%">

                    <tr>
                        <td style="width: 10%; text-align: right;">Vehicle :&nbsp;</td>
                        <td style="width: 45%; text-align: left;">
                           <select id="ddlVehicle" style="width: 350px"   class="requiredField"></select>
                           
                        </td>
                        <td style="width: 15%; text-align: right;">Reading Type :&nbsp;</td>
                        <td style="width: 30%; text-align: left;">
                         <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Text="KM Basis" Value="1" />
                                <asp:ListItem Text="Range Basis" Value="2" />
                                <asp:ListItem Text="Both" Value="3" />
                        </asp:RadioButtonList>
                        </td>
                    </tr>
                    </table>
                    <div class="Purchaseheader" id="divReadingHeader">
                         &nbsp;
                    </div>
                     <table style="width: 100%" id="tblReadingDetails">

                     <tr id="trKMBasis">
                        <td style="width: 10%; text-align: right;">Rate/KM&nbsp;:&nbsp;</td>
                        <td style="width: 60%; text-align: left;">
                            <input type="text" id="txtRatePerKM" style="width: 70px;" maxlength="20" title="Enter Rate/KM" value="0" class="numbersOnly requiredField"  onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" />
                        </td>
                        <td style="width: 10%; text-align: right;"></td>
                        <td style="width: 20%; text-align: left;"></td>
                    </tr>

                    <tr id="trRangeBasis">
                        <td style="width: 10%; text-align: right;">Range&nbsp;:&nbsp;</td>
                        <td style="width: 60%; text-align: left;">
                            <input type="text" id="txtRangeFrom" style="width: 70px;" maxlength="20" title="Enter Range From" value="0" class="numbersOnly requiredField" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" />&nbsp<span valign="top">To</span>&nbsp;
                             <input type="text" id="txtRangeTo" style="width: 70px;" maxlength="20" title="Enter Range To" value="0" class="numbersOnly requiredField" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" />
                        </td>

                        <td style="width: 10%; text-align: right;">Amount&nbsp;:&nbsp;</td>
                        <td style="width: 20%; text-align: left;"> 
                            <input type="text" id="txtRatePerRange" style="width: 70px;" maxlength="20" title="Enter Amount" value="0"  class="numbersOnly requiredField"  onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" />
                        </td>
                    </tr>

                       <tr>
                        <td style="width: 100%; text-align: center;" colspan="4"> 
                            <input id="btnAdd" type="button" title="ADD"  value="ADD" class="ItDoseButton" />
                        </td>
                                                  
                         </tr>
                </table>
                


        <asp:Panel ID="PnlReadingDetail" runat="server" Style="display: none; width:700px; height:auto;" ClientIDMode="Static">
                
            <div class="content" style="width:auto; height:auto;">                        
                        <div id="KMBasisOutput" style="max-height: 200px; overflow-y:auto;overflow-x: hidden;">  
                            <table id="KMBasis_tbSelected"  rules="all"  style="width:700px; display:none" class="GridViewStyle">          
                            <tr id="KMBasis_Header1">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 440px; text-align:left" colspan="6">KM Basis Reading Detail</th>                    
                                </tr>
                <tr id="KMBasis_Header">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align:left; display:none;"></th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align:left;display:none;">Vehicle ID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 350px; text-align:left">Vehicle Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align:left;display:none;">ReadingTypeID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align:left">Rate</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 200px; text-align:left">Reading Type</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 200px; text-align:left"></th>
                </tr>             </table>  
                        </div>

                 <div id="RangeBasisOutput" style="max-height: 200px; overflow-y:auto;overflow-x: hidden;">
                            <table id="RangeBasis_tbSelected"  rules="all" border="1" style="border-collapse: collapse; width:700px;  display:none" class="GridViewStyle">
                                 <tr id="RangeBasis_Header1">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 440px; text-align:left" colspan="6">Range Basis Reading Detail</th>                    
                                </tr>
                                <tr id="RangeBasis_Header">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 350px; text-align:left">Vehicle Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 90px; text-align:left">From(KM)</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 90px; text-align:left">To(KM)</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align:left">Rate</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 180px; text-align:left">Reading Type</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:left"></th>
                                </tr>
                               
                            </table>
                            </div>

                    <div  style="text-align: center">
                <input type="button" id="btnSave" class="ItDoseButton" value="Save" />
                       <div id="Div_ReadingDetail" style="max-height: 200px; width:800px; overflow-y:auto;overflow-x: hidden;">   </div>


                    </div>

            </div>
                
                     </asp:Panel>
                <br />
                
               
               
               

            </div>
                 

            </div>
          
        </div>
         
       
       
    
    </div>
    
     <script type="text/html" id="ReadingDetail">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" style="border-collapse: collapse;" id="tb_KMBasisSearch">
             <tr id="ReadingDetail_Header21">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 440px; text-align:left" colspan="6">Reading Detail</th>                    
                                </tr>
                <tr id="ReadingDetail_Header22">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align:left; display:none;"></th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align:left;display:none;">Vehicle ID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 200px; text-align:left">Vehicle Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align:left;display:none;">ReadingTypeID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align:left">Rate</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 90px; text-align:left">From(KM)</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 90px; text-align:left">To(KM)</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align:left">Amount</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left">Reading Type</th>
                                   <%-- <th class="GridViewHeaderStyle" scope="col" style="width: 200px; text-align:left"></th>--%>
                </tr>

            <#
                var dataLength=ReadingDetail.length;
		        window.status="Total Records Found :"+ dataLength;
		        var objRow;   
		        for(var j=0;j<dataLength;j++)
		        {
                    objRow=ReadingDetail[j];
            #>
                    <tr>                      
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center; display:none"> <#=j+1#>&nbsp;&nbsp;</td> 
                        <td class="GridViewLabItemStyle" id="tdVehicleID"  style="width:50px;text-align:center;display:none;" ><#=objRow.VehicleID#></td>
                        <td class="GridViewLabItemStyle" id="tdVehicleName"  style="width:200px; text-align:left;" ><#=objRow.VehicleName#></td>
					    <td class="GridViewLabItemStyle" id="tdReadingTypeID"  style="width:50px;text-align:center;display:none;" ><#=objRow.ReadingTypeID#></td>
                        <td class="GridViewLabItemStyle" id="tdRatePerKM" style="width:60px;text-align:center; "><#=objRow.RatePerKM#></td>    
                        <td class="GridViewLabItemStyle" id="td1RangeFrom" style="width:60px;text-align:center; "><#=objRow.RangeFrom#></td>  
                        <td class="GridViewLabItemStyle" id="td1RangeTo" style="width:60px;text-align:center; "><#=objRow.RangeTo#></td> 
                        <td class="GridViewLabItemStyle" id="td1RangeAmount" style="width:60px;text-align:center; "><#=objRow.RangeAmount#></td>  
                        <td class="GridViewLabItemStyle" id="tdReadingType" style="width:100px; text-align:left; "><#=objRow.ReadingType#></td>  
                      <%--  <td class="GridViewLabItemStyle" id="tdRemoveRow" style="width:200px;text-align:center; "><img id="imgRemove" onclick="RemoveRowsRangeBasis(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td> 
                        --%>
                        
                                                             
                    </tr>                           
            <#    
                }                
            #>
        </table>
    </script>
    

</asp:Content>
